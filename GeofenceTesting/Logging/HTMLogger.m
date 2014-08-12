//
//  HTMLogger.m
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/29/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import "HTMLogger.h"

NSString * const HTMLoggerReceivedLogNotification = @"HTMLoggerReceivedLogNotification";
NSString * const kReceivedLogKey = @"kReceivedLogKey";

@interface HTMLogger()
@property (nonatomic) NSMutableArray *receivedLogs;
@end

@implementation HTMLogger

+ (instancetype)sharedLogger
{
    static HTMLogger *me;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [self new];
        me->_receivedLogs = [NSMutableArray array];
    });
    return me;
}

- (void)logMessage:(DDLogMessage *)logMessage
{
    [self.receivedLogs addObject:logMessage];
    [[NSNotificationCenter defaultCenter] postNotificationName:HTMLoggerReceivedLogNotification object:nil userInfo:@{kReceivedLogKey : logMessage}];
}

- (NSArray *)logs
{
    return [self.receivedLogs copy];
}

@end
