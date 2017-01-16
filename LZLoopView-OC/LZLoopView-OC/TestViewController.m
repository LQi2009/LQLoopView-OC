//
//  TestViewController.m
//  LZLoopView-OC
//
//  Created by Artron_LQQ on 2016/11/17.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "TestViewController.h"
#import "LZLoopView.h"

@interface TestViewController ()
{
    LZLoopView *loop;
}
@end

@implementation TestViewController
- (void)dealloc {
    
    NSLog(@"TestViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 20, 100, 40);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    NSArray *arr = @[@"findCar_topBanner01", @"findCar_topBanner02", @"findCar_topBanner03", @"findCar_topBanner04"];
    NSArray *title = @[@"1111111111", @"22222222222222222222222222222222222", @"3333333", @"44444444444444444444444444444444444444444444444444444444444444444444444444"];
    loop = [[LZLoopView alloc]init];
    loop.frame = CGRectMake(0, 100, self.view.bounds.size.width, 200);
    loop.backgroundColor = [UIColor greenColor];
    
    loop.dataSource = arr;
    loop.titles = title;
    loop.isAutoScroll = NO;
    [self.view addSubview:loop];
//    [LZLoopView addTimer:loop];
    
    
    LZLoopView *loop1 = [LZLoopView loopViewOn:self.view frame:CGRectMake(0, 300, self.view.frame.size.width, 200) dataSource:arr didSelected:^(NSInteger index) {
        
        NSLog(@"选中了%ld",(long)index);
    }];
    
//    [LZLoopView addTimer:loop1];
}

- (void)btnClick {
    
//    [LZLoopView invalidateAllTimer];
//    [loop stopTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
