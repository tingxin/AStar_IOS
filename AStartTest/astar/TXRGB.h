//
//  FindPath with A-Star Algorithm
//  Created by Tingxin xu on 15-5-21.
//  Copyright (c) 2015年 Tingxin All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TXRGB : NSObject

@property (nonatomic) int A;
@property (nonatomic) int R;
@property (nonatomic) int G;
@property (nonatomic) int B;

- (BOOL)similarAs:(TXRGB*)rgb;
+ (TXRGB*)initWithUIColor:(UIColor*)uiColor;

@end