//
//  SearchViewController.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 3/1/10.
//  Copyright 2010 Nuxeo. All rights reserved.
//

#import "SearchViewController.h"

#define SEARCH_TPL @"<?xml version='1.0'?><query xmlns='http://docs.oasis-open.org/ns/cmis/core/200908/'>\
    <statement><![CDATA[SELECT * FROM cmis:folder WHERE contains(%s)]]></statement></query>"

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Running search for %@", searchBar.text);
}

@end
