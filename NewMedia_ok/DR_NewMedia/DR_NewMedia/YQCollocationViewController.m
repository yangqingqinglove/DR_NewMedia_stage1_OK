//
//  YQCollocationViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/20.
//  Copyright © 2017年 YQ. All rights reserved.
//

#define pictureFrames 36
#define widthSize [UIScreen mainScreen].bounds.size.width
#define heightSize [UIScreen mainScreen].bounds.size.height
#define collocationBackColor [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:0.3]
#define buttonSize 45
#define ADuration 0.01
#define downTime 2.5

#import "YQCollocationViewController.h"
#import "YQBottomView.h"
#import "YQTopView.h"
#import "YQWardrobeCollectionView.h"
#import "YQWardrobeCell.h"
#import "YQDetailViewController.h"
#import "YQRulerVC.h"
#import "YQBackGroundViewController.h"
#import "YQImageGroupView.h"
#import "YQSaveFileViewController.h"
#import <MBProgressHUD.h>
#import "QRCodeReaderViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>


@interface YQCollocationViewController ()<YQBottomViewClickDeleage,YQTopViewClickDeleate,UICollectionViewDelegate,UICollectionViewDataSource,YQImageGroupViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QRCodeReaderDelegate>

//@property (weak, nonatomic) IBOutlet UIView *navBarView;

@property (weak, nonatomic) IBOutlet YQImageGroupView *imageView;

@property(nonatomic,strong)YQWardrobeCollectionView * wardrobeView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

/// 各种的展示控制器
@property(nonatomic,strong)YQDetailViewController * detailVC;
@property(nonatomic,strong)YQRulerVC * rulerVC;
@property(nonatomic,strong)YQBackGroundViewController * BGVC;
@property(nonatomic,strong)YQSaveFileViewController * saveFileVC;


/// 定义的记录属性 view
@property(nonatomic,strong)UIView * bottomV;
@property(nonatomic,strong)UIView * topView;
@property(nonatomic,strong)UIView * baffleView;

/// 伸缩属性
@property(nonatomic,assign)BOOL isShow;

/// 定义的是衣柜模型数组
@property(nonatomic,strong)NSMutableArray * collocationArray;

@end

UIImagePickerController *_imagePickerController;

static NSString * ID = @"imageCell";

@implementation YQCollocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //0.添加菊花加载
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeIndeterminate;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(downTime* NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        
        // Do something... downsometing....
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    });

    //1.加载topView
    YQTopView * topView = [YQTopView buttonMenu];
    topView.deleage = self;
    [topView bringSubviewToFront:topView.collectionImageVIEW];
    topView.backImageView.backgroundColor = collocationBackColor;
    topView.collectionImageVIEW.selected = NO;
    [self.view addSubview:topView];
    self.topView = topView;
    self.topView.frame = CGRectMake(widthSize - 60, 64, 60, 34);
    
    //2.创建buttonView的展示的效果
    YQBottomView * bottomView = [YQBottomView buttonMenu];
    bottomView.deleage = self;
    [self.view addSubview:bottomView];
    self.bottomV = bottomView;
    CGFloat childs = self.bottomV.subviews.count;
    self.bottomV.frame = CGRectMake(0, heightSize - buttonSize - 48,childs *(buttonSize+ 5),  buttonSize);
    
    //3.创建share的衣柜,创建的流水布局
    //3.1 创建布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 5;
