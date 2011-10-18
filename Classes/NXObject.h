//
//  Object.h
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"

@interface NXObject : NSObject {
    NSString *title;
    NSString *uid;
    NSURL *url;
    NSMutableDictionary *properties;
}

@property (retain) NSString *title;
@property (retain) NSString *uid;
@property (retain) NSURL *url;
@property (retain) NSMutableDictionary *properties;

- (id)initWithEntry:(DDXMLElement *)entry;

- (BOOL)isFolder;

- (NSObject *)getProperty:(NSString *)name;

- (void)parse:(DDXMLElement *)entry;

@end
