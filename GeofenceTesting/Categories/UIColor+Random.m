//
//  UIColor+Random.m
//  Project-Gator
//
//  Created by John Hammerlund on 6/5/14.
//  Copyright (c) 2014 MINDBODY Inc. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)randomColor
{
    return [self randomColorWithAlpha:1];
}

+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha
{
    CGFloat red = arc4random_uniform(256) / 255.f;
    CGFloat blue = arc4random_uniform(256) / 255.f;
    CGFloat green = arc4random_uniform(256) / 255.f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
