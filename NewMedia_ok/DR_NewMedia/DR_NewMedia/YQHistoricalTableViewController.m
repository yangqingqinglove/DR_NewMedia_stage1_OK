//
//  YQHistoricalTableViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/12.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQHistoricalTableViewController.h"

@interface YQHistoricalTableViewController ()

@end

static NSString * ID = @"cell";

@implementation YQHistoricalTableViewController

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


@end
