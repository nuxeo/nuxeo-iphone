//
//  RootViewController.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright Nuxeo 2009. All rights reserved.
//

#import "FolderViewController.h"
#import "DocViewController.h"
#import "iNuxeoAppDelegate.h"
#import "CmisClient.h"
#import "FolderViewCell.h"

@implementation FolderViewController

@synthesize folder, url;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationItem.rightBarButtonItem = infoButton;

    CmisClient *client = [CmisClient sharedClient];
    if (self.url == nil) {
        self.url = client.rootCollectionUrl;
    }
    self.folder = [client getFolderInfoAt:self.url];
}

// TODO: hack for now
- (void)refresh {
    CmisClient *client = [CmisClient sharedClient];
    self.url = client.rootCollectionUrl;
    self.folder = [client getFolderInfoAt:self.url];
    [self.tableView reloadData]; 
}
    
- (void)dealloc {
    [folder release];
    [url release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection called, url = %@", self.url);
    return [self.folder.children count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    NXObject *object = [self.folder.children objectAtIndex:indexPath.row];
    
    FolderViewCell *cell = (FolderViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[FolderViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell initWithObject:object];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    NXObject *object = [self.folder.children objectAtIndex:row];

    if ([object isFolder]) {
        // Push Folder View Controller
        FolderViewController *folderViewController = [[FolderViewController alloc] initWithNibName:@"FolderView" bundle:nil];
        folderViewController.title = object.title;
        folderViewController.url = object.url;
        [self.navigationController pushViewController:folderViewController animated:YES];
        [folderViewController release];

    } else {
        // Push Document View Controller.
        DocViewController *docViewController = [[DocViewController alloc] initWithNibName:@"DocView" bundle:nil];
        docViewController.title = object.title;
        docViewController.url = object.url;
        [self.navigationController pushViewController:docViewController animated:YES];
        [docViewController loadDocument];
        [docViewController release];
    }
}

@end
