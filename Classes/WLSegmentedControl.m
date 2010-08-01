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

- (id)initWithItems:(NSArray *)items {
	if ((self = [self initWithFrame:CGRectZero])) {
		
	}
	return self;
}

- (void)dealloc {
	[_segments release];
	[_tintColor release];
	
	[_selectedSegmentIndice release];
	
    [super dealloc];
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
	
	[_selectedSegmentIndice release];
	_selectedSegmentIndice = [indexSet mutableCopy];
}

- (void)selectSegmentWithIndex:(NSInteger)index {
	WLSegment *segmentToSelect = [_segments objectAtIndex:index];
	segmentToSelect.selected = YES;
	[self bringSubviewToFront:segmentToSelect];
	[_selectedSegmentIndice addIndex:index];
}

- (void)deselectSegmentWithIndex:(NSInteger)index {
	WLSegment *selectedSegment = [_segments objectAtIndex:index];
	selectedSegment.selected = NO;
	[self sendSubviewToBack:selectedSegment];
	[_selectedSegmentIndice removeIndex:index];
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
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}



@end
