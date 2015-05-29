//
//  ViewController.m
//  AStartTest
//
//  Created by tingxin on 5/27/15.
//  Copyright (c) 2015 tingxin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    BOOL isStart;
}
@property (nonatomic,strong) TXPathFinder *pathFinder;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pathFinder=[[TXPathFinder alloc] initWithMap:self.imgMap.image wallColor:[UIColor redColor]];
    self.pathFinder.delegate=self;
    self->isStart=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    CGPoint pos=[touch locationInView:self.imgMap];
    if(isStart){
        self.startSign.frame=CGRectMake(pos.x, pos.y, self.startSign.frame.size.width,self.startSign.frame.size.height);
    }
    else{
     
        self.endSign.frame=CGRectMake(pos.x, pos.y, self.startSign.frame.size.width,self.startSign.frame.size.height);
    }
    isStart=!isStart;
}

- (IBAction)btnSearchPath:(id)sender {
    
    self.pathMap.stroke=nil;
    [self.pathMap setNeedsDisplay];
    
     NSLog(@"search from(%f,%f) to (%f,%f)",self.startSign.frame.origin.x,self.startSign.frame.origin.y,self.endSign.frame.origin.x,self.endSign.frame.origin.y);
    
    [self.pathFinder searchFromPoint:self.startSign.frame.origin toPoint:self.endSign.frame.origin];
}

- (void) didFindPath:(NSArray*)cgPoints{

    self.pathMap.stroke=[NSMutableArray arrayWithArray:cgPoints] ;
    [self.pathMap setNeedsDisplay];

}

- (void) failedToFindPath:(NSError*)error{

}
@end
