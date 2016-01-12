//
//  WLSegment.h
//  WLSegmentedControls
//
//  Created by Wang Ling on 7/27/10.
//  Copyright © 2016 Moke. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSInteger, WLSegmentStyle) {
	WLSegmentStyleHorizontal,
	WLSegmentStyleVertical,
};

@interface WLSegment : UIButton

+ (instancetype)segmentWithItem:(id)item selectedItem:(id)selectedItem backgroundImage:(UIImage *)backgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage style:(WLSegmentStyle)style tint:(BOOL)tint;

@property(nonatomic, assign) BOOL isFirst;
@property(nonatomic, assign) BOOL isLast;

@end
