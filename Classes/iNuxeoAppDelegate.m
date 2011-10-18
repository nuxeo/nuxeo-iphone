//
//  iNuxeoAppDelegate.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright Nuxeo 2009. All rights reserved.
//

#import "iNuxeoAppDelegate.h"

@implementation iNuxeoAppDelegate

@synthesize window;
@synthesize tabController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];    
    if (nil == [userDefaults stringForKey:@"serviceUrl"]
        || nil == [userDefaults stringForKey:@"username"]
        || nil == [userDefaults stringForKey:@"password"]) {
        tabController.selectedIndex = 3;
    }
    
	// Configure and show the window
	[window addSubview:[tabController view]];
	[window makeKeyAndVisible];
    [self showSplashView];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

- (void)dealloc {
	[tabController release];
	[window release];
	[super dealloc];
}

// Splash screen fadeout goodness (or evilness?)

- (void)showSplashView {
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [window addSubview:splashView];
    [window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-60, -60, 440, 600);
    [UIView commitAnimations];
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashView removeFromSuperview];
    [splashView release];
}

@end
