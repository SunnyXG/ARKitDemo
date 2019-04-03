//
//  ViewController.m
//  ARKitDemo
//
//  Created by zhangxiaoguang on 2019/4/2.
//  Copyright © 2019 zhangxiaoguang. All rights reserved.
//

#import "ViewController.h"
#import "ARScnViewController.h"
#import "ARTraceViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)startAR:(id)sender
{
    ARScnViewController *arVC = [ARScnViewController new];
    [self.navigationController pushViewController:arVC animated:YES];
}

- (IBAction)traceAR:(id)sender
{
    ARTraceViewController *traceVC = [ARTraceViewController new];
    [self.navigationController pushViewController:traceVC animated:YES];
}

@end
