//
//  LZTimer.m
//  LZLoopView-OC
//
//  Created by Artron_LQQ on 2016/11/21.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZTimer.h"


@interface LZTempTarget : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation LZTempTarget

- (void)fire:(NSTimer *)timer {
    
    if (self.target) {
        
        [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0.0];
    } else {
        
        [self.timer invalidate];
    }
}
@end

@implementation LZTimer

+ (nullable NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ingerval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats {
    
    LZTempTarget *temp = [[LZTempTarget alloc]init];
    
    temp.target = target;
    temp.selector = selector;
    temp.timer = [NSTimer scheduledTimerWithTimeInterval:ingerval target:temp selector:@selector(fire:) userInfo:userInfo repeats:repeats];
    
    return temp.timer;
}
@end
