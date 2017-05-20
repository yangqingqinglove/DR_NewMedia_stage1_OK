//
//  YQRecordMessageVC.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/11.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQRecordMessageVC.h"
#import "YQMessageTableViewController.h"


@interface YQRecordMessageVC ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation YQRecordMessageVC

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
    self.commentButton.selected = YES;
    
    //5.设置属性
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    
}


#pragma mark - childVC的创建方法
- (void)setupChildVces
{
    YQMessageTableViewController *vc01 = [[YQMessageTableViewController alloc] init];
    vc01.title = @"评论";
    [self addChildViewController:vc01];
    
    YQMessageTableViewController *vc02 = [[YQMessageTableViewController alloc] init];
    vc02.title = @"赞";
    [self addChildViewController:vc02];
    
}


#pragma mark - allButtonClicked方法
- (IBAction)commentButtonClicked:(UIButton *)sender {
    
    if(sender.selected){
        //默认是 选中的状态
        return;
    }
    self.agreeButton.selected = NO;
    // 计算x方向上的偏移量
    CGFloat offsetX = sender.tag * self.contentScrollView.frame.size.width;
    
    // 设置偏移量
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    sender.selected = !self.agreeButton.selected;

}

- (IBAction)agreeButtonClicked:(UIButton *)sender {
    if(sender.selected){
        //默认是 选中的状态
        return;
    }
    self.commentButton.selected = NO;
    // 计算x方向上的偏移量
    CGFloat offsetX = sender.tag * self.contentScrollView.frame.size.width;
    
    // 设置偏移量
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    sender.selected = !self.commentButton.selected;

    
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
            
            self.commentButton.selected = YES;
            self.agreeButton.selected = NO;
            break;
        }
        case 1:{
            
            self.commentButton.selected = NO;
            self.agreeButton.selected = YES;
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
