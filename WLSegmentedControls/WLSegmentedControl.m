//
//  WLSegmentedControl.m
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/27/10.
//  Copyright © 2016 Moke. All rights reserved.
//

#import "WLSegmentedControl.h"

@implementation WLSegmentedControl {
    BOOL _tint;
    NSMutableIndexSet *_selectedSegmentIndice;
}

#pragma mark - Lifetime

- (id)_initWithItems:(NSArray *)items selectedItems:(NSArray *)selectedItems backgroundImages:(NSArray *)backgroundImages selectedBackgroundImages:(NSArray *)selectedBackgroundImages tint:(BOOL)tint {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        _tint = tint;
        // Default selection is none.
        _selectedSegmentIndex = UISegmentedControlNoSegment;
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items selectedItems:(NSArray *)selectedItems backgroundImages:(NSArray *)backgroundImages selectedBackgroundImages:(NSArray *)selectedBackgroundImages {
    return [self _initWithItems:items selectedItems:selectedItems backgroundImages:backgroundImages selectedBackgroundImages:selectedBackgroundImages tint:(backgroundImages == nil)];
}

- (instancetype)initWithImages:(NSArray *)images selectedImages:(NSArray *)selectedImages {
    return [self _initWithItems:images selectedItems:selectedImages backgroundImages:nil selectedBackgroundImages:nil tint:NO];
}

- (instancetype)initWithItems:(NSArray *)items {
    return [self initWithItems:items selectedItems:nil backgroundImages:nil selectedBackgroundImages:nil];
}

#pragma mark - Managing Segment Content

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
    [(WLSegment *)_segments[segment] setImage:image forState:UIControlStateNormal];
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)segment {
    return [(WLSegment *)_segments[segment] imageForState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
    [(WLSegment *)_segments[segment] setTitle:title forState:UIControlStateNormal];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment {
    return [(WLSegment *)_segments[segment] titleForState:UIControlStateNormal];
}

- (void)setSelectedImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
    [(WLSegment *)_segments[segment] setImage:image forState:UIControlStateSelected];
}

- (UIImage *)selectedImageForSegmentAtIndex:(NSUInteger)segment {
    return [(WLSegment *)_segments[segment] imageForState:UIControlStateSelected];
}

- (void)setSelectedTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
    [(WLSegment *)_segments[segment] setTitle:title forState:UIControlStateSelected];
}

- (NSString *)selectedTitleForSegmentAtIndex:(NSUInteger)segment {
    return [(WLSegment *)_segments[segment] titleForState:UIControlStateSelected];    
}

#pragma mark - Managing Segments

- (void)setEnabled:(BOOL)enabled {
    super.enabled = enabled;
    for (WLSegment *segment in _segments) {
        segment.enabled = enabled;
    }
}

- (void)setAllowsMultiSelection:(BOOL)allowsMultiSelection {
    if (_allowsMultiSelection == allowsMultiSelection) return;

    _allowsMultiSelection = allowsMultiSelection;

    if (allowsMultiSelection) {
        if (self.selectedSegmentIndex != UISegmentedControlNoSegment) {
            self.selectedSegmentIndice = [NSMutableIndexSet indexSetWithIndex:self.selectedSegmentIndex];
        } else {
            self.selectedSegmentIndice = [NSMutableIndexSet indexSet];
        }
    } else {
        self.selectedSegmentIndice = nil;
        self.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)index {
    if (_selectedSegmentIndex == index) return;
    
    if (_selectedSegmentIndex != UISegmentedControlNoSegment) {
        WLSegment *selectedSegment = _segments[_selectedSegmentIndex];
        selectedSegment.selected = NO;
        [self sendSubviewToBack:selectedSegment];
    }
    
    if (index != UISegmentedControlNoSegment) {
        WLSegment *segmentToSelect = _segments[index];
        segmentToSelect.selected = YES;
        [self bringSubviewToFront:segmentToSelect];
    }
    
    _selectedSegmentIndex = index;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setSelectedSegmentIndice:(NSIndexSet *)indexSet {
    if ([_selectedSegmentIndice isEqualToIndexSet:indexSet]) return;
    
    [_selectedSegmentIndice enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        WLSegment *selectedSegment = _segments[idx];
        selectedSegment.selected = NO;        
        [self sendSubviewToBack:selectedSegment];
    }];

    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        WLSegment *segmentToSelect = _segments[idx];
        segmentToSelect.selected = YES;
        [self bringSubviewToFront:segmentToSelect];
    }];
    
    _selectedSegmentIndice = [indexSet mutableCopy];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)selectSegmentWithIndex:(NSInteger)index {
    WLSegment *segmentToSelect = _segments[index];
    segmentToSelect.selected = YES;
    [self bringSubviewToFront:segmentToSelect];
    [_selectedSegmentIndice addIndex:index];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)deselectSegmentWithIndex:(NSInteger)index {
    WLSegment *selectedSegment = _segments[index];
    selectedSegment.selected = NO;
    [self sendSubviewToBack:selectedSegment];
    [_selectedSegmentIndice removeIndex:index];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Tint

- (void)setTintColor:(UIColor *)tintColor {
    super.tintColor = tintColor;

    for (WLSegment *segment in _segments) {
        segment.tintColor = tintColor;
    }
}

- (void)drawRect:(CGRect)rect {
    if (!_tint) return;

    CGFloat lineWidth = 1.;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, lineWidth / 2, lineWidth / 2) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(3.5f, 3.5f)];
    path.lineWidth = lineWidth;
    if (self.enabled) {
        [self.tintColor setStroke];
    } else {
        [[self.tintColor colorWithAlphaComponent:(CGFloat)0.50] setStroke];
    }
    [path stroke];
}

#pragma mark - Responding to Selection Events

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
