//
//  HTMGeofencedCircleRenderer.m
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/28/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import "HTMGeofencedCircleRenderer.h"
#import <CoreText/CoreText.h>

@implementation HTMGeofencedCircleRenderer

- (void)fillPath:(CGPathRef)path inContext:(CGContextRef)context
{
    [super fillPath:path inContext:context];

    if (!self.centerLabelText)
        return;

    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:300.f]};
    CGSize stringSize = [self.centerLabelText sizeWithAttributes:attributes];

    CGRect bounds = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));

    CGPoint origin = CGPointMake(center.x - stringSize.width/2, center.y - stringSize.height/2);
    CGRect stringRect = CGRectMake(origin.x, origin.y, stringSize.width, stringSize.height);

    UIGraphicsPushContext(context);
    [self.centerLabelText drawInRect:stringRect withAttributes:attributes];

    UIGraphicsPopContext();
}

@end
