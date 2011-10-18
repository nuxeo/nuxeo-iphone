//
//  CmisTestCase.h
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html


#import <SenTestingKit/SenTestingKit.h>
#import "CmisClient.h"

@interface CmisTestCase : SenTestCase {
    CmisClient *client;
}

@end
