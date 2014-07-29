//
//  HTMGeofenceManager.h
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/28/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

extern NSString * const HTMGeofencedRegionsUpdatedNotification;
extern NSString * const kAddedGeofencedRegionsKey;
extern NSString * const kRemovedGeofencedRegionsKey;

@interface HTMGeofenceManager : NSObject

+ (instancetype)sharedManager;

- (void)registerGeofenceForRegion:(CLRegion *)region;
- (void)registerGeofenceForCoordinate:(CLLocationCoordinate2D)coordinate
                               radius:(CGFloat)radius;

- (void)removeGeofencedRegion:(CLRegion *)geofencedRegion;
- (void)removeAllGeofencedRegions;

- (NSArray *)geofencedRegions;

@end
