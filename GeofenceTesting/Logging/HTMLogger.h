//
//  HTMLogger.h
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/29/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import <CocoaLumberjack/DDLog.h>

extern NSString * const HTMLoggerReceivedLogNotification;
extern NSString * const kReceivedLogKey;

@interface HTMLogger : DDAbstractLogger

+ (instancetype)sharedLogger;

@property (nonatomic, readonly, copy) NSArray *logs;

@end
