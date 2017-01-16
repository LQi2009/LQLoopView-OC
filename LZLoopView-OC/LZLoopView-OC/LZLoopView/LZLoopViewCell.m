//
//  LZLoopViewCell.m
//  LZLoopView-OC
//
//  Created by Artron_LQQ on 2016/11/17.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZLoopViewCell.h"

@interface LZLoopViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation LZLoopViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (UIImageView *)imgView {
    
    if (_imgView == nil) {
        
        _imgView = [[UIImageView alloc]init];
//        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _imgView;
}

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
    }
    
    return _titleLabel;
}

- (void)setObj:(id)obj {
    _obj = obj;
    
    if ([obj isKindOfClass:[UIImage class]]) {
        
        self.imgView.image = (UIImage *)obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        
        NSString *str = (NSString *)obj;
        if ([str hasPrefix:@"http"]) {
#warning 添加网络加载图片
            
        } else {
            
            UIImage *img = [UIImage imageNamed:str];
            if (img == nil) {
                
                img = [UIImage imageWithContentsOfFile:str];
            }
            
            self.imgView.image = img;
        }
    } else if ([obj isKindOfClass:[NSData class]]) {
        
        self.imgView.image = [UIImage imageWithData:(NSData *)obj];
    }
}
- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imgView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.imgView];
    
    if (self.title && self.title.length > 0) {
        
        self.titleLabel.frame = CGRectMake(10, CGRectGetHeight(self.frame) - 50, CGRectGetWidth(self.frame) - 20, 30);
        [self.contentView addSubview:self.titleLabel];
    }
}
@end
