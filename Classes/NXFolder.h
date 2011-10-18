//
//  Folder.h
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXObject.h"

@interface NXFolder : NXObject {
    NSMutableArray *children;
}

@property (retain) NSMutableArray *children;

- (void)addChild:(NXObject*)child;
- (void)sort;
- (NSUInteger)countChildren;

@end
