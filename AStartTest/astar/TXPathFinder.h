//
//  FindPath with A-Star Algorithm
//  Created by Tingxin xu on 15-5-21.
//  Copyright (c) 2015年 Tingxin All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TXFindRequest.h"


@protocol TXPathFinderDelegate <NSObject>

@required
- (void) didFindPath:(NSArray*)cgPoints;
- (void) failedToFindPath:(NSError*)error;

@end

@interface TXPathFinder : NSObject

@property (weak, nonatomic) id<TXPathFinderDelegate> delegate;

-(id)initWithMap:(UIImage*)mapImg wallColor:(UIColor*)wallColor;

- (void)searchFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint ;
- (void)cancelSearchPath;

@end