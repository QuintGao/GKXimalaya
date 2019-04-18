//
//  GKHomeModel.h
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKHomeCategoryModel;
NS_ASSUME_NONNULL_BEGIN

@interface GKHomeModel : NSObject

//"ret": 0,
@property (nonatomic, assign) NSInteger ret;
//"msg": "0",
@property (nonatomic, copy) NSString *msg;
//"errorCode": null,
@property (nonatomic, copy) NSString *errorCode;
//"categoryList": [6 items],
@property (nonatomic, strong) NSArray *categoryList;
//"customCategoryList": [19 items],
@property (nonatomic, strong) NSArray<GKHomeCategoryModel *> *customCategoryList;
//"modifyTime": 0,
@property (nonatomic, copy) NSString *modifyTime;
//"first": 0,
@property (nonatomic, copy) NSString *first;
//"bottomFirst": 0
@property (nonatomic, copy) NSString *bottomFirst;

@end

@interface GKHomeCategoryModel : NSObject

//"id": "recommend",
@property (nonatomic, strong) NSString  *cat_id;
//"title": "推荐",
@property (nonatomic, strong) NSString  *title;
//"itemType": "recommend",
@property (nonatomic, strong) NSString  *itemType;
//"categoryId": null,
@property (nonatomic, strong) NSString  *categoryId;
//"categoryType": null,
@property (nonatomic, strong) NSString  *categoryType;
//"moduleType": null,
@property (nonatomic, strong) NSString  *moduleType;
//"isDisplayCornerMark": null,
@property (nonatomic, strong) NSString  *isDisplayCornerMark;
//"cornerMark": "",
@property (nonatomic, strong) NSString  *cornerMark;
//"coverPath": "http://fdfs.xmcdn.com/group46/M01/78/40/wKgKlluOCWrzp2gmAAAEJADD21w497.png",
@property (nonatomic, strong) NSString  *coverPath;
//"unactiveCoverPath": "",
@property (nonatomic, strong) NSString  *unactiveCoverPath;
//"activeCoverPath": "",
@property (nonatomic, strong) NSString  *activeCoverPath;
//"recommendType": "fixed",
@property (nonatomic, strong) NSString  *recommendType;
//"url": "",
@property (nonatomic, strong) NSString  *url;
//"defaultSelected": true,
@property (nonatomic, strong) NSString  *defaultSelected;
//"audioStreamId": null,
@property (nonatomic, strong) NSString  *audioStreamId;
//"tabTheme": {
//    "headerBGColor": null,
//    "searchBoxColor": null
//},
@property (nonatomic, strong) NSDictionary  *tabTheme;
//"searchBoxRightContent": {
//    "icon": null,
//    "description": null,
//    "iting": null
//},
@property (nonatomic, strong) NSDictionary  *searchBoxRightContent;
//"hideInReview": false,
@property (nonatomic, strong) NSString  *hideInReview;
//"metadata": null,
@property (nonatomic, strong) NSString  *metadata;
//"cityCode": null
@property (nonatomic, strong) NSString  *cityCode;

@end

NS_ASSUME_NONNULL_END
