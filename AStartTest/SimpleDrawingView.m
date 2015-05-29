//
//  SimpleDrawingView.m
//  AStartTest
//
//  Created by tingxin on 5/27/15.
//  Copyright (c) 2015 tingxin. All rights reserved.
//

#import "SimpleDrawingView.h"

@implementation SimpleDrawingView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.stroke=[[NSMutableArray alloc] init];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    CGContextRef context=UIGraphicsGetCurrentContext();

    [self drawingPoints:self.stroke withColor:[UIColor purpleColor] withContext:context];
}

-(void)drawingPoints:(NSArray*)points withColor:(UIColor*)color withContext:(CGContextRef)context {
    if(points!=nil&&points.count>1){
    
        const CGFloat* components = CGColorGetComponents(color.CGColor);
        const CGFloat alpha=1.0;
        CGContextSetRGBFillColor(context, components[0], components[1], components[2], alpha);
        CGContextSetRGBStrokeColor(context, components[0], components[1], components[2], alpha);
        CGContextSetLineWidth(context, 2.0);
        CGPoint currentPoint=[points[0] CGPointValue];
        CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
               for(int i=1;i<points.count;i++){
        
            currentPoint=[points[i] CGPointValue];
            CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        }
        CGContextStrokePath(context);
        
    }
    else{
        CGContextClearRect(context, self.frame);
    }
    
}

@end
