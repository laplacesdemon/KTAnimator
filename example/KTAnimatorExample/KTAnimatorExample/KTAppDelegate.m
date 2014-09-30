//
//  KTAppDelegate.m
//  KTAnimatorExample
//
//  Created by Suleyman Melikoglu on 01/08/14.
//  Copyright (c) 2014 Katu. All rights reserved.
//

#import "KTAppDelegate.h"
#import "KTDemoViewController.h"


@implementation KTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    KTDemoViewController *vc = [[KTDemoViewController alloc] initWithNibName:@"KTDemoViewController" bundle:nil];
    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
