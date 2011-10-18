//
//  FolderViewCell.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 3/8/10.
//  Copyright 2010 Nuxeo. All rights reserved.
//

#import "FolderViewCell.h"

@implementation FolderViewCell

// On-demand initializer for read-only property.
- (NSDateFormatter *)dateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd '|' hh:mm"];
    }
    return dateFormatter;
}

- (void)dealloc {
    [dateFormatter release];
	[super dealloc];
}

- (id)initWithObject:(NXObject *)object {

    UILabel *titleLabel = nil;
    titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 3, 240, 18)] autorelease];
    titleLabel.tag = 1;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.text = object.title;
    [self.contentView addSubview:titleLabel];

    UILabel *infoLabel = nil;
    infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(30, 18, 240, 30)] autorelease];
    infoLabel.tag = 2;
    infoLabel.font = [UIFont systemFontOfSize:11];

    NSString *creator = (NSString *)[object getProperty:@"cmis:createdBy"];
    NSDate *lastModificationDate = (NSDate *)[object getProperty:@"cmis:lastModificationDate"];
    
    if ([object isFolder]) {
        infoLabel.text = [NSString stringWithFormat:@"%@ | %@",
                          creator,
                          [self.dateFormatter stringFromDate:lastModificationDate]];
    } else {
        long long size = [(NSNumber *)[object getProperty:@"cmis:contentStreamLength"] longLongValue];
        NSString *formattedSize;
        if (size < 1000) {
            formattedSize = [NSString stringWithFormat:@"%db", size];
        } else if (size < 1000000) {
            formattedSize = [NSString stringWithFormat:@"%dkB", size/1000];
        } else if (size < 1000000000) {
            formattedSize = [NSString stringWithFormat:@"%dMB", size/1000000];
        } else if (size < 1000000000000) {
            formattedSize = [NSString stringWithFormat:@"%dGB", size/1000000000];
        }
        infoLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@",
                          creator,
                          [self.dateFormatter stringFromDate:lastModificationDate],
                          formattedSize];
    }
    [self.contentView addSubview:infoLabel];

    NSString *imageName;
    if ([object isFolder]) {
        imageName = @"folder.png";
    } else {
        NSString *mimeType = (NSString*)[object getProperty:@"cmis:contentStreamMimeType"];
        NSLog(@"MimeType = %@", mimeType);
        if ([mimeType isEqualToString:@"application/pdf"]) {            
            imageName = @"page_white_acrobat.png";
        } else if ([mimeType hasPrefix:@"image/"]) {            
            imageName = @"camera.png";
        } else if ([mimeType hasPrefix:@"video/"]) {            
            imageName = @"film.png";
        } else if ([mimeType isEqualToString:@"text/html"]) {            
            imageName = @"html.png";
        } else if ([mimeType isEqualToString:@"application/vnd.ms-powerpoint"]
                   || [mimeType hasPrefix:@"application/vnd.ms-word"]
                   || [mimeType isEqualToString:@"application/vnd.ms-excel"]
                   || [mimeType isEqualToString:@"application/msword"]
                   || [mimeType isEqualToString:@"application/vnd.ms-office"]) {            
            imageName = @"page_white_office.png";
        } else {
            imageName = @"page_white_text.png";
        }
    }
    UIImageView *iconView;
    iconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
    CGRect imageFrame = iconView.frame;
    imageFrame.origin = CGPointMake(5, 15);
    iconView.frame = imageFrame;
    iconView.tag = 3;
    iconView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.contentView addSubview:iconView];
    
    return self;
}

@end
