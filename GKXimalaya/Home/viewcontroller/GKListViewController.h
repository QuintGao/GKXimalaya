//
//  GKListViewController.h
//  GKXimalaya
//
//  Created by gaokun on 2019/3/29.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "GKNavigationBarViewController.h"
#import <JXCategoryView/JXCategoryListCollectionContainerView.h>
#import "GKHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@class GKListViewController;

@protocol GKListViewControllerDelegate <NSObject>

- (void)listVC:(GKListViewController *)vc didChangeColor:(UIColor *)color;

- (void)listVC:(GKListViewController *)vc didScroll:(UIScrollView *)scrollView;

@end

@interface GKListViewController : GKNavigationBarViewController<JXCategoryListCollectionContentViewDelegate>

@property (nonatomic, weak) id<GKListViewControllerDelegate> delegate;

@property (nonatomic, strong) GKHomeCategoryModel    *categoryModel;

@property (nonatomic, strong) UIColor   *bgColor;

// 是否到达临界点
@property (nonatomic, assign) BOOL      isCriticalPoint;

// 标题颜色 
@property (nonatomic, strong) UIColor   *titleColor;

@property (nonatomic, assign) BOOL      isSelected;

// 加载数据
- (void)loadData;

- (void)startScroll;
- (void)stopScroll;

@end

NS_ASSUME_NONNULL_END
