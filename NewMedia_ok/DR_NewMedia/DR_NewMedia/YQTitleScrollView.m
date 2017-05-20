//
//  YQTitleScrollView.m
//  DR_NewMedia
//
//  Created by 杨庆 on 2017/4/19.
//  Copyright © 2017年 YQ. All rights reserved.
//

#define Default_Line_Width      2
#define subViews     4
#import "YQTitleScrollView.h"

@interface YQTitleScrollView ()
/// 重要set属性
@property(nonatomic,strong)UIView * lineLayer;

@property(nonatomic,assign)CGFloat   beginOffsetX;

@property(nonatomic,assign)CGFloat   lineWidth;      //  linewidth > 0，底部高亮线
@end

@implementation YQTitleScrollView

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
//    CGContextSetLineWidth(context, self.borderWidth);
//    CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect) - self.borderWidth);
//    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - self.borderWidth);
//    CGContextStrokePath(context);
//}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.lineWidth = Default_Line_Width;
        // 初始化高亮的线
        self.lineLayer = [[UIView alloc]init];
        self.lineLayer.backgroundColor = (__bridge UIColor * _Nullable)((__bridge CGColorRef _Nullable)([UIColor redColor]));
        self.lineLayer.frame = CGRectMake(CGRectGetMinX(self.lineLayer.frame), CGRectGetHeight(self.frame) - self.lineWidth, CGRectGetWidth(self.bounds)/subViews, self.lineWidth);
        
        [self addSubview: self.lineLayer];
        
    }

    return self;
}

- (void)scrollToRate:(CGFloat)rate{
    //实现的思路是:通过的是 调节rate的位置来进行的设置 transform的位移!
    //拿到的是:rate
    //NSLog(@"rate == %f",rate);
    
    CGFloat x = rate * (CGRectGetWidth(self.bounds)/subViews);
    
    //NSLog(@"x == %f",x);
    //NSLog(@"withd = %f",CGRectGetWidth(self.bounds)/subViews);
    
    //注意的是:这里的是应用的 绝对值的 添加的 transform的情况!
    CGAffineTransform transform = CGAffineTransformMake(1, 0,0,1, 0, 0);
    //注意的是: x的移动的是 相对移动的!
    self.lineLayer.transform = CGAffineTransformTranslate(transform, x, 0);
    //最后的调整的 准确的移动来定位!
    
}

@end
