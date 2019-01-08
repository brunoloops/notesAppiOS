//
//  main.m
//  Notes
//
//  Created by admin on 1/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DataManager.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        DataManager *dataManager = [DataManager sharedManager];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
