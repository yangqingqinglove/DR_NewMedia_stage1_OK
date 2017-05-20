//
//  YQFeedbackTableViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/12.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQFeedbackTableViewController.h"

@interface YQFeedbackTableViewController ()

@end
static NSString * ID = @"cell";

@implementation YQFeedbackTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册原型cell
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


@end
