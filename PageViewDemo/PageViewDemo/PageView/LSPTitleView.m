//
//  XTitleView.m
//  PageViewDemo
//  https://github.com/MrLSPBoy/PageViewController
//  Created by Object on 17/7/11.
//  Copyright © 2017年 Object. All rights reserved.
//

#import "LSPTitleView.h"

@interface LSPTitleView ()

@property(nonatomic, strong) NSArray <NSString *>*titles;

@property(nonatomic, strong) LSPTitleStyle *style;

@property(nonatomic, assign) NSInteger currentIndex;

@property(nonatomic, strong) NSMutableArray <UILabel *>*titleLabels;

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIView *splitLineView;

@property(nonatomic, strong) UIView *bottomLine;

@property(nonatomic, strong) UIView *coverView;

@property(nonatomic) const CGFloat *normalColorRGB;

@property(nonatomic) const CGFloat *selectedColorRGB;

@end


@implementation LSPTitleView

- (NSMutableArray<UILabel *> *)titleLabels{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (const CGFloat *)normalColorRGB{
    return [self getRGBWithColor:self.style.normalColor];
}

- (const CGFloat *)selectedColorRGB{
    return [self getRGBWithColor:self.style.selectedColor];
}


- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

- (UIView *)splitLineView{
    if (_splitLineView == nil) {
        CGFloat h = 0.5;
        _splitLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - h, self.frame.size.width, h)];
        _splitLineView.backgroundColor = [UIColor  lightGrayColor];
    }
    return _splitLineView;
}

- (UIView *)bottomLine{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = self.style.bottomLineColor;
    }
    return _bottomLine;
}

- (UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [self.style.coverBgColor colorWithAlphaComponent:0.7];
    }
    return _coverView;
}



- (LSPTitleView *)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles style:(LSPTitleStyle *)style{
    
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        self.style  = style;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    //添加scrollView
    [self addSubview:self.scrollView];
    
    //添加底部分割线
    [self addSubview:self.splitLineView];
    
    //添加所有标题
    [self setupTitleLabels];
    
    //设置底部滚动条
    if (self.style.isShowBottomLine) {
        [self setupBottomLine];
    }
    
    //设置遮盖
    if (self.style.isShowCover) {
        [self setupCoverView];
    }
}

- (void)setupTitleLabels{
    
    for (int i = 0; i < self.titles.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = i + 10;
        label.text = self.titles[i];
        label.textColor = i == 0 ? self.style.selectedColor : self.style.normalColor;
        label.font = self.style.font;
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tap];
        
        [self.titleLabels addObject:label];
        
        [self.scrollView addSubview:label];
    }
    
    //设置Lable位置
    [self setupTitleLabelFrame];
}

- (void)setupTitleLabelFrame{
    
    CGFloat titleX = 0.0;
    CGFloat titleY = 0.0;
    CGFloat titleW = 0.0;
    CGFloat titleH = self.frame.size.height;
    
    if (self.titleLabels.count <= 4)
    {
        titleW = self.frame.size.width / self.titleLabels.count;
        self.style.isTitleViewScrollEnable = NO;
    }else
    {
        titleW = self.frame.size.width / 4;
        self.style.isTitleViewScrollEnable = YES;
    }
    
//    NSInteger count = self.titleLabels.count;
    
    for (int i = 0; i < self.titleLabels.count; i++) {
        
        UILabel *label = self.titleLabels[i];
        if (self.style.isTitleViewScrollEnable) {//不需要滑动
            
//            NSDictionary *attributes = [NSDictionary dictionaryWithObject:self.style.font forKey:NSFontAttributeName];
//
//            CGRect rect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//            titleW = rect.size.width;
            
            if (i == 0) {
                titleX = self.style.titleMargin * 0.5;
            }else{
                UILabel *preLabel = self.titleLabels[i - 1];
                titleX = CGRectGetMaxX(preLabel.frame) + self.style.titleMargin;
            }
            
        }else{//滑动
            
            //titleW = self.frame.size.width / count;
            titleX = titleW * i;
        }
        
        label.frame = CGRectMake(titleX, titleY, titleW, titleH);
        
        //放大的代码
        if (i == 0) {
            CGFloat scale = self.style.isNeedScale ? self.style.scaleRange : 1.0;
            label.transform = CGAffineTransformMakeScale(scale, scale);
        }
        
        if (self.style.isTitleViewScrollEnable) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.titleLabels.lastObject.frame) + self.style.titleMargin * 0.5, 0);
        }
    }
}

