//
//  iNuxeoAppDelegate.h
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright Nuxeo 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iNuxeoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabController;
    UIImageView *splashView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabController;

- (void)showSplashView;

@end

