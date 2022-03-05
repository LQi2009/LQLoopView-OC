//
//  LQLoopView.h
//  LQLoopView
//
//  Created by 刘启强 on 2022/3/5.
//

#import <UIKit/UIKit.h>
#import "LQLoopViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LQLoopView : UIView

@property (nonatomic) id<LQLoopViewDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval timeInterval ;
@property (nonatomic, assign) BOOL isAutoScroll;
// 是否根据滑动方向切换自动滚动方向, 默认YES
@property (nonatomic, assign) BOOL isChangeAutoScrollDeterectionWithDragging;

- (void) registerContentCells:(NSArray <NSString *> *) cells ;
- (void) configDatas:(NSArray<id<LQLoopContentProtocol>> *) datas ;
@end

NS_ASSUME_NONNULL_END
