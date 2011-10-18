//
//  Folder.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import "NXFolder.h"

@implementation NXFolder

@synthesize children;

- (id)init {
    [super init];
    self.children = [[NSMutableArray alloc] init];
    return self;
}

- (id)initWithTitle:(NSString*)_title {
    [self init];
    self.title = _title;
    return self;
}


-(BOOL)isFolder {
    return YES;
}

- (void)addChild:(NXObject*)child {
    [self.children addObject:child];
}

- (NSUInteger)countChildren {
    return [self.children count];
}

- (void)sort {
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    [self.children sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
    [sortDesc release];
}

@end
