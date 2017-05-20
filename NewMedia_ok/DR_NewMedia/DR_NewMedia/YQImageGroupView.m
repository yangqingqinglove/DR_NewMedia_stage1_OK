//
//  YQImageGroupView.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/25.
//  Copyright © 2017年 YQ. All rights reserved.
//

#define X_Var 10
#define ADuration 0.01
#define pictureFrames 36
#define pictureName1 @"ku170427_30000036"
#define pictureName2 @"yi170427_40000036"

#define buttonSize 45
#define widthSize [UIScreen mainScreen].bounds.size.width
#define heightSize [UIScreen mainScreen].bounds.size.height

#define pictureWidthSize 315
#define pictureHeightSize 560

#import "YQImageGroupView.h"

@interface YQImageGroupView ()<UIGestureRecognizerDelegate>

//记录起始点的位置point
@property(nonatomic,assign)CGPoint firstPoint;

//记录索引
@property(nonatomic,assign)int newIndex;

//定圆心的index
@property(nonatomic,assign)int firstTouchLock;

//TempSwipeMovePoint
@property(nonatomic,assign)CGPoint swipeMovePoint;

//tempTouchMove
@property(nonatomic,assign)CGFloat touchMoveX;
@property(nonatomic,assign)CGFloat touchMoveY;

//定制scaling 档位
@property(nonatomic,assign)CGFloat  stall;

@end

@implementation YQImageGroupView

#pragma mark - 初始化方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
    
        //1.设置
        self.userInteractionEnabled = YES;
        //属性记录
        self.currentUpImageName = [NSString stringWithFormat:@"%@_%02d.png",pictureName2,0];
        
        self.currentDownImageName = [NSString stringWithFormat:@"%@_%02d.png",pictureName1,0];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            //2.加载图片
            for(int i =0;i<pictureFrames ;i++){
                
                NSString * string1 = [NSString stringWithFormat:@"%@_%02d.png",pictureName1,i*10];
                NSString * path1 = [[NSBundle mainBundle] pathForResource:string1 ofType:nil];
                
                NSString * string2 = [NSString stringWithFormat:@"%@_%02d.png",pictureName2,i*10];
                NSString * path2 = [[NSBundle mainBundle] pathForResource:string2 ofType:nil];
                
                //  生成图片
                UIImage *image = [self addImagePath:path1 withImage:path2];
                
                //  将图片加入数组
                [self.cacheArray addObject:image];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //3.添加缓存
                self.image = self.cacheArray[0];
                
            });
            
        });
        
        //4.1添加的是捏合的放大的手势
        UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(addPinchFunction:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
        
        //4.2添加拖拽的手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(addPanFunction:)];
        pan.delegate = self;
        pan.minimumNumberOfTouches = 2;
        [self addGestureRecognizer:pan];
        
        //5.设定档位
        self.stall = 1.0;
        self.scaleStall = self.stall;
        
        //6.记录原始位置
        self.originalTransform = self.transform;
        
    }
    return self;

}

