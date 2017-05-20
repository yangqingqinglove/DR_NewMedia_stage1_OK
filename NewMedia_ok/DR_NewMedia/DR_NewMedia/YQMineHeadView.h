//
//  YQMineHeadView.h
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/8.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQMineHeadView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *jobTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *followLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansLabel;

@property (weak, nonatomic) IBOutlet UILabel *visitorLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;

+(instancetype)initMineHeadView;

@end
