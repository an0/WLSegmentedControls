//
//  WLSegmentedControl.h
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/27/10.
//  Copyright 2010 I Wonder Phone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLSegment.h"


@interface WLSegmentedControl : UIControl {
	NSMutableArray *_segments;
	UIColor *_tintColor;
	
@private
	NSInteger _selectedSegmentIndex;
	NSMutableIndexSet *_selectedSegmentIndice;
	BOOL _allowsMultiSelection;
}

//////////////////////////////////////////////////////////////////////////////
/// @name Initializing a Segmented Control
//////////////////////////////////////////////////////////////////////////////
/// @{
/**
 Initializes and returns a segmented control with segments having the given titles or images.
 
 @param items A non-empty array of NSString objects (for segment titles) or UIImage objects (for segment images) which is used for normal state.
 @param selectedItems Nil, or a non-empty array of NSString objects (for segment titles) or UIImage objects (for segment images) which is used for selected state. If nil, normal items are also used for selected state. If not nil, the array must be of the same length as items array and each element in this array must correspond to the element at the same index in items array. If not all segments have special items for selected state, you should use setSelectedImage:forSegmentAtIndex: or setSelectedTitle:forSegmentAtIndex: to set individual selected items.
 @param tint If YES, all segments are drawn with tint color. If NO, no segments are drawn with tint color, which is good for fully custom image segments. The default is YES.
 @return A WLSegmentedControl object or nil if there was a problem in initializing the object.
 */
- (id)initWithItems:(NSArray *)items selectedItems:(NSArray *)selectedItems tint:(BOOL)tint;
- (id)initWithItems:(NSArray *)items;
/// @}

//////////////////////////////////////////////////////////////////////////////
/// @name Managing Segment Content
//////////////////////////////////////////////////////////////////////////////
/// @{
- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (UIImage *)imageForSegmentAtIndex:(NSUInteger)segment;
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment;
- (void)setSelectedImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment;
- (UIImage *)selectedImageForSegmentAtIndex:(NSUInteger)segment;
- (void)setSelectedTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;
- (NSString *)selectedTitleForSegmentAtIndex:(NSUInteger)segment;
/// @}


//////////////////////////////////////////////////////////////////////////////
/// @name Managing Segments
//////////////////////////////////////////////////////////////////////////////
/// @{
@property(nonatomic, assign) BOOL allowsMultiSelection;
@property(nonatomic, assign) NSInteger selectedSegmentIndex; ///< The index of the selected segment. It is undefined if @c allowsMultiSelection is @c YES.
@property(nonatomic, copy) NSIndexSet *selectedSegmentIndice; ///< The indice of the selected segments. It is undefined if @c allowsMultiSelection is @c NO
/// @}


//////////////////////////////////////////////////////////////////////////////
/// @name Managing Segment Behavior and Appearance
//////////////////////////////////////////////////////////////////////////////
/// @{
@property(nonatomic, retain) UIColor *tintColor; ///< The tint color of the segmented control. Must be RGBA color.
/// @}



// Protected.
- (void)_didTapItem:(WLSegment *)sender;


@end
