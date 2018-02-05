//
//  XTitleView.h
//  PageViewDemo
//  https://github.com/MrLSPBoy/PageViewController
//  Created by Object on 17/7/11.
//  Copyright © 2017年 Object. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPTitleStyle.h"
@class LSPTitleView;
@protocol LSPTitleViewDelegate <NSObject>

- (void)titleViewWithTitleView:(LSPTitleView *)titleView selectedIndex:(NSInteger)selectedIndex;

@end


@interface LSPTitleView : UIView

- (LSPTitleView *)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles style:(LSPTitleStyle *)style;

- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

- (void)contentViewDidEndScroll;

@property(nonatomic, weak) id<LSPTitleViewDelegate> delegate;


@end
