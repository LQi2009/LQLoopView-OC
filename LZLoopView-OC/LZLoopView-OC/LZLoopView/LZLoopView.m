//
//  LZLoopView.m
//  LZLoopView-OC
//
//  Created by Artron_LQQ on 2016/11/16.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZLoopView.h"
#import "LZLoopViewCell.h"
#import "LZTimer.h"

static NSString *reuseIdentifier = @"LZLoopCollectionViewCell";
@interface LZLoopView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isAutoRunDeterectionLeft;

@property (nonatomic, copy) loopBlock selected;
@property (nonatomic, copy) loopBlock scrolled;
@end
@implementation LZLoopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.timeInterval = 4.0;
        self.isAutoScroll = YES;
        self.isAutoRunDeterectionLeft = YES;
        self.isChangeAutoScrollDeterectionWithDragging = YES;
        
        [self.collectionView registerClass:[LZLoopViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    return self;
}
+ (instancetype)loopViewOn:(UIView *)superView frame:(CGRect)frame dataSource:(NSArray *)data titles:(NSArray *)titles didSelected:(loopBlock)selected {
    
    return [self loopViewOn:superView frame:frame dataSource:data titles:titles didSelected:selected];
}

+ (instancetype)loopViewOn:(UIView *)superView frame:(CGRect)frame dataSource:(NSArray *)data didSelected:(loopBlock)selected {
    
    return [self loopViewOn:superView frame:frame dataSource:data titles:nil didSelected:selected didScrolled:nil];
}

+ (instancetype)loopViewOn:(UIView *)superView frame:(CGRect)frame dataSource:(NSArray *)data titles:(NSArray *)titles didSelected:(loopBlock)selected didScrolled:(loopBlock)scrolled {
    
    LZLoopView *loop = [[LZLoopView alloc]initWithFrame:frame];
    [superView addSubview:loop];
    
    loop.dataSource = [data copy];
    loop.titles = [titles copy];
    loop.selected = selected;
    loop.scrolled = scrolled;
    
    return loop;
}

- (void)didSelected:(loopBlock)block {
    
    self.selected = block;
}

- (void)didScrolled:(loopBlock)block {
    
    self.scrolled = block;
}

- (void)setPageColor:(UIColor *)pageColor {
    
    _pageColor = pageColor;
    self.pageControl.pageIndicatorTintColor = pageColor;
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    
    _currentPageColor = currentPageColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}

- (void)startTimer {
    
    if (self.timer == nil) {
        
        self.isAutoScroll = YES;
        self.timer = [LZTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoRun) userInfo:nil repeats:YES];
        
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
    }
    
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    
    return _pageControl;
}

- (CGFloat)width {
    
    return self.frame.size.width;
}

- (CGFloat)height {
    
    return self.frame.size.height;
}

- (void)autoRun {
    
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
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = self.bounds;
    [self addSubview:self.collectionView];
    
    self.pageControl.frame = CGRectMake(0, self.height - 16, self.width, 14);
    self.pageControl.numberOfPages = self.dataSource.count;
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    
    // 滚动到中间一组
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
    
    LZLoopViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.obj = [self.dataSource objectAtIndex:indexPath.row];
    
    if (self.titles && self.titles.count > indexPath.row) {
        
        cell.title = self.titles[indexPath.row];
    }
    
    return cell;
}

#pragma mark - cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selected) {
        self.selected(indexPath.row);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.width, self.height);
}

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
    
    [self keepInMiddle];
}

//这里是处理定时器滚动完之后视图位置调整
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self keepInMiddle];
    
}

#pragma mark - 这个方法是为了保证视图永远处在最中间的那一组, 不会滚动到头
- (void)keepInMiddle {
    
    CGFloat temp = self.collectionView.contentOffset.x / self.width;
    
    int i = 0;
    if (temp - (CGFloat)((int)temp) > 0.0)
    {
        i = (int)temp + 1;
    }
    else
    {
        i = (int)temp;
    }
    
    self.pageControl.currentPage = i % self.dataSource.count;
    if (self.collectionView.contentOffset.x < self.width * self.dataSource.count || self.collectionView.contentOffset.x >  self.width * (self.dataSource.count * 2 - 1))
    {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:i % self.dataSource.count inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    if (self.scrolled) {
        self.scrolled(self.pageControl.currentPage);
    }
}

-(void)dealloc
{
    NSLog(@"LZLoopView dealloc");
    
    [self stopTimer];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

