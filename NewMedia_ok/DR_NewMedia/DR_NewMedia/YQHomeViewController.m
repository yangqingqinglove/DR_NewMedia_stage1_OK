//
//  YQHomeViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/17.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQHomeViewController.h"
#import "YQFirstTableViewController.h"
#import "YQButton.h"
#import "YQTitleScrollView.h"
#import "CityListViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface YQHomeViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet YQTitleScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

/// 定位属性
@property(nonatomic,strong)CLLocationManager * locationManager;
@property(nonatomic,copy)NSString * currentCity;//当前城市

@end

@implementation YQHomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 0.开始定位
    [self locate];
    
    // 1.添加子控制器
    [self setupChildVces];
    
    // 2.添加顶部的所有标题
    [self setupTitles];
    
    // 3.添加的是默认的第一个的控制器
    UIViewController *firstVc = [self.childViewControllers firstObject];
    firstVc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:firstVc.view];
    
    // 4.设置contentSize
    CGFloat contentW = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.contentScrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 4.1偏移的bug设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 5.设置barItem的属性,item 就是模型
    //注意的是: 一定要 拿到它的 栈顶的控制器来进行的设置它的属性
    // 5.1 设置两边的 rignt and left的itemview的情况
    //不要渲染的原始 图片(也可以是storyAboard的中来设置)
    UIImage * image = [UIImage imageNamed:@"logo.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.bounds = CGRectMake(0, 0, 80, 25);
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:imageView];
    self.navigationItem.leftBarButtonItem = item;
//    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    // 5.2 可以的是设置 按钮的为item的情况!
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 默认的进行的获取 地点
    //button
    button.backgroundColor = [UIColor clearColor];//设置透明
    button.bounds = CGRectMake(0, 0, 40, 20);
    [button setTitleColor:[UIColor colorWithRed:55.0/255.0 green:85.0/255.0 blue:166.0/255.0 alpha:1] forState:UIControlStateNormal];
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIImageView * rightImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"定位.png"]];
    rightImage.bounds = CGRectMake(0, 0, 25, 25);
    // rightImage.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem * rightImageItem = [[UIBarButtonItem alloc]initWithCustomView:rightImage];
    self.navigationItem.rightBarButtonItems = @[rightImageItem,rightItem,];
    
    // 6.接受通知
    [self abserverAllNoties];
    
}

#pragma mark --------添加子控制器------
- (void)setupChildVces
{
    YQFirstTableViewController *vc01 = [[YQFirstTableViewController alloc] init];
    vc01.title = @"3D秀场";
    [self addChildViewController:vc01];
    
    YQFirstTableViewController *vc02 = [[YQFirstTableViewController alloc] init];
    vc02.title = @"媒体看点";
    [self addChildViewController:vc02];
    
    YQFirstTableViewController *vc03 = [[YQFirstTableViewController alloc] init];
    vc03.title = @"问答";
    [self addChildViewController:vc03];
    
    YQFirstTableViewController *vc04 = [[YQFirstTableViewController alloc] init];
    vc04.title = @"视频";
    [self addChildViewController:vc04];
 
}

#pragma mark --------添加顶部所有的标题------
- (void)setupTitles
{
    // 创建button
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat labelW = self.view.bounds.size.width / count;
    CGFloat labelH = self.titleScrollView.bounds.size.height -2;
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
    
    // 设置偏移量
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];

}

