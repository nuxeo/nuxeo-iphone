//
//  FolderViewCell.h
//  iNuxeo
//
//  Created by Stefane Fermigier on 3/8/10.
//  Copyright 2010 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXObject.h"

@interface FolderViewCell : UITableViewCell {
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain, readonly) NSDateFormatter *dateFormatter;

- (id)initWithObject:(NXObject *)object;

@end
