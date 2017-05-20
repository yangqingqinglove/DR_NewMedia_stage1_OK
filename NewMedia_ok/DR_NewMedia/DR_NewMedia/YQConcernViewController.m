//
//  YQConcernViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/3.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQConcernViewController.h"
#import "YQConcerFirstTableViewController.h"
#import "YQHotDetailViewController.h"
#import "YQButton.h"

@interface YQConcernViewController ()<UIScrollViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

/// 记录当前的bnt 的选中状态
@property(nonatomic,strong)UIButton * currentButton;


@end

@implementation YQConcernViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 1.添加子控制器
    [self setupChildVces];
    
    // 2.添加顶部的所有标题
    [self setupTitles];
    
    // 3.设置默认第一个控制器的内容
    UIViewController *firstVc = [self.childViewControllers firstObject];
    firstVc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:firstVc.view];
    
    // 4.设置contentSize
    CGFloat contentW = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.contentScrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 4.1偏移的bug设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 5.设置默认的第一个bnt的选中状态
    UIButton * fristBnt = self.titleScrollView.subviews[0];
    fristBnt.selected = YES;
    self.currentButton = fristBnt;
    
    // 6.添加navItem
    UIButton * rightBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBnt.backgroundColor = [UIColor clearColor];//设置透明
    [rightBnt addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBnt setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [rightBnt sizeToFit];
    
    UIBarButtonItem * bntItem = [[UIBarButtonItem alloc]initWithCustomView:rightBnt];
    self.navigationItem.rightBarButtonItem = bntItem;
    
    // 7.titileView的添加
    UISearchBar * search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [search setPlaceholder:@"搜你关注的内容或圈友"];
    search.tintColor = [UIColor grayColor];
    search.delegate = self;
//    UIBarButtonItem * imageItem = [[UIBarButtonItem alloc]initWithCustomView:search];
    self.navigationItem.titleView = search;

    // 8.接受通知
    [self abserverAllNoties];
    
    
}

#pragma mark --------添加子控制器------
- (void)setupChildVces
{
    YQConcerFirstTableViewController *vc01 = [[YQConcerFirstTableViewController alloc] init];
    vc01.title = @"热门推荐";
    [self addChildViewController:vc01];
    
    YQConcerFirstTableViewController *vc02 = [[YQConcerFirstTableViewController alloc] init];
    vc02.title = @"关注";
    [self addChildViewController:vc02];
    
    YQConcerFirstTableViewController *vc03 = [[YQConcerFirstTableViewController alloc] init];
    vc03.title = @"问答";
    [self addChildViewController:vc03];
    
    YQConcerFirstTableViewController *vc04 = [[YQConcerFirstTableViewController alloc] init];
    vc04.title = @"我的消息";
    [self addChildViewController:vc04];
    
}

#pragma mark --------添加顶部所有的标题------
- (void)setupTitles
{
    // 创建button
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat labelW = self.view.bounds.size.width / count;
    CGFloat labelH = self.titleScrollView.bounds.size.height - 2;
    CGFloat labelY = 0;
    
    for (NSUInteger i = 0; i < count; i++) {
        // 创建labe
        YQButton *btn = [[YQButton alloc] init];
        btn.tag = i;
        
        // 设置frame
        CGFloat btnX = i * labelW;
        btn.frame = CGRectMake(btnX, labelY, labelW, labelH);
        
        // 设置文字和图片
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        
        //[btn setImage:[UIImage imageNamed:vc.title] forState:UIControlStateHighlighted];
        //btn setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
        
        // 监听点击事件
        [btn addTarget:self action:@selector(bottonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScrollView addSubview:btn];
    }
    
    // 设置scrollView的内容大小
    CGFloat titlesContentW = count * labelW;
    self.titleScrollView.contentSize = CGSizeMake(titlesContentW, 0);
}


-(void)bottonDidClicked:(UIButton *)btn{
    
    //这里的是:切换加载对应的VC
    // 计算x方向上的偏移量
    CGFloat offsetX = btn.tag * self.contentScrollView.frame.size.width;
    self.currentButton.selected = NO;
    btn.selected = YES;
    self.currentButton = btn;
    
    // 设置偏移量
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    // 获得当前需要显示的子控制器索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];
    // 执行的bnt选中的状态的调整
    self.currentButton.selected = NO;
    UIButton * btn = self.titleScrollView.subviews[index];
    btn.selected = YES;
    self.currentButton = btn;
    
    
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

#pragma mark - navBarClick的方法
-(void)rightBarButtonClicked:(UIButton *)rightBnt{//其他的功能的设置


}

-(void)right1BarButtonClicked:(UIButton *)right1Bnt{//继承的友盟 分享


}

#pragma mark - searchBar的代理方法
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //默认置为nil
    searchBar.text = nil;
    

}

#pragma mark - 接受所有通知的方法
-(void)abserverAllNoties{

    [YQNoteCenter addObserver:self selector:@selector(pushDetailView) name:YQContentTabelViewClicked object:nil];

}

#pragma mark - 通知执行的方法
-(void)pushDetailView{
    
    //解决跳转详情键盘 不回收bug
    [self.view endEditing:YES];
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQHotDetail" bundle:nil];
    UIViewController * vc = [sb instantiateInitialViewController];
    
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark --------dealloc------
-(void)dealloc{

    [YQNoteCenter removeObserver:self];
}

@end
