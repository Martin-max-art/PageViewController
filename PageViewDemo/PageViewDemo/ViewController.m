//
//  ViewController.m
//  PageViewDemo
//
//  Created by Object on 17/7/11.
//  Copyright © 2017年 Object. All rights reserved.
//

#import "ViewController.h"

#import "LSPPageView.h"
@interface ViewController ()<LSPPageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    NSMutableArray *testArray = [NSMutableArray array];
    
    for (int i = 0; i < 15; i++) {
        [testArray addObject:[NSString stringWithFormat:@"Test%d",i]];
    }

    NSMutableArray *childVcArray = [NSMutableArray array];
    for (int i = 0; i < testArray.count; i++) {
        UIViewController *vc = [[UIViewController alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = self.view.center;
        label.text = testArray[i];
        [vc.view addSubview:label];
        [childVcArray addObject:vc];
    }
    LSPPageView *pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) titles:testArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    [pageView setToIndex:3];
    pageView.delegate = self;
    pageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pageView];

}
#pragma mark - LSPPageViewDelegate
- (void)pageViewScollEndView:(LSPPageView *)pageView WithIndex:(NSInteger)index
{
    NSLog(@"第%zd个",index);
}


@end
