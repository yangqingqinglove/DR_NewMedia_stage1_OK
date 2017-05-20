//
//  YQBottomView.h
//  底部滚动动画实现
//
//  Created by neuracle on 16/5/4.
//  Copyright © 2016年 neuracle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YQBottomView;

@protocol YQBottomViewClickDeleage <NSObject>

//创建的方法
-(void)bottomView:(YQBottomView *)bottomV didSelectedButtonFrom:(NSUInteger) from to:(int)To ;

@end

@interface YQBottomView : UIView

//提供创建的 类方法
+(instancetype)buttonMenu;

//创建代理
@property(nonatomic,weak)id<YQBottomViewClickDeleage>  deleage;




@end
