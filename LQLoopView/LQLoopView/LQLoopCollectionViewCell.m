//
//  LQLoopCollectionViewCell.m
//  LQLoopView
//
//  Created by 刘启强 on 2022/3/5.
//

#import "LQLoopCollectionViewCell.h"
#import "LQLoopModel.h"

@interface LQLoopCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation LQLoopCollectionViewCell

+ (NSString *)reuseIdentifier {
    return @"LQLoopCollectionViewCellID";
}

- (void) fillWithData:(id<LQLoopContentProtocol>) data {
    
    if ([data isKindOfClass:[LQLoopModel class]]) {
        LQLoopModel *model = data;
        
        id obj = model.obj;
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
        
        self.titleLabel.text = model.title;
    }
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imgView.frame = self.contentView.bounds;
    
    self.titleLabel.frame = CGRectMake(10, CGRectGetHeight(self.frame) - 50, CGRectGetWidth(self.frame) - 20, 30);
    
}

- (UIImageView *)imgView {
    
    if (_imgView == nil) {
        
        _imgView = [[UIImageView alloc]init];
//        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imgView];
    }
    
    return _imgView;
}

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
    }
    
    return _titleLabel;
}
@end