//    layout.headerReferenceSize = CGSizeMake(60, 5 );
    
    //3.2 创建rect
    CGRect rect = CGRectMake(widthSize, 64 + 34, 60, heightSize - 48 -64 -34);
    YQWardrobeCollectionView * wardrobe = [[YQWardrobeCollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
    wardrobe.backgroundColor = collocationBackColor;
    wardrobe.dataSource = self;
    wardrobe.delegate =   self;
    
    //3.3 注册原型cell
    UINib * cellNib = [UINib nibWithNibName:@"YQWardrobeCell" bundle:nil];
    [wardrobe registerNib:cellNib forCellWithReuseIdentifier:ID];
    self.wardrobeView = wardrobe;
    [self.view addSubview:wardrobe];
    
    //4.设置代理
    self.imageView.delegate = self;
    
    //5.0 设置nav 的大的透明的背景
    UIImage * image = [[UIImage alloc]init];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    //去横线去阴影的方法
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    }
    
    //5.1 设置自定义的titleView
    UIButton * leftBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBnt.backgroundColor = [UIColor clearColor];//设置透明
    [leftBnt addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftBnt setImage:[UIImage imageNamed:@"扫描.png"] forState:UIControlStateNormal];
    [leftBnt sizeToFit];
    UIBarButtonItem * imageItem = [[UIBarButtonItem alloc]initWithCustomView:leftBnt];
    self.navigationItem.leftBarButtonItem = imageItem;
    
    
    //6.设置rightBar
    UIButton * rightBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBnt.backgroundColor = [UIColor clearColor];//设置透明
    [rightBnt addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBnt setImage:[UIImage imageNamed:@"其他.png"] forState:UIControlStateNormal];
    [rightBnt sizeToFit];
    UIBarButtonItem * bntItem = [[UIBarButtonItem alloc]initWithCustomView:rightBnt];
    
    UIButton * rightBnt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBnt1.backgroundColor = [UIColor clearColor];//设置透明
    [rightBnt1 addTarget:self action:@selector(rightItem1BarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBnt1 setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [rightBnt1 sizeToFit];

    UIBarButtonItem * bntItem1 = [[UIBarButtonItem alloc]initWithCustomView:rightBnt1];
    self.navigationItem.rightBarButtonItems = @[bntItem,bntItem1];
    
    //7.接受所有通知
    [self abserverAllNoties];
    
}


#pragma mark - 懒加载
-(NSMutableArray *)collocationArray{
    
    if(!_collocationArray){
        //添加下载收藏的图片柜
        NSArray * images = @[@"duowei_00",@"philips_hq6070_00",@"quen170427_40000036_00",@"yi170427_40000036_00",@"ku170427_30000036_00"];
        _collocationArray = [NSMutableArray array];
        
        for(int i =0;i<images.count ;i++){
            
            NSString * string1 = [NSString stringWithFormat:@"%@.png",images[i]];
            
            //  将图片加入数组
            [_collocationArray addObject:string1];
        }
    }
    return _collocationArray;
}


#pragma mark TopBottomViewClickDeleage代理执行的方法
-(void)bottomView:(YQBottomView *)bottomV didSelectedButtonFrom:(NSUInteger)from to:(int)To{
    
    if(self.imageView.animating){
        return;
    }
    
    [self bottomViewDetegateToOriginalPicture];
    [self bottomViewDetegateToPlayPictureFrom:To];

}

-(void)topView:(YQTopView *)TopV buttonDidSelectTag:(NSInteger)tag{
    //移动 transform
    //禁止用户交互其他的选项
    self.imageView.userInteractionEnabled = NO;
    
    CGFloat x = 0;
    
    CGAffineTransform transform = CGAffineTransformMake(1, 0,0,1, 0, 0);
    if (!_isShow) {
        
        x = -60;
        
    }else{
        
        x = 60;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.wardrobeView.transform = CGAffineTransformTranslate(transform, x, 0);
        TopV.backImageView.transform = CGAffineTransformTranslate(transform, x, 0);
        
    }completion:^(BOOL finished) {
        
        
        self.imageView.userInteractionEnabled = YES;
    }];
    
    self.isShow = !self.isShow;
    TopV.collectionImageVIEW.selected = self.isShow;
    
}


#pragma mark - collectionView的数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collocationArray.count;
}


-(UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YQWardrobeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor whiteColor];
    //cell.imagename  = self.imagesArray[indexPath.row];
    //if(indexPath.row < self.collocationArray.count){
    
    //NSString * path1 = [[NSBundle mainBundle] pathForResource:self.collocationArray[indexPath.item] ofType:nil];
    cell.imageview.image = [UIImage imageNamed:self.collocationArray[indexPath.item]];
    
    //}
    
    return cell;
}


