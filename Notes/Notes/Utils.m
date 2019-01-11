//
//  Utils.m
//  Notes
//
//  Created by admin on 1/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)dateToReadableDate:(NSDate *)date withStyle:(NSDateFormatterStyle )style {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = style;
    return [formatter stringFromDate:date];
}

@end
