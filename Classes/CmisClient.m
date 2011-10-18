//
//  CMISClient.m
//  TestNavBased
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import "CmisClient.h"
#import "DDXML.h"
#import "StringUtil.h"

@interface CmisClient (Private)
- (NSData*)get:(NSURL*)url consumes:(NSString*)mimeType;
- (NSString*)queryXPath:(NSData*)data withQuery:(NSString*)query;
@end

@implementation CmisClient

static CmisClient *sharedClient = NULL;

@synthesize serviceUrl, rootCollectionUrl, username, password;

+ (CmisClient *)sharedClient {
    if (!sharedClient) {
        sharedClient = [[CmisClient alloc] init];
    }
    return sharedClient;
}

- (id)init {
    [super init];
    [self connect];
    return self;
}

- (void)connect {
    self.username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
	self.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    NSString *serviceUrlStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"serviceUrl"];
    NSLog(@"serviceUrl = %@", serviceUrlStr);
    if (serviceUrlStr != nil) {
        self.serviceUrl = [NSURL URLWithString:serviceUrlStr];
        [self fetchServiceDocument];
    }
}

- (NXFolder*)getFolderInfoAt:(NSURL*)url {
    NSData *data = [self get:url consumes:@"application/atom+xml;type=feed"];

    NSString *title = [self queryXPath:data withQuery:@"/*[local-name()='feed']/*[local-name()='title']"];
    NXFolder *folder = [[NXFolder alloc] init];
    folder.title = title;
    
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *entries = [doc nodesForXPath:@"/*[local-name()='feed']/*[local-name()='entry']" error:nil];
    
    for (DDXMLElement *entry in entries) {
        NSString *url;
        BOOL isFolder = YES;
        NXObject *childObject;
        
        for (DDXMLElement *link in [entry elementsForName:@"link"]) {
            // For folders
            if ([[[link attributeForName:@"rel"] stringValue] isEqual:@"down"]
                    && [[[link attributeForName:@"type"] stringValue] hasPrefix:@"application/atom+xml"]) {
                url = [[link attributeForName:@"href"] stringValue];
            }
            // For docs
            if ([[[link attributeForName:@"rel"] stringValue] isEqual:@"edit-media"]) {
                url = [[link attributeForName:@"href"] stringValue];
                isFolder = NO;
            }
        }
        if (isFolder) {
            childObject = [[NXFolder alloc] initWithEntry:entry];
        } else {
            childObject = [[NXDocument alloc] initWithEntry:entry];
        }
        childObject.url = [NSURL URLWithString:url];
        [folder addChild:childObject];
    }
    [folder sort];
    
    return folder;
}

- (NSURL*)fetchDocumentAt:(NSURL*)url {
    NSData *data = [self get:url consumes:@"*/*"];
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"tempfile"];
    [data writeToFile:path atomically:YES];
    [data release];
    
    //NSData *data2 = [NSData dataWithContentsOfFile:path];

    NSURL *tempUrl = [NSURL fileURLWithPath:path];
    return tempUrl;
}

- (NSMutableURLRequest *)makeRequestForURL:(NSURL *)url consumes:(NSString*)mimeType {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString* auth = [NSString stringWithFormat:@"%@:%@", username, password];
    NSString* basicauth = [NSString stringWithFormat:@"Basic %@", [NSString base64encode:auth]];
    [request setValue:basicauth forHTTPHeaderField:@"Authorization"];
    [request setValue:mimeType forHTTPHeaderField:@"Accept"];
    return request;
}

// Private methods

- (void)fetchServiceDocument {
    NSData *data = [self get:self.serviceUrl consumes:@"*/*"];
    // Parse service document
    NSString *query = @"//*[local-name()='collection' and child::*[local-name()='collectionType' and text()='root']]/@href";
    NSString *result = [self queryXPath:data withQuery:query];
    if (result == nil) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error fetching remote repository info"
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK?"
                                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        self.rootCollectionUrl = [NSURL URLWithString:result];
    }
}

- (NSData *)get:(NSURL*)url consumes:(NSString*)mimeType {
    NSLog(@"URL: %@", url);
    NSMutableURLRequest *request = [self makeRequestForURL:url consumes:mimeType];
    NSHTTPURLResponse *response;
    NSError *error;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([response statusCode] != 200) {
        NSLog(@"Status code: %d", [response statusCode]);
        NSString *msg = [NSString stringWithFormat:@"URL: %@\nPlease check or update settings.", url];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error fetching remote object"
                                                            message:msg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK?"
                                                  otherButtonTitles:nil];
        [alertView show];
        return nil;
    }
    return data;
}    

- (NSString*)queryXPath:(NSData*)data withQuery:(NSString*)query {
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *nodes = [doc nodesForXPath:query error:nil];
    //NSAssert([nodes count] > 0, [NSString stringWithFormat:@"FAIL. query=%@\ndoc=%@", query, doc]);
    DDXMLNode *node = [nodes objectAtIndex:0];
    return [node stringValue];
}

@end
