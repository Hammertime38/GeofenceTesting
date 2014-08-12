//
//  HTMLogTableViewCell.h
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/29/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMLogTableViewCell : UITableViewCell

- (void)configureWithLog:(DDLogMessage *)logMessage;
+ (CGFloat)heightWithLog:(DDLogMessage *)logMessage constrainedWidth:(CGFloat)width;

@end
