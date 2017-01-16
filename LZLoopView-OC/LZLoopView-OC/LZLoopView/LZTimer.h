//
//  LZTimer.h
//  LZLoopView-OC
//
//  Created by Artron_LQQ on 2016/11/21.
//  Copyright © 2016年 Artup. All rights reserved.
//
// 防止定时器引起的内存泄露

#import <Foundation/Foundation.h>

@interface LZTimer : NSObject

+ (nullable NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ingerval target:(nonnull id)target selector:(nonnull SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats;
@end