#pragma mark - collectionView的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //点击的item的选中的情况! 取出来进行检验图片名是否相同!
    //1.首先判断的是这个图片是单张or 组合
    NSString * str = [self.collocationArray[indexPath.item] substringToIndex:2];
    
    if(![str isEqualToString:@"yi"] && ![str isEqualToString:@"ku"]){//单张图片
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            //图片是从记录的 位置,开始显示!
            // 注意的是,这里还要有判断上衣和 下衣的逻辑 合成图片
            NSString * string1 = self.collocationArray[indexPath.item];
            NSString * string2 = [string1 substringToIndex:string1.length - 7];
            
//            NSString * string2 = self.imageView.currentDownImageName;
//            NSString * string3 = [string2 substringToIndex:string2.length - 7];
            if([str isEqualToString:@"qu"]){
                
                for(int i=0;i < pictureFrames ;i++){
                    
                    NSString * string3 = [NSString stringWithFormat:@"%@_%02d.png",string2,i*10];
                    NSString * path1 = [[NSBundle mainBundle] pathForResource:string3 ofType:nil];
                    
                    //                NSString * string2 = [NSString stringWithFormat:@"%@_%02d.png",string3,i*10];
                    //                NSString * path2 = [[NSBundle mainBundle] pathForResource:string2 ofType:nil];
                    
                    //  生成图片
                    UIImage *image = [UIImage imageWithContentsOfFile:path1];
                    
                    //  将图片加入数组
                    [self.imageView.cacheArray replaceObjectAtIndex:i withObject:image];
                };
                
            }else{
                
                for(int i=0;i < pictureFrames ;i++){
                    
                    NSString * string1 = [NSString stringWithFormat:@"%@_%02d.jpg",string2,i*10];
                    NSString * path1 = [[NSBundle mainBundle] pathForResource:string1 ofType:nil];
                    
                    //                NSString * string2 = [NSString stringWithFormat:@"%@_%02d.png",string3,i*10];
                    //                NSString * path2 = [[NSBundle mainBundle] pathForResource:string2 ofType:nil];
                    
                    //  生成图片
                    UIImage *image = [UIImage imageWithContentsOfFile:path1];
                    
                    //  将图片加入数组
                    [self.imageView.cacheArray replaceObjectAtIndex:i withObject:image];
                };
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //最后的显示的是: 当前停止的状态
                self.imageView.image = self.imageView.cacheArray[0];
                self.imageView.lastIndex = 0;
                self.imageView.currentUpImageName = string1;
                self.imageView.currentDownImageName = nil;
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.imageView.transform = self.imageView.originalTransform;
                    
                }];
            });
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            // Do something...
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
        
    }else{
        
        
        BOOL equal1 =[self.collocationArray[indexPath.item] isEqualToString: self.imageView.currentDownImageName];
        
        BOOL equal2 =[self.collocationArray[indexPath.item] isEqualToString: self.imageView.currentUpImageName];
        
        if(equal1 || equal2){//相等,证明的是,图片存在
            
            //alert 提示当前 衣服就是!
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经在展示了哟!" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil ];
            
            return;
            
        }else{//不相等的情况下,需要的是合成 //还有的 逻辑的判断是 现存的是 如果是同类 和 不是同一类的情况
            
            
            BOOL equal1 =[[self.imageView.currentDownImageName substringToIndex:2] isEqualToString: @"ku"];
            
            BOOL equal2 =[[self.imageView.currentUpImageName substringToIndex:2] isEqualToString: @"yi"];
            
            //BOOL equal3 =[self.collocationArray[indexPath.item] isEqualToString: @"ku"];
            
            BOOL equal4 =[str isEqualToString: @"yi"];

            if(equal1 || equal2){
            
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    //图片是从记录的 位置,开始显示!
                    // 注意的是,这里还要有判断上衣和 下衣的逻辑 合成图片
                    NSString * string1 = self.collocationArray[indexPath.item];
                    NSString * string = [string1 substringToIndex:string1.length - 7];
                    
                    NSString * string2 = nil;
                    if(equal1){//当前是裤子
                        
                        string2 = self.imageView.currentDownImageName;
                        NSString * string3 = [string2 substringToIndex:string2.length - 7];
                        
                        for(int i=0;i < pictureFrames ;i++){
                            
                            NSString * string1 = [NSString stringWithFormat:@"%@_%02d.png",string,i*10];
                            NSString * path1 = [[NSBundle mainBundle] pathForResource:string1 ofType:nil];
                            
                            NSString * string2 = [NSString stringWithFormat:@"%@_%02d.png",string3,i*10];
                            NSString * path2 = [[NSBundle mainBundle] pathForResource:string2 ofType:nil];
                            
                            //  生成图片
                            UIImage *image = [self.imageView addImagePath:path2 withImage:path1];
                            
                            //  将图片加入数组
                            [self.imageView.cacheArray replaceObjectAtIndex:i withObject:image];
                        };

                    }else{
                        
                        string2 = self.imageView.currentUpImageName;
                        NSString * string3 = [string2 substringToIndex:string2.length - 7];
                        
                        for(int i=0;i < pictureFrames ;i++){
                            
                            NSString * string1 = [NSString stringWithFormat:@"%@_%02d.png",string,i*10];
                            NSString * path1 = [[NSBundle mainBundle] pathForResource:string1 ofType:nil];
                            
                            NSString * string2 = [NSString stringWithFormat:@"%@_%02d.png",string3,i*10];
                            NSString * path2 = [[NSBundle mainBundle] pathForResource:string2 ofType:nil];
                            
                            //  生成图片
                            UIImage *image = [self.imageView addImagePath:path1 withImage:path2];
                            
                            //  将图片加入数组
                            [self.imageView.cacheArray replaceObjectAtIndex:i withObject:image];
                        };
                    }

                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //最后的显示的是: 当前停止的状态
                        self.imageView.image = self.imageView.cacheArray[self.imageView.lastIndex];
                        if(equal1){//当前是裤子
                        
                            self.imageView.currentUpImageName = string1;
                        }else{
                            
                            self.imageView.currentDownImageName = string1;
                        }
                    });
                    
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(downTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                    
                    // Do something...
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                });
                
            }else{
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    //图片是从记录的 位置,开始显示!
                    // 注意的是,这里还要有判断上衣和 下衣的逻辑 合成图片
                    NSString * string1 = self.collocationArray[indexPath.item];
                    NSString * string = [string1 substringToIndex:string1.length - 7];
                    
                    //            NSString * string2 = self.imageView.currentDownImageName;
                    //            NSString * string3 = [string2 substringToIndex:string2.length - 7];
                    
                    for(int i=0;i < pictureFrames ;i++){
                        
                        NSString * string1 = [NSString stringWithFormat:@"%@_%02d.png",string,i*10];
                        NSString * path1 = [[NSBundle mainBundle] pathForResource:string1 ofType:nil];
                        
                        //                NSString * string2 = [NSString stringWithFormat:@"%@_%02d.png",string3,i*10];
                        //                NSString * path2 = [[NSBundle mainBundle] pathForResource:string2 ofType:nil];
                        
                        //  生成图片
                        UIImage *image = [UIImage imageWithContentsOfFile:path1];
                        
                        //  将图片加入数组
                        [self.imageView.cacheArray replaceObjectAtIndex:i withObject:image];
                    };
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //最后的显示的是: 当前停止的状态
                        self.imageView.image = self.imageView.cacheArray[self.imageView.lastIndex];
                        
                        if(equal4){
                        
                            self.imageView.currentUpImageName = string1;
                            self.imageView.currentDownImageName = nil;
                            
                        }else{
                            
                            self.imageView.currentUpImageName = nil;
                            self.imageView.currentDownImageName = string1;

                        }
                    });
                    
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                    // Do something...
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                });
            }
        }
    }
}