#pragma mark --------懒加载数据------
-(NSMutableArray *)cacheArray{
    
    if(!_cacheArray){
        _cacheArray = [NSMutableArray array];
    }
    return _cacheArray;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //注意的是:这里的事件传递和 产生 都是imageView 上的手指的移动的效果! 自己接受事件 自己来处理!
    //得到的是:记录开始点的第一个坐标点!
    UITouch * touch = [touches anyObject];
    CGPoint pointBegan = [touch locationInView:self];
    
    self.firstPoint = pointBegan;
    self.firstTouchLock = 1;
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    UITouch * touch = [touches anyObject];
    self.swipeMovePoint  = [touch locationInView:self];
    
    if(self.animating ){
        
        return;
    }
    
    /*
     1.每移动的是20个像素点来旋转一次动画的效果
     */
    int tempMoveX = (self.swipeMovePoint.x - self.firstPoint.x) * self.scaleStall;
    
    int index = tempMoveX / (X_Var );
    //#warning TODO; 每次的旋转的index相同 导致的图片的跳帧的情况比较明显! bug成功解决
    if (index >= pictureFrames) {
        
        index = pictureFrames - 1;
    }else if(index <= -pictureFrames){
        
        index = -(pictureFrames -1);
    }
    
    
    if(self.lastIndex +index >= pictureFrames){
        
        //重新归零
        self.lastIndex = 0;
        
    }else if (self.lastIndex+ index < 0){
        
        self.lastIndex = pictureFrames - 1;
    }
    
    if(self.newIndex == index){
        //避免的是,重复的加载的闪帧
        return;
    }
    
    if (ABS(tempMoveX) % X_Var ) {
        
        self.newIndex = index;
        //NSLog(@"index = %d",index);
        
        NSMutableArray * array = [NSMutableArray array];
        
        if (index < 0) {
            
            for (int i = 0; i<= ABS(index); i++) {
                
                //  生成图片名
                //  内存优化! (重点!!!)
                //  将图片加入数组,从缓存数组中的下标来取值!
                [array arrayByAddingObject:self.cacheArray[(self.lastIndex - i)]];
            }
            
        }else{
            
            for (int i = 0; i<= index; i++) {
                
                //  生成图片名
                //  内存优化! (重点!!!)
                //  将图片加入数组
                if ((self.lastIndex + i) < 0) {
                    
                    [array arrayByAddingObject:self.cacheArray[pictureFrames +(self.lastIndex + i)]];
                    
                }else if((self.lastIndex + i) >= pictureFrames){
                    
                    [array arrayByAddingObject:self.cacheArray[(self.lastIndex + i) - pictureFrames]];
                    
                }else{
                    
                    [array arrayByAddingObject:self.cacheArray[(self.lastIndex + i)]];
                }
            }
        }
        
        //  1.3把数组存入UIImageView中
        self.animationImages = array;
        
        //  fps  12
        self.animationDuration = ADuration;
        
        //  1.5播放动画
        [self startAnimating];
        
        [self performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.animationDuration + 0.005];
        
        //给组动画最后最后一张来赋值
        //内存优化!
        self.image = self.cacheArray[index + self.lastIndex];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //得到的是最后停止的点的坐标
    UITouch * touch = [touches anyObject];
    CGPoint pointBegan = [touch locationInView:self];
    
    //NSLog(@"%f=== %f",pointBegan.x, pointBegan.y);
    
    int tempMoveX = pointBegan.x - self.firstPoint.x;
    int index = tempMoveX / X_Var;
    
    //赋值更新
    self.lastIndex += index;
    self.firstPoint = pointBegan;
    
    if(self.lastIndex >= pictureFrames){//解决逻辑bug
        self.lastIndex =0;
    }
}



#pragma mark --------pan添加手势方法------
-(void)addPanFunction:(UIPanGestureRecognizer*)pan{
    
    if(self.animating){
        return;
    }
    
    if(self.frame.origin.x <= (-widthSize* 1) ){
        
        //self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, widthSize/2,  0);
        return;
    }
    if (self.frame.origin.x >= (1 * widthSize)) {
        
        //self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, -widthSize/2,  0);
        return;
    }
    if (self.frame.origin.y <= (-heightSize* 1) ) {
        //self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, 0,  heightSize/2);
        return;
        
    }
    if(self.frame.origin.y >= (1 * heightSize)){
        
        //self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, 0,  -heightSize/2);
        return;
    }
    
    CGPoint translateP = [pan translationInView:self];
    //NSLog(@" x=%f; ==> y=%f  ",self.imageView.frame.origin.x,self.imageView.frame.origin.y);
    
    self.transform = CGAffineTransformTranslate(self.transform, translateP.x, translateP.y);
    [pan setTranslation:CGPointZero inView:self];
    
}

#pragma mark --------pinch捏合的添加方法------
-(void)addPinchFunction:(UIPinchGestureRecognizer *)pinch{
    
    //NSLog(@"scale == %f",pinch.scale);
    //注意的是: 这里的pinch.scale的 比例是用户的手指移动的位置! 也可以是说,手指移动的幅度
    if(self.animating){
        
        return;
    }
    
    CGPoint tempPoint = [pinch locationInView:self];
    //    self.touchMoveY = (tempPoint.y - self.firstPoint.y);
    //    self.touchMoveX = (tempPoint.x - self.firstPoint.x);
    
    if (pinch.scale >1 && pinch.scale <1.3) { //放大的操作
        
        //注意的是: 这里的pinch 在
        if (self.frame.size.width > 1000) {//上限
            //提示用户! 已经是最大了! 代理要求,alert
            if ([self.delegate respondsToSelector:@selector(imageGroupView:ViewWithWidthSize:)]) {
                
                [self.delegate imageGroupView:self ViewWithWidthSize:self.frame.size.width];
            }
            
            return;
        }
        
        if (self.firstTouchLock) {
            
            //每次的计算的 中心点的 相距距离!
            self.touchMoveX = (tempPoint.x - self.firstPoint.x);
            self.touchMoveY = (tempPoint.y - self.firstPoint.y);
            self.firstTouchLock = 0;
            
        }
        
        [UIView animateWithDuration:0.05 animations:^{
            
            CGAffineTransform transform = CGAffineTransformMake(1, 00,00,1, self.touchMoveX, self.touchMoveY);
            self.transform = CGAffineTransformScale(transform,self.stall,self.stall);
            
        }completion:^(BOOL finished) {
            
            self.stall += 0.01;//档位的渐变和累加的过程! 注意的是: 要求的避免的是 档位的突变的情况!
            self.scaleStall = self.stall;
        }];
        
    }else if(pinch.velocity < 0){
        
        //缩小到最小 之后就要求的 还原!
        self.scaleStall -= 0.01;
        self.stall = 1;
        
        if (self.frame.size.width <= 300) {//下限
            
            //提示用户! 已经是最小了! 代理要求控制器来alert
            if ([self.delegate respondsToSelector:@selector(imageGroupView:ViewWithWidthSize:)]) {
                
                [self.delegate imageGroupView:self ViewWithWidthSize:self.frame.size.width];
            }
            
            return;
        }
        self.transform = CGAffineTransformScale(self.transform, pinch.scale, pinch.scale);
        
    }
    
    if(self.scaleStall < 1){
        self.scaleStall = 1;
    }
    //每次都是在1 的基础上来进行的判断和缩放的!
    pinch.scale = 1;
    
}


#pragma mark - gestureDelage的代理方法
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    
    return NO;
}

#pragma mark --------添加合成图片的重要的方法------
- (UIImage *)addImagePath:(NSString *)imagePath1 withImage:(NSString *)imagePath2 {
    
    UIImage *image1 = [UIImage imageWithContentsOfFile:imagePath1];
    UIImage *image2 = [UIImage imageWithContentsOfFile:imagePath2];
    
    CGRect nowRect = CGRectMake(0, 0, pictureWidthSize, pictureHeightSize);
    //UIGraphicsBeginImageContext(image1.size);
    UIGraphicsBeginImageContextWithOptions(nowRect.size, NO, 0.0);
    
    /*
     注意的是: 这个两个的图片合成的位置,设定的情况有待分析解决!两张图片的大小和位置是可以来进行 单独合成的!
     */
    [image1 drawInRect:CGRectMake(0, 0, pictureWidthSize, pictureHeightSize)];
    [image2 drawInRect:CGRectMake(0, 0, pictureWidthSize, pictureHeightSize)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

@end
