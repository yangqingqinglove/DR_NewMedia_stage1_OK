//
//  YQConcerFirstTableViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/9.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQConcerFirstTableViewController.h"
#import "YQConcernViewController.h"


@interface YQConcerFirstTableViewController ()

@end

static NSString * ID = @"detailCell";

@implementation YQConcerFirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.textLabel.text = self.title;
    
    return cell;
}

#pragma mark - tabelView的代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //弹出详情控制器
    [YQNoteCenter postNotificationName:YQContentTabelViewClicked object:nil userInfo:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

@end
