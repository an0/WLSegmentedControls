//
//  WLSegment.m
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/27/10.
//  Copyright 2010 I Wonder Phone. All rights reserved.
//

#import "WLSegment.h"
#import "UIColor+Extension.h"


@interface WLSegment ()

@property(nonatomic, retain) UIColor *hTopOuterBorderColor;
@property(nonatomic, retain) UIColor *hTopInnerBorderColor;
@property(nonatomic, retain) UIColor *hBottomOuterBorderColor;
@property(nonatomic, retain) UIColor *hBottomInnerBorderColor;
@property(nonatomic, retain) UIColor *hOuterSideBorderColor;
@property(nonatomic, retain) UIColor *hInnerSideBorderColor;

@property(nonatomic, readonly) CGGradientRef vOuterBorderGradient;
@property(nonatomic, readonly) CGGradientRef vInnterBorderGradient;
@property(nonatomic, readonly) CGGradientRef vSelectedInnerBorderGradient;

@end




#pragma mark -

@implementation WLSegment

@synthesize
hTopOuterBorderColor = _hTopOuterBorderColor,
hTopInnerBorderColor = _hTopInnerBorderColor,
hBottomOuterBorderColor = _hBottomOuterBorderColor,
hBottomInnerBorderColor = _hBottomInnerBorderColor,
hOuterSideBorderColor = _hOuterSideBorderColor,
hInnerSideBorderColor = _hInnerSideBorderColor;


@synthesize 
vInnterBorderGradient = _vInnterBorderGradient,
vSelectedInnerBorderGradient = _vSelectedInnerBorderGradient,
vOuterBorderGradient = _vOuterBorderGradient;

@synthesize
isFirst = _isFirst,
isLast = _isLast;



#pragma mark -
#pragma mark Creating, Copying, and Deallocating

- (id)initWithItem:(id)item style:(WLSegmentStyle)style {
	if ((self = [self initWithFrame:CGRectZero])) {
		if ([item isKindOfClass:[UIImage class]]) {
			[self setImage:item forState:UIControlStateNormal];
		} else {
			[self setTitle:item forState:UIControlStateNormal];
		}
		
		self.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
		self.titleLabel.adjustsFontSizeToFitWidth = NO;
		self.titleLabel.minimumFontSize = 13.f;
		self.titleLabel.shadowOffset = CGSizeMake(0.f, -1.f);
		[self setTitleShadowColor:[UIColor colorWithWhite:0.1f alpha:1.f] forState:UIControlStateNormal];
		self.strokeWeight = 0.f;
		self.cornerRadius = 0.f;
		
		_style = style;
	}	
	return self;
}


- (void)dealloc {	    
	[_hTopOuterBorderColor release];
	[_hTopInnerBorderColor release];
	[_hBottomOuterBorderColor release];
	[_hBottomInnerBorderColor release];
	[_hOuterSideBorderColor release];
	[_hInnerSideBorderColor release];
	
	if (_vOuterBorderGradient != NULL)
		CGGradientRelease(_vOuterBorderGradient);
    if (_vInnterBorderGradient != NULL)
        CGGradientRelease(_vInnterBorderGradient);
    if (_vSelectedInnerBorderGradient != NULL)
        CGGradientRelease(_vSelectedInnerBorderGradient);
	
    [super dealloc];
}



