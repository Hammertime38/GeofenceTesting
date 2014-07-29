//
//  MKMapView+MBDebugDrawing.h
//  Project-Gator
//
//  Created by John Hammerlund on 6/10/14.
//  Copyright (c) 2014 MINDBODY Inc. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MBDebugDrawing)

- (MKOverlayRenderer *)mb_rendererForOverlay:(id<MKOverlay>)overlay;
- (BOOL)mb_drawsGeofencedRegions;
- (void)mb_setDrawsGeofencedRegions:(BOOL)drawsGeofencedRegions;

@end
