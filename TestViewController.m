//
//  TestViewController.m
//  Bussiness_zh
//
//  Created by zh on 2018/11/2.
//

#import "TestViewController.h"



@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [[UIButton alloc] init];
    btn.width = 100;
    btn.x = 100;
    btn.height = 100;
    btn.y = 100;
    
    [btn setExtendedHitArea:CGRectMake(50, 50, 50, 50)];
    [ self.view addSubview:btn];
    self.view.backgroundColor = kRandomColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
