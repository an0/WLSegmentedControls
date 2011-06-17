//
//  WLSegmentedControl.m
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/27/10.
//  Copyright 2010 I Wonder Phone. All rights reserved.
//

#import "WLSegmentedControl.h"


@implementation WLSegmentedControl



@synthesize tintColor = _tintColor;
@synthesize selectedSegmentIndex = _selectedSegmentIndex;
@synthesize selectedSegmentIndice = _selectedSegmentIndice;
@synthesize allowsMultiSelection = _allowsMultiSelection;



#pragma mark -
#pragma mark Creating, Copying, and Deallocating

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// Default selection is none.
		_selectedSegmentIndex = UISegmentedControlNoSegment;
    }
    return self;
}

- (id)_initWithItems:(NSArray *)items selectedItems:(NSArray *)selectedItems backgroundImages:(NSArray *)backgroundImages selectedBackgroundImages:(NSArray *)selectedBackgroundImages tint:(BOOL)tint {
	if ((self = [self initWithFrame:CGRectZero])) {
		
	}
	return self;	
}

- (id)initWithItems:(NSArray *)items selectedItems:(NSArray *)selectedItems backgroundImages:(NSArray *)backgroundImages selectedBackgroundImages:(NSArray *)selectedBackgroundImages {
	if ((self = [self _initWithItems:items selectedItems:selectedItems backgroundImages:backgroundImages selectedBackgroundImages:selectedBackgroundImages tint:(backgroundImages == nil)])) {
		
	}
	return self;	
}

- (id)initWithImages:(NSArray *)images selectedImages:(NSArray *)selectedImages {
	if ((self = [self _initWithItems:images selectedItems:selectedImages backgroundImages:nil selectedBackgroundImages:nil tint:NO])) {
		
	}
	return self;	
}

- (id)initWithItems:(NSArray *)items {
	if ((self = [self initWithItems:items selectedItems:nil backgroundImages:nil selectedBackgroundImages:nil])) {
		
	}
	return self;
}



#pragma mark -
#pragma mark Managing Segment Content

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
	[(WLSegment *)[_segments objectAtIndex:segment] setImage:image forState:UIControlStateNormal];
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)segment {
	return [(WLSegment *)[_segments objectAtIndex:segment] imageForState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
	[(WLSegment *)[_segments objectAtIndex:segment] setTitle:title forState:UIControlStateNormal];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment {
	return [(WLSegment *)[_segments objectAtIndex:segment] titleForState:UIControlStateNormal];
}

- (void)setSelectedImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
	[(WLSegment *)[_segments objectAtIndex:segment] setImage:image forState:UIControlStateSelected];
}

- (UIImage *)selectedImageForSegmentAtIndex:(NSUInteger)segment {
	return [(WLSegment *)[_segments objectAtIndex:segment] imageForState:UIControlStateSelected];
}

- (void)setSelectedTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
	[(WLSegment *)[_segments objectAtIndex:segment] setTitle:title forState:UIControlStateSelected];
}

- (NSString *)selectedTitleForSegmentAtIndex:(NSUInteger)segment {
	return [(WLSegment *)[_segments objectAtIndex:segment] titleForState:UIControlStateSelected];	
}



#pragma mark -
#pragma mark Managing Segments

- (void)setAllowsMultiSelection:(BOOL)flag {
	if (flag && !_allowsMultiSelection) {
		if (self.selectedSegmentIndex != UISegmentedControlNoSegment) {
			self.selectedSegmentIndice = [NSMutableIndexSet indexSetWithIndex:self.selectedSegmentIndex];
		} else {
			self.selectedSegmentIndice = [NSMutableIndexSet indexSet];
		}
		_allowsMultiSelection = flag;
	} else if (!flag && _allowsMultiSelection) {
		self.selectedSegmentIndice = nil;
		self.selectedSegmentIndex = UISegmentedControlNoSegment;
		_allowsMultiSelection = flag;
	}
}

- (void)setSelectedSegmentIndex:(NSInteger)index {
	if (_selectedSegmentIndex == index) {
		return;
	}
	
	if (_selectedSegmentIndex != UISegmentedControlNoSegment) {
		WLSegment *selectedSegment = [_segments objectAtIndex:_selectedSegmentIndex];
		selectedSegment.selected = NO;
		[self sendSubviewToBack:selectedSegment];
	}
	
	if (index != UISegmentedControlNoSegment) {
		WLSegment *segmentToSelect = [_segments objectAtIndex:index];
		segmentToSelect.selected = YES;
		[self bringSubviewToFront:segmentToSelect];
	}
	
	_selectedSegmentIndex = index;
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setSelectedSegmentIndice:(NSIndexSet *)indexSet {
	if ([_selectedSegmentIndice isEqualToIndexSet:indexSet]) {
		return;
	}
	
	[_selectedSegmentIndice enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		WLSegment *selectedSegment = [_segments objectAtIndex:idx];
		selectedSegment.selected = NO;		
		[self sendSubviewToBack:selectedSegment];
	}];
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		WLSegment *segmentToSelect = [_segments objectAtIndex:idx];
		segmentToSelect.selected = YES;
		[self bringSubviewToFront:segmentToSelect];
	}];
	
	_selectedSegmentIndice = [indexSet mutableCopy];
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)selectSegmentWithIndex:(NSInteger)index {
	WLSegment *segmentToSelect = [_segments objectAtIndex:index];
	segmentToSelect.selected = YES;
	[self bringSubviewToFront:segmentToSelect];
	[_selectedSegmentIndice addIndex:index];
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)deselectSegmentWithIndex:(NSInteger)index {
	WLSegment *selectedSegment = [_segments objectAtIndex:index];
	selectedSegment.selected = NO;
	[self sendSubviewToBack:selectedSegment];
	[_selectedSegmentIndice removeIndex:index];
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}




#pragma mark -
#pragma mark Responding to Selection Events

- (void)_didTapItem:(WLSegment *)sender {
	NSUInteger index = [_segments indexOfObject:sender];
	if (_allowsMultiSelection) {
		if (sender.selected) {
			[self deselectSegmentWithIndex:index];
		} else {
			[self selectSegmentWithIndex:index];
		}		
	} else {
		self.selectedSegmentIndex = index;
	}	
}



@end
