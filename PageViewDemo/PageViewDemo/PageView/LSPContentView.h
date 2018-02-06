//
//  XContentView.h
//  PageViewDemo
//  https://github.com/MrLSPBoy/PageViewController
//  Created by Object on 17/7/11.
//  Copyright © 2017年 Object. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPTitleStyle.h"
@class LSPContentView;
@protocol LSPContentViewDelegate <NSObject>

- (void)contentViewWith:(LSPContentView *)contentView progress:(CGFloat)progress sourceIndex:(CGFloat)sourceIndex targetIndex:(CGFloat)targetIndex;

- (void)contentViewEndScrollWithContentView:(LSPContentView *)contentView;

- (void)scrollViewDidEndDeceleratingWithIndex:(NSInteger)index;

@end

@interface LSPContentView : UIView

/**
 创建ContentView

 @param frame ContentView的Frame
 @param childVcs 所有子控制器数组
 @param parentViewController 父控制器
 @param style 标题样式
 @return ContentView
 */
- (LSPContentView *)initWithFrame:(CGRect)frame childVcs:(NSArray <UIViewController *>*)childVcs parentViewController:(UIViewController *)parentViewController style:(LSPTitleStyle *)style;

/**
 点击标题之后通过代理 滚动视图

 @param currentIndex 滚动到第几个
 */
- (void)setCurrentIndex:(NSInteger)currentIndex;


@property(nonatomic, weak) id<LSPContentViewDelegate> delegate;

@end
