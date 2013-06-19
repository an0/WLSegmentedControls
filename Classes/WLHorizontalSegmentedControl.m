//
//  WLHorizontalSegmentedControl.m
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/27/10.
//  Copyright 2010 I Wonder Phone. All rights reserved.
//

#import "WLSegmentedControl+Private.h"
#import "WLHorizontalSegmentedControl.h"
#import "UIColor+WLExtension.h"


@interface WLHorizontalSegmentedControl ()

@property(nonatomic, copy) NSArray *normalGradientColors;
@property(nonatomic, copy) NSArray *selectedGradientColors;

- (void)tintSegments;

@end



#pragma mark -

@implementation WLHorizontalSegmentedControl

@synthesize normalGradientColors = _normalGradientColors;
@synthesize selectedGradientColors = _selectedGradientColors;

#pragma mark -
#pragma mark Default gradient color with tintColor = nil

+ (NSArray *)defaultNormalGradientColors {
	static NSArray *defaultNormalGradientColors = nil;
	if (defaultNormalGradientColors == nil) {
		defaultNormalGradientColors = [[NSArray alloc] initWithObjects:
									   [UIColor colorWithRed:0.639f green:0.698f blue:0.765f alpha:1.000f],
									   [UIColor colorWithRed:0.475f green:0.557f blue:0.667f alpha:1.000f],
									   [UIColor colorWithRed:0.420f green:0.514f blue:0.631f alpha:1.000f],
									   [UIColor colorWithRed:0.431f green:0.522f blue:0.639f alpha:1.000f],
									   nil];		
	}
	return defaultNormalGradientColors;
}

+ (NSArray *)defaultSelectedGradientColors {
	static NSArray *defaultSelectedGradientColor = nil;
	if (defaultSelectedGradientColor == nil) {
		defaultSelectedGradientColor = [[NSArray alloc] initWithObjects:
										[UIColor colorWithRed:0.556f green:0.636f blue:0.751f alpha:1.000f],
										[UIColor colorWithRed:0.345f green:0.467f blue:0.635f alpha:1.000f],
										[UIColor colorWithRed:0.282f green:0.416f blue:0.596f alpha:1.000f],
										[UIColor colorWithRed:0.282f green:0.416f blue:0.596f alpha:1.000f],
										nil];			
	}
	return defaultSelectedGradientColor;
}

#pragma mark -
#pragma mark Creating, Copying, and Deallocating

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.normalGradientColors = [WLHorizontalSegmentedControl defaultNormalGradientColors];
		self.selectedGradientColors = [WLHorizontalSegmentedControl defaultSelectedGradientColors];
    }
    return self;
}

- (id)_initWithItems:(NSArray *)items selectedItems:(NSArray *)selectedItems backgroundImages:(NSArray *)backgroundImages selectedBackgroundImages:(NSArray *)selectedBackgroundImages tint:(BOOL)tint {
	if ((self = [super _initWithItems:items selectedItems:selectedItems backgroundImages:backgroundImages selectedBackgroundImages:selectedBackgroundImages tint:tint])) {
		CGFloat maxHeight = 0.f;
		CGFloat maxWidth = 0.f;
		_segments = [[NSMutableArray alloc] initWithCapacity:[items count]];
		for (NSUInteger i = 0; i < [items count]; ++i) {
			id item = [items objectAtIndex:i];
			id selectedItem = [selectedItems objectAtIndex:i];
			UIImage *backgroundImage = [backgroundImages objectAtIndex:i];
			UIImage *selectedBackgroundImage = [selectedBackgroundImages objectAtIndex:i];
			WLSegment *segment = [[WLSegment alloc] initWithItem:item selectedItem:selectedItem backgroundImage:backgroundImage selectedBackgroundImage:selectedBackgroundImage style:WLSegmentStyleHorizontal tint:tint];
			segment.selectedGradientLocations = segment.normalGradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:1.f], nil];
			segment.contentMode = UIViewContentModeRedraw;
			[segment sizeToFit];
			maxWidth = MAX(maxWidth, segment.frame.size.width);
			maxHeight = MAX(maxHeight, segment.frame.size.height);
			[self addSubview:segment];
			[segment addTarget:self action:@selector(_didTapItem:) forControlEvents:UIControlEventTouchDown];
			[_segments addObject:segment];
		}
		
		if (_segments.count > 0) {
			// The first and last segment have rounded corners.
			WLSegment *firstSegment = [_segments objectAtIndex:0];
			firstSegment.isFirst = YES;
			firstSegment.cornerRadius = 5.f;
			firstSegment.roundedCornerPositions = WLRoundedCornerLeftTop | WLRoundedCornerLeftBottom;
			
			WLSegment *lastSegment = [_segments lastObject];
			lastSegment.isLast = YES;
			lastSegment.cornerRadius = 5.f;
			lastSegment.roundedCornerPositions = WLRoundedCornerRightTop | WLRoundedCornerRightBottom;
		}
		
		
		CGRect frame = self.frame;
		// Make segments have a uniform width and merge adjacent borders.
		frame.size.width = maxWidth * _segments.count - (_segments.count - 1);
		frame.size.height = MAX(maxHeight, 30.f);
		self.frame = frame;
		
		// Horizontally layout segments.
		CGFloat segmentWidth = maxWidth; // Uniformly distribute the width among segments, considering the merged adjacent borders.
		CGFloat segmentHeight = self.bounds.size.height;
		CGFloat x = 0.f;
		for (WLSegment *segment in _segments) {
			CGRect segmentFrame = segment.frame;
			segmentFrame.origin.x = x;
			segmentFrame.origin.y = 0.f;
			segmentFrame.size.width = segmentWidth;
			segmentFrame.size.height = segmentHeight;
			segment.frame = segmentFrame;
			segment.autoresizingMask =
			UIViewAutoresizingFlexibleWidth | 
			UIViewAutoresizingFlexibleHeight | 
			UIViewAutoresizingFlexibleTopMargin | 
			UIViewAutoresizingFlexibleBottomMargin | 
			UIViewAutoresizingFlexibleLeftMargin | 
			UIViewAutoresizingFlexibleRightMargin;
			
			x += segmentFrame.size.width - 1.f; // Merge adjacent borders.
		}
		
		[self tintSegments];
	}
	
	return self;
}



