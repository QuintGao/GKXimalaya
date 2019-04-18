//
//  GKHttpRequestTool.m
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "GKHttpRequestTool.h"
#import <AFNetworking/AFNetworking.h>

@implementation GKHttpRequestTool

+ (void)getRequestWithUrl:(NSString *)url success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ? : success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failure ? : failure(error);
    }];
}

@end
