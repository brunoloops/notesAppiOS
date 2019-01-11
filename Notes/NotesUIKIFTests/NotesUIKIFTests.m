//
//  NotesUIKIFTests.m
//  NotesUIKIFTests
//
//  Created by admin on 1/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import "KIFUITestActor+EXAdditions.h"

@interface NotesUIKIFTests : KIFTestCase

@end

@implementation NotesUIKIFTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testGoToAddNote {
    [tester navigateToAddNote];
}

- (void)testAddNote {
    [tester navigateToAddNote];
    [tester waitForViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester waitForCellAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] inTableViewWithAccessibilityIdentifier:@"NotesTableView"];
}

- (void)testNoteDetail {
    [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] inTableViewWithAccessibilityIdentifier: @"NotesTableView"];
    [tester waitForTappableViewWithAccessibilityLabel: @"Edit"];
}

@end
