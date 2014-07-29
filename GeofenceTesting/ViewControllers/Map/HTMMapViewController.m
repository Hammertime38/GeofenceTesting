//
//  HTMMapViewController.m
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/28/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import "HTMMapViewController.h"
#import <MapKit/MapKit.h>
#import "MBLocationArrowButton.h"
#import "MKMapView+MBDebugDrawing.h"
#import "HTMGeofenceManager.h"
#import <objc/runtime.h>

#define HTM_GEOFENCE_DEFAULT_RADIUS 250

@interface HTMMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet MBLocationArrowButton *locationArrowButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, assign, getter = didMoveToUserLocationOnFirstLoad) BOOL movedToUserLocationOnFirstLoad;
@property (nonatomic) CLLocation *currentUserLocation;
@end

@implementation HTMMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUserCoordinate:kCLLocationCoordinate2DInvalid];

    [self.mapView setShowsUserLocation:YES];
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressMap_:)];
    [longPressRecognizer setMinimumPressDuration:0.5];
    [self.mapView addGestureRecognizer:longPressRecognizer];

    [self.mapView setDelegate:self];
    [self.mapView mb_setDrawsGeofencedRegions:YES];

    [self.locationArrowButton addTarget:self action:@selector(moveToUserLocation_) forControlEvents:UIControlEventTouchUpInside];

    [[HTMGeofenceManager sharedManager] removeAllGeofencedRegions];
    [self setLocationManager:[CLLocationManager new]];
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
}

- (void)moveToUserLocation_
{
    if (self.currentUserLocation.horizontalAccuracy > 0 && self.currentUserLocation.horizontalAccuracy < 100) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentUserLocation.coordinate, 1000, 1000);
        [self.mapView setRegion:region animated:YES];
    }
}

static char * kSelectedCoordinateHackyKey;

- (void)didLongPressMap_:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSArray *geofencedRegions = [[HTMGeofenceManager sharedManager] geofencedRegions];

        CLLocationCoordinate2D selectedCoordinate = [self.mapView convertPoint:[sender locationInView:self.mapView] toCoordinateFromView:self.mapView];

        NSUInteger numSelectedRegions = 0;

        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:self];
        [actionSheet addButtonWithTitle:@"Add New Region"];

        for (NSUInteger i = 0; i < geofencedRegions.count; i++) {
            CLCircularRegion *geofencedRegion = geofencedRegions[i];
            if ([geofencedRegion containsCoordinate:selectedCoordinate]) {
                [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"Remove Region %lu", i+1]];
                numSelectedRegions++;
            }
        }

        [actionSheet addButtonWithTitle:@"Cancel"];

        [actionSheet setTitle:@"Derp"];
        [actionSheet setCancelButtonIndex:numSelectedRegions];
        objc_setAssociatedObject(actionSheet, kSelectedCoordinateHackyKey, [NSValue valueWithMKCoordinate:selectedCoordinate], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        if (numSelectedRegions > 0) {
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
        else {
            [[HTMGeofenceManager sharedManager] registerGeofenceForCoordinate:selectedCoordinate radius:HTM_GEOFENCE_DEFAULT_RADIUS];
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    return [self.mapView mb_rendererForOverlay:overlay];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    [self.mapView setRegion:region];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations firstObject];

    if (currentLocation.horizontalAccuracy > 0 && currentLocation.horizontalAccuracy < 100) {
        [self setCurrentUserLocation:currentLocation];
        if (!self.didMoveToUserLocationOnFirstLoad) {
            [self moveToUserLocation_];
            [self setMovedToUserLocationOnFirstLoad:YES];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSArray *geofencedRegions = [[HTMGeofenceManager sharedManager] geofencedRegions];

    if (buttonIndex == 0) {
        // Add new region
        NSValue *coordinateValue = objc_getAssociatedObject(actionSheet, kSelectedCoordinateHackyKey);
        [[HTMGeofenceManager sharedManager] registerGeofenceForCoordinate:[coordinateValue MKCoordinateValue] radius:HTM_GEOFENCE_DEFAULT_RADIUS];
    }
    else if (buttonIndex <= geofencedRegions.count) {
        [[HTMGeofenceManager sharedManager] removeGeofencedRegion:geofencedRegions[buttonIndex - 1]];
    }
}

@end
