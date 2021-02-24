//
//  UIColor+GKCategory.h
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (GKCategory)

/**
 获取图片的主色调（出现最多的颜色）

 @param image 原图
 @param scale 精准度（0~1）
 @return 主色调颜色
 */
+ (UIColor *)colorWithMostImage:(UIImage *)image scale:(CGFloat)scale;

/**
 根据十六进制字符串生成颜色

 @param hexString 十六进制字符串
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (NSString *)hexFromUIColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
