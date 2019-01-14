//
//  UIViewController+Alerts.m
//  Notes
//
//  Created by admin on 1/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "UIViewController+Alerts.h"
#import <objc/runtime.h>
#import <JGProgressHUD.h>

static const char *alertViewControllersKey = "alertViewControllersKey";

@implementation UIViewController (Alerts)

- (void)presentAlertViewController:(UIViewController *)alertViewController named:(NSString *)key animated:(BOOL)animated
{
    NSMutableDictionary *alertViewControllers = objc_getAssociatedObject(self, alertViewControllersKey);
    if (!alertViewControllers)
    {
        alertViewControllers = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, alertViewControllersKey, alertViewControllers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // Check for an existing object with the same key
    UIViewController *oldViewController = [alertViewControllers objectForKey:key];
    if (oldViewController)
    {
        [self dismissAlertViewControllerNamed:key animated:YES];
    }
    
    // store the alertViewController in our array
    [alertViewControllers setObject:alertViewController forKey:key];
    [self addChildViewController:alertViewController];
    
    // Add new view to our view stack
    CGFloat originalAlpha = alertViewController.view.alpha;
    alertViewController.view.alpha = 0;
    [self.view addSubview:alertViewController.view];
    
    [UIView animateWithDuration:(animated ? 0.3 : 0.0) animations:^{
        alertViewController.view.alpha = originalAlpha;
    }];
}

- (void)dismissAlertViewControllerNamed:(NSString *)key animated:(BOOL)animated {
    NSMutableDictionary *alertViewControllers = objc_getAssociatedObject(self, alertViewControllersKey);
    if (alertViewControllers)
    {
        UIViewController *alertViewController = [alertViewControllers objectForKey:key];
        
        if (alertViewController)
        {
            // animate out of position
            CGFloat originalAlpha = alertViewController.view.alpha;
            [UIView animateWithDuration:(animated ? 0.3 : 0.0) animations:^{
                alertViewController.view.alpha = 0;
            } completion:^(BOOL finished) {
                // remove the view controller from the list
                [alertViewController.view removeFromSuperview];
                alertViewController.view.alpha = originalAlpha;
                [alertViewController removeFromParentViewController];
                [alertViewControllers removeObjectForKey:key];
            }];
        }
    }
}

- (void)presentLoadingWithText:(NSString *)text andDismissAfterDelay:(double)delay {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = text;
    [HUD showInView:self.view];
    [HUD dismissAfterDelay:delay];
}

@end
