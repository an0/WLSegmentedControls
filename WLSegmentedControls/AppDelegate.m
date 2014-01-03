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

@implementation AppDelegate {
    UILabel *_label;
    WLVerticalSegmentedControl *_vSeg;
    WLHorizontalSegmentedControl *_hSeg;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [UIViewController new];
	UIView *view = self.window.rootViewController.view;
    view.backgroundColor = [UIColor whiteColor];
    
    _label = [UILabel new];
    _label.adjustsFontSizeToFitWidth = YES;
    _label.minimumScaleFactor = 0.5;
    [view addSubview:_label];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    
	_vSeg = [[WLVerticalSegmentedControl alloc] initWithItems:@[@"None", @"Daily", @"Weekly", @"Monthly", @"Yearly"]];
    _vSeg.tintColor = [UIColor blackColor];
	_vSeg.allowsMultiSelection = NO;
    _vSeg.selectedSegmentIndex = 0;
    [_vSeg addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:_vSeg];
    _vSeg.translatesAutoresizingMaskIntoConstraints = NO;
	
	_hSeg = [[WLHorizontalSegmentedControl alloc] initWithItems:@[@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"]];
	_hSeg.allowsMultiSelection = YES;
	[_hSeg addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:_hSeg];
	_hSeg.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_label, _vSeg, _hSeg);
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_vSeg]-[_label]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[_hSeg]-|" options:kNilOptions metrics:nil views:viewDict]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_vSeg(216)]-20-[_hSeg]" options:kNilOptions metrics:nil views:viewDict]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:_vSeg attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:-(10 + _hSeg.intrinsicContentSize.height / 2)]];
    
    [self.window makeKeyAndVisible];
    
    [self updateLabel];
	
    return YES;
}

- (void)action:(id)sender {
    [self updateLabel];
}

- (void)updateLabel {
    switch (_vSeg.selectedSegmentIndex) {
        case 1:
            _label.text = @"Repeat daily";
            _hSeg.enabled = NO;
            break;
            
        case 2: {
            NSMutableString *text = [NSMutableString stringWithString:@"Repeat weekly"];
            if (_hSeg.selectedSegmentIndice.count > 0) {
                [text appendString:@" on "];
            }
            [_hSeg.selectedSegmentIndice enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [text appendString:[_hSeg titleForSegmentAtIndex:idx]];
                if (idx != _hSeg.selectedSegmentIndice.lastIndex) {
                    [text appendString:@", "];
                }
            }];
            _hSeg.enabled = YES;
            _label.text = text;
        }
            break;
            
        case 3:
            _label.text = @"Repeat monthly";
            _hSeg.enabled = NO;
            break;
            
        case 4:
            _label.text = @"Repeat yearly";
            _hSeg.enabled = NO;
            break;
            
        default:
            _label.text = @"No repeat";
            _hSeg.enabled = NO;
            break;
    }
}
	 
@end
