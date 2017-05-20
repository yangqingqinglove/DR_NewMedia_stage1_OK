//
//  YQHistoricalFootprintVC.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/11.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQHistoricalFootprintVC.h"
#import "YQHistoricalTableViewController.h"

@interface YQHistoricalFootprintVC ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *readButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation YQHistoricalFootprintVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.设置子控制器
    [self setupChildVces];
    
    //2.设置scrollview
    CGFloat contentW = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.contentScrollView.contentSize = CGSizeMake(contentW, 0);
    
    //3.设置默认的第一个 控制器
    UIViewController *firstVc = [self.childViewControllers firstObject];
    firstVc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:firstVc.view];
    
    //4.默认设置readBnt的选中的状态
    self.readButton.selected = YES;
    
    //5.设置属性
    self.automaticallyAdjustsScrollViewInsets = NO;

    
}


#pragma mark - childVC的创建方法
- (void)setupChildVces
{
    YQHistoricalTableViewController *vc01 = [[YQHistoricalTableViewController alloc] init];
    vc01.title = @"阅读足迹";
    [self addChildViewController:vc01];
    
    YQHistoricalTableViewController *vc02 = [[YQHistoricalTableViewController alloc] init];
    vc02.title = @"分享足迹";
    [self addChildViewController:vc02];
    
}

- (IBAction)readButtonClicked:(UIButton*)sender {
    
    if(sender.selected){
        //默认是 选中的状态
        return;
    }
    self.shareButton.selected = NO;
    // 计算x方向上的偏移量
    CGFloat offsetX = sender.tag * self.contentScrollView.frame.size.width;
    
    // 设置偏移量
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    sender.selected = !self.shareButton.selected;
    
}

- (IBAction)shareButtonClicked:(UIButton *)sender {
    if(sender.selected){
        //默认是 选中的状态
        return;
    }
    self.readButton.selected = NO;
    // 计算x方向上的偏移量
    CGFloat offsetX = sender.tag * self.contentScrollView.frame.size.width;
    
    // 设置偏移量
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    sender.selected = !self.readButton.selected;
    
}


#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得当前需要显示的子控制器索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];
    // 对应的控制器的按钮来 进行的高亮选中处理
    switch (index) {
        case 0:{
            
            self.readButton.selected = YES;
            self.shareButton.selected = NO;
            break;
        }
        case 1:{
            
            self.readButton.selected = NO;
            self.shareButton.selected = YES;
            break;
        }
            
        default:
            break;
    }
    
    // 如果子控制器的view已经在上面,就直接返回
    if (vc.view.superview) return;
    
    // 添加
    CGFloat vcW = scrollView.frame.size.width;
    CGFloat vcH = scrollView.frame.size.height;
    CGFloat vcY = 0;
    CGFloat vcX = index * vcW;
    vc.view.frame = CGRectMake(vcX, vcY, vcW, vcH);
    
    [scrollView addSubview:vc.view];
    
}

/**
 *  当scrollview停止滚动时调用这个方法 (用户手动触发的动画结束,会调用这个方法)
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


@end
