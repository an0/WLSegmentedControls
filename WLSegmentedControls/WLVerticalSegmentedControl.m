//
//  WLVerticalSegmentedControl.m
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/21/10.
//  Copyright © 2016 Moke. All rights reserved.
//

#import "WLVerticalSegmentedControl.h"

@implementation WLVerticalSegmentedControl

- (id)_initWithItems:(NSArray *)items selectedItems:(NSArray *)selectedItems backgroundImages:(NSArray *)backgroundImages selectedBackgroundImages:(NSArray *)selectedBackgroundImages tint:(BOOL)tint {
    if ((self = [super _initWithItems:items selectedItems:selectedItems backgroundImages:backgroundImages selectedBackgroundImages:selectedBackgroundImages tint:tint])) {
        NSUInteger itemCount = items.count;
        _segments = [[NSMutableArray alloc] initWithCapacity:itemCount];
        __block WLSegment *prevSegment;
        [items enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
            id selectedItem = selectedItems[idx];
            UIImage *backgroundImage = backgroundImages[idx];
            UIImage *selectedBackgroundImage = selectedBackgroundImages[idx];
            WLSegment *segment = [WLSegment segmentWithItem:item selectedItem:selectedItem backgroundImage:backgroundImage selectedBackgroundImage:selectedBackgroundImage style:WLSegmentStyleVertical tint:tint];
            if (tint) {
                segment.contentMode = UIViewContentModeRedraw;
            }
            [self addSubview:segment];
            [segment addTarget:self action:@selector(_didTapItem:) forControlEvents:UIControlEventTouchUpInside];
            [_segments addObject:segment];

            segment.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *viewDict = NSDictionaryOfVariableBindings(segment);
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[segment]|" options:0 metrics:nil views:viewDict]];
            if (prevSegment) {
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[prevSegment]-1-[segment(==prevSegment)]" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(prevSegment, segment)]];
            }
            prevSegment = segment;
            if (idx == 0) {
                segment.isFirst = YES;
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[segment]" options:kNilOptions metrics:nil views:viewDict]];
            }
            if (idx == itemCount - 1) {
                segment.isLast = YES;
                [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[segment]|" options:kNilOptions metrics:nil views:viewDict]];
            }
        }];
        [self sizeToFit];
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize fittingSize;
    CGFloat maxWidth = 0.f, maxHeight = 0.f;
    for (WLSegment *segment in _segments) {
        CGSize segmentSize = [segment sizeThatFits:size];
        maxWidth = MAX(maxWidth, segmentSize.width);
        maxHeight = MAX(maxHeight, segmentSize.height);
    }
    fittingSize.width = maxWidth;
    fittingSize.height = maxHeight * _segments.count + 1.f * (_segments.count - 1);
    return fittingSize;
}

- (CGSize)intrinsicContentSize {
    CGSize intrinsicSize;
    CGFloat maxWidth = 0.f, maxHeight = 0.f;
    for (WLSegment *segment in _segments) {
        CGSize segmentSize = segment.intrinsicContentSize;
        maxWidth = MAX(maxWidth, segmentSize.width);
        maxHeight = MAX(maxHeight, segmentSize.height);
    }
    intrinsicSize.width = maxWidth;
    intrinsicSize.height = maxHeight * _segments.count + 1.f * (_segments.count - 1);
    return intrinsicSize;
}

@end
