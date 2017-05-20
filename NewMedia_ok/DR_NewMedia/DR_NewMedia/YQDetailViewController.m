//
//  YQDetailViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/21.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQDetailViewController.h"

@interface YQDetailViewController ()

@end

@implementation YQDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (IBAction)closeViewClicked:(id)sender {
    //发送通知给 主view
    [YQNoteCenter postNotificationName:YQCollocationRoomChildViewClose object:nil];
    
    
}



@end