- (void)setupBottomLine{
    
    [self.scrollView addSubview:self.bottomLine];
    
    self.bottomLine.frame = CGRectMake(self.titleLabels.firstObject.frame.origin.x, self.bounds.size.height - self.style.bottomLineH, self.titleLabels.firstObject.frame.size.width, self.style.bottomLineH);
}

- (void)setupCoverView{
    [self.scrollView addSubview:self.coverView];
    
    [self.scrollView insertSubview:self.coverView atIndex:0];
    
    UILabel *firstLabel = self.titleLabels.firstObject;
    
    CGFloat coverX = firstLabel.frame.origin.x;
    CGFloat coverW = firstLabel.frame.size.width;
    CGFloat coverH = self.style.coverH;
    CGFloat coverY = (self.bounds.size.height - coverH) * 0.5;
    
    if (self.style.isTitleViewScrollEnable) {
        coverX -= self.style.coverMargin;
        coverW += self.style.coverMargin * 2;
    }
    self.coverView.frame = CGRectMake(coverX, coverY, coverW, coverH);
    self.coverView.layer.cornerRadius = self.style.coverRadius;
    self.coverView.layer.masksToBounds = YES;
    
}

- (void)titleLabelClick:(UITapGestureRecognizer *)tap{
    
    UILabel *currentLabel = (UILabel *)tap.view;
    //如果重复点击同一个title，那么直接返回
    if (currentLabel.tag - 10 == self.currentIndex) {
//        NSLog(@"相同的indnex");
        return;
    }
    //获取之前的Label
    UILabel *oldLabel = self.titleLabels[self.currentIndex];
    
    //切换文字颜色
    currentLabel.textColor = self.style.selectedColor;
    oldLabel.textColor = self.style.normalColor;
    //保存最新Label的下标值
    self.currentIndex = currentLabel.tag - 10;
    
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(titleViewWithTitleView:selectedIndex:)]) {
        [self.delegate titleViewWithTitleView:self selectedIndex:self.currentIndex];
    }
    
    //居中显示
    [self contentViewDidEndScroll];
    
    
    //调整bottomLine
    if (self.style.isShowBottomLine){
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomLine.frame = CGRectMake(currentLabel.frame.origin.x, self.bottomLine.frame.origin.y, currentLabel.frame.size.width, self.bottomLine.frame.size.height);
        }];
    }
    
    //调整比例
    if (self.style.isNeedScale) {
        oldLabel.transform = CGAffineTransformIdentity;
        currentLabel.transform = CGAffineTransformMakeScale(self.style.scaleRange, self.style.scaleRange);
    }
    
    if (self.style.isShowCover) {
        CGFloat coverX = self.style.isTitleViewScrollEnable ? (currentLabel.frame.origin.x - self.style.coverMargin) : (currentLabel.frame.origin.x);
        CGFloat coverW = self.style.isTitleViewScrollEnable ? (currentLabel.frame.size.width + self.style.coverMargin * 2) : (currentLabel.frame.size.width);
        [UIView animateWithDuration:0.5 animations:^{
           
            self.coverView.frame = CGRectMake(coverX, self.coverView.frame.origin.y, coverW, self.coverView.frame.size.height);
        }];
    }
    
}


- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
   
    //取出sourceLabel和targetLabel
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    //颜色渐变
    UIColor *delataColor = [UIColor colorWithRed:self.selectedColorRGB[0] - self.normalColorRGB[0] green:self.selectedColorRGB[1] - self.normalColorRGB[1] blue:self.selectedColorRGB[2] - self.normalColorRGB[2] alpha:1.0];
    const CGFloat *colorDelta = [self getRGBWithColor:delataColor];
//    NSLog(@"+:%f   -:%f  progress:%f",self.selectedColorRGB[0] + colorDelta[0] * progress,self.selectedColorRGB[0] - colorDelta[0] * progress,progress);
    
    sourceLabel.textColor = [UIColor colorWithRed:self.selectedColorRGB[0] - colorDelta[0] * progress green:self.selectedColorRGB[1] - colorDelta[1] * progress blue:self.selectedColorRGB[2] - colorDelta[2] * progress alpha:1.0];
    
    targetLabel.textColor = [UIColor colorWithRed:self.normalColorRGB[0] + colorDelta[0] * progress green:self.normalColorRGB[1] + colorDelta[1] * progress blue:self.normalColorRGB[2] + colorDelta[2] * progress alpha:1.0];
    
    
    //记录最新的index
    self.currentIndex = targetIndex;
    
    //NSLog(@"======setTitleWithProgress====== soureceIndex = %zd  targetIndex = %zd",sourceIndex,targetIndex);
    
    CGFloat moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveTotalW = targetLabel.frame.size.width - sourceLabel.frame.size.width;
    
    //计算滚动的范围差值
    if (self.style.isShowBottomLine){
        
        CGFloat x = sourceLabel.frame.origin.x + moveTotalX * progress;
        
        CGFloat width = sourceLabel.frame.size.width + moveTotalW * progress;
        
        self.bottomLine.frame = CGRectMake(x, self.bottomLine.frame.origin.y,width, self.bottomLine.frame.size.height);
    }
    
    //放大比例
    if (self.style.isNeedScale) {
        CGFloat scaleDelta = (self.style.scaleRange - 1.0) * progress;
        
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.scaleRange - scaleDelta, self.style.scaleRange - scaleDelta);
        targetLabel.transform = CGAffineTransformMakeScale(1.0 + scaleDelta, 1.0 + scaleDelta);
    }
    //计算cover的滚动
    if (self.style.isShowCover) {
        
        CGFloat width = self.style.isTitleViewScrollEnable ? (sourceLabel.frame.size.width + 2 * self.style.coverMargin + moveTotalW *progress) : (sourceLabel.frame.size.width + moveTotalW * progress);
        
        CGFloat x = self.style.isTitleViewScrollEnable ? (sourceLabel.frame.origin.x - self.style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress);
        
        self.coverView.frame = CGRectMake(x, self.coverView.frame.origin.y, width, self.coverView.frame.size.height);
    }
}

- (void)contentViewDidEndScroll{
//    NSLog(@"======contentViewDidEndScroll");
    //如果不需要滚动，则不需要调整中间位置
    if (!self.style.isTitleViewScrollEnable) {
        return;
    }
    //获取目标Label
    UILabel *targetLabel = self.titleLabels[self.currentIndex];
    
    //计算中间位置的偏移量
    CGFloat offSetX = targetLabel.center.x - self.bounds.size.width * 0.5;
    if (offSetX < 0) {
        offSetX = 0;
    }
    
    CGFloat maxOffset = self.scrollView.contentSize.width - self.bounds.size.width;
    if (offSetX > maxOffset) {
        offSetX = maxOffset;
    }
    
    //滚动ScrollView
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
    
}

- (const CGFloat *)getRGBWithColor:(UIColor *)color{
    CGColorRef refColor = [color CGColor];
    const CGFloat *components = nil;
    long numComponents = CGColorGetNumberOfComponents(refColor);
    if (numComponents == 4) {
        components = CGColorGetComponents(refColor);
    }
    return components;
}

@end
