//
//  DataManager.h
//  Notes
//
//  Created by admin on 1/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject


+ (instancetype) sharedManager;
- (void)getNotesWithCompletionBlock:(void (^)(NSArray * nullable, NSError *error))completionBlock;

@end

NS_ASSUME_NONNULL_END
