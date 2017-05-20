//
//  YQSystemSettingTableViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/11.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQSystemSettingTableViewController.h"

@interface YQSystemSettingTableViewController ()

@end

@implementation YQSystemSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统设置";

}

#pragma mark - tableView的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        switch (indexPath.row) {
            case 0:{//编辑资料
                
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQEditProfile" bundle:nil];
                UIViewController * vc = [sb instantiateInitialViewController];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            case 1:{//密码修改
                
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQModifyPassword" bundle:nil];
                UIViewController * vc = [sb instantiateInitialViewController];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            case 2:{//手机绑定
                
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQPhoneBinding" bundle:nil];
                UIViewController * vc = [sb instantiateInitialViewController];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            case 3:{//证件绑定
                
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQDocumentBinding" bundle:nil];
                UIViewController * vc = [sb instantiateInitialViewController];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            case 4:{//帐号绑定
                
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQAccountBinding" bundle:nil];
                UIViewController * vc = [sb instantiateInitialViewController];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:{//接受通知
                
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"YQAcceptNotice" bundle:nil];
                UIViewController * vc = [sb instantiateInitialViewController];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
                
            default:
                break;
        }
        
    }
}



@end
