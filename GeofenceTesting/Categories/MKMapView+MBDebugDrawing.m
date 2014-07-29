//
//  MKMapView+MBDebugDrawing.m
//  Project-Gator
//
//  Created by John Hammerlund on 6/10/14.
//  Copyright (c) 2014 MINDBODY Inc. All rights reserved.
//

#import "MKMapView+MBDebugDrawing.h"
#import "UIColor+Random.h"
#import "HTMGeofenceManager.h"
#import "HTMGeofencedCircleRenderer.h"
#import <objc/runtime.h>

@implementation MKMapView (MBDebugDrawing)

static const char * kMBMapViewDrawsGeofencedRegionsKey = "kMBMapViewDrawsGeofencedRegionsKey";
static const char * kMBMapViewDebugOverlaysKey = "kMBMapViewDebugOverlaysKey";

- (MKOverlayRenderer *)mb_rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([[self mb_mapViewDebugOverlays_] containsObject:overlay]) {
        const CGFloat kMKCircleAlpha = 0.25f;
        HTMGeofencedCircleRenderer *circleRenderer = [[HTMGeofencedCircleRenderer alloc] initWithCircle:overlay];
        NSUInteger idx = [[self mb_mapViewDebugOverlays_] indexOfObject:overlay];
        [circleRenderer setCenterLabelText:[NSString stringWithFormat:@"%lu", (unsigned long)idx+1]];

        UIColor *randomColor = [UIColor randomColorWithAlpha:kMKCircleAlpha];
        CGFloat colorBrightness, colorHue, colorSaturation;
        [randomColor getHue:&colorHue saturation:&colorSaturation brightness:&colorBrightness alpha:nil];

        [circleRenderer setFillColor:randomColor];
        [circleRenderer setStrokeColor:[UIColor colorWithHue:colorHue saturation:colorSaturation brightness:fmaxf(colorBrightness-0.05, 0) alpha:kMKCircleAlpha]];
        return circleRenderer;
    }
    return nil;
}

- (NSMutableArray *)mb_mapViewDebugOverlays_
{
    id overlays = objc_getAssociatedObject(self, kMBMapViewDebugOverlaysKey);
    if (!overlays) {
        [self mb_setMapViewDebugOverlays_:[NSMutableArray array]];
        return objc_getAssociatedObject(self, kMBMapViewDebugOverlaysKey);
    }
    return overlays;
}

- (void)mb_setMapViewDebugOverlays_:(NSMutableArray *)overlays
{
    objc_setAssociatedObject(self, kMBMapViewDebugOverlaysKey, overlays, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Geofencing

- (BOOL)mb_drawsGeofencedRegions
{
    return [objc_getAssociatedObject(self, kMBMapViewDrawsGeofencedRegionsKey) boolValue];
}

- (void)mb_setDrawsGeofencedRegions:(BOOL)drawsGeofencedRegions
{
    if (drawsGeofencedRegions != [self mb_drawsGeofencedRegions]) {
        if (drawsGeofencedRegions) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(mb_drawGeofencedRegionsOnMap_)
                                                         name:HTMGeofencedRegionsUpdatedNotification
                                                       object:nil];
            [self mb_drawGeofencedRegionsOnMap_];

        }
        else {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [self mb_removeGeofencedRegionsFromMap_];
        }
    }
    objc_setAssociatedObject(self, kMBMapViewDrawsGeofencedRegionsKey, @(drawsGeofencedRegions), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mb_drawGeofencedRegionsOnMap_
{
    NSArray *monitoredRegions = [[HTMGeofenceManager sharedManager] geofencedRegions];
    [self mb_removeGeofencedRegionsFromMap_];

    NSMutableArray *circleOverlays = [NSMutableArray arrayWithCapacity:monitoredRegions.count];
    for (CLCircularRegion *circularRegion in monitoredRegions) {
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:circularRegion.center radius:circularRegion.radius];
        [circleOverlays addObject:circle];
    }
    [[self mb_mapViewDebugOverlays_] addObjectsFromArray:circleOverlays];
    [self addOverlays:circleOverlays];
}

- (void)mb_removeGeofencedRegionsFromMap_
{
    NSMutableArray *overlays = [self mb_mapViewDebugOverlays_];
    if ([overlays count])
        [self removeOverlays:overlays];
    [overlays removeAllObjects];
}

@end
