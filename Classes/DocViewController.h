//
//  DocViewController.h
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXDocument.h"


@interface DocViewController : UIViewController {
    // The attached document (not used for now!)
    NXDocument *document;
    // The document's download URL
    NSURL *url;

    IBOutlet UIView *spinnerView;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NXDocument *document;

- (void)loadDocument;

@end
