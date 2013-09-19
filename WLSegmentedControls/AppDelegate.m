//
//  WLSegmentedControlsAppDelegate.m
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/21/10.
//  Copyright I Wonder Phone 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "WLVerticalSegmentedControl.h"
#import "WLHorizontalSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	UIView *view = self.window.rootViewController.view;
	WLVerticalSegmentedControl *verticalSegmentedControl = [[WLVerticalSegmentedControl alloc] initWithItems:@[@"None", @"Daily", @"Weekly", @"Monthly", @"Yearly"]];
	verticalSegmentedControl.allowsMultiSelection = YES;
    [view addSubview:verticalSegmentedControl];
	verticalSegmentedControl.frame = CGRectMake(0, 140, 75, 216);
	
	WLHorizontalSegmentedControl *horizontalSegmentedControl = [[WLHorizontalSegmentedControl alloc] initWithItems:@[@"First", @"Second", @"Third"]];
	horizontalSegmentedControl.allowsMultiSelection = YES;
//	horizontalSegmentedControl.tintColor = [UIColor colorWithRed:.2 green:.0 blue:.2 alpha:1];
//	horizontalSegmentedControl.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	horizontalSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [view addSubview:horizontalSegmentedControl];
	CGRect frame = horizontalSegmentedControl.frame;
	frame.origin.x = (view.bounds.size.width - frame.size.width) / 2;
	frame.origin.y = 40;
	horizontalSegmentedControl.frame = frame;
	[horizontalSegmentedControl addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];

    [self.window makeKeyAndVisible];
	
    return YES;
}

- (void)action:(id)sender {
	
}
	 
@end
