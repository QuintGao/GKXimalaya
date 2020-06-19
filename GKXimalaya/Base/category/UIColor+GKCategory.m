//
//  UIColor+GKCategory.m
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "UIColor+GKCategory.h"

@implementation UIColor (GKCategory)

+ (UIColor *)colorWithMostImage:(UIImage *)image scale:(CGFloat)scale{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    if (scale < 0) {
        scale = 0;
    }else if (scale > 1) {
        scale = 1;
    }
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width * 4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData(context);
    if (data == NULL) return nil;
    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width * thumbSize.height];
    
    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {
            int offset  = 4 * (x * y);
            int red     = data[offset];
            int green   = data[offset+1];
            int blue    = data[offset+2];
            int alpha   =  data[offset+3];
            if (alpha > 0){ //去除透明
                if (red == 255 && green == 255 && blue == 255) { //去除白色
                    continue;
                }else{
                    NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    while ((curColor = [enumerator nextObject]) != nil) {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if (tmpCount < MaxCount ) continue;
        MaxCount = tmpCount;
        MaxColor = curColor;
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
