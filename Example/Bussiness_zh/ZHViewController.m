//
//  ZHViewController.m
//  Bussiness_zh
//
//  Created by zh-ios on 11/02/2018.
//  Copyright (c) 2018 zh-ios. All rights reserved.
//

#import "ZHViewController.h"
#import "TestViewController.h"
@interface ZHViewController ()

@end

@implementation ZHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:[[TestViewController alloc] init] animated:YES];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
