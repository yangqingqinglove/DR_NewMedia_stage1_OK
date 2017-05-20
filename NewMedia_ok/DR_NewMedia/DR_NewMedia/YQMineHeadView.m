//
//  YQMineHeadView.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/8.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQMineHeadView.h"

@interface YQMineHeadView ()



@end

@implementation YQMineHeadView

+(instancetype)initMineHeadView{

    return [[NSBundle mainBundle]loadNibNamed:@"YQMineHead" owner:nil options:nil].lastObject;

}



@end
