//
//  MBLocationArrowButton.h
//  Project-Gator
//
//  Created by John Hammerlund on 3/17/14.
//  Copyright (c) 2014 MINDBODY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBLocationArrowButton : UIButton

- (void)indicateAtCurrentLocationIsActive;
- (void)indicateNotAtCurrentLocation;

@end
