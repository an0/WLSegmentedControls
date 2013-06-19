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
									   [UIColor colorWithRed:0.636f green:0.638f blue:0.665f alpha:1.000f],
									   [UIColor colorWithRed:0.155f green:0.164f blue:0.222f alpha:1.000f],
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
		_segments = [[NSMutableArray alloc] initWithCapacity:[items count]];
		NSUInteger itemCount = items.count;
		__block WLSegment *prevSegment;
		[items enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
			id selectedItem = [selectedItems objectAtIndex:idx];
			UIImage *backgroundImage = [backgroundImages objectAtIndex:idx];
			UIImage *selectedBackgroundImage = [selectedBackgroundImages objectAtIndex:idx];
			WLSegment *segment = [[WLSegment alloc] initWithItem:item selectedItem:selectedItem backgroundImage:backgroundImage selectedBackgroundImage:selectedBackgroundImage style:WLSegmentStyleVertical tint:tint];
			segment.selectedGradientLocations = segment.normalGradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.f], [NSNumber numberWithFloat:1.f], nil];
			segment.contentMode = UIViewContentModeRedraw;
			[self addSubview:segment];
			[segment addTarget:self action:@selector(_didTapItem:) forControlEvents:UIControlEventTouchDown];
			[_segments addObject:segment];

			// Vertically layout segments. Uniformly distribute the height among segments.
			segment.translatesAutoresizingMaskIntoConstraints = NO;
			NSDictionary *viewDict = NSDictionaryOfVariableBindings(segment);
			[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[segment]|" options:0 metrics:nil views:viewDict]];
			if (prevSegment) {
				[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevSegment][segment(==prevSegment)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(prevSegment, segment)]];
			}
			prevSegment = segment;
			if (idx == 0) {
				[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segment]" options:0 metrics:nil views:viewDict]];
			}
			if (idx == itemCount - 1) {
				[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[segment]|" options:0 metrics:nil views:viewDict]];
			}
		}];
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
		self.normalGradientColors = [NSArray arrayWithObjects:
									 [_tintColor brighterColor:0.46f],
									 _tintColor,
									 nil];		
	} else {
		self.normalGradientColors = [WLVerticalSegmentedControl defaultNormalGradientColors];
	}
	
	[self setNeedsLayout];
}

- (void)layoutSubviews {
	[super layoutSubviews];
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
