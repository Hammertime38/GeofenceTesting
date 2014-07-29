//
//  HTMGeofenceManager.m
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/28/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import "HTMGeofenceManager.h"

NSString * const HTMGeofencedRegionsUpdatedNotification = @"HTMGeofencedRegionsUpdatedNotification";
NSString * const kAddedGeofencedRegionsKey = @"kAddedGeofencedRegionsKey";
NSString * const kRemovedGeofencedRegionsKey = @"kRemovedGeofencedRegionsKey";

@interface HTMGeofenceManager() <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSMutableOrderedSet *orderedMonitoredRegions;
@end

@implementation HTMGeofenceManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static HTMGeofenceManager *me;
    dispatch_once(&onceToken, ^{
        me = [self new];
        me->_locationManager = [CLLocationManager new];
        [me->_locationManager setDelegate:me];
        me->_orderedMonitoredRegions = [NSMutableOrderedSet orderedSet];
    });
    return me;
}

- (void)registerGeofenceForRegion:(CLRegion *)region
{
    if ([self.locationManager.monitoredRegions containsObject:region])
        return;

	[self.locationManager startMonitoringForRegion:region];
    [self.orderedMonitoredRegions addObject:region];
    [[NSNotificationCenter defaultCenter] postNotificationName:HTMGeofencedRegionsUpdatedNotification object:self userInfo:@{kAddedGeofencedRegionsKey : @[region]}];
}

- (void)registerGeofenceForCoordinate:(CLLocationCoordinate2D)coordinate
                               radius:(CGFloat)radius
{
    NSString *identifier = [NSString stringWithFormat:@"CIRCULAR_REGION_LONG_%lf_LAT_%lf_RADIUS_%lf", coordinate.longitude, coordinate.latitude, radius];
	CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:radius identifier:identifier];
    [self registerGeofenceForRegion:region];
}

- (void)removeGeofencedRegion:(CLRegion *)geofencedRegion
{
	if (![self.locationManager.monitoredRegions containsObject:geofencedRegion])
        return;

    [self.locationManager stopMonitoringForRegion:geofencedRegion];
    [self.orderedMonitoredRegions removeObject:geofencedRegion];
    [[NSNotificationCenter defaultCenter] postNotificationName:HTMGeofencedRegionsUpdatedNotification object:self userInfo:@{kRemovedGeofencedRegionsKey : @[geofencedRegion]}];
}

- (void)removeAllGeofencedRegions
{
	if (self.locationManager.monitoredRegions.count == 0)
        return;

    NSArray *monitoredRegions = [self.locationManager.monitoredRegions allObjects];
    for (CLRegion *region in monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
        [self.orderedMonitoredRegions removeObject:region];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HTMGeofencedRegionsUpdatedNotification object:self userInfo:@{kRemovedGeofencedRegionsKey : monitoredRegions}];
}

- (NSArray *)geofencedRegions
{
	return [self.orderedMonitoredRegions array];
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{

}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{

}

@end
