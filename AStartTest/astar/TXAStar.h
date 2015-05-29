//
//  FindPath with A-Star Algorithm
//  Created by Tingxin xu on 15-5-21.
//  Copyright (c) 2015年 Tingxin All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


#define MAP_EMPTY               0
#define MAP_BLOCK               1

typedef struct _TXGraphNode {
    int x;
    int y;
    int g;
    int f;
    bool available;
} TXGraphNode;

#define PathFindErrorDomain @"com.tingxxu.findpath"

typedef enum TXSearchErrorCode : NSUInteger {
    SEARCH_CANCELED,
    INPUT_INVALID
} TXSearchErrorCode;


@interface TXAStar : NSObject

-(id)initWithMap:(int**) mapInput withWidth:(int)width withHeight:(int)height;
-(NSArray *)searchWithGraphNode:(TXGraphNode)startNode endNode:(TXGraphNode)endNode failedError:(NSError**)error
 cancelSearch:(BOOL (^)(void))cancelSearch;

@end
