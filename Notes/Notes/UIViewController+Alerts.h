//
//  UIViewController+Alerts.h
//  Notes
//
//  Created by admin on 1/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alerts)

- (void)presentAlertViewController:(UIViewController *)alertViewController named:(NSString *)key animated:(BOOL)animated;
- (void)dismissAlertViewControllerNamed:(NSString *)key animated:(BOOL)animated;
- (void)presentLoadingWithText:(NSString *)text andDismissAfterDelay:(double)delay;

@end

NS_ASSUME_NONNULL_END
