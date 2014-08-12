//
//  HTMLogTableViewCell.m
//  GeofenceTesting
//
//  Created by John Hammerlund on 7/29/14.
//  Copyright (c) 2014 Hammertime. All rights reserved.
//

#import "HTMLogTableViewCell.h"

@interface HTMLogTableViewCell()
@property (nonatomic, weak) UILabel *logLabel;
@end

@implementation HTMLogTableViewCell

- (UILabel *)logLabel
{
    if (!_logLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        [label setNumberOfLines:0];
        [self addSubview:label];
        _logLabel = label;
    }
    return _logLabel;
}

- (void)configureWithLog:(DDLogMessage *)logMessage
{
    [self.logLabel setFrame:CGRectMake(0, 0, self.frame.size.width, [self.class heightWithLog:logMessage constrainedWidth:self.frame.size.width])];

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:logMessage->logMsg attributes:[self.class stringAttributesForLog_:logMessage]];
    [self.logLabel setAttributedText:attributedString];
}

+ (CGFloat)heightWithLog:(DDLogMessage *)logMessage constrainedWidth:(CGFloat)width
{
    static const CGFloat kPaddingY = 10;

    NSDictionary *attributes = [self stringAttributesForLog_:logMessage];
    NSString *logString = logMessage->logMsg;

    CGRect boundingRect = [logString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                               attributes:attributes
                                                  context:nil];
    return boundingRect.size.height + kPaddingY;
}

+ (NSDictionary *)stringAttributesForLog_:(DDLogMessage *)logMessage
{
    return @{NSFontAttributeName : [UIFont systemFontOfSize:20.f]};
}

@end
