//
//  HTMMainTabBarController.m
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/28/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import "HTMMainTabBarController.h"
#import "HTMGeofenceLoggerViewController.h"
#import "HTMMapViewController.h"

@interface HTMMainTabBarController ()

@end

@implementation HTMMainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        HTMMapViewController *mapViewController = [HTMMapViewController new];
        [mapViewController.tabBarItem setImage:[UIImage imageNamed:@"HTMMapTabBarIcon"]];

        HTMGeofenceLoggerViewController *loggerViewController = [HTMGeofenceLoggerViewController new];
        [loggerViewController.tabBarItem setImage:[UIImage imageNamed:@"HTMListTabBarIcon"]];

        [self setViewControllers:@[mapViewController, loggerViewController]];
    }
    return self;
}

@end