#pragma mark - AllButtonClick的方法
- (IBAction)rulerBtnClick:(id)sender {
    
    //整体的 modal 出来一个控制器
    //添加蒙版,设置成为第一响应者
    UIView * baffleV = [[UIView alloc]initWithFrame:self.view.bounds];
    baffleV.backgroundColor = [UIColor grayColor];
    baffleV.alpha = 0.5;
    //BOOL ISTR = [baffleV isFirstResponder];//是否是 第一响应者的情况!
    //[baffleV becomeFirstResponder];//成为第一响应者
    //[baffleV resignFirstResponder];//取消第一响应者
    [self.view addSubview:baffleV];
    self.baffleView = baffleV;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(baffleViewDidClilck)];
    [self.baffleView addGestureRecognizer:tap];
    
    YQRulerVC * ruler = [[YQRulerVC alloc]init];
    self.rulerVC = ruler;
    [self.view addSubview:ruler.view];
    self.rulerVC.view.alpha = 0;
    self.rulerVC.view.hidden = YES;
    self.rulerVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
    
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        
        //        [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(baffleV.mas_top).offset(200);
        //            make.width.equalTo(baffleV.mas_bottom).offset(200);
        //        }];
        // self.rulerVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
        self.rulerVC.view.alpha = 1;
        self.rulerVC.view.hidden = NO;
        
    }];
    
    
    // modal 弹框的效果的图形
