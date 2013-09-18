//
//  WLSegment.m
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/27/10.
//  Copyright 2010 I Wonder Phone. All rights reserved.
//

#import "WLSegment.h"
#import "UIColor+WLExtension.h"


@interface WLSegment () {
	WLSegmentStyle _style;
	BOOL _tint;
	UIImageView *_divider;
}

@end

@implementation WLSegment

+ (instancetype)segmentWithItem:(id)item selectedItem:(id)selectedItem backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage style:(WLSegmentStyle)style tint:(BOOL)tint {
	WLSegment *segment = [self buttonWithType:UIButtonTypeCustom];
	segment.contentEdgeInsets = UIEdgeInsetsMake(6., 6., 6., 6.);
	if (segment) {
		if ([item isKindOfClass:[UIImage class]]) {
			[segment setImage:item forState:UIControlStateNormal];
		} else {
			[segment setTitle:item forState:UIControlStateNormal];
		}
		
		if (selectedItem) {
			if ([selectedItem isKindOfClass:[UIImage class]]) {
				[segment setImage:selectedItem forState:UIControlStateSelected];
			} else {
				[segment setTitle:selectedItem forState:UIControlStateSelected];
			}			
		}
		
		if (backgroundImage) {
			[segment setBackgroundImage:backgroundImage forState:UIControlStateNormal];
			// selectedBackgroundImage is meaningful only if backgroundImage is set in the first place.
			if (selectedBackgroundImage) {
				[segment setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
			}			
		}

		segment.titleLabel.font = [UIFont systemFontOfSize:13.];

		segment->_style = style;
		segment->_tint = tint;

		UIImageView *divider = [UIImageView new];
		[segment addSubview:divider];
		divider.translatesAutoresizingMaskIntoConstraints = NO;
		switch (style) {
			case WLSegmentStyleHorizontal:
				[divider addConstraint:[NSLayoutConstraint constraintWithItem:divider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1. constant:1.]];
				[segment addConstraint:[NSLayoutConstraint constraintWithItem:divider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:segment attribute:NSLayoutAttributeRight multiplier:1. constant:0.]];
				[segment addConstraint:[NSLayoutConstraint constraintWithItem:divider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:segment attribute:NSLayoutAttributeTop multiplier:1. constant:0.]];
				[segment addConstraint:[NSLayoutConstraint constraintWithItem:divider attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:segment attribute:NSLayoutAttributeBottom multiplier:1. constant:0.]];
				break;

			case WLSegmentStyleVertical:
				[divider addConstraint:[NSLayoutConstraint constraintWithItem:divider attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1. constant:1.]];
				[segment addConstraint:[NSLayoutConstraint constraintWithItem:divider attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:segment attribute:NSLayoutAttributeBottom multiplier:1. constant:0.]];
				[segment addConstraint:[NSLayoutConstraint constraintWithItem:divider attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:segment attribute:NSLayoutAttributeLeading multiplier:1. constant:0.]];
				[segment addConstraint:[NSLayoutConstraint constraintWithItem:divider attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:segment attribute:NSLayoutAttributeTrailing multiplier:1. constant:0.]];
				break;
		}
		segment->_divider = divider;

		segment.tintColor = segment.tintColor;
	}
	return segment;
}

- (void)setTintColor:(UIColor *)tintColor {
	[super setTintColor:tintColor];

	[self setTitleColor:tintColor forState:UIControlStateNormal];
	_divider.backgroundColor = tintColor;
}

- (void)setIsLast:(BOOL)isLast {
	if (_isLast == isLast) return;

	_isLast = isLast;
	_divider.hidden = _isLast;
}

- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	[self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	self.titleLabel.alpha = !selected;
}

- (void)drawRect:(CGRect)rect {
	if (!_tint) return;
	if (!self.highlighted && !self.selected) return;

	UIBezierPath *path;
	UIRectCorner roundingCorners = 0;
	if (_style == WLSegmentStyleHorizontal) {
		if (_isFirst) {
			roundingCorners |= UIRectCornerTopLeft | UIRectCornerBottomLeft;
		}
		if (_isLast) {
			roundingCorners |= UIRectCornerTopRight | UIRectCornerBottomRight;
		}
	} else {
		if (_isFirst) {
			roundingCorners |= UIRectCornerTopLeft | UIRectCornerTopRight;
		}
		if (_isLast) {
			roundingCorners |= UIRectCornerBottomLeft | UIRectCornerBottomRight;
		}
	}
	path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:roundingCorners cornerRadii:CGSizeMake(3.5f, 3.5f)];

	if (self.selected) {
		[self.tintColor setFill];
	} else {
		[[self.tintColor transparentColor:0.15f] setFill];
	}
	[path fill];

	if (self.selected) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetBlendMode(context, kCGBlendModeClear);
		[self.titleLabel.attributedText drawAtPoint:self.titleLabel.frame.origin];
	}
}

@end
