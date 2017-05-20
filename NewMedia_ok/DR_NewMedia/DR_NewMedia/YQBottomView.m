//
//  YQBottomView.m
//  底部滚动动画实现
//
//  Created by neuracle on 16/5/4.
//  Copyright © 2016年 neuracle. All rights reserved.
//
#define delta 45;

#import "YQBottomView.h"
@interface YQBottomView()

@property(nonatomic,strong) NSMutableArray * item;

@property (weak, nonatomic) IBOutlet UIButton *mainBtn;

@end

@implementation YQBottomView

#pragma mark --------视图的创建------
+(instancetype)buttonMenu{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"bottomView" owner:nil options:nil] lastObject];
}

#pragma mark --------懒加载创建------
-(NSMutableArray *)item{
    if(_item == nil){
        
        _item = [NSMutableArray array];
    }
    return _item;
}

#pragma mark - 注意的实现的方法是:
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    //对象是从 xib 和 storyaboard 中来添加过来的
    //就是对象是从xib中 来进行的初始化过来的情况!!!
    if(self = [super initWithCoder:aDecoder]){
        
        [self initItems];
    }
    return self;
}

#pragma mark - 初始化三个隐藏的按钮
-(void)initItems{
    //添加三个不同的按钮来进行的操作
    [self addBtnWithBgImage:@"02角度_1" tag:0];
    [self addBtnWithBgImage:@"02角度_4" tag:27];
    [self addBtnWithBgImage:@"02角度_3" tag:18];
    [self addBtnWithBgImage:@"02角度_2" tag:9];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];

    //所有的隐藏的按钮的大小都是一样的
    CGRect btnBounds = CGRectMake(0, 0, 40, 40);
    //遍历的三个隐藏的按钮
    for (UIButton * btn in self.item) {
        
        btn.bounds = btnBounds;//通过的看图片的宽度来,进行的除以2获得的是当前的宽度和高度;
        btn.center = self.mainBtn.center;
    }
    //要求的是把红色的按钮来要求的置顶
    [self bringSubviewToFront:self.mainBtn];
    
}

//通过的添加一张图片来添加按钮
-(void)addBtnWithBgImage:(NSString *)bgImage tag:(NSInteger)tag{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    //设置背景图片
    [btn setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(childButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.item addObject:btn];
    [self addSubview:btn];
    
}

- (IBAction)mainBtnClick:(id)sender {
    //实现的思路是:
    //设计组动画的情况!
    BOOL show = CGAffineTransformIsIdentity(self.mainBtn.transform);
    
    [UIView animateWithDuration:1.0 animations:^{
        if(show){//专门的属性来进行的测试,代表的是transfrom 未被改变
            //要求的是,制作一个条件的判断的语句来
            self.mainBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
            
        }else{
            
            self.mainBtn.transform = CGAffineTransformIdentity;//通过的倒换属性的方式来进行的赋值
        }
    }];
    
    //2.所有的子view需要执行动画组
    [self showItemsAnimation:show];
}

-(void)showItemsAnimation: (BOOL)show{
    //注意的是一个按钮要求的对应的一个组动画
    //必须要求的实现的多次的创建..实现的组动画
    //通过的遍历的属性来进行的设置position动画的值:
    //3.2实现 items的显示位置
    for (int i =0;i< self.item.count;i++) {
        
        UIButton * btn =  self.item[i];
        //3.实现items 的组动画的效果
        CAAnimationGroup * group = [CAAnimationGroup animation];
        group.duration = 1;
        
        //3.1添加的一个平移的动画来实现
        CAKeyframeAnimation * positionAni = [CAKeyframeAnimation animation];
        positionAni.keyPath = @"position";
        
        //重新设置每个按钮的x的值
        CGFloat bntCenterX = self.mainBtn.center.x + (i+1) * delta;
        CGFloat bntCenterY = self.mainBtn.center.y;
        //最终要执行的动画
        CGPoint lastPoint = CGPointMake(bntCenterX, bntCenterY);

        if(show){//实现的整体的核心的思路是:  通过的是UIView的动画来进行的设置btn的 center 的属性来实现完成的;
            
            //设置平移动画的路劲(要求的是有 两个值)
            NSValue * value1 = [NSValue valueWithCGPoint:self.mainBtn.center];
            NSValue * value2 = [NSValue valueWithCGPoint:CGPointMake(bntCenterX * 0.5, bntCenterY)];
            NSValue * value3 = [NSValue valueWithCGPoint:CGPointMake(bntCenterX * 1.2, bntCenterY)];
            NSValue * value4 = [NSValue valueWithCGPoint:lastPoint];
            //整体的添加
            positionAni.values = @[value1,value2,value3,value4];//设置的核心的技术点,就是开始的位置点,和结束的位置点的数组的集合!注意的是不管是多么复杂的动画都能通过设置路径来进行的完成的
            
            btn.center = lastPoint;
            
        }else {//设置隐藏
            //设置"平移动画 的 路径"
            NSValue * value1 = [NSValue valueWithCGPoint:btn.center];//第一点是: 我们的当前的位置就是移动以后的位置
            NSValue * value2 = [NSValue valueWithCGPoint:CGPointMake(bntCenterX * 1.2, bntCenterY)];//第二个点是: 我们要求的移动到的点;
            NSValue * value3 = [NSValue valueWithCGPoint:CGPointMake(bntCenterX * 0.5, bntCenterY)];
            NSValue * value4 = [NSValue valueWithCGPoint:self.mainBtn.center];
            //整体的添加
            positionAni.values = @[value1,value2,value3,value4]; //这个是一个数组,要求的是要有先后的顺序
            //center的中心点还是那个我们的mainBtn的中心点;
            btn.center = self.mainBtn.center;
        }
        
        //添加子动画
        group.animations = @[positionAni];
        //然后的执行组 动画
        [btn.layer addAnimation:group forKey:nil];
    }
}

#pragma mark --------childButton点击执行的方法------
-(void)childButtonClick:(UIButton * )btn{
    //通过代理的方法来实现tag 值的传递!
    if([self.deleage respondsToSelector:@selector(bottomView:didSelectedButtonFrom:to:)]){
        //执行代理的方法
        [self.deleage bottomView:self didSelectedButtonFrom:0 to:(int)btn.tag];
    }
}


@end
