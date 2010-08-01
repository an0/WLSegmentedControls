//
//  WLSegmentedControlsAppDelegate.h
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/21/10.
//  Copyright I Wonder Phone 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WLSegmentedControlsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@end

