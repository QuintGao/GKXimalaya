//
//  GKHomeBannerModel.h
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GKHomeBannerModel : NSObject

//"adId": 235133,
@property (nonatomic, copy) NSString    *adId;
//"adType": 0,
@property (nonatomic, copy) NSString    *adType;
//"buttonShowed": false,
@property (nonatomic, copy) NSString    *buttonShowed;
//"clickAction": -1,
@property (nonatomic, copy) NSString    *clickAction;
//"clickTokens": [],
@property (nonatomic, copy) NSString    *clickTokens;
//"clickType": 1,
@property (nonatomic, copy) NSString    *clickType;
//"cover": "http://fdfs.xmcdn.com/group57/M00/2C/C4/wKgLgVychFyTYN0iAAJL3IH3r0Y903.jpg",
@property (nonatomic, copy) NSString    *cover;
//"description": "",
@property (nonatomic, copy) NSString    *desc;
//"displayType": 1,
@property (nonatomic, copy) NSString    *displayType;
//"isAd": false,
@property (nonatomic, copy) NSString    *isAd;
//"isInternal": 0,
@property (nonatomic, copy) NSString    *isInternal;
//"isLandScape": false,
@property (nonatomic, copy) NSString    *isLandScape;
//"isShareFlag": false,
@property (nonatomic, copy) NSString    *isShareFlag;
//"link": "http://ad.ximalaya.com/adrecord?sdn=H4sIAAAAAAAAAKtWykhNTEktUrLKK83J0VFKzs_PzkyF8QoSixJzU0tSi4qVrKqVElM8S1JzPVOUrJSMjE0NjY2VamsBCAvHJEAAAAA&ad=235133&bucketIds=0&xmly=uiwebview&rec_src=146V11&rec_track=r.20000&rec_src=146V11&rec_track=r.20000",
@property (nonatomic, copy) NSString    *link;
//"name": "",
@property (nonatomic, copy) NSString    *name;
//"openlinkType": 0,
@property (nonatomic, copy) NSString    *openlinkType;
//"realLink": "iting://open?msg_type=94&bundle=rn_slqj&activityId=5&ad=1",
@property (nonatomic, copy) NSString    *realLink;
//"recSrc": "146V11",
@property (nonatomic, copy) NSString    *recSrc;
//"recTrack": "r.20000",
@property (nonatomic, copy) NSString    *recTrack;
//"showTokens": [],
@property (nonatomic, strong) NSArray    *showTokens;
//"targetId": -1,
@property (nonatomic, copy) NSString    *targetId;
//"thirdClickStatUrls": [],
@property (nonatomic, strong) NSArray    *thirdClickStatUrls;
//"thirdShowStatUrls": []
@property (nonatomic, strong) NSArray    *thirdShowStatUrls;

@property (nonatomic, strong) UIColor   *headerBgColor;

@end

NS_ASSUME_NONNULL_END
