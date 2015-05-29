//
//  FindPath with A-Star Algorithm
//  Created by Tingxin xu on 15-5-21.
//  Copyright (c) 2015年 Tingxin All rights reserved.
//

#import "TXRGB.h"

#define COLOR_DIFF 150

@implementation TXRGB

- (BOOL)similarAs:(TXRGB*)rgb {
    if (!rgb) {
        return NO;
    }
    if(abs(self.A - rgb.A) < COLOR_DIFF) {
        if(abs(self.R - rgb.R) < COLOR_DIFF) {
            if(abs(self.G - rgb.G) < COLOR_DIFF) {
                if(abs(self.B - rgb.B) < COLOR_DIFF) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

+ (TXRGB*)initWithUIColor:(UIColor*)uiColor {
    if (!uiColor) {
        return nil;
    }

    TXRGB* rgb = [[TXRGB alloc] init];
    if (rgb) {
        CGFloat alpha;
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        if ([uiColor getRed:&red green:&green blue:&blue alpha:&alpha]) {
            rgb.A = 255 * alpha;
            rgb.R = 255 * red;
            rgb.G = 255 * green;
            rgb.B = 255 * blue;
            return rgb;
        };
    }
    return nil;
}

@end
