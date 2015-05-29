//
//  ViewController.h
//  AStartTest
//
//  Created by tingxin on 5/27/15.
//  Copyright (c) 2015 tingxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXPathFinder.h"
#import "SimpleDrawingView.h"

@interface ViewController : UIViewController<TXPathFinderDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgMap;
- (IBAction)btnSearchPath:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *startSign;
@property (strong, nonatomic) IBOutlet UIView *endSign;
@property (strong, nonatomic) IBOutlet SimpleDrawingView *pathMap;

@end

