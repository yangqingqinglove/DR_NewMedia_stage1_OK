//
//  YQHeadTitleView.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/3.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQHeadTitleView.h"

@interface YQHeadTitleView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *englishTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loveImage;
@property (weak, nonatomic) IBOutlet UILabel *loveNums;


@end

@implementation YQHeadTitleView

#pragma mark --------init------
+(instancetype)headTitleInit{

    return [[NSBundle mainBundle]loadNibNamed:@"YQHeadTitle" owner:nil options:nil].lastObject;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
    
        
    
    }
    return self;

}

@end
