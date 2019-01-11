//
//  KIFUITestActor+EXAdditions.m
//  NotesUITests
//
//  Created by admin on 1/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "KIFUITestActor+EXAdditions.h"

@implementation KIFUITestActor (EXAdditions)

- (void)navigateToAddNote {
    [self tapViewWithAccessibilityLabel:@"Add"];
}

@end