#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
	CGFloat width = self.bounds.size.width;
	CGFloat height = self.bounds.size.height;
	CGFloat left = self.bounds.origin.x;
	CGFloat right = left + width;
	CGFloat top = self.bounds.origin.y;
	CGFloat bottom = top + height;
	CGFloat lineWeight = 1.f;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, lineWeight);

	if (_style == WLSegmentStyleHorizontal) {
		// Fill the region.
		self.bounds = CGRectMake(left, top, width, height - lineWeight);
		self.cornerRadius += 1.f;
		[super drawRect:rect];
		self.cornerRadius -= 1.f;
		self.bounds = CGRectMake(left, top, width, height);

		// Draw the borders.
		CGFloat outerLeft = left + 0.5f * lineWeight;
		CGFloat outerRight = right - 0.5f * lineWeight;
		CGFloat outerTop = top + 0.5f * lineWeight;
		CGFloat outerBottom = bottom - 0.5f * lineWeight;
		
		CGFloat innerLeft = outerLeft;
		CGFloat innerRight = outerRight;
		CGFloat innerTop = top + 1.5f * lineWeight;
		CGFloat innerBottom = bottom - 1.5f * lineWeight;
		
		BOOL hasLeftTopRoundedCorner = _cornerRadius > 0.f && (_roundedCornerPositions & WLRoundedCornerLeftTop);
		BOOL hasLeftBottomRoundedCorner = _cornerRadius > 0.f && (_roundedCornerPositions & WLRoundedCornerLeftBottom);
		BOOL hasRightTopRoundedCorner = _cornerRadius > 0.f && (_roundedCornerPositions & WLRoundedCornerRightTop);
		BOOL hasRightBottomRoundedCorner = _cornerRadius > 0.f && (_roundedCornerPositions & WLRoundedCornerRightBottom);
		
		// The dark boundary is around (outerLeft, outerTop), (outerRight, outerTop), (outerRight, innerBottom), (outerLeft, innerBottom).
		
		// Left border.
		if (hasLeftTopRoundedCorner) {
			CGContextMoveToPoint(context, outerLeft, top + 0.8f * _cornerRadius);
		} else {
			CGContextMoveToPoint(context, outerLeft, top);
		}
		
		if (hasLeftBottomRoundedCorner) {
			CGContextAddLineToPoint(context, outerLeft, innerBottom + 0.5f * lineWeight - 0.8f * _cornerRadius);
		} else {
			CGContextAddLineToPoint(context, outerLeft, innerBottom + 0.5f * lineWeight);
		}
		
		CGContextSetStrokeColorWithColor(context, _isFirst ? self.hOuterSideBorderColor.CGColor : self.hInnerSideBorderColor.CGColor);
		CGContextStrokePath(context);		
		
		// Right border.
		if (hasRightTopRoundedCorner) {
			CGContextMoveToPoint(context, outerRight, top + 0.8f * _cornerRadius);
		} else {
			CGContextMoveToPoint(context, outerRight, top);
		}
		
		if (hasRightBottomRoundedCorner) {
			CGContextAddLineToPoint(context, outerRight, innerBottom + 0.5f * lineWeight - 0.8f * _cornerRadius);
		} else {
			CGContextAddLineToPoint(context, outerRight, innerBottom + 0.5f * lineWeight);
		}
		
		CGContextSetStrokeColorWithColor(context, _isLast ? self.hOuterSideBorderColor.CGColor : self.hInnerSideBorderColor.CGColor);
		CGContextStrokePath(context);
		
		// Top outer border.
		if (hasLeftTopRoundedCorner) {
			CGContextMoveToPoint(context, outerLeft, outerTop + _cornerRadius);
			CGContextAddArcToPoint(context, outerLeft, outerTop, outerRight, outerTop, _cornerRadius);
		} else {
			CGContextMoveToPoint(context, left, outerTop);
		}
		
		if (hasRightTopRoundedCorner) {
			CGContextAddArcToPoint(context, outerRight, outerTop, outerRight, outerBottom, _cornerRadius);
		} else {
			CGContextAddLineToPoint(context, right, outerTop);
		}

		CGContextSetStrokeColorWithColor(context, self.hTopOuterBorderColor.CGColor);
		CGContextStrokePath(context);
		
		// Bottom outer border.
		// Because the region below bottem outer border is not filled, if it is drawn from left to right, the two colors from adjacent segments will mix. So it is drawn from outerLeft to outerRight.
		if (hasLeftBottomRoundedCorner) {
			CGContextMoveToPoint(context, outerLeft, outerBottom - _cornerRadius);
			CGContextAddArcToPoint(context, outerLeft, outerBottom, outerRight, outerBottom, _cornerRadius);
		} else {
			CGContextMoveToPoint(context, outerLeft, outerBottom);
		}
		
		if (hasRightBottomRoundedCorner) {
			CGContextAddArcToPoint(context, outerRight, outerBottom, outerRight, outerTop, _cornerRadius);
		} else {
			CGContextAddLineToPoint(context, outerRight, outerBottom);
		}
		
		CGContextSetStrokeColorWithColor(context, self.hBottomOuterBorderColor.CGColor);
		CGContextStrokePath(context);

		// Top inner border.
		if (hasLeftTopRoundedCorner) {
			CGContextMoveToPoint(context, innerLeft, innerTop + _cornerRadius);
			CGContextAddArcToPoint(context, innerLeft, innerTop, innerRight, innerTop, _cornerRadius);
		} else {
			CGContextMoveToPoint(context, left, innerTop);
		}
		
		if (hasRightTopRoundedCorner) {
			CGContextAddArcToPoint(context, innerRight, innerTop, innerRight, innerBottom, _cornerRadius);
		} else {
			CGContextAddLineToPoint(context, right, innerTop);
		}
		
		CGContextSetStrokeColorWithColor(context, self.hTopInnerBorderColor.CGColor);
		CGContextStrokePath(context);
		
		// Bottom inner border.
		if (hasLeftBottomRoundedCorner) {
			CGContextMoveToPoint(context, innerLeft, innerBottom - _cornerRadius);
			CGContextAddArcToPoint(context, innerLeft, innerBottom, innerRight, innerBottom, _cornerRadius);
		} else {
			CGContextMoveToPoint(context, left, innerBottom);
		}		

		if (hasRightBottomRoundedCorner) {
			CGContextAddArcToPoint(context, innerRight, innerBottom, innerRight, innerTop, _cornerRadius);
		} else {
			CGContextAddLineToPoint(context, right, innerBottom);
		}
		
		CGContextSetStrokeColorWithColor(context, self.hBottomInnerBorderColor.CGColor);
		CGContextStrokePath(context);
	}
	
	else {
		// Fill the region.
		self.bounds = CGRectMake(0.f, 2 * lineWeight, width - 2 * lineWeight, height - 2 * lineWeight);
		[super drawRect:rect];
		self.contentMode = UIViewContentModeBottomLeft;
		self.bounds = CGRectMake(0.f, 0.f, width, height);		

		// Draw the top and right border lines.
		CGGradientRef darkGradient = self.vOuterBorderGradient;
		CGGradientRef lightGradient;
		if (self.selected) {
			lightGradient = self.vSelectedInnerBorderGradient;
		} else {
			lightGradient = self.vInnterBorderGradient;
		}	
		
		// The outer dark line.
		CGContextMoveToPoint(context, left, top + 0.5f * lineWeight);
		CGContextAddLineToPoint(context, right - 0.5f * lineWeight, top + 0.5f * lineWeight);
		CGContextAddLineToPoint(context, right - 0.5f * lineWeight, bottom);
		
		CGContextReplacePathWithStrokedPath(context);
		CGContextSaveGState(context);
		CGContextClip(context);
		CGContextDrawLinearGradient(context, darkGradient, CGPointMake(left + 0.5f * width, top), CGPointMake(left + 0.5f * width, bottom), 0);
		
		// The inner light line.	
		CGContextRestoreGState(context);
		CGContextSaveGState(context);
		CGContextMoveToPoint(context, left, top + 1.5f * lineWeight);
		CGContextAddLineToPoint(context, right - 1.5f * lineWeight, top + 1.5f * lineWeight);
		CGContextAddLineToPoint(context, right - 1.5f * lineWeight, bottom);
		
		CGContextReplacePathWithStrokedPath(context);
		CGContextClip(context);	
		CGContextDrawLinearGradient(context, lightGradient, CGPointMake(left + 0.5f * width, top), CGPointMake(left + 0.5f * width, bottom), 0);
		CGContextRestoreGState(context);
	}
	
}



