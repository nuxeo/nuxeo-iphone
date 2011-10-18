//
//  CmisTestCase.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import "CmisTestCase.h"
#import "DDXML.h"

#define USERNAME @"Administrator"
#define PASSWORD @"Administrator"
#define SERVICE_URL @"http://localhost:8080/nuxeo/site/cmis/repository"
#define AUTH_KEY @"Basic QWRtaW5pc3RyYXRvcjpBZG1pbmlzdHJhdG9y"

@implementation CmisTestCase

- (void)setUp {
    [[NSUserDefaults standardUserDefaults] setObject:USERNAME forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:PASSWORD forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:SERVICE_URL forKey:@"serviceUrl"];
    client = [[CmisClient alloc] init];
}

- (void)tearDown {
    [client release];
}

- (void)testDDXML {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SERVICE_URL]];
    [request setValue:AUTH_KEY forHTTPHeaderField:@"Authorization"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:nil];
    NSArray *nodes;
    NSString *query;
    
    nodes = [doc nodesForXPath:@"/*[local-name()='service']" error:nil];
    STAssertTrue([nodes count] == 1, @"FAIL");

    query = @"//*[local-name()='collection' and child::*[local-name()='collectionType' and text()='root']]/@href";
    nodes = [doc nodesForXPath:query error:nil];
    STAssertTrue([nodes count] == 1, @"FAIL: %d != %1", [nodes count]);
}

- (void)testServiceUrl {
    STAssertEqualObjects(SERVICE_URL, [client.serviceUrl absoluteString], @"FAIL"); 
}

- (void)testRootCollectionUrl {
    NSString *rootCollectionUrl = [client.rootCollectionUrl absoluteString];
    STAssertEqualObjects(@"http:", [rootCollectionUrl substringToIndex:5], @"FAIL");
}    

- (void)testGetRootFolderInfo {
    NSLog(@"Fetch info for root collection %@", client.rootCollectionUrl);
    NXFolder *folderInfo = [client getFolderInfoAt:client.rootCollectionUrl];
    STAssertEqualObjects(folderInfo.title, @"children collection", @"FAIL");
}

- (void)testGetChildFolderInfo {
    NSLog(@"Fetch info for root collection %@", client.rootCollectionUrl);
    NXFolder *folderInfo = [client getFolderInfoAt:client.rootCollectionUrl];
    NXFolder *firstFolder = [folderInfo.children objectAtIndex:0];
    STAssertNotNil(firstFolder.title, @"FAIL");
    STAssertNotNil(firstFolder.url, @"FAIL");
    STAssertEqualObjects(@"default-domain", firstFolder.title, @"FAIL");
    
    firstFolder = [client getFolderInfoAt:firstFolder.url];
    STAssertNotNil(firstFolder.title, @"FAIL");
    //STAssertNotNil(firstFolder.url, @"FAIL");
    //STAssertEqualObjects(firstFolder.title, @"default-domain", @"FAIL");
    STAssertTrue([firstFolder.children count] > 2, @"FAIL");    
}

@end