//    YQRulerVC * ruler = [[YQRulerVC alloc]init];
//    ruler.modalPresentationStyle = UIModalPresentationFormSheet;// 只针对于 ipad的view,对于iphone的项目不适用!
//    [self presentViewController:ruler animated:YES completion:nil];
//    
}




- (IBAction)backgroundBtnClick:(id)sender {
    //实现的思路是:添加模板, 然后的是:自定义的弹窗modal的效果
    /*
     //通过的是调用的popview的窗口来实现的
     //1.创建内容的控制器
     UIStoryboard * revise = [UIStoryboard storyboardWithName:@"YQReviseCase" bundle:nil];
     YQReviseCaseTableViewController * reviseCaseVC = [revise instantiateInitialViewController];
     
     //2.创建popover的控制器
     #pragma clang diagnostic push
     #pragma clang diagnostic ignored "-Wdeprecated-declarations"
     
     self.casePopover = [[UIPopoverController alloc]initWithContentViewController:reviseCaseVC];
     #pragma clang diagnostic pop
     
     CGFloat x = self.superview.superview.bounds.origin.x;
     CGFloat y = self.superview.superview.bounds.origin.y;
     CGRect rect = CGRectMake(x-350, y+230, 900, 600);
     
     //3.弹出present出来一个控制器
     [self.casePopover presentPopoverFromRect:rect inView:self.superview.superview permittedArrowDirections:UIPopoverArrowDirectionUnknown animated:YES];
     */
    //整体的 modal 出来一个控制器
    //添加蒙版,设置成为第一响应者
    UIView * baffleV = [[UIView alloc]initWithFrame:self.view.bounds];
    baffleV.backgroundColor = [UIColor grayColor];
    baffleV.alpha = 0.5;
    [self.view addSubview:baffleV];
    self.baffleView = baffleV;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(baffleViewDidClilck)];
    [self.baffleView addGestureRecognizer:tap];
    
    if(!self.BGVC){
        
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQBackGround" bundle:nil];
        self.BGVC = [sb instantiateInitialViewController];
    }
    
    [self.view addSubview:self.BGVC.view];
    self.BGVC.view.alpha = 0;
    self.BGVC.view.hidden = YES;
    self.BGVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
    
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        
        //        [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(baffleV.mas_top).offset(200);
        //            make.width.equalTo(baffleV.mas_bottom).offset(200);
        //        }];
        // self.rulerVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
        self.BGVC.view.alpha = 1;
        self.BGVC.view.hidden = NO;
        
    }];
    
}

- (IBAction)detailBtnClick:(id)sender {
    //停止用户的交互
    //self.view.userInteractionEnabled = NO;
    //添加蒙版,设置成为第一响应者
    UIView * baffleV = [[UIView alloc]initWithFrame:self.view.bounds];
    baffleV.backgroundColor = [UIColor grayColor];
    baffleV.alpha = 0.5;
    //BOOL ISTR = [baffleV isFirstResponder];//是否是 第一响应者的情况!
    //[baffleV becomeFirstResponder];//成为第一响应者
    //[baffleV resignFirstResponder];//取消第一响应者
    [self.view addSubview:baffleV];
    self.baffleView = baffleV;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(baffleViewDidClilck)];
    [self.baffleView addGestureRecognizer:tap];
    
    if(!self.detailVC){
    
        //然后再添加控制器来成为 baffleV的子视图!
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQDetail" bundle:nil];
        self.detailVC = [sb instantiateInitialViewController];
        
    }
    [self.view addSubview:self.detailVC.view];
