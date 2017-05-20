//
//  YQBackGroundViewController.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/23.
//  Copyright © 2017年 YQ. All rights reserved.
//

#define widthSize [UIScreen mainScreen].bounds.size.width
#define heightSize [UIScreen mainScreen].bounds.size.height

#import "YQBackGroundViewController.h"
#import "YQBackGroundCollectionCell.h"


@interface YQBackGroundViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *YQBGCollectionView;

/// 模型数据
@property(nonatomic,strong)NSMutableArray * BGArray;

/// 相机类
@property(nonatomic,strong)UIImagePickerController * imagePicker;



@end

static NSString * ID = @"bgCell";

@implementation YQBackGroundViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //1.自定义布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    layout.headerReferenceSize = CGSizeMake(5, 0);
    
    layout.itemSize = CGSizeMake(self.YQBGCollectionView.width /2, self.YQBGCollectionView.height);

    self.YQBGCollectionView.collectionViewLayout = layout;
    
    //2.注册原型cell
    UINib * cellNib = [UINib nibWithNibName:@"YQBackGroundCell" bundle:nil];
    [self.YQBGCollectionView registerNib:cellNib forCellWithReuseIdentifier:ID];
    
    //3.设置背景
    self.view.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:0.5];
    
}

#pragma mark - 懒加载数据方法
-(NSMutableArray *)BGArray{
    if(!_BGArray){
    
        _BGArray = [NSMutableArray array];
        
        for(int i =1;i< 15 ;i++){
            
            NSString * string1 = [NSString stringWithFormat:@"backdrop_00%02d.jpg",i ];
            
            //  将图片加入数组
            [_BGArray addObject:string1];
        }
    }

    return _BGArray;
}


#pragma mark - CollectionView数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.BGArray.count;
}


-(UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YQBackGroundCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
//    cell.backgroundColor = [UIColor redColor];
    //cell.imagename  = self.imagesArray[indexPath.row];
    //if(indexPath.row < self.collocationArray.count){
    
//    NSString * path1 = [[NSBundle mainBundle] pathForResource:self.BGArray[indexPath.item] ofType:nil];
    cell.backImageView.image = [UIImage imageNamed:self.BGArray[indexPath.item]];
    
    //}
    
    return cell;
}



#pragma mark - CollectionView的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //点击的是 item,将对应的图片传给控制 通知!
    [[NSNotificationCenter defaultCenter]postNotificationName:YQbackGroundChange object:nil userInfo:@{YQpictureName:self.BGArray[indexPath.item]}];


}

#pragma mark - buttonClick的方法

- (IBAction)CameraMake:(UIButton *)sender {//调用摄像头
    
    [YQNoteCenter postNotificationName:YQAddCameraNotification object:nil];
    
}

- (IBAction)pictureMake:(UIButton *)sender {//获取相册的功能
    
    [YQNoteCenter postNotificationName:YQAddAlbumSelectImageNotification object:nil];

}

- (IBAction)closeButtonClick:(UIButton *)sender {//关闭退出界面
    
    [YQNoteCenter postNotificationName:YQCollocationRoomChildViewClose object:nil];
}


@end
