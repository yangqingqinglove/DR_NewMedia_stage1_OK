//
//  YQSaveFileViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/5/5.
//  Copyright © 2017年 YQ. All rights reserved.
//

#import "YQSaveFileViewController.h"
#import "YQSaveFileCell.h"
#import "YQBackGroundCollectionCell.h"
#import "YQLongPressGestureRecognizer.h"

@interface YQSaveFileViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *YQFileCollectionView;

/// data数组
@property(nonatomic,strong)NSMutableArray * saveFileArray;



@end

static NSString * ID = @"fileCell";

@implementation YQSaveFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.自定义布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5;
    layout.headerReferenceSize = CGSizeMake(5, 0);
    //设置的是 item的宽度是 45
    layout.itemSize = CGSizeMake(50, self.YQFileCollectionView.height);
    
    self.YQFileCollectionView.collectionViewLayout = layout;
    
    //2.注册原型cell
    UINib * cellNib = [UINib nibWithNibName:@"SaveFileCell" bundle:nil];
    [self.YQFileCollectionView registerNib:cellNib forCellWithReuseIdentifier:ID];

    
}

#pragma mark - 懒加载数据方法
-(NSMutableArray *)saveFileArray{
    if(!_saveFileArray){
        
        _saveFileArray = [NSMutableArray array];
        NSString * string1 = nil;
        
        for(int i =1;i< 15 ;i++){
            
            if(i < 3 || i==4){
                string1  = [NSString stringWithFormat:@"搭配%d.png",i];
            }else{
            
                string1  = [NSString stringWithFormat:@"add.png"];
            }
            
            UIImage * image = [UIImage imageNamed:string1];
            //  将图片加入数组
            [_saveFileArray addObject:image];
        }
    }
    return _saveFileArray;
}


#pragma mark - CollectionView数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.saveFileArray.count;
}


-(UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YQSaveFileCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:60/255.0 alpha:0.4];
    //cell.imagename  = self.imagesArray[indexPath.row];
    //if(indexPath.row < self.collocationArray.count){
    
    // NSString * path1 = [[NSBundle mainBundle] pathForResource:self.BGArray[indexPath.item] ofType:nil];
    cell.saveImageView.image = self.saveFileArray[indexPath.item];
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"MM/dd"];
    NSString *strDate = [dataFormatter stringFromDate:[NSDate date]];
    
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [componets weekday];//a就是星期几，1代表星期日，2代表星期一，后面依次
    NSArray *weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSString *weekStr = weekArray[weekday-1];
    
    cell.dateLabel.text = weekStr;
    cell.timeLabel.text = strDate;
    
    YQLongPressGestureRecognizer * longPress = [[YQLongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.0;
    longPress.delegate = self;
    longPress.tag = indexPath.item;
//    NSLog(@"view.tag==%ld",longPress.tag);
    
    [cell addGestureRecognizer:longPress];
    
    //}
    return cell;
}


#pragma mark - CollectionView的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSAssert(self.currentGrounpImage != nil, @"self.currentGrounpImage必须有值");
    
    //点击的是 item,将对应的图片传给控制 通知!
    //点击的是 当前的item来通过的 图片的替换的功能
    [self.saveFileArray replaceObjectAtIndex:indexPath.item withObject:self.currentGrounpImage];
    
    NSArray * array = @[indexPath];
    [collectionView reloadItemsAtIndexPaths:array];
    
    
}

#pragma mark - longPress触发的方法
-(void)handleLongPress:(YQLongPressGestureRecognizer *)longpress{
    //处理长按的手势时,系统会进行的调用的两次
    if(longpress.state == UIGestureRecognizerStateBegan){
        //弹框处理
        UIAlertController * alertV =[UIAlertController alertControllerWithTitle:@"删除" message:@"是否要删除图片" preferredStyle:UIAlertControllerStyleAlert];
        [alertV addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertV dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        [alertV addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.saveFileArray removeObjectAtIndex:longpress.tag];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:longpress.tag inSection:0];
//            NSLog(@"longpress.view.tag==%ld",longpress.tag);
            
            NSArray * deleteItem = @[indexPath];
            [self.YQFileCollectionView deleteItemsAtIndexPaths:deleteItem];
            
        }]];
        
        [self presentViewController:alertV animated:YES completion:^{
            
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"add.png"]];
            [self.saveFileArray addObject:image];
            NSIndexPath * indexPath1 = [NSIndexPath indexPathForRow:self.saveFileArray.count -1 inSection:0];
            NSArray * addItem = @[indexPath1];
            [self.YQFileCollectionView insertItemsAtIndexPaths:addItem];
            
        }];
    }
}


-(void)dealloc{


}

@end
