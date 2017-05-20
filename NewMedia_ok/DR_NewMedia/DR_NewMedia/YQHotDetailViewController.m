//
//  YQHotDetailViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/9.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQHotDetailViewController.h"
#import "YQHeadTitleView.h"
#import "YQConcerAllTableViewController.h"


@interface YQHotDetailViewController ()<UIScrollViewDelegate>

/// childView
@property(nonatomic,strong)YQHeadTitleView * headTitleView;
@property (weak, nonatomic) IBOutlet UIView *HeadView;
@property (weak, nonatomic) IBOutlet UIScrollView *ContentScrollView;

/// childButton
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;


@end

@implementation YQHotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    // 0.navBar设置为全透明的
//    UIImage * image = [[UIImage alloc]init];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
//    
//    //去横线去阴影的方法
//    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
//    {
//        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
//    }
    

    // 1.headtitle的初始化
    [self initWithHeadTitleView];
    
    // 2.添加子控制器的方法
    [self setupChildVces];
    
    // 3.设置scrollview
    CGFloat contentW = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.ContentScrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 4.设置默认的第一个 控制器
    UIViewController *firstVc = [self.childViewControllers firstObject];
    firstVc.view.frame = self.ContentScrollView.bounds;
    [self.ContentScrollView addSubview:firstVc.view];
    
    // 5.默认的 全部按钮是选中的状态
    self.allButton.selected = YES;
    
    // 6.添加返回按钮组
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button
    button.backgroundColor = [UIColor clearColor];//设置透明
    button.bounds = CGRectMake(0, 0, 40, 20);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:55.0/255.0 green:85.0/255.0 blue:166.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(leftBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIImageView * rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"左.png"]];
    rightImage.bounds = CGRectMake(0, 0, 15, 15);
    // rightImage.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem * rightImageItem = [[UIBarButtonItem alloc]initWithCustomView:rightImage];
    self.navigationItem.leftBarButtonItems = @[rightImageItem,rightItem,];

    // 7.偏移的属性
    self.automaticallyAdjustsScrollViewInsets = NO;


}

#pragma mark - init_childView方法
-(void)initWithHeadTitleView{
    
    self.headTitleView = [YQHeadTitleView headTitleInit];
    [self.HeadView addSubview:self.headTitleView];
    
    [self.headTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.HeadView.mas_left).offset(10);
        make.right.mas_equalTo(self.HeadView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.HeadView.mas_bottom).offset(-10);
        make.height.mas_equalTo(60);
        
    }];
}

#pragma mark - childVC的创建方法
- (void)setupChildVces
{
    YQConcerAllTableViewController *vc01 = [[YQConcerAllTableViewController alloc] init];
    vc01.title = @"全部";
    [self addChildViewController:vc01];
    
    YQConcerAllTableViewController *vc02 = [[YQConcerAllTableViewController alloc] init];
    vc02.title = @"问答";
    [self addChildViewController:vc02];
    
}

#pragma mark - buttonClicked的点击方法
- (IBAction)AllButtonClicked:(UIButton *)sender {
    if(sender.selected){
        //默认是 选中的状态
        return;
    }
    self.answerButton.selected = NO;
    // 计算x方向上的偏移量
    CGFloat offsetX = sender.tag * self.ContentScrollView.frame.size.width;
    
    // 设置偏移量
    [self.ContentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    sender.selected = !self.answerButton.selected;
    
}

- (IBAction)answerButtonClicked:(UIButton *)sender {
    
    if(sender.selected){
        //默认是 选中的状态
        return;
    }
    self.allButton.selected = NO;
    // 计算x方向上的偏移量
    CGFloat offsetX = sender.tag * self.ContentScrollView.frame.size.width;
    
    // 设置偏移量
    [self.ContentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    sender.selected = !self.allButton.selected;
    
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
            
            self.allButton.selected = YES;
            self.answerButton.selected = NO;
            break;
        }
        case 1:{
            
            self.allButton.selected = NO;
            self.answerButton.selected = YES;
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
    //    NSLog(@"index == %ld",index);
}

/**
 *  当scrollview停止滚动时调用这个方法 (用户手动触发的动画结束,会调用这个方法)
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


#pragma mark - dismissVC方法
-(void)leftBarButtonClicked{

    [self.navigationController popViewControllerAnimated:YES];

}


@end