#pragma mark - 执行的scorllView的代理方法
/**
 *  在scrollview动画结束时调用 (添加子控制器的view到 self.contentScrollview )
 *  用户手动触发的动画结束,不会调用这个方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    // 获得当前需要显示的子控制器索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    UIViewController *vc = self.childViewControllers[index];
   
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //思路是 将btn的高亮的状态和 offset的效果执行起来实现一个动画的效果!
    // 1. 需要进行控制的文字 (2个标题)
    // 2. 两个标题各自的比例值
    // 偏移量 / 宽度
    CGFloat value = ABS(self.contentScrollView.contentOffset.x / self.contentScrollView.frame.size.width);
    //NSLog(@"===%f",value);// 这个的 value的取值的 范围是: 0 ~ 3 的取值的情况!!!
    
    // 左边bnt的索引
    NSUInteger leftIndex = (NSUInteger)(self.contentScrollView.contentOffset.x / self.contentScrollView.frame.size.width);
    // 右边bnt的索引
    NSUInteger rightIndex = leftIndex + 1;
    
    if (rightIndex > 3) {//就是 避免数组越界
        rightIndex = 3;
    }
    
    // 右边文字的比例
    CGFloat rightScale = value - leftIndex;
    // 左边文字的比例
    CGFloat leftScale = 1 - rightScale;
    
    // 取出label设置高亮状态的apla 的渐变的效果
    YQButton *leftBtn = self.titleScrollView.subviews[leftIndex +1];
    leftBtn.scale = leftScale;
    
    YQButton *rightBtn = self.titleScrollView.subviews[rightIndex +1];
    rightBtn.scale = rightScale;
    
    
    //范围是: 0~3
    [self.titleScrollView scrollToRate:(self.contentScrollView.contentOffset.x / self.contentScrollView.frame.size.width)];

}


#pragma mark - rightBarClick方法
-(void)rightBarButtonClicked:(UIButton *)btn{//点击了 定位城市的功能
    //跳转
    CityListViewController * cityVC = [[CityListViewController alloc]init];
    
    cityVC.latelyString = self.currentCity;
    [self.navigationController pushViewController:cityVC animated:YES];
    
    
}

#pragma mark - 接受通知的方法
-(void)abserverAllNoties{
    
    [YQNoteCenter addObserver:self selector:@selector(pushHomeContentVC) name:YQHomeContentTabelViewClicked object:nil];
    [YQNoteCenter addObserver:self selector:@selector(upDateLocationCity:) name:YQSettingLocationTitileNotification object:nil];

}

#pragma mark - 通知执行的方法
-(void)pushHomeContentVC{
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQHomeContent" bundle:nil];
    UIViewController * vc = [sb instantiateInitialViewController];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)upDateLocationCity:(NSNotification *)notes{
    
    self.currentCity = notes.userInfo[YQSettingLocationTitileKey];
    UIBarButtonItem * buttonItem = self.navigationItem.rightBarButtonItems.lastObject;
    UIButton * bnt = (UIButton *)buttonItem.customView;
    [bnt setTitle:self.currentCity forState:UIControlStateNormal];
    [bnt sizeToFit];
    
}


#pragma mark - 定位功能实现的方法
-(void)locate{
    //判断手机的定位功能是否已经打开
    if([CLLocationManager locationServicesEnabled]){
        
        self.locationManager = [[CLLocationManager alloc]init ];
        self.locationManager.delegate = self;
        // 是否需要始终开启定位
        [self.locationManager requestAlwaysAuthorization];
        
        //city
        self.currentCity = [[NSString alloc]init];
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - 定位实现coreLocation的代理方法
//定位失败则执行此代理方法
//定位失败弹出提示框,点击"打开定位"按钮,会打开系统的设置,提示打开定位服务
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
        
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


//定位成功(编码和反编码操作)
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    [self.locationManager stopUpdatingLocation];
    
//    NSLog(@"%@",self.locationManager);
//    NSLog(@"%ld",self.currentCity.length);
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    //反编码地理位置
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        [self.locationManager stopUpdatingLocation];
        
        if (placemarks.count > 0) {
            
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
            if (!_currentCity) {
                _currentCity = @"无法定位当前城市";
            }
//            NSLog(@"%@",_currentCity); //这就是当前的城市
//            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
//            NSLog(@"%@",[NSThread currentThread]); // 显示的是主 线程
            UIBarButtonItem * buttonItem = self.navigationItem.rightBarButtonItems.lastObject;
            UIButton * bnt = (UIButton *)buttonItem.customView;
            [bnt setTitle:_currentCity forState:UIControlStateNormal];
            [bnt sizeToFit];
            
        }else if (error == nil && placemarks.count == 0) {
            
            NSLog(@"No location and error return");
            
        }else if (error) {
            
            NSLog(@"location error: %@ ",error);
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
}


#pragma mark - dealloc方法
-(void)dealloc{
    
    [YQNoteCenter removeObserver:self];

}



@end
