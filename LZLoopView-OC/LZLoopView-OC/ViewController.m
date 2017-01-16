//
//  ViewController.m
//  LZLoopView-OC
//
//  Created by Artron_LQQ on 2016/11/16.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *arr = @[@"http://d.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc42223e3f13bdbb6fd536633f7.jpg",
                    @"http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
                    @"http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
                    @"http://wallpaper.160.com/Wallpaper/Image/1280_960/1280_960_37227.jpg"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick {
    
    TestViewController *test = [[TestViewController alloc]init];
    
    [self presentViewController:test animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
