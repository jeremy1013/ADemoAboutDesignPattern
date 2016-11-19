//
//  HorizontalScroller.m
//  BlueLibrary
//
//  Created by Jeremy on 2016/11/17.
//  Copyright © 2016年 Eli Ganem. All rights reserved.
//

#import "HorizontalScroller.h"
#define VIEW_PADDING 10
#define VIEW_DEMENSIONS 100
#define VIEW_OFFSET 100

@interface HorizontalScroller () <UIScrollViewDelegate>

@end

@implementation HorizontalScroller

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

{
    UIScrollView *scroller;
}


- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        scroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scroller.delegate = self;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollerTapped:)];
        [scroller addGestureRecognizer:tapRecognizer];
    }
    return self;
}


- (void)scrollerTapped:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:gesture.view];
    
    NSLog(@"%@", gesture.view);
    NSLog(@"%f, %f", location.x, location.y);
    
    for (int index = 0; index < [self.delegate numberOfViewsForHorizontalScroller:self]; index++) {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location)) {
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width  / 2, 0) animated:YES];
            break;
        }
    }
}


- (void)reload {
    if (self.delegate == nil) {
        return;
    }
    
    [scroller.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    CGFloat xValue = VIEW_OFFSET;
    for (int i = 0; i < [self.delegate numberOfViewsForHorizontalScroller:self]; i++) {
        xValue += VIEW_PADDING;
        UIView *view = [self.delegate horizontalScroller:self viewAtIndex:i];
        
        //这里的self是ViewController里面的HorizontalScroller *scroller。因为是scroller调用的reload
        NSLog(@"%@", self);
        
        
        scroller.backgroundColor = [UIColor greenColor];
        
        view.frame  = CGRectMake(xValue, VIEW_PADDING, VIEW_DEMENSIONS, VIEW_DEMENSIONS);
        [scroller addSubview:view];
        xValue += VIEW_DEMENSIONS + VIEW_PADDING;
    }
    
    [scroller setContentSize:CGSizeMake(xValue + VIEW_OFFSET, self.frame.size.height)];
    
    if ([self.delegate respondsToSelector:@selector(initialViewIndexForHorizontalScroller:)]) {
        NSInteger initialView = [self.delegate initialViewIndexForHorizontalScroller:self];
        [scroller setContentOffset:CGPointMake(initialView*(VIEW_DEMENSIONS+(2*VIEW_PADDING)), 0) animated:YES];
    }
    
    [self addSubview:scroller];
    
}

#pragma mark --UIView

- (void)didMoveToSuperview {
    NSLog(@"didMoveToSuperView");
    [self reload];
}

#pragma mark -- my

- (void)centerCurrentView {
    int xFinal = scroller.contentOffset.x + (VIEW_OFFSET / 2) + VIEW_PADDING;
    int viewIndex = xFinal / (VIEW_DEMENSIONS + (2*VIEW_PADDING));
    xFinal = viewIndex * (VIEW_DEMENSIONS + (2*VIEW_PADDING));
    [scroller setContentOffset:CGPointMake(xFinal, 0) animated:YES];
    [self.delegate horizontalScroller:self clickedViewAtIndex:viewIndex];
}



#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self centerCurrentView];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self centerCurrentView];
}













@end
