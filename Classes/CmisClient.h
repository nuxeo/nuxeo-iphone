//
//  CMISClient.h
//  TestNavBased
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXFolder.h"
#import "NXDocument.h"

@interface CmisClient : NSObject {
    NSString *username, *password;
    NSURL *serviceUrl;
    NSURL *rootCollectionUrl;
}

@property (retain) NSURL *serviceUrl;
@property (retain) NSURL *rootCollectionUrl;
@property (retain) NSString *username;
@property (retain) NSString *password;

+ (CmisClient *)sharedClient;
- (NXFolder*)getFolderInfoAt:(NSURL*)url;
- (NSURL*)fetchDocumentAt:(NSURL*)url;
- (NSMutableURLRequest *)makeRequestForURL:(NSURL *)url consumes:(NSString*)mimeType;
- (void)fetchServiceDocument;
- (void)connect;

@end
