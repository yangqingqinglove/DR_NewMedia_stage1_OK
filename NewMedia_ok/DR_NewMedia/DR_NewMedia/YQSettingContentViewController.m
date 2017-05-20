//
//  YQSettingContentViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/19.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQSettingContentViewController.h"

@interface YQSettingContentViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickName;

@property (weak, nonatomic) IBOutlet UITextField *logPassWord;


@end

@implementation YQSettingContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)nextSettingOK:(id)sender {
    
//    NSAssert(self.logPassWord.text.length >0, @"self.logPassWord为nil");
//    NSAssert(self.nickName.text.length > 0, @"self.nickName为nil");
    
    if (self.logPassWord.text.length >0 && self.nickName.text.length > 0) {
        //保存偏好
        [[NSUserDefaults standardUserDefaults]setObject:self.logPassWord forKey:UserPassWordSave];
        [[NSUserDefaults standardUserDefaults]setObject:self.nickName forKey:UserNickName];
        
        // 首次登录
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsFirstLogin];
        
    }
}

- (IBAction)closeVC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