#pragma mark -
#pragma mark Resizing Subviews

- (CGSize)sizeThatFits:(CGSize)size {
	CGSize sizeThatFits = [super sizeThatFits:size];
	// Enlarge.
	sizeThatFits.width += 16.f;
	return sizeThatFits;
}


#pragma mark -
#pragma mark Gradient Colors

- (void)setNormalGradientLocations:(NSArray *)locations {
	// Invalidate the cached gradient and redraw.
	if (_vInnterBorderGradient != NULL) {
		CGGradientRelease(_vInnterBorderGradient);
		_vInnterBorderGradient = NULL;
	}
	if (_vOuterBorderGradient != NULL) {
		CGGradientRelease(_vOuterBorderGradient);
		_vOuterBorderGradient = NULL;
	}
	
	[super setNormalGradientLocations:locations];	
}

- (void)setSelectedGradientLocations:(NSArray *)locations {
	// Invalidate the cached gradient and redraw.
	if (_vSelectedInnerBorderGradient != NULL) {
		CGGradientRelease(_vSelectedInnerBorderGradient);
		_vSelectedInnerBorderGradient = NULL;
	}
	
	[super setSelectedGradientLocations:locations];
}

- (void)setNormalGradientColors:(NSArray *)colors {
	// Invalidate the cached gradient and redraw.
	if (_vInnterBorderGradient != NULL) {
		CGGradientRelease(_vInnterBorderGradient);
		_vInnterBorderGradient = NULL;
	}
	if (_vOuterBorderGradient != NULL) {
		CGGradientRelease(_vOuterBorderGradient);
		_vOuterBorderGradient = NULL;
	}	
	
	if (_style == WLSegmentStyleHorizontal) {
		UIColor *baseColor = [colors lastObject];
		self.hTopOuterBorderColor = [[UIColor interpolatedColor:0.5f from:baseColor to:[UIColor blackColor]] transparentColor:0.7f];
		self.hTopInnerBorderColor = [[UIColor interpolatedColor:0.1f from:baseColor to:[UIColor blackColor]] transparentColor:0.2f];
		self.hBottomInnerBorderColor = [[UIColor interpolatedColor:0.5f from:baseColor to:[UIColor blackColor]] transparentColor:0.5f];
		self.hBottomOuterBorderColor = [[UIColor interpolatedColor:0.75f from:baseColor to:[UIColor whiteColor]] transparentColor:0.2f];
		self.hOuterSideBorderColor = [[UIColor interpolatedColor:0.5f from:baseColor to:[UIColor blackColor]] transparentColor:0.4f];
		self.hInnerSideBorderColor = [[UIColor interpolatedColor:0.2f from:baseColor to:[UIColor blackColor]] transparentColor:0.7f];
	}
	
	[super setNormalGradientColors:colors];
}