//    [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(baffleV.mas_bottom);
//        make.left.equalTo(baffleV.mas_left).offset(30);
//        make.right.equalTo(baffleV.mas_right).offset(30);
//        make.width.equalTo(@400);
//    }];
    
    self.detailVC.view.alpha = 0;
    self.detailVC.view.hidden = YES;
    self.detailVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
    
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        
//        [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(baffleV.mas_top).offset(200);
//            make.width.equalTo(baffleV.mas_bottom).offset(200);
//        }];
//       self.detailVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
        self.detailVC.view.alpha = 1;
        self.detailVC.view.hidden = NO;

    }];
    
}

- (IBAction)taggingBtnClick:(id)sender {
    //整体的 modal 出来一个控制器
    //添加蒙版,设置成为第一响应者
    UIView * baffleV = [[UIView alloc]initWithFrame:self.view.bounds];
    baffleV.backgroundColor = [UIColor grayColor];
    baffleV.alpha = 0.5;
    //BOOL ISTR = [baffleV isFirstResponder];//是否是 第一响应者的情况!
    //[baffleV becomeFirstResponder];//成为第一响应者
    //[baffleV resignFirstResponder];//取消第一响应者
    [self.view addSubview:baffleV];
    self.baffleView = baffleV;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(baffleViewDidClilck)];
    [self.baffleView addGestureRecognizer:tap];
    if(!self.BGVC){
    
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQBackGround" bundle:nil];
        self.BGVC = [sb instantiateInitialViewController];
    }
    
    [self.view addSubview:self.BGVC.view];
    self.BGVC.view.alpha = 0;
    self.BGVC.view.hidden = YES;
    self.BGVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
    
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        
        //        [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(baffleV.mas_top).offset(200);
        //            make.width.equalTo(baffleV.mas_bottom).offset(200);
        //        }];
        // self.rulerVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
        self.BGVC.view.alpha = 1;
        self.BGVC.view.hidden = NO;
        
    }];
}

- (IBAction)graphicBtnClick:(id)sender {
    //整体的 modal 出来一个控制器
    //添加蒙版,设置成为第一响应者
    UIView * baffleV = [[UIView alloc]initWithFrame:self.view.bounds];
    baffleV.backgroundColor = [UIColor grayColor];
    baffleV.alpha = 0.5;
    [self.view addSubview:baffleV];
    self.baffleView = baffleV;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(baffleViewDidClilck)];
    [self.baffleView addGestureRecognizer:tap];
    
    if(!self.BGVC){
        
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQBackGround" bundle:nil];
        self.BGVC = [sb instantiateInitialViewController];
    }
    
    [self.view addSubview:self.BGVC.view];
    self.BGVC.view.alpha = 0;
    self.BGVC.view.hidden = YES;
    self.BGVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
    
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        
        //        [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(baffleV.mas_top).offset(200);
        //            make.width.equalTo(baffleV.mas_bottom).offset(200);
        //        }];
        // self.rulerVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
        self.BGVC.view.alpha = 1;
        self.BGVC.view.hidden = NO;
        
    }];

}

