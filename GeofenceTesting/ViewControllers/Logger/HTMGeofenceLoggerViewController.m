//
//  HTMGeofenceLoggerViewController.m
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/28/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import "HTMGeofenceLoggerViewController.h"
#import "HTMLogger.h"
#import "HTMLogTableViewCell.h"

@implementation HTMGeofenceLoggerViewController

NSString * const kLogTableCellIdentifier = @"kLogTableCellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[HTMLogTableViewCell class] forCellReuseIdentifier:kLogTableCellIdentifier];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setContentInset:UIEdgeInsetsMake(40, 0, 0, 0)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveLog_:) name:HTMLoggerReceivedLogNotification object:nil];
}

- (void)didReceiveLog_:(NSNotification *)note
{
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTMLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLogTableCellIdentifier forIndexPath:indexPath];
    [cell configureWithLog:[[HTMLogger sharedLogger] logs][indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HTMLogTableViewCell heightWithLog:[[HTMLogger sharedLogger] logs][indexPath.row] constrainedWidth:tableView.frame.size.width];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[HTMLogger sharedLogger] logs].count;
}

@end
