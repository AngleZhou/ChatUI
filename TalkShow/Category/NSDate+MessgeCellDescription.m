//
//  NSDate+MessgeCellDescription.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/18.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "NSDate+MessgeCellDescription.h"

@implementation NSDate (MessgeCellDescription)


+ (NSString *)ts_desciptionOfDate:(NSDate *)date fullDate:(BOOL)fullDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    if (fullDate) {
        formatter.dateStyle = NSDateFormatterMediumStyle;
    }
    formatter.locale = [NSLocale currentLocale];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
@end