- (IBAction)saveBtnClick:(id)sender {
    
    /* alert 弹框的方法封装
     
     //通过alert的方式来进行的实现
     UIAlertController * save = [UIAlertController alertControllerWithTitle:@"保存" message:@"是否要保存" preferredStyle:UIAlertControllerStyleAlert];
     
     [save addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
     NSLog(@"点击取消");
     
     }]];
     
     
     [save addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
     NSLog(@"点击确认");
     
     }]];
     
     //    [alertController addAction:[UIAlertAction actionWithTitle:@"警告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
     //
     //        NSLog(@"点击警告");
     //
     //    }]];
     
     //    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
     //
     //        NSLog(@"添加一个textField就会调用 这个block");
     //
     //    }];
     
     
     // 由于它是一个控制器 直接modal出来就好了
     
     [self presentViewController:save animated:YES completion:nil];
     
     */
    //整体的 modal 出来一个控制器
    //添加蒙版,设置成为第一响应者
    UIView * baffleV = [[UIView alloc]initWithFrame:self.view.bounds];
    baffleV.backgroundColor = [UIColor grayColor];
    baffleV.alpha = 0.4;
    [self.view addSubview:baffleV];
    self.baffleView = baffleV;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(baffleViewDidClilck)];
    [self.baffleView addGestureRecognizer:tap];
    
    if(!self.saveFileVC){// 懒加载
        
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQSaveFile" bundle:nil];
        self.saveFileVC = [sb instantiateInitialViewController];

    }
    [self.view addSubview:self.saveFileVC.view];
    self.saveFileVC.view.alpha = 0;
    self.saveFileVC.view.hidden = YES;
    
    [self.saveFileVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-48);
        
        make.height.mas_equalTo(90);
        
    }];
    
    //添加动画
    [UIView animateWithDuration:0.25 animations:^{
        
        //        [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(baffleV.mas_top).offset(200);
        //            make.width.equalTo(baffleV.mas_bottom).offset(200);
        //        }];
        // self.rulerVC.view.frame = CGRectMake(0, heightSize/4, widthSize, 300);
        self.saveFileVC.view.alpha = 1;
        self.saveFileVC.view.hidden = NO;
        self.saveFileVC.currentGrounpImage = self.imageView.cacheArray[0];
        
    }];

    
}

#pragma mark - 移除弹框解锁方法
-(void)baffleViewDidClilck{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        //        [self.detailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(baffleV.mas_top).offset(200);
        //            make.width.equalTo(baffleV.mas_bottom).offset(200);
        //        }];
        
        self.detailVC.view.alpha = 0;
        self.detailVC.view.hidden = YES;
        self.rulerVC.view.alpha = 0;
        self.rulerVC.view.hidden = YES;
        self.BGVC.view.alpha = 0;
        self.BGVC.view.hidden = YES;
        self.saveFileVC.view.alpha = 0;
        self.saveFileVC.view.hidden = YES;
        
    }];
    
    [self.saveFileVC.view removeFromSuperview]; //要求有一定的保存
    [self.BGVC.view removeFromSuperview];
    [self.rulerVC.view removeFromSuperview];
    [self.detailVC.view removeFromSuperview];
    [self.baffleView removeFromSuperview];

}


#pragma mark --------封装代理方法中的复原------
-(void)bottomViewDetegateToOriginalPicture{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.imageView.transform = self.imageView.originalTransform;
    }];
    
}


#pragma mark --------封装代理方法中的回播------
-(void)bottomViewDetegateToPlayPictureFrom:(int)num{
    
    if (self.imageView.lastIndex == num) {
        return;
    }
    
    if (self.imageView.lastIndex < 0) {
        // 如果是 负数的话就要求的是 回转一圈
        self.imageView.lastIndex = self.imageView.lastIndex + pictureFrames;
    }
    
    NSMutableArray * array = [NSMutableArray array];
    //回到主视图的操作
    //停留的帧数 倒序 回放到 原始地方的逻辑的处理
    if( self.imageView.lastIndex < num){
        
        for (int i = self.imageView.lastIndex; i < num; i++) {
            
            [array addObject:self.imageView.cacheArray[i]];
        }
        
    }else{
        for (int i = self.imageView.lastIndex; i > num; i--) {
            
            [array addObject:self.imageView.cacheArray[i]];
        }
    }
    
    //  1.3把数组存入UIImageView中
    self.imageView.animationImages = array;
    
    //  fps  12
    self.imageView.animationDuration = ADuration * array.count * 10;
    
    //  1.5播放动画
    [self.imageView startAnimating];
    
    [self.imageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.imageView.animationDuration + 0.005 ];
    
    self.imageView.image = (UIImage *)self.imageView.cacheArray[num];
    
    //给组动画最后最后一张来赋值
    //内存优化!
    self.imageView.lastIndex = num;
    self.imageView.scaleStall = 1;
    
}


