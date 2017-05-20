//
//  YQCycleView.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/18.
//  Copyright © 2017年 YQ. All rights reserved.
//

//  应用初始化图片 轮播的情况!

#import "YQCycleView.h"

@interface YQCycleView ()<SDCycleScrollViewDelegate>


@end

@implementation YQCycleView

/*
 =========== 本地图片的加载 ==========
 NSArray *imageNames = @[@"h1.jpg",
 @"h2.jpg",
 @"h3.jpg",
 @"h4.jpg",
 @"h7" // 本地图片请填写全名
 ];
 
 ============ 网络URL的请求加载 ========
 NSArray *imagesURLStrings = @[
 @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
 @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
 @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
 ];
 
 
 ============ 本地titile的加载 ========
 NSArray *titles = @[@"新建交流QQ群：185534916 ",
 @"感谢您的支持，如果下载的",
 @"如果代码在使用过程中出现问题",
 @"您可以发邮件到gsdios@126.com"
 ];
 
 */

#pragma mark --------初始化创建的方法------
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        NSArray *imageNames = @[@"01.jpg",
                                @"02.jpg",
                                @"03.jpg",
                                @"04.jpg",
                                @"05.jpg" // 本地图片请填写全名
                                ];
        
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView2.localizationImageNamesGroup = imageNames;
        
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        [self addSubview:cycleScrollView2];
        
    
    }
    
    return self;
}


@end