- (void)setSelectedGradientColors:(NSArray *)colors {
	// Invalidate the cached gradient and redraw.
	if (_vSelectedInnerBorderGradient != NULL) {
		CGGradientRelease(_vSelectedInnerBorderGradient);
		_vSelectedInnerBorderGradient = NULL;
	}
	
	[super setSelectedGradientColors:colors];
}


//- (CGGradientRef)hOuterBorderGradient {
//	static CGFloat const darkDeltaTable[4] = { 0.407, 0.184, 0.169, 0.095 };
//	static CGFloat const brightDeltaTable[4] = { 0.600, 0.350, 0.350, 0.300};
//	
//    if (_hOuterBorderGradient == NULL)
//    {
//        NSUInteger locCount = [_normalGradientLocations count];
//        CGFloat locations[locCount];
//        for (size_t i = 0; i < locCount; i++)
//        {
//            NSNumber *location = [_normalGradientLocations objectAtIndex:i];
//            locations[i] = [location floatValue];
//        }
//        
//		CGFloat const *deltaTable = [[_normalGradientColors lastObject] brightness] > 0.5 ? brightDeltaTable : darkDeltaTable;
//		CFMutableArrayRef colorArray = CFArrayCreateMutable(NULL, _normalGradientColors.count, NULL);
//		for (size_t i = 0; i < _normalGradientColors.count; ++i) {
//			UIColor *color = (UIColor *)[_normalGradientColors objectAtIndex:i];
//			CFArrayAppendValue(colorArray, [color darkerColor:deltaTable[i]].CGColor);
//		}
//        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//        _hOuterBorderGradient = CGGradientCreateWithColors(space, colorArray, locCount > 0 ? locations : NULL);
//        CGColorSpaceRelease(space);
//    }
//    return _hOuterBorderGradient;	
//}
//
//- (CGGradientRef)hSelectedOuterBorderGradient {
//	static CGFloat const darkDeltaTable[4] = { 0.363, 0.091, 0.114, 0.067 };
//	static CGFloat const brightDeltaTable[4] = { 0.500, 0.160, 0.175, 0.150 };
//	
//    if (_hSelectedOuterBorderGradient == NULL)
//    {
//        NSUInteger locCount = [_selectedGradientLocations count];
//        CGFloat locations[locCount];
//        for (size_t i = 0; i < locCount; i++)
//        {
//            NSNumber *location = [_selectedGradientLocations objectAtIndex:i];
//            locations[i] = [location floatValue];
//        }
//        
//		CGFloat const *deltaTable = [[_normalGradientColors lastObject] brightness] > 0.5 ? brightDeltaTable : darkDeltaTable;
//		CFMutableArrayRef colorArray = CFArrayCreateMutable(NULL, _selectedGradientColors.count, NULL);
//		for (size_t i = 0; i < _selectedGradientColors.count; ++i) {
//			UIColor *color = (UIColor *)[_selectedGradientColors objectAtIndex:i];
//			CFArrayAppendValue(colorArray, [color darkerColor:deltaTable[i]].CGColor);
//		}
//        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//        _hSelectedOuterBorderGradient = CGGradientCreateWithColors(space, colorArray, locCount > 0 ? locations : NULL);
//        CGColorSpaceRelease(space);
//    }
//    return _hSelectedOuterBorderGradient;	
//}