#pragma mark - YQGroupViewDelegate_alert的代理方法
-(void)imageGroupView:(YQImageGroupView *)groupView ViewWithWidthSize:(CGFloat)width{
    
    if (width > 1000) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最大了,已经最大了哟!" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil ];

        
    }else{
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"最小了,已经最小了哟!" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil ];

    }
    
}

#pragma mark - BarButtonClick的方法
-(void)rightBarButtonClicked:(UIButton *)bnt{//设置更多 按钮的点击



}

-(void)rightItem1BarButtonClicked:(UIButton *)bnt{//友盟分享
    
    //显示分享面板(调用的是 友盟系统的UI的界面)
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        [self shareWebPageToPlatformType:platformType ];
//        [self getAuthWithUserInfoFromDouban];
        
    }];
    
}

-(void)leftBarButtonClicked:(UIButton *)bnt{//zxing 的二维扫描
    
    QRCodeReaderViewController *reader = [QRCodeReaderViewController new];
    reader.modalPresentationStyle = UIModalPresentationFormSheet;
    reader.delegate = self;
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:reader];
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 友盟分享内容视图方法
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
//        [self alertWithError:error];
    }];
}

#pragma mark - 获取SSO_豆瓣的授权方法

- (void)getAuthWithUserInfoFromDouban
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Douban currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Douban uid: %@", resp.uid);
            NSLog(@"Douban accessToken: %@", resp.accessToken);
            NSLog(@"Douban expiration: %@", resp.expiration);
            
            // 第三方平台SDK源数据
            NSLog(@"Douban originalResponse: %@", resp.originalResponse);
        }
    }];
}


#pragma mark - scanResult的代理方法
#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{// 最后的扫描的结果是 得到是resulut的url 进行的函数的回调
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"QRCodeReader" message:result preferredStyle:UIAlertControllerStyleAlert];
        // 解决扫码弹出 不消毁的方法
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }];
}


- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - 接受所有的通知方法
-(void)abserverAllNoties{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundPictureChange:) name:YQbackGroundChange object:nil];
    [YQNoteCenter addObserver:self selector:@selector(baffleViewDidClilck) name:YQCollocationRoomChildViewClose object:nil];
    [YQNoteCenter addObserver:self selector:@selector(AddAlbum) name:YQAddAlbumSelectImageNotification object:nil];
    [YQNoteCenter addObserver:self selector:@selector(AddCamera) name:YQAddCameraNotification object:nil];
    
}

#pragma mark - 实现通知的方法
-(void)backgroundPictureChange:(NSNotification *)noties{

    NSString * pictureName = noties.userInfo[YQpictureName];
    self.backgroundImageView.image = [UIImage imageNamed:pictureName];
    
    //dismiss
    [self baffleViewDidClilck];
}

-(void)AddAlbum{
    
//    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    if(_imagePickerController == nil){
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = YES;
        
    }
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
}

-(void)AddCamera{
    
    BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    
    if (!iscamera) {
        NSLog(@"没有摄像头");
        return ;
    }
    if(_imagePickerController == nil){
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = YES;
        
    }
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_imagePickerController animated:YES completion:^{
        
        // 判断是否有后置摄像头
        //        UIImagePickerControllerCameraDeviceFront ,为前置摄像头
        
        //        imagePick.allowsEditing = YES; //拍完照可以进行编辑
//        这个是设置 视频流的 保存的
//        imagePick.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
        
    }];
    
}

#pragma mark --UIImagePickerController Delegate
// 相册图片选中后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    NSLog(@"%@", info);// 打印出相应的key信息,注意的是 可以将key 和 valuy 进行的保存来获取照片的相应的点击的顺序!
//    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
    
        UIImage *image = [info objectForKey: UIImagePickerControllerEditedImage];
        //    UIImagePickerControllerEditedImage  拍完照后可以进行编辑
        self.backgroundImageView.image = image;
        
//    }else{
//        
//        UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
//        //    UIImagePickerControllerEditedImage  拍完照后可以进行编辑
//        self.backgroundImageView.image = image;
//    
//    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

// 取消按钮的点击事件
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - controller_dealloc的方法

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];

}



@end
