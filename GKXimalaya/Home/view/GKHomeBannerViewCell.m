//
//  GKHomeBannerViewCell.m
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "GKHomeBannerViewCell.h"

@implementation GKHomeBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.imgView = [UIImageView new];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.layer.cornerRadius = 10.0f;
        self.imgView.layer.masksToBounds = YES;
        [self addSubview:self.imgView];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(ADAPTATIONRATIO * 32.0f);
            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 32.0f);
        }];
    }
    return self;
}

@end