- (CGGradientRef)vOuterBorderGradient {
    if (_vOuterBorderGradient == NULL)
    {
        NSUInteger locCount = [_normalGradientLocations count];
        CGFloat locations[locCount];
        for (size_t i = 0; i < locCount; i++)
        {
            NSNumber *location = [_normalGradientLocations objectAtIndex:i];
            locations[i] = [location floatValue];
        }
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        
		CFMutableArrayRef colorArray = CFArrayCreateMutable(NULL, _normalGradientColors.count, NULL);
		for (UIColor *color in _normalGradientColors) {
			CFArrayAppendValue(colorArray, [color darkerColor:0.3f].CGColor);
		}
        _vOuterBorderGradient = CGGradientCreateWithColors(space, colorArray, locCount > 0 ? locations : NULL);
        CGColorSpaceRelease(space);
    }
    return _vOuterBorderGradient;
}

- (CGGradientRef)vInnterBorderGradient {
    if (_vInnterBorderGradient == NULL)
    {
        NSUInteger locCount = [_normalGradientLocations count];
        CGFloat locations[locCount];
        for (size_t i = 0; i < locCount; i++)
        {
            NSNumber *location = [_normalGradientLocations objectAtIndex:i];
            locations[i] = [location floatValue];
        }
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        
		CFMutableArrayRef colorArray = CFArrayCreateMutable(NULL, _normalGradientColors.count, NULL);
		for (UIColor *color in _normalGradientColors) {
			CFArrayAppendValue(colorArray, [color brighterColor:0.20f].CGColor);
		}
        _vInnterBorderGradient = CGGradientCreateWithColors(space, colorArray, locCount > 0 ? locations : NULL);
        CGColorSpaceRelease(space);
    }
    return _vInnterBorderGradient;
}

- (CGGradientRef)vSelectedInnerBorderGradient {
    
    if (_vSelectedInnerBorderGradient == NULL)
    {
		NSUInteger locCount = [_selectedGradientLocations count];
        CGFloat locations[locCount];
        for (size_t i = 0; i < locCount; i++)
        {
            NSNumber *location = [_selectedGradientLocations objectAtIndex:i];
            locations[i] = [location floatValue];
        }
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
		
		CFMutableArrayRef colorArray = CFArrayCreateMutable(NULL, _selectedGradientColors.count, NULL);
		for (UIColor *color in _selectedGradientColors) {
			CFArrayAppendValue(colorArray, [color brighterColor:0.15f].CGColor);
		}
		
        _vSelectedInnerBorderGradient = CGGradientCreateWithColors(space, colorArray, locCount > 0 ? locations : NULL);
        CGColorSpaceRelease(space);
    }
    return _vSelectedInnerBorderGradient;
}


@end
