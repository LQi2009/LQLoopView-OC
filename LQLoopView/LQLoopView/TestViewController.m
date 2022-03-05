//
//  TestViewController.m
//  LQLoopView
//
//  Created by 刘启强 on 2022/3/5.
//

#import "TestViewController.h"
#import "LQLoopView/LQLoopView.h"
#import "LQLoopModel.h"
#import "LQLoopCollectionViewCell.h"

@interface TestViewController ()

@property (nonatomic, strong) LQLoopView *loopView;
@end

@implementation TestViewController

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
    
    NSMutableArray *datas = [NSMutableArray array];
    for (int i =0; i < arr.count; i++) {
        LQLoopModel *model = [[LQLoopModel alloc]init];
        
        model.obj = arr[i];
        model.title = title[i];
        model.reuseId = [LQLoopCollectionViewCell reuseIdentifier];
        [datas addObject:model];
    }
    self.loopView = [[LQLoopView alloc]init];
    
    [self.loopView registerContentCells:@[@"LQLoopCollectionViewCell"]];
    
    self.loopView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 200);
    self.loopView.backgroundColor = [UIColor greenColor];
    [self.loopView configDatas:datas];
    
    [self.view addSubview:self.loopView];
//    [LZLoopView addTimer:loop];
    
    
//     *loop1 = [LZLoopView loopViewOn:self.view frame:CGRectMake(0, 300, self.view.frame.size.width, 200) dataSource:arr didSelected:^(NSInteger index) {
//
//        NSLog(@"选中了%ld",(long)index);
//    }];
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
