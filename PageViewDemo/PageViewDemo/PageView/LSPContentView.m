//
//  XContentView.m
//  PageViewDemo
//  https://github.com/MrLSPBoy/PageViewController
//  Created by Object on 17/7/11.
//  Copyright © 2017年 Object. All rights reserved.
//

#import "LSPContentView.h"

static NSString *kContentCellID = @"kContentCellID";

@interface LSPContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 所有的子控制器
 */
@property(nonatomic, copy) NSArray <UIViewController *>*childVcs;
/**
 父控制器
 */
@property(nonatomic, weak) UIViewController *parentVc;
/**
 是否禁止ScollView拖动，防止两个代理产生死循环
 */
@property(nonatomic, assign) BOOL isForbidScrollDelegate;
/**
 开始滑动的位置
 */
@property(nonatomic, assign) CGFloat startOffsetX;
/**
 内容视图
 */
@property(nonatomic, strong) UICollectionView *collectionView;
/**
标题样式
 */
@property(nonatomic, strong) LSPTitleStyle *style;

@end


@implementation LSPContentView

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.scrollsToTop = NO;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.frame = self.bounds;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContentCellID];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = self.style.isContentViewScrollEnable;
    }
    return _collectionView;
}

- (LSPContentView *)initWithFrame:(CGRect)frame childVcs:(NSArray<UIViewController *> *)childVcs parentViewController:(UIViewController *)parentViewController style:(LSPTitleStyle *)style{
    if (self = [super initWithFrame:frame]) {
        
        self.childVcs = childVcs;
        self.parentVc = parentViewController;
        self.style = style;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    //将所有控制器添加到父控制器中
    for (UIViewController *childVc in self.childVcs) {
        [self.parentVc addChildViewController:childVc];
    }
    
    //添加CollectionView
    [self addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childVcs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCellID forIndexPath:indexPath];
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIViewController *childVc = self.childVcs[indexPath.item];
    childVc.view.backgroundColor =[UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0];
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.isForbidScrollDelegate = NO;
    
    self.startOffsetX = scrollView.contentOffset.x;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //判断是否是点击事件
    if (self.isForbidScrollDelegate) {
        return;
    }
    //定义获取需要的变量
    CGFloat progress = 0.0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
   
    //判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;

    if (currentOffsetX > self.startOffsetX) {//左滑
         //计算progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        
        //计算sourceIndex
        sourceIndex =  (NSInteger)(currentOffsetX / scrollViewW);

        //计算targetIndex
        targetIndex = sourceIndex + 1;
//        NSLog(@"targetIndex=%zd",targetIndex);
        if (targetIndex >= self.childVcs.count) {
            targetIndex = self.childVcs.count - 1;
            sourceIndex = self.childVcs.count - 1;
        }

        //如果完全划过去
        if (currentOffsetX - self.startOffsetX == scrollViewW) {

            progress = 1.0;
            targetIndex = sourceIndex;
        }
        
    }else{//右滑
        //计算progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));

        //计算targetIndex
        targetIndex = (NSInteger)(currentOffsetX / scrollViewW);

        //计算sourceIndex
        sourceIndex = targetIndex + 1;
        
        if (sourceIndex >= self.childVcs.count) {

            sourceIndex = self.childVcs.count - 1;
        }
    }
   // NSLog(@"progress:%f  targetIndex:%zd  sourceIndex:%zd",progress,targetIndex,sourceIndex);
    //将progress/sourceIndex/targetIndex
    if ([self.delegate respondsToSelector:@selector(contentViewWith:progress:sourceIndex:targetIndex:)]) {
        [self.delegate contentViewWith:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;

    //快速滑动之后 可能会出现偏差 需要重置
    NSInteger targetIndex = (NSInteger)(currentOffsetX / scrollViewW);
    if (targetIndex >= self.childVcs.count - 1)
    {
//        NSLog(@"目标====%zd",targetIndex);
        NSInteger sourceIndex = targetIndex;
        CGFloat progress = 1.0;
        if ([self.delegate respondsToSelector:@selector(contentViewWith:progress:sourceIndex:targetIndex:)])
        {
            
            [self.delegate contentViewWith:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(contentViewEndScrollWithContentView:)]) {
        [self.delegate contentViewEndScrollWithContentView:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDeceleratingWithIndex:)]) {
        [self.delegate scrollViewDidEndDeceleratingWithIndex:(NSInteger)(currentOffsetX / scrollViewW)];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        if ([self.delegate respondsToSelector:@selector(contentViewEndScrollWithContentView:)]) {
            [self.delegate contentViewEndScrollWithContentView:self];
        }
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    //记录需要进行执行代理方法
    self.isForbidScrollDelegate = YES;
    
    //滚动到正确位置
    CGFloat offsetX = currentIndex * self.collectionView.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}

@end
