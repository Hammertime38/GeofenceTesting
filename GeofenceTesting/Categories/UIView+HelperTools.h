//
//  UIView+Helpers.h
//  Project-Gator
//
//  Created by Brett Wellman on 11/22/13.
//  Copyright (c) 2013 MINDBODY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIView (HelperTools)

typedef NS_OPTIONS (NSUInteger, MBSelectiveBorder) {
    MBSelectiveBorderLeft = 1 <<  0,
    MBSelectiveBorderRight = 1 <<  1,
    MBSelectiveBorderTop = 1 <<  2,
    MBSelectiveBorderBottom = 1 <<  3,
    MBSelectiveBorderAll = ~0UL
};

- (void) addLoadingSpinnerToView;
- (void) removeLoadingSpinnerFromView;
- (void) makeViewCircular;

@property (nonatomic) CGFloat frameHeight;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameY;
@property (nonatomic) CGFloat frameX;

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

- (void)increaseFrameHeight:(CGFloat)height;
- (void)decreaseFrameHeight:(CGFloat)height;
- (void)increaseFrameWidth:(CGFloat)width;
- (void)decreaseFrameWidth:(CGFloat)width;

- (void)increaseFrameY:(CGFloat)y;
- (void)decreaseFrameY:(CGFloat)y;
- (void)increaseFrameX:(CGFloat)x;
- (void)decreaseFrameX:(CGFloat)x;

/**
 Adds a border to the desired side(s) of an UIView
 */
- (void)addBorder:(MBSelectiveBorder)side withColor:(UIColor*)color andThickness:(CGFloat)thickness;
@end
