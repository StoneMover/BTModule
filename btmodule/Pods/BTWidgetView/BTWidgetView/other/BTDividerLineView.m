//
//  BTDividerLineView.m
//  huashi
//
//  Created by stonemover on 16/8/20.
//  Copyright © 2016年 StoneMover. All rights reserved.
//

#import "BTDividerLineView.h"
#import <BTHelp/UIView+BTViewTool.h>


@implementation BTDividerLineView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.color = [UIColor colorWithRed:0.24 green:0.24 blue:0.26 alpha:0.29];
    self.lineWidth = .5;
    return self;
}

-(void)drawRect:(CGRect)rect{
    self.backgroundColor = UIColor.clearColor;
    CGFloat lineWidth=self.lineWidth;
    CGColorRef strokeColor=self.color.CGColor;
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, strokeColor);
    
    if (self.oriention==BTDividerLineViewHoz) {
        //水平情况
        if(self.aligntMent==BTDividerLineViewAlignmentTop){
            //居上的情况
            CGContextMoveToPoint(ctx, 0, self.lineWidth/2);
            CGContextAddLineToPoint(ctx, self.BTWidth, self.lineWidth/2);
        }else if (self.aligntMent==BTDividerLineViewAlignmentCenter){
            CGContextMoveToPoint(ctx, 0, self.BTHeight/2.0);
            CGContextAddLineToPoint(ctx, self.BTWidth, self.BTHeight/2.0);
        }else if (self.aligntMent==BTDividerLineViewAlignmentBottom){
            CGContextMoveToPoint(ctx, 0, self.BTHeight-self.lineWidth/2);
            CGContextAddLineToPoint(ctx, self.BTWidth, self.BTHeight-self.lineWidth/2);
        }
        
    }else{
        
        if (self.aligntMent==BTDividerLineViewAlignmentLeft) {
            CGContextMoveToPoint(ctx, self.lineWidth/2, 0);
            CGContextAddLineToPoint(ctx, self.lineWidth/2,self.BTHeight);
        }else if (self.aligntMent==BTDividerLineViewAlignmentCenter){
            CGContextMoveToPoint(ctx, self.BTWidth/2.0, 0);
            CGContextAddLineToPoint(ctx, self.BTWidth/2.0,self.BTHeight);
        }else if (self.aligntMent==BTDividerLineViewAlignmentRight){
            CGContextMoveToPoint(ctx, self.BTWidth-self.lineWidth/2, 0);
            CGContextAddLineToPoint(ctx, self.BTWidth-self.lineWidth/2,self.BTHeight);
        }
        
        
    }
    
    if (self.dashedLineWidthAndMargin != 0) {
        CGFloat arr[] = {self.dashedLineWidthAndMargin,self.dashedLineWidthAndMargin};
        CGContextSetLineDash(ctx, 0, arr, 2);
    }
    
    CGContextSetLineWidth(ctx, lineWidth);
    
    CGContextStrokePath(ctx);
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth=lineWidth;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color{
    _color=color;
    [self setNeedsDisplay];
}

- (void)setOriention:(NSInteger)oriention{
    _oriention=oriention;
    [self setNeedsDisplay];
}

- (void)setAligntMent:(NSInteger)aligntMent{
    _aligntMent=aligntMent;
    [self setNeedsDisplay];
}

- (void)setDashedLineWidthAndMargin:(NSInteger)dashedLineWidthAndMargin{
    _dashedLineWidthAndMargin = dashedLineWidthAndMargin;
    if (dashedLineWidthAndMargin == 0) {
        return;
    }
    [self setNeedsDisplay];
}

@end


@interface BTDashLineCornerView()

@property (nonatomic, assign) NSInteger contentPadding;

@end


@implementation BTDashLineCornerView

-(void)drawRect:(CGRect)rect
{
    self.contentPadding = self.lineCorner;
    
    CGFloat selfW = rect.size.width;
    CGFloat selfH = rect.size.height;
    CGPoint point1 = CGPointMake(selfW - self.contentPadding - self.lineCorner - selfW / 2.0, self.contentPadding);
    CGPoint point2 = CGPointMake(self.contentPadding + self.lineCorner, self.contentPadding);
    CGPoint point3 = CGPointMake(self.contentPadding, self.contentPadding + self.lineCorner);
    CGPoint point4 = CGPointMake(self.contentPadding, selfH - self.contentPadding - self.lineCorner);
    CGPoint point5 = CGPointMake(self.contentPadding + self.lineCorner, selfH - self.contentPadding);
    CGPoint point6 = CGPointMake(selfW - self.contentPadding - self.lineCorner, selfH - self.contentPadding);
    CGPoint point7 = CGPointMake(selfW - self.contentPadding, selfH - self.contentPadding - self.lineCorner);
    CGPoint point8 = CGPointMake(selfW - self.contentPadding, self.contentPadding + self.lineCorner);
    CGPoint point9 = CGPointMake(selfW - self.contentPadding - self.lineCorner, self.contentPadding);

    //贝斯曲线的控制点 --画圆角用
    CGPoint controlPoint1 = CGPointMake(self.lineCorner, self.lineCorner);
    CGPoint controlPoint2 = CGPointMake(self.lineCorner, selfH - self.lineCorner);
    CGPoint controlPoint3 = CGPointMake(selfW - self.lineCorner, selfH - self.lineCorner);
    CGPoint controlPoint4 = CGPointMake(selfW - self.lineCorner, self.lineCorner);

    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    const CGFloat lengths[] = {self.dashWidth,self.dashWidth};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextMoveToPoint(context, point1.x, point1.y);
    CGContextAddLineToPoint(context, point2.x, point2.y);
    
    CGContextAddQuadCurveToPoint(context, controlPoint1.x ,controlPoint1.y , point3.x,point3.y );
    
    CGContextAddLineToPoint(context, point4.x, point4.y);
    
    CGContextAddQuadCurveToPoint(context,controlPoint2.x ,  controlPoint2.y , point5.x ,point5.y);
    
    CGContextAddLineToPoint(context, point6.x, point6.y);
    
    CGContextAddQuadCurveToPoint(context,controlPoint3.x ,  controlPoint3.y , point7.x ,point7.y);
    
    CGContextAddLineToPoint(context, point8.x, point8.y);
    
    CGContextAddQuadCurveToPoint(context,controlPoint4.x ,  controlPoint4.y , point9.x ,point9.y);
    
    CGContextAddLineToPoint(context, point1.x, point1.y);
    
    CGContextStrokePath(context);
    CGContextClosePath(context);

}

@end
