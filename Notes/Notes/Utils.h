//
//  Utils.h
//  Notes
//
//  Created by admin on 1/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (NSString *)dateToReadableDate:(NSDate *)date withStyle:(NSDateFormatterStyle)style;

@end

NS_ASSUME_NONNULL_END
