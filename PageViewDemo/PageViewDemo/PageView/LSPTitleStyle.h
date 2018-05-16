//
//  XTitleStyle.h
//  PageViewDemo
//  https://github.com/MrLSPBoy/PageViewController
//  Created by Object on 17/7/11.
//  Copyright © 2017年 Object. All rights reserved.


#import <UIKit/UIKit.h>


@interface LSPTitleStyle : NSObject


//================内容的属性==============//
/**
 内容是否需要滑动，如果设为NO，则只有点击标题才会切换视图
 */
@property(nonatomic, assign) BOOL isContentViewScrollEnable;

//================标题的属性==============//
/**
 是否是滚动的Title
 */
@property(nonatomic, assign) BOOL isTitleViewScrollEnable;
/**
 普通Title的颜色
 */
@property(nonatomic, strong) UIColor *normalColor;
/**
 选中Title的颜色
 */
@property(nonatomic, strong) UIColor *selectedColor;
/**
 Title字体大小
 */
@property(nonatomic, strong) UIFont *font;
/**
 滚动Title的字体间距
 */
@property(nonatomic, assign) CGFloat titleMargin;

//================标题带底部细线==============//
/**
 是否显示底部滚动条
 */
@property(nonatomic, assign) BOOL isShowBottomLine;
/**
 底部滚动条的颜色
 */
@property(nonatomic, strong) UIColor *bottomLineColor;
/**
 底部滚动条的高度
 */
@property(nonatomic, assign) CGFloat bottomLineH;
/**
 底部滚动条的宽度
 */
@property (nonatomic,assign) CGFloat bottomLineW;


//================标题带缩放==============//
/**
 是否进行缩放
 */
@property(nonatomic, assign) BOOL isNeedScale;
/**
 缩放比例
 */
@property(nonatomic, assign) CGFloat scaleRange;


//================标题带背景===============//
/**
 是否显示遮盖
 */
@property(nonatomic, assign) BOOL isShowCover;
/**
 遮盖背景色
 */
@property(nonatomic, strong) UIColor *coverBgColor;
/**
 文字和遮盖间隙
 */
@property(nonatomic, assign) CGFloat coverMargin;
/**
 遮盖高度
 */
@property(nonatomic, assign) CGFloat coverH;
/**
 设置圆角大小
 */
@property(nonatomic, assign) CGFloat coverRadius;

@end
