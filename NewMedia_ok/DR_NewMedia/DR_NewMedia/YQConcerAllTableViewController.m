//
//  YQConcerAllTableViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/8.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQConcerAllTableViewController.h"

@interface YQConcerAllTableViewController ()


@end

static NSString * cellID = @"cell";

@implementation YQConcerAllTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.title];
    cell.detailTextLabel.text =[NSString stringWithFormat: @"----%@界面的展示啦....",self.title] ;
    
    return cell;
    
}

@end
