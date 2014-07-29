//
//  MBLocationArrowButton.m
//  Project-Gator
//
//  Created by John Hammerlund on 3/17/14.
//  Copyright (c) 2014 MINDBODY Inc. All rights reserved.
//

#import "MBLocationArrowButton.h"
#import "UIView+HelperTools.h"

@interface MBLocationArrowButton()

// Needed to create two seperate imageViews because of an issue of
// not being able to change the view's image to the orange arrow
@property (nonatomic, weak) UIImageView *grayArrowImageView;
@property (nonatomic, weak) UIImageView *orangeArrowImageView;

@end

@implementation MBLocationArrowButton

const CGFloat kLocationArrowButtonAlpha = 0.9f;

- (id)init
{
    return self = [[super init] configure_];
}

- (id)initWithFrame:(CGRect)frame
{
    return self = [[super initWithFrame:frame] configure_];
}

- (UIView *)grayArrowImageView
{
    if (!_grayArrowImageView) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        _grayArrowImageView = imageView;
    }
    return _grayArrowImageView;
}

- (UIView *)orangeArrowImageView
{
    if (!_orangeArrowImageView) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        _orangeArrowImageView = imageView;
    }
    return _orangeArrowImageView;
}

- (id)configure_
{
    [self.layer setShouldRasterize:YES];
    return self;
}

- (void)layoutSubviews
{
    [self configureArrow];

    const CGSize  kShadowOffset       = CGSizeMake(0, 1.5); // Again -- CGSize for an offset? Really, Apple?
    const CGFloat kShadowOpacity      = 0.1f;

    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:kShadowOffset];
    [self.layer setShadowRadius:0];
    [self.layer setShadowOpacity:kShadowOpacity];

    CGRect circleFrame = [self circleRectForFrame:self.bounds];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:circleFrame cornerRadius:circleFrame.size.height/2];

    [self.layer setShadowPath:circlePath.CGPath];

    [super layoutSubviews];
}

- (void)configureArrow
{
    // The arrow isn't perfectly centered because of visual derp
    CGSize arrowOffset = CGSizeMake(-1, 1); // Alright, I might possibly be mocking them at this point
    
    CGFloat imageScale = 0.45; // Size of image compared to size of button
    UIImage *orangeArrowImage = [UIImage imageNamed:@"MBCenterMapArrowOrange"];
    UIImage *grayArrowImage = [UIImage imageNamed:@"MBCenterMapArrowGrey"];
    CGSize imageSize = CGSizeMake(grayArrowImage.size.width * imageScale, grayArrowImage.size.height * imageScale);
    
    [self.orangeArrowImageView setFrameSize:imageSize];
    [self.orangeArrowImageView setCenter:CGPointMake(self.frameWidth/2 + arrowOffset.width, self.frameHeight/2 + arrowOffset.height)];
    [self.orangeArrowImageView setImage:[self imageWithImage:orangeArrowImage toSize:imageSize]];
    
    [self.grayArrowImageView setFrameSize:imageSize];
    [self.grayArrowImageView setCenter:CGPointMake(self.frameWidth/2 + arrowOffset.width, self.frameHeight/2 + arrowOffset.height)];
    [self.grayArrowImageView setImage:[self imageWithImage:grayArrowImage toSize:imageSize]];
}

- (UIImage *)imageWithImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)indicateAtCurrentLocationIsActive
{
    [self bringSubviewToFront:self.orangeArrowImageView];
}

- (void)indicateNotAtCurrentLocation
{
    [self bringSubviewToFront:self.grayArrowImageView];
}

- (CGRect)circleRectForFrame:(CGRect)frame
{
    return CGRectInset(frame, 0.5, 0.5);
}

- (void)drawRect:(CGRect)rect
{
    CGRect rectWithoutLineWidth = [self circleRectForFrame:rect];
    [[UIColor grayColor] setStroke];
    [[[UIColor whiteColor] colorWithAlphaComponent:self.isHighlighted ? 1 : kLocationArrowButtonAlpha] setFill];

    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:rectWithoutLineWidth cornerRadius:rectWithoutLineWidth.size.height/2];
    [circlePath stroke];
    [circlePath fill];

}

@end
