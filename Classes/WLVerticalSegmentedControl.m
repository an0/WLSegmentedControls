//
//  WLVerticalSegmentedControl.m
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/21/10.
//  Copyright 2010 I Wonder Phone. All rights reserved.
//

#import "WLSegmentedControl+Private.h"
#import "WLVerticalSegmentedControl.h"
#import "UIColor+WLExtension.h"

@interface WLVerticalSegmentedControl ()

@property(nonatomic, copy) NSArray *normalGradientColors;

- (void)tintSegments;

@end


#pragma mark -

@implementation WLVerticalSegmentedControl

@synthesize normalGradientColors = _normalGradientColors;

#pragma mark -
#pragma mark Default gradient color with tintColor = nil

+ (NSArray *)defaultNormalGradientColors {
	static NSArray *defaultNormalGradientColors = nil;
	
	if (defaultNormalGradientColors == nil) {
		defaultNormalGradientColors = [[NSArray alloc] initWithObjects:
									   [UIColor colorWithRed:0.636 green:0.638 blue:0.665 alpha:1.000],
									   [UIColor colorWithRed:0.155 green:0.164 blue:0.222 alpha:1.000],
									   nil];		
	}
	return defaultNormalGradientColors;
}


#pragma mark -
#pragma mark Creating, Copying, and Deallocating

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.normalGradientColors = [WLVerticalSegmentedControl defaultNormalGradientColors];
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
			WLSegment *segment = [[WLSegment alloc] initWithItem:item selectedItem:selectedItem backgroundImage:backgroundImage selectedBackgroundImage:selectedBackgroundImage style:WLSegmentStyleVertical tint:tint];
			segment.selectedGradientLocations = segment.normalGradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.f], [NSNumber numberWithFloat:1.f], nil];
			segment.contentMode = UIViewContentModeRedraw;
			[segment sizeToFit];
			maxHeight = MAX(maxHeight, segment.frame.size.height);
			maxWidth = MAX(maxWidth, segment.frame.size.width);
			[self addSubview:segment];
			[segment addTarget:self action:@selector(_didTapItem:) forControlEvents:UIControlEventTouchDown];
			[_segments addObject:segment];
			[segment release];
		}
		
		CGRect frame = self.frame;
		frame.size.width = maxWidth;
		// Make segments have a uniform height.
		frame.size.height = maxHeight * _segments.count;
		self.frame = frame;
		
		// Vertically layout segments.
		CGFloat segmentWidth = self.bounds.size.width;
		CGFloat segmentHeight = maxHeight; // Uniformly distribute the height among segments.
		CGFloat y = 0.f;
		for (WLSegment *segment in _segments) {
			CGRect segmentFrame = segment.frame;
			segmentFrame.origin.x = 0.f;
			segmentFrame.origin.y = y;
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
			
			y += segmentFrame.size.height;
		}
		
		[self tintSegments];
	}
	
	return self;
}

- (void)dealloc {
	[_normalGradientColors release];
	
	[super dealloc];
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
	
	[_tintColor release];
	_tintColor = [color retain];
	
	// Recolor.
	if (_tintColor) {
		self.normalGradientColors = [NSArray arrayWithObjects:
									 [_tintColor brighterColor:0.46f],
									 _tintColor,
									 nil];		
	} else {
		self.normalGradientColors = [WLVerticalSegmentedControl defaultNormalGradientColors];
	}
	
	[self tintSegments];
}

- (void)setFrame:(CGRect)frame {
	if (CGRectEqualToRect(self.frame, frame)) {
		return;
	}
	
	[super setFrame:frame];
	[self tintSegments];
}


- (void)tintSegments {
	// Gradually distribute the tint color to segments.
	CGFloat height = self.bounds.size.height;
	UIColor *topColor = [self.normalGradientColors objectAtIndex:0];
	UIColor *bottomColor = [self.normalGradientColors objectAtIndex:1];
	
	for (WLSegment *segment in _segments) {
		UIColor *normalSegmentTopColor = [UIColor interpolatedColor:segment.frame.origin.y / height from:topColor to:bottomColor];
		UIColor *normalSegmentBottomColor = [UIColor interpolatedColor:(segment.frame.origin.y + segment.frame.size.height) / height from:topColor to:bottomColor];
		// Selected gradient color is a bit more severe.
		UIColor *selectedSegmentTopColor = [normalSegmentTopColor brighterColor:0.35f];
		UIColor *selectedSegmentBottomColor = [normalSegmentBottomColor darkerColor:0.35f];
		segment.normalGradientColors = [NSArray arrayWithObjects:normalSegmentTopColor, normalSegmentBottomColor, nil];
		segment.selectedGradientColors = [NSArray arrayWithObjects:selectedSegmentTopColor, selectedSegmentBottomColor, nil];
	}	
}


@end