#pragma mark -
#pragma mark Resizing Subviews

- (CGSize)sizeThatFits:(CGSize)size {
	return size;
}



#pragma mark -
#pragma mark Managing Segment Behavior and Appearance

- (void)setTintColor:(UIColor *)color {
	if (_tintColor == color) {
		return;
	}
	
	_tintColor = color;
	
	// Recolor.
	if (_tintColor) {
		//		CGFloat brightness = [_tintColor brightness];
		//		CGFloat saturation = [_tintColor saturation];
		self.normalGradientColors = [NSArray arrayWithObjects:
									 [_tintColor tintColor],
									 [UIColor interpolatedColor:0.1f from:_tintColor to:[UIColor whiteColor]],
									 _tintColor,
									 _tintColor,
									 nil];
		
		UIColor *selectedBaseColor = [UIColor interpolatedColor:0.12f from:_tintColor to:[UIColor whiteColor]];
		self.selectedGradientColors = [NSArray arrayWithObjects:
									   [selectedBaseColor tintColor],
									   [UIColor interpolatedColor:0.1f from:selectedBaseColor to:[UIColor whiteColor]],
									   selectedBaseColor,
									   selectedBaseColor,
									   nil];		
	} else {
		self.normalGradientColors = [WLHorizontalSegmentedControl defaultNormalGradientColors];
		self.selectedGradientColors = [WLHorizontalSegmentedControl defaultSelectedGradientColors];
	}
	
	[self tintSegments];
}

- (void)tintSegments {
	UIColor *normalTopColor = [_normalGradientColors objectAtIndex:0];
	UIColor *normalTopMiddleColor = [_normalGradientColors objectAtIndex:1];
	UIColor *normalBottomMiddleColor = [_normalGradientColors objectAtIndex:2];
	UIColor *normalBottomColor = [_normalGradientColors objectAtIndex:3];
	UIColor *selectedTopColor = [_selectedGradientColors objectAtIndex:0];
	UIColor *selectedTopMiddleColor = [_selectedGradientColors objectAtIndex:1];
	UIColor *selectedBottomMiddleColor = [_selectedGradientColors objectAtIndex:2];
	UIColor *selectedBottomColor = [_selectedGradientColors objectAtIndex:3];
	
	for (WLSegment *segment in _segments) {
		segment.normalGradientColors = [NSArray arrayWithObjects:normalTopColor, normalTopMiddleColor, normalBottomMiddleColor, normalBottomColor, nil];
		segment.selectedGradientColors = [NSArray arrayWithObjects:selectedTopColor, selectedTopMiddleColor, selectedBottomMiddleColor, selectedBottomColor, nil];
	}	
}


- (void)setFrame:(CGRect)frame {
	// Adjust the corner radius proportionately.
	if (_segments.count > 0) {
		// The first and last segment have rounded corners.
		WLSegment *firstSegment = [_segments objectAtIndex:0];
		firstSegment.cornerRadius = frame.size.height / 6;
		
		WLSegment *lastSegment = [_segments lastObject];
		lastSegment.cornerRadius = frame.size.height / 6;
	}
	
	[super setFrame:frame];
}


@end
