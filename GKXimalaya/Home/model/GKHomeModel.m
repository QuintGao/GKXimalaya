//
//  GKHomeModel.m
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "GKHomeModel.h"

@implementation GKHomeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"customCategoryList" : [GKHomeCategoryModel class]};
}

@end

@implementation GKHomeCategoryModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cat_id"  : @"id"};
}

@end
