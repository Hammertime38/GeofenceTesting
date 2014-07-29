//
//  UIView+Helpers.m
//  Project-Gator
//
//  Created by Brett Wellman on 11/22/13.
//  Copyright (c) 2013 MINDBODY Inc. All rights reserved.
//

#import "UIView+HelperTools.h"

@implementation UIView (HelperTools)

static const void * KEY;

- (void) addLoadingSpinnerToView
{
    if (self && [self superview]) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner setBackgroundColor:[UIColor clearColor]];
        [spinner setFrame:[self frame]];

        objc_setAssociatedObject(self, KEY, spinner, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [[self superview] addSubview:spinner];
        [spinner startAnimating];
    }
}

- (void) removeLoadingSpinnerFromView
{
    if (self && [self superview]) {
        UIActivityIndicatorView *spinner = objc_getAssociatedObject(self, KEY);
        if (spinner) {
            [spinner stopAnimating];
            [spinner removeFromSuperview];
        }
    }
}

- (void) makeViewCircular
{
    if (self && self.frame.size.height > 0) {
        [self.layer setCornerRadius:(self.frame.size.height / 2)];
        [self.layer setMasksToBounds:YES];
        [self setContentMode:UIViewContentModeScaleAspectFill];
     }
}

- (CGFloat) frameY
{
    return self.layer.frame.origin.y;
}

- (void) setFrameY:(CGFloat)yPositionOfFrame
{
    [self setFrame:CGRectMake(self.layer.frame.origin.x, yPositionOfFrame, self.layer.frame.size.width, self.layer.frame.size.height)];
}

- (CGFloat) frameX
{
    return self.layer.frame.origin.x;
}

- (void) setFrameX:(CGFloat)xPositionOfFrame
{
    [self setFrame:CGRectMake(xPositionOfFrame, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height)];
}

- (CGFloat)frameWidth
{
    return self.layer.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)width
{
    [self setFrame:CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, width, self.layer.frame.size.height)];
}

- (CGFloat)frameHeight
{
    return self.layer.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)height
{
    [self setFrame:CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, self.layer.frame.size.width, height)];
}

- (CGPoint) frameOrigin
{
    return self.frame.origin;
}

- (void) setFrameOrigin:(CGPoint)newOrigin
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = newOrigin.x;
    newFrame.origin.y = newOrigin.y;
    [self setFrame:newFrame];
}

- (CGSize) frameSize
{
    return self.frame.size;
}

- (void) setFrameSize:(CGSize)newSize
{
    CGRect newFrame = self.frame;
    newFrame.size.width = newSize.width;
    newFrame.size.height = newSize.height;
    [self setFrame:newFrame];
}

- (void)increaseFrameHeight:(CGFloat)height
{
    [self setFrameHeight:(self.layer.frame.size.height + height)];
}

- (void)decreaseFrameHeight:(CGFloat)height
{
    [self setFrameHeight:(self.layer.frame.size.height - height)];
}

- (void)increaseFrameWidth:(CGFloat)width
{
    [self setFrameWidth:(self.layer.frame.size.width + width)];
}

- (void)decreaseFrameWidth:(CGFloat)width
{
    [self setFrameWidth:(self.layer.frame.size.width - width)];
}

- (void)increaseFrameY:(CGFloat)y;
{
    [self setFrameY:self.layer.frame.origin.y + y];
}

- (void)decreaseFrameY:(CGFloat)y
{
    [self setFrameY:self.layer.frame.origin.y - y];
}

- (void)increaseFrameX:(CGFloat)x
{
    [self setFrameX:self.layer.frame.origin.x + x];
}

- (void)decreaseFrameX:(CGFloat)x
{
    [self setFrameX:self.layer.frame.origin.x - x];
}

- (void)addBorder:(MBSelectiveBorder)side withColor:(UIColor*)color andThickness:(CGFloat)thickness
{
    if (side & MBSelectiveBorderBottom)
        [self _addLayerWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds), CGRectGetMaxX(self.bounds), thickness)
                       withColor:color andThickness:thickness];

    if (side & MBSelectiveBorderTop)
        [self _addLayerWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.bounds), thickness)
                       withColor:color andThickness:thickness];

    if (side & MBSelectiveBorderLeft)
        [self _addLayerWithFrame:CGRectMake(0, 0, thickness, CGRectGetMaxY(self.bounds))
                       withColor:color andThickness:thickness];

    if (side & MBSelectiveBorderRight)
        [self _addLayerWithFrame:CGRectMake(CGRectGetMaxX(self.bounds) - thickness, 0, thickness, CGRectGetMaxY(self.bounds))
                       withColor:color andThickness:thickness];
}

/**
 Simple private helper for addBorder:(MBSelectiveBorder)side withColor:(UIColor*)color andThickness:(CGFloat)thickness
 */
-(void)_addLayerWithFrame:(CGRect)frame withColor:(UIColor*)color andThickness:(CGFloat)thickness
{
    CALayer *border = [CALayer layer];
    [border setFrame:frame];
    [border setBackgroundColor:color.CGColor];
    [self.layer addSublayer:border];
}

@end
