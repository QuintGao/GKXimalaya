//
//  GKHttpRequestTool.h
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKHttpRequestTool : NSObject

+ (void)getRequestWithUrl:(NSString *)url success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
