//
//  TestViewController.m
//  Bussiness_zh
//
//  Created by zh on 2018/11/2.
//

#import "TestViewController.h"

#import "UIView+coordinate.h"
#import "UIView+ExtendHitArea.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.width = 100;
    btn.x = 100;
    btn.height = 100;
    btn.y = 100;
    
    [btn setExtendedHitArea:CGRectMake(50, 50, 50, 50)];
    [ self.view addSubview:btn];
    self.view.backgroundColor = [UIColor redColor];

}



@end
