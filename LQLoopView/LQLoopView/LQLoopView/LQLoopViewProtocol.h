//
//  LQLoopViewProtocol.h
//  LQLoopView
//
//  Created by 刘启强 on 2022/3/5.
//

@protocol LQLoopContentProtocol <NSObject>

@property (nonatomic, copy) NSString *reuseId;

@end

@protocol LQLoopContentCellProtocol <NSObject>

+ (NSString *) reuseIdentifier ;

- (void) fillWithData:(id<LQLoopContentProtocol>) data ;
@end

@class LQLoopView;
@protocol LQLoopViewDelegate <NSObject>

- (void) loopView:(LQLoopView *)loop didSelectedAtIndex:(NSInteger) index;
- (void) loopView:(LQLoopView *)loop didScrolledAtIndex:(NSInteger) index;
- (void) loopView:(LQLoopView *)loop willDisplayCell:(id<LQLoopContentCellProtocol>)cell forItemaAtIndex:(NSInteger) index ;
- (void) loopView:(LQLoopView *)loop didDisplayCell:(id<LQLoopContentCellProtocol>)cell forItemaAtIndex:(NSInteger) index ;
@end


