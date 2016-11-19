//
//  HorizontalScroller.h
//  BlueLibrary
//
//  Created by Jeremy on 2016/11/17.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  HorizontalScroller;
@protocol HorizontalScrollerDelegate <NSObject>

@required
- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller;

- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index;

- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index;

@optional
- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller;


@end


@interface HorizontalScroller : UIView

@property (weak) id<HorizontalScrollerDelegate> delegate;

- (void)reload;

@end

