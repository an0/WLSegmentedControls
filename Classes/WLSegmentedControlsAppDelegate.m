//
//  WLSegmentedControlsAppDelegate.m
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/21/10.
//  Copyright I Wonder Phone 2010. All rights reserved.
//

#import "WLSegmentedControlsAppDelegate.h"
#import "WLVerticalSegmentedControl.h"
#import "WLHorizontalSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

@interface WLSegmentedControlsAppDelegate ()

- (void)pickDate:(WLVerticalSegmentedControl *)sender;

@end


@implementation WLSegmentedControlsAppDelegate

@synthesize window;
@synthesize datePicker;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	WLVerticalSegmentedControl *verticalSegmentedControl = [[WLVerticalSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"None", @"Daily", @"Weekly", @"Monthly", @"Yearly", nil]];
	verticalSegmentedControl.allowsMultiSelection = YES;
//	verticalSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [window addSubview:verticalSegmentedControl];
	[verticalSegmentedControl addTarget:self action:@selector(pickDate:) forControlEvents:UIControlEventValueChanged];
	verticalSegmentedControl.frame = CGRectMake(0, 140, 75, 216);
	
	WLHorizontalSegmentedControl *horizontalSegmentedControl = [[WLHorizontalSegmentedControl alloc] initWithImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"time"], [UIImage imageNamed:@"priority"], [UIImage imageNamed:@"location"], nil] selectedImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"time_active"], [UIImage imageNamed:@"priority_active"], [UIImage imageNamed:@"location_active"], nil]];
	horizontalSegmentedControl.allowsMultiSelection = YES;
//	horizontalSegmentedControl.tintColor = [UIColor colorWithRed:.2 green:.0 blue:.2 alpha:1];
	horizontalSegmentedControl.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	horizontalSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [window addSubview:horizontalSegmentedControl];
	[horizontalSegmentedControl addTarget:self action:@selector(pickDate:) forControlEvents:UIControlEventValueChanged];
	CGRect frame = horizontalSegmentedControl.frame;
	frame.origin.x = 56;
	frame.origin.y = 40;
//	frame.size.width = 200;
	horizontalSegmentedControl.frame = frame;
	
    [window makeKeyAndVisible];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}




#pragma mark -
#pragma mark Events Handling
	 
- (void)pickDate:(WLVerticalSegmentedControl *)sender {
	switch (sender.selectedSegmentIndex) {
		case 0:
			self.datePicker.date = [NSDate date];
			break;
			
		case 1:
			self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:3600];
			break;
			
		case 2:
			self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:86400];
			break;	
			
		default:
			break;
	}
}
	 
@end
