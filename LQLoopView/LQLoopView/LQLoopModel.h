//
//  LQLoopModel.h
//  LQLoopView
//
//  Created by 刘启强 on 2022/3/5.
//

#import <Foundation/Foundation.h>
#import "LQLoopViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LQLoopModel : NSObject <LQLoopContentProtocol>

@property (nonatomic, copy) NSString *reuseId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) id obj;
@end

NS_ASSUME_NONNULL_END
