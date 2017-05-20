//
//  YQTopView.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/20.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQTopView.h"

@implementation YQTopView

+(instancetype)buttonMenu{
    
    //加载xib
     return [[[NSBundle mainBundle]loadNibNamed:@"YQTopView" owner:nil options:nil] lastObject];
}

- (IBAction)shareButtonClick:(UIButton *)sender {
    //调用 友盟的分享的平台
    if([self.deleage respondsToSelector:@selector(topView:buttonDidSelectTag:)]){
        
        [self.deleage topView:self buttonDidSelectTag:sender.tag];
        
    }
}

- (IBAction)collectButtonClick:(UIButton *)sender {
    
    //self.backgroundColor = [UIColor grayColor];
    //执行的 frame的穿索加载!  就是一个show 和 UnShow的展示
    if([self.deleage respondsToSelector:@selector(topView:buttonDidSelectTag:)]){
    
        [self.deleage topView:self buttonDidSelectTag:sender.tag];
    
    }
    
    
    
}



@end
