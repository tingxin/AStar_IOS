//
//  FindPath with A-Star Algorithm
//  Created by Tingxin xu on 15-5-21.
//  Copyright (c) 2015年 Tingxin All rights reserved.
//

#import "TXPathFinder.h"
#import "TXRGB.h"
#import "TXAStar.h"

@interface TXPathFinder ()
{
    int** map;
}
@property (nonatomic) TXFindRequest* findRequest;

@end

@implementation TXPathFinder

int mapWidth;
int mapHeight;
int mapPassableCount;

-(id)initWithMap:(UIImage *)mapImg wallColor:(UIColor *)wallColor{
    
    self=[super init];
    if(self){
        mapPassableCount=0;
        self->map= pixelsWithUIImage(mapImg,wallColor);
    }
    return self;
}

- (void) endPathSearchWithResult:(NSArray*)cgPoints {
    if (!self.delegate) {
        return;
    }
    [self.delegate didFindPath:cgPoints];
}

- (void) endPathSearchWithError:(NSError*)error {
    if (!self.delegate) {
        return;
    }
    [self.delegate failedToFindPath:error];
}

- (void) beginPathSearch:(TXFindRequest*)request {
    
    TXAStar* astar = [[TXAStar alloc]initWithMap:self->map withWidth:mapWidth withHeight:mapHeight];
    
    TXGraphNode startNode;

    startNode.x=request.startPoint.y;
    startNode.y=request.startPoint.x;
    
    TXGraphNode endNode;
    endNode.x=request.endPoint.y;
    endNode.y=request.endPoint.x;
    
    
    NSError* error = nil;
    
    NSDate *currentTime=[NSDate date];

    NSArray* cgPoints = [astar searchWithGraphNode:startNode endNode:endNode failedError:&error  cancelSearch:^{
        BOOL isCancel= (BOOL)(self.findRequest != request);
        return isCancel;
    }];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:currentTime];
    NSLog(@"search Cost time is :%f milliseconds",interval*1000);

    if (error) {
        if (error.code == SEARCH_CANCELED) {
            NSLog(@"%@",[error localizedDescription]);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endPathSearchWithError:error];
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self endPathSearchWithResult:cgPoints];
    });
}

-(void)searchFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint{
    
    TXFindRequest *request =[[TXFindRequest alloc]init];
    request.startPoint = startPoint;
    request.endPoint = endPoint;
    
    self.findRequest = request;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self beginPathSearch:request];
    });
}


- (void)cancelSearchPath {
    self.findRequest = nil;
}

int** pixelsWithUIImage(UIImage* uiImage,UIColor *wallColor)
{

    NSDate *currentTime=[NSDate date];
    
    CGImageRef imageRef = [uiImage CGImage];
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    unsigned char* rawData = malloc(height*width*4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextClearRect(context, CGRectMake(0.0, 0.0, width, height));
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);

    CGContextRelease(context);
    
    TXRGB *cmxWallColor=[TXRGB initWithUIColor: wallColor];

    
    size_t row = 0;
    size_t column = 0;
    
    int** cmxMap;
    cmxMap= (int **) malloc ( sizeof(int*)*height);
    for(int i=0;i<height;i++){
        cmxMap[i]=(int*)malloc(sizeof(int)*width);
    }

    for(size_t byteIndex = 0; byteIndex < height * width * 4; byteIndex += 4) {

        TXRGB* rgb = [[TXRGB alloc] init];
        rgb.R = rawData[byteIndex];
        rgb.G = rawData[byteIndex + 1];
        rgb.B = rawData[byteIndex + 2];
        rgb.A = rawData[byteIndex + 3];
        
        
        if([cmxWallColor similarAs:rgb]){
          cmxMap[row][column]=MAP_BLOCK;
        }
        else{
            cmxMap[row][column]=MAP_EMPTY;
            mapPassableCount=mapPassableCount+1;
        }
      

        column++;
        if (column > width - 1) {
            column=0;
            row++;
        }
    }

    free(rawData);
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:currentTime];
    NSLog(@"pixelsWithUIImage Cost time is :%f milliseconds",interval*1000);

    mapWidth=width;
    mapHeight=height;

    return cmxMap;
}

@end