//
//  YQStaticTableViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/8.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQStaticTableViewController.h"

@interface YQStaticTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *historyLable;
@property (weak, nonatomic) IBOutlet UILabel *messageLable;
@property (weak, nonatomic) IBOutlet UILabel *opinionLable;

@property (weak, nonatomic) IBOutlet UILabel *systemLable;


@end

@implementation YQStaticTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

#pragma mark - tabelView的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        switch (indexPath.row) {
            case 0:{//历史足迹的通知
                
                [YQNoteCenter postNotificationName:YQPushChildsViewController object:nil userInfo:@{YQPushChlidsVCTitileKey:@"YQHistoricalFootprint"}];
                break;
            }
                
            case 1:{//消息通知
                
                 [YQNoteCenter postNotificationName:YQPushChildsViewController object:nil userInfo:@{YQPushChlidsVCTitileKey:@"YQRecordMessage"}];
                break;
            }
                
            default:
                break;
        }
    
    }else if (indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:{//意见反馈的通知
                [YQNoteCenter postNotificationName:YQPushChildsViewController object:nil userInfo:@{YQPushChlidsVCTitileKey:@"YQFeedback"}];
                
                break;
            }
                
            case 1:{//发送系统设置的通知
                [YQNoteCenter postNotificationName:YQPushChildsViewController object:nil userInfo:@{YQPushChlidsVCTitileKey:@"YQSystemSetting"}];
                
                break;
            }
                
            default:
                break;
        }

    }else{//退出当前的帐号的功能---> 要求的弹出的是登录的界面
    
    
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


@end
