//
//  YQLoginViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/17.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQLoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "YQRegisterViewController.h"
#import "YQLookupPassWordViewController.h"

@interface YQLoginViewController ()




@end

@implementation YQLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];




}

#pragma mark - LoginButton点击的方法
- (IBAction)registerButtonClicked:(id)sender {
    //创建sb 进行的弹窗展示
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQRegsiter" bundle:nil];
    UIViewController * vc = [sb instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (IBAction)lookUpPassWord:(id)sender {
    //创建sb 进行的弹窗展示
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQlookupPW" bundle:nil];
    UIViewController * vc = [sb instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)closeVC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)loginButtonClick:(id)sender {//非首次登录的情况
    
    
}

#pragma mark - sso授权登录的方法
- (IBAction)SSOChatWei:(id)sender {
    
    [self getAuthWithUserInfoFromWechat];
}

- (IBAction)SSOSina:(id)sender {
    
    [self getAuthWithUserInfoFromSina];
}

- (IBAction)SSO_QQ:(id)sender {
    
    [self getAuthWithUserInfoFromQQ];
}



#pragma mark - 微博的第三方登录方法
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];
}


#pragma mark - 获取新浪的sso 授权用户名和昵称
- (void)getAuthWithUserInfoFromSina
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            //授权除错了
            [self AuthFormError];
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            
            [self AuthFormSuccess:resp];
        }
    }];
}

#pragma mark - 获取QQ的sso 授权用户名和昵称
- (void)getAuthWithUserInfoFromQQ
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            //授权除错了
            [self AuthFormError];
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            
            [self AuthFormSuccess:resp];

        }
    }];
}

#pragma mark - 获取微信的sso 授权用户名和昵称
- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            //授权除错了
            [self AuthFormError];
        } else {
            
            UMSocialUserInfoResponse *resp = result;
    
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
            //回调
            [self AuthFormSuccess:resp];
        }
    }];
}

#pragma mark - 授权成功的回调用户信息
-(void)AuthFormSuccess:(UMSocialUserInfoResponse *)result{//保存偏好,通知Tabbar更新
    //保存偏好
    [[NSUserDefaults standardUserDefaults]setObject:result.accessToken forKey:UserPassWordSave];
    [[NSUserDefaults standardUserDefaults]setObject:result.name forKey:UserNickName];
    [[NSUserDefaults standardUserDefaults]setObject:result.iconurl forKey:UserIconurl];
    
    // 首次登录
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsFirstLogin];

}


#pragma mark - 授权失败error方法
-(void)AuthFormError{//网络原因,授权失败
    
    UIAlertController * lertVC = [UIAlertController alertControllerWithTitle:@"授权出错了" message:@"请检查网络状态后,重试!" preferredStyle:UIAlertControllerStyleAlert];
    [lertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:lertVC animated:YES completion:nil];
    

}


@end
