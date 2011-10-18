//
//  RootViewController.h
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright Nuxeo 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXFolder.h"

@interface FolderViewController : UITableViewController {
    NXFolder *folder;
    NSURL *url;
    
    IBOutlet UIBarButtonItem* infoButton;
}

@property (nonatomic, retain) NXFolder *folder;
@property (nonatomic, retain) NSURL *url;

- (void)refresh;

@end
