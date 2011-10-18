//
//  Document.h
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXObject.h"

@interface NXDocument : NXObject {
    NSString *downloadUrl;
    NSString *mimeType;
}

@property (retain) NSString *downloadUrl;
@property (retain) NSString *mimeType;

@end
