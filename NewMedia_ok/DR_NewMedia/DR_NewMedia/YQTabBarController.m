//
//  YQTabBarController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/17.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQTabBarController.h"
#import "YQCollocationViewController.h"

@interface YQTabBarController ()<UITabBarDelegate>

@property(nonatomic,assign)int lock;


@end

@implementation YQTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //直接的是,整个的背景改为 ---> 主色系
    self.tabBar.tintColor = [UIColor colorWithRed:254.0/255.0 green:85.0/255.0 blue:166.0/255.0 alpha:1];
    //设置 TabBarItem的字体的颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor colorWithRed:240.0/255.0 green:85.0/255.0 blue:166.0/255.0 alpha:1]} forState:UIControlStateNormal];

    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[MBProgressHUD showMessage:@"正在登录中..." toView:self.view];
    // dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    hud.mode = MBProgressHUDModeIndeterminate;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        // Do something...
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    });
    
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    //目标控制器
    id destVC = segue.destinationViewController;
    
    if([destVC isKindOfClass:[YQCollocationViewController class]]){
        
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //[MBProgressHUD showMessage:@"正在登录中..." toView:self.view];
        // dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
        hud.mode = MBProgressHUDModeIndeterminate;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            // Do something...
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    }
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
//    item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    if(item.tag == 3 && !self.lock){
        //进行的判断的处理,这里需要我们的是 从偏好中来进行的取值
        //两种的逻辑的处理:没有登录
        //默认进行的登录的情况!
        
        
        self.lock = 1;
    }

}


@end
