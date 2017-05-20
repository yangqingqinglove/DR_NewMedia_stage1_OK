//
//  YQMineViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/8.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQMineViewController.h"
#import "YQMineHeadView.h"
#import "YQStaticTableViewController.h"

@interface YQMineViewController ()

@property(nonatomic,strong)YQMineHeadView * mineHeadView;

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIView *contentView;


// 属性记录保存
@property(nonatomic,strong)YQStaticTableViewController * staticTableView;

// 登录状态的设置
@property(nonatomic,assign)BOOL isLogin;

@end

@implementation YQMineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 1.nav控制器要求实现的是透明
    UIImage * image = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    //去横线去阴影的方法
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 2.加载视图的xib
    [self initMineHeadView];
    
    // 3.加载静态单元cell
    [self initStaticTableView];
    
    // 4.接受通知
    [self abserverAllNoties];
    
    // 5.获取用户偏好设置的基本信息来设置
    self.isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:IsFirstLogin];


}


#pragma mark - 登录界面视图更新的方法
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //实现的思路: 通过的是 判断偏好设置中有没有值来 判断登录的状态
    //接受到,登录注册之后的界面的逻辑的调整!
    BOOL isFristLogin = [[NSUserDefaults standardUserDefaults] objectForKey:IsFirstLogin];
    if(isFristLogin ){
    
        self.tabBarItem.image = [UIImage imageNamed:@"个人_登录off"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"个人_登录on"];
        self.tabBarItem.title = @"我的";
        
        /// 用户的所有的信息的复用设置
        [self.mineHeadView.headImageView sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] objectForKey:UserIconurl] placeholderImage:nil];
        self.mineHeadView.titleLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:UserNickName];
        
    }

}

-(void)initMineHeadView{

    self.mineHeadView = [YQMineHeadView initMineHeadView];
    
    [self.backImageView addSubview:self.mineHeadView];
    
    [self.mineHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backImageView).offset(10);
        make.bottom.right.equalTo(self.backImageView).offset(-10);
        make.height.mas_equalTo(60);
        
    }];
}

-(void)initStaticTableView{
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQStaticTV" bundle:nil];
    self.staticTableView = [sb instantiateInitialViewController];
    [self.contentView addSubview:self.staticTableView.view];
    

    [self.staticTableView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.left.bottom.top.equalTo(self.contentView);
    }];
    
}


#pragma mark - 接受所有通知的方法
-(void)abserverAllNoties{
    
    [YQNoteCenter addObserver:self selector:@selector(pushDetailView:) name:YQPushChildsViewController object:nil];
}

#pragma mark - 通知执行的方法
-(void)pushDetailView:(NSNotification *)notes{
    
    NSString * VCName = notes.userInfo[YQPushChlidsVCTitileKey];
    
    if(!self.isLogin){//没有登录的情况下:
        
        
        BOOL isSetting = [VCName isEqualToString:@"YQSystemSetting"];
        
        if(isSetting){
            
            UIStoryboard * sb = [UIStoryboard storyboardWithName:VCName bundle:nil];
            UIViewController * vc = [sb instantiateInitialViewController];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{//弹出的登录注册的界面
            
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQLogin" bundle:nil];
            UIViewController * vc = [sb instantiateInitialViewController];
            [self presentViewController:vc animated:YES completion:nil];
            
        }
        
    }else{//已经登录的情况下
        UIStoryboard * sb = [UIStoryboard storyboardWithName:VCName bundle:nil];
        UIViewController * vc = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark --------dealloc------
-(void)dealloc{
    
    [YQNoteCenter removeObserver:self];
}


@end
