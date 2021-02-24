//
//  GKListContainerView.h
//  GKXimalaya
//
//  Created by gaokun on 2019/4/1.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import <JXCategoryViewExt/JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GKListContainerViewDelegate <NSObject>

- (void)scrollWillBegin;
- (void)scrollDidEnded;

@end

@interface GKListContainerView : JXCategoryListContainerView

@property (nonatomic, weak) id<GKListContainerViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
