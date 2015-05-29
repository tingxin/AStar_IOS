//
//  FindPath with A-Star Algorithm
//  Created by Tingxin xu on 15-5-21.
//  Copyright (c) 2015年 Tingxin All rights reserved.
//

#import "TXAStar.h"

@interface TXAStar (){
    TXGraphNode currentNode;
    
    int** map;
    int mapWidth;
    int mapHeight;

    TXGraphNode nodeCache[10000];
    int nodeCacheCount;
}

@end

@implementation TXAStar


-(id)initWithMap:(int**) mapInput withWidth:(int)width withHeight:(int)height{
    self=[super init];
    if(self){
     
        self->mapWidth=width;
        self->mapHeight=height;
        self->map=mapInput;
        
        nodeCacheCount=0;
        
    }
    return  self;
}

-(NSArray *)searchWithGraphNode:(TXGraphNode)startNode endNode:(TXGraphNode)endNode failedError:(NSError**)error cancelSearch:(BOOL (^)(void))cancelSearch
{

    int** calculateMap;
    calculateMap= (int **) malloc ( sizeof(int*)*mapHeight);
    for(int i=0;i<mapHeight;i++){
        calculateMap[i]=(int*)malloc(sizeof(int)*mapWidth);
    }
    
    for(int i=0;i<mapHeight;i++){
        for(int j=0;j<mapWidth;j++){
        
            calculateMap[i][j]=-1;
        }
    }
    
    currentNode.x = startNode.x;
    currentNode.y = startNode.y;
    currentNode.g = 0;
    currentNode.f = 0;
    
    calculateMap[currentNode.x][currentNode.y]=MAP_EMPTY;
    
    while (currentNode.x!=endNode.x||
           currentNode.y!=endNode.y) {
        
        if(cancelSearch()){
        
            *error =[self getError:@"Operation canceled" searchFrom:startNode to:endNode];
            return nil;
        };
        
        int currentValue= calculateMap[currentNode.x][currentNode.y];
        if(currentNode.g<=currentValue){
        
            TXGraphNode candidate;
            for (int i=-1; i<2; i++) {
                
                for (int j=-1;j<2; j++) {
                    
                    if(i!=0||j!=0){
                        candidate.x=currentNode.x+i;
                        candidate.y=currentNode.y+j;
                        
                        int pathValue=map[candidate.x][candidate.y];
                        if(candidate.x>=0&&
                           candidate.x<mapHeight&&
                           candidate.y>=0&&
                           candidate.y<mapWidth&&
                           pathValue!=MAP_BLOCK){
                            
                            int candidateValue=calculateMap[candidate.x][candidate.y];
                            candidate.f=currentNode.g+1+Manhattan(candidate, endNode);
                            
                            if(candidateValue==-1||
                               candidateValue>(currentNode.g+1))
                            {
                                
                                calculateMap[candidate.x][candidate.y]=currentNode.g+1;
                                candidate.g=currentNode.g+1;
                                
                                candidate.available=true;
                                nodeCache[nodeCacheCount]=candidate;
                                nodeCacheCount=nodeCacheCount+1;
                                
                            }
                        }
                    }
                }
            }
            
        }
        
        if(nodeCacheCount>0)
        {
            int index=-1;
            for(int i=0;i<nodeCacheCount;i++)
            {
                if(nodeCache[i].available==false)continue;
                
                if(index<0)
                {
                    currentNode=nodeCache[i];
                    index=i;
                }
                else
                {
                    if(currentNode.f>nodeCache[i].f)
                    {
                        currentNode=nodeCache[i];
                        index=i;
                    }
                }
            }
            
            currentNode.available=false;

            if(index!=nodeCacheCount-1){
                nodeCache[index]=nodeCache[nodeCacheCount-1];
            }
            nodeCacheCount=nodeCacheCount-1;
        }
        else{
            *error =[self getError:@"NO Found" searchFrom:startNode to:endNode];
            return nil;
        }
    }
    

    NSMutableArray *result=[NSMutableArray array];

    
    TXGraphNode currentPath;
    TXGraphNode candidatePath;
    BOOL next;
    
    currentPath = endNode;
    
    for (int g = calculateMap[endNode.x][endNode.y]; g > 0; g--) {
        next = NO;
        // déplacement sur x
        for(int i = -1; i < 2; i++) {
            // déplacement sur y
            for(int j = -1; j < 2; j++) {
                // on ne fait pas sur le même point
                if((i != 0 || j != 0) && !next) {
                    candidatePath.x = currentPath.x+i;
                    candidatePath.y = currentPath.y+j;
                    candidatePath.g = calculateMap[currentPath.x+i][currentPath.y+j];
                    if( candidatePath.g == g-1 )
                    {
                        CGPoint position;
                        position.x=candidatePath.y;
                        position.y=candidatePath.x;
                        [result addObject:[NSValue value:&position withObjCType:@encode(CGPoint)]];
                        
                        currentPath=candidatePath;
                        next=YES;
                    }
                }
            }
        }
    }
    
    if(result.count>0){
        return result;
    }
    else{
        *error =[self getError:@"NO Found" searchFrom:startNode to:endNode];
        return nil;
    }
}

-(NSError*)getError:(NSString*)des searchFrom:(TXGraphNode)startNode to:(TXGraphNode)endNode{

    NSString* desc = [NSString stringWithFormat:@"%@ :find path failed from [%d,%d]  to [%d,%d]",des,startNode.y,startNode.x,endNode.y,endNode.x];
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:desc};
    NSError* error = [NSError errorWithDomain:PathFindErrorDomain code:INPUT_INVALID userInfo:userInfo];

    return error;
}


int Manhattan(TXGraphNode candidate, TXGraphNode end) {
    return (abs(candidate.x-end.x) + abs(candidate.y-end.y));
}

@end
