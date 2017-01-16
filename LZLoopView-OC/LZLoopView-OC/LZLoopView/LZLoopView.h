//
//  LZLoopView.h
//  LZLoopView-OC
//
//  Created by Artron_LQQ on 2016/11/16.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loopBlock)(NSInteger index);
@interface LZLoopView : UIView

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) BOOL isAutoScroll;
// 是否根据滑动方向切换自动滚动方向, 默认YES
@property (nonatomic, assign) BOOL isChangeAutoScrollDeterectionWithDragging;
// 分页控制器圆点颜色
@property (nonatomic, strong) UIColor *pageColor;
@property (nonatomic, strong) UIColor *currentPageColor;

- (void)startTimer;
- (void)stopTimer;
- (void)didSelected:(loopBlock)block ;
- (void)didScrolled:(loopBlock)block ;

+ (instancetype)loopViewOn:(UIView *)superView frame:(CGRect)frame dataSource:(NSArray *)data didSelected:(loopBlock)selected ;

+ (instancetype)loopViewOn:(UIView *)superView frame:(CGRect)frame dataSource:(NSArray *)data titles:(NSArray *)titles didSelected:(loopBlock)selected ;

+ (instancetype)loopViewOn:(UIView *)superView frame:(CGRect)frame dataSource:(NSArray *)data titles:(NSArray *)titles didSelected:(loopBlock)selected didScrolled:(loopBlock)scrolled ;
@end
