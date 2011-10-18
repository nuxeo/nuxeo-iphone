//
//  RestApiTestCase.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/9/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#if 0

#import "RestApiTestCase.h"
#define SERVICE_URL @"http://Administrator:Administrator@localhost:8080/nuxeo/restAPI/default/browse"

@implementation RestApiTestCase

- (void) setUp {
    client = [[RestApi alloc] initWithUrl:[NSURL URLWithString:SERVICE_URL]];
}

- (void) tearDown {
    [client release];
}

- (void) testServiceUrl {
    STAssertEquals(SERVICE_URL, [client.serviceURL absoluteString], @"FAIL"); 
}

- (void)testRootCollectionUrl {
    NSString *rootCollectionUrl = [[client getRootCollectionUrl] absoluteString];
    STAssertEquals(@"phony", rootCollectionUrl, @"FAIL"); 
}    

- (void)testDummy {
    [client fetchServiceDocument];
}

- (void)testMustFail {
    //STFail(@"FAIL");
}

@end

#endif