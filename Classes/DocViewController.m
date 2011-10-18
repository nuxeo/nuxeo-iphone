//
//  DocViewController.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import "DocViewController.h"
#import "CmisClient.h"

@implementation DocViewController

@synthesize url, document;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.title = document.title;
    self.navigationItem.backBarButtonItem.enabled = YES;
}

- (void)loadDocument {
    UIWebView *view = [[UIWebView alloc] init];
    view.scalesPageToFit = YES;
    self.view = view;
    
    NSMutableURLRequest *request = [[CmisClient sharedClient] makeRequestForURL:url consumes:@"*/*"];
    NSHTTPURLResponse *response;
    NSError *error;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[self showSpinner];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] != 200) {
        NSLog(@"WARNING: non-200 response code!: %d", [response statusCode]);
    }
    [view loadData:data MIMEType:[response MIMEType] textEncodingName:nil baseURL:url];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[self hideSpinner];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark spinner

- (void)addProgressIndicator {
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    [self.view addSubview:spinnerView];
    spinnerView.alpha = 0.0;
    [self.view bringSubviewToFront:spinnerView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    spinnerView.alpha = 0.7;
    [UIView commitAnimations];
    
    [apool release];
}

- (void)removeProgressIndicator {
    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    [UIView setAnimationDelegate:self];
    spinnerView.alpha = 0.0;
    [UIView commitAnimations];
    
    [spinnerView removeFromSuperview];
    
    [apool release];
}

- (void)showSpinner {
    [self performSelectorInBackground:@selector(addProgressIndicator) withObject:nil];
}

- (void)hideSpinner {
    [self performSelectorInBackground:@selector(removeProgressIndicator) withObject:nil];
}

@end
