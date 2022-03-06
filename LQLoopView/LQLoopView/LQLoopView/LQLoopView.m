//
//  LQLoopView.m
//  LQLoopView
//
//  Created by 刘启强 on 2022/3/5.
//

#import "LQLoopView.h"

#define LQLoopViewDefaultReuseID @"LQLoopViewDefaultReuseID"
@interface LQLoopTimer : NSObject

+ (nullable NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ingerval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats;
@end


@interface LQLoopView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isAutoRunDeterectionLeft;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, strong) NSMutableArray<id<LQLoopContentProtocol>> *dataSource;
@end
@implementation LQLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.timeInterval = 4.0;
        self.isAutoScroll = YES;
        self.isAutoRunDeterectionLeft = YES;
        self.isChangeAutoScrollDeterectionWithDragging = YES;
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        self.lastIndexPath = self.currentIndexPath;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LQLoopViewDefaultReuseID];
    }
    
    return self;
}
- (void) registerContentCells:(NSArray <NSString *> *) cells {
    
    for (NSString *name in cells) {
        Class cls = NSClassFromString(name);
        if (!cls) {
            continue;
        }
        
        if (![cls isSubclassOfClass:[UICollectionViewCell class]]) {
            continue;
        }
        
        if ([cls conformsToProtocol:@protocol(LQLoopContentCellProtocol)]) {
            if ([cls respondsToSelector:@selector(reuseIdentifier)]) {
                NSString *reuse = [cls reuseIdentifier];
                [self.collectionView registerClass:cls forCellWithReuseIdentifier:reuse];
            }
        }
    }
}

- (void) configDatas:(NSArray<id<LQLoopContentProtocol>> *) datas {
    for (id<LQLoopContentProtocol> obj in datas) {
        if ([obj conformsToProtocol:@protocol(LQLoopContentProtocol)]) {
            [self.dataSource addObject:obj];
        }
    }

    [self.collectionView reloadData];
}

- (void)startTimer {
    
    if (self.timer == nil) {
        
        self.isAutoScroll = YES;
        self.timer = [LQLoopTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoScrollToNextItem) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    
    if (self.timer) {
        
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_collectionView];
    }
    
    return _collectionView;
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (CGFloat)height {
    
    return self.frame.size.height;
}

- (void)autoScrollToNextItem {
    
    CGPoint offset = self.collectionView.contentOffset;
    
    if (self.isAutoRunDeterectionLeft) {
        
        offset.x = offset.x + self.width;
        if (offset.x - (CGFloat)((int)offset.x) != 0) {
            offset.x = (int)offset.x + 1;
        }
        
        [self.collectionView scrollRectToVisible:CGRectMake(offset.x, 0, self.width, self.height) animated:YES];
    } else {
        
        offset.x = offset.x - self.width;
        if (offset.x - (CGFloat)((int)offset.x) != 0) {
            offset.x = (int)offset.x - 1;
        }
        
        [self.collectionView scrollRectToVisible:CGRectMake(offset.x, 0, self.width, self.height) animated:YES];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
    // 滚动到中间一组
    self.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    if (self.isAutoScroll) {
        [self startTimer];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // 这里设置成3组, 让界面上显示的永远都停留在中间的那一组
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id<LQLoopContentProtocol> obj = self.dataSource[indexPath.row];
    
    if (!obj.reuseId) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LQLoopViewDefaultReuseID forIndexPath:indexPath];
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:obj.reuseId forIndexPath:indexPath];
    
    if ([cell conformsToProtocol:@protocol(LQLoopContentCellProtocol)]) {
        
        id<LQLoopContentCellProtocol> pcell = (id<LQLoopContentCellProtocol>)cell;
        if ([pcell respondsToSelector:@selector(fillWithData:)]) {
            [pcell fillWithData:obj];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"willDisplayCell %@", indexPath);
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopView:willDisplayCell:forItemaAtIndex:)]) {
        [self.delegate loopView:self willDisplayCell:(id<LQLoopContentCellProtocol>)cell forItemaAtIndex:indexPath.row];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopView:didEndDisplayCell:forItemaAtIndex:)]) {
        [self.delegate loopView:self didEndDisplayCell:(id<LQLoopContentCellProtocol>)cell forItemaAtIndex:indexPath.row];
    }
}

#pragma mark - cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopView:didSelectedAtIndex:)]) {
        [self.delegate loopView:self didSelectedAtIndex:indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.width, self.height);
}

#pragma mark - 处理手势
//这里是在手动滑动将要开始的时候将计时器停止(移除), 防止其在后台还在计时, 造成滚动多页的情况
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.isAutoScroll) {
        [self stopTimer];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (self.isChangeAutoScrollDeterectionWithDragging == NO) {
        return;
    }
    
    CGPoint target = *targetContentOffset;
    if (target.x - scrollView.contentOffset.x > 0) {
        self.isAutoRunDeterectionLeft = YES;
    } else {
        self.isAutoRunDeterectionLeft = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.isAutoScroll) {
        [self startTimer];
    }
}

//这里是处理手动滑动之后视图的位置调整
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self adjustToMiddle];
}

//这里是处理定时器滚动完之后视图位置调整
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self adjustToMiddle];
}

// 这个方法是为了保证视图永远处在最中间的那一组, 不会滚动到头
- (void) adjustToMiddle {
    
    CGFloat temp = self.collectionView.contentOffset.x / self.width;
    
    int i = 0;
    if (temp - (CGFloat)((int)temp) > 0.0) {
        i = (int)temp + 1;
    } else {
        i = (int)temp;
    }
    
    NSInteger index = (i % self.dataSource.count);
    if (self.collectionView.contentOffset.x < self.width * self.dataSource.count || self.collectionView.contentOffset.x >  self.width * (self.dataSource.count * 2 - 1)) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loopView:didScrolledAtIndex:)]) {
        [self.delegate loopView:self didScrolledAtIndex:index];
    }
}

-(NSMutableArray<id<LQLoopContentProtocol>> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)dealloc
{
    NSLog(@"LQLoopView dealloc");
    [self stopTimer];
}
@end

#pragma mark - LQLoopTimer

@interface LQLoopTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;

- (void)fire:(NSTimer *)timer ;
@end

@implementation LQLoopTimer

+ (nullable NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ingerval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats {
    
    LQLoopTarget *temp = [[LQLoopTarget alloc]init];
    
    temp.target = target;
    temp.selector = selector;
    temp.timer = [NSTimer scheduledTimerWithTimeInterval:ingerval target:temp selector:@selector(fire:) userInfo:userInfo repeats:repeats];
    
    return temp.timer;
}

@end

@implementation LQLoopTarget

- (void)fire:(NSTimer *)timer {
    
    if (self.target) {
        
        [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0.0];
    } else {
        
        [self.timer invalidate];
    }
}
@end
