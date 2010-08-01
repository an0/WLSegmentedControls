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
 
 @param items A non-empty array of NSString objects (for segment titles) or UIImage objects (for segment images).
 @return A WLSegmentedControl object or nil if there was a problem in initializing the object.
 */
- (id)initWithItems:(NSArray *)items; 
/// @}

//////////////////////////////////////////////////////////////////////////////
/// @name Managing Segments
//////////////////////////////////////////////////////////////////////////////
/// @{
@property(nonatomic, assign) BOOL allowsMultiSelection;
@property(nonatomic, assign) NSInteger selectedSegmentIndex; ///< The index of the selected segment. It is undefined if @c allowsMultiSelection is @c YES.
@property(nonatomic, copy) NSIndexSet *selectedSegmentIndice; ///< The indice of the selected segments. It is undefined if @c allowsMultiSelection is @c NO.
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
