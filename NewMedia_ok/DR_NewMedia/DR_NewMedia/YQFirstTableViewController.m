//
//  YQFirstTableViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/18.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQFirstTableViewController.h"

@interface YQFirstTableViewController ()

@end

static NSString * cellID = @"cell";

@implementation YQFirstTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //注册原型cell的情况
    //没有storyboard的情况下来进行的实现!
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.title];
    cell.detailTextLabel.text = @"----详情界面的展示啦....";
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [YQNoteCenter postNotificationName:YQHomeContentTabelViewClicked object:nil userInfo:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
