//
//  GKHomeViewController.h
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "GKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GKHomeThemeStyle) {
    GKHomeThemeStyleNone  = -1, // 为设置
    GKHomeThemeStyleWhite = 0,  // 白色主题
    GKHomeThemeStyleBlack = 1   // 黑色主题
};

@interface GKHomeViewController : GKBaseViewController

@end

NS_ASSUME_NONNULL_END
