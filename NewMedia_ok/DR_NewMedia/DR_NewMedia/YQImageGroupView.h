//
//  YQImageGroupView.h
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/25.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQImageGroupView;

@protocol YQImageGroupViewDelegate <NSObject>

-(void)imageGroupView:(YQImageGroupView *)groupView ViewWithWidthSize:(CGFloat)width;

@end

@interface YQImageGroupView : UIImageView

//停留的原帧数
@property(nonatomic,assign)int lastIndex;

//记录原始的transform;
@property(nonatomic,assign)CGAffineTransform  originalTransform;

//定义的是图片的缓存池
@property(nonatomic,strong)NSMutableArray * cacheArray;

//定制的缩放的档位
@property(nonatomic,assign)CGFloat scaleStall;

/*
 组合视图的up down的图片记录
 */
@property(nonatomic,copy)NSString * currentUpImageName;
@property(nonatomic,copy)NSString * currentDownImageName;

@property(nonatomic,weak)id<YQImageGroupViewDelegate> delegate;



/// 外界调用的合成的image
- (UIImage *)addImagePath:(NSString *)imagePath1 withImage:(NSString *)imagePath2;


@end
