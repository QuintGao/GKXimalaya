//
//  GKHomeViewController.m
//  GKXimalaya
//
//  Created by QuintGao on 2019/3/31.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "GKHomeViewController.h"
#import "GKListViewController.h"
#import "GKHttpRequestTool.h"
#import "GKHomeModel.h"
#import <JXCategoryView/JXCategoryView.h>
#import "GKListContainerView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JXCategoryTitleView+GKCategory.h"

@interface GKHomeViewController()<JXCategoryViewDelegate, JXCategoryListCollectionContainerViewDataSource, GKListContainerViewDelegate, GKListViewControllerDelegate>

@property (nonatomic, strong) UIView                *headerBgView;
@property (nonatomic, strong) UIView                *coverView;

@property (nonatomic, strong) UIView                    *topView;
@property (nonatomic, strong) JXCategoryTitleImageView  *categoryView;
@property (nonatomic, strong) JXCategoryIndicatorLineView   *lineView;

@property (nonatomic, strong) GKListContainerView  *containerView;

@property (nonatomic, strong) NSMutableArray    *titles;
@property (nonatomic, strong) NSMutableArray    *imgUrls;
@property (nonatomic, strong) NSMutableArray    *imgSelectUrls;
@property (nonatomic, strong) NSMutableArray    *imgTypes;

@property (nonatomic, strong) GKHomeModel       *model;

@property (nonatomic, assign) GKHomeThemeStyle  style;

@end

@implementation GKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationBar.hidden = YES;
    self.style = GKHomeThemeStyleNone;
    
    [self.view addSubview:self.headerBgView];
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.categoryView];
    [self.view addSubview:self.containerView];
    
    [self.headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(ADAPTATIONRATIO * 360.0f);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerBgView);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(GK_STATUSBAR_NAVBAR_HEIGHT);
    }];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(GK_STATUSBAR_HEIGHT);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(GK_NAVBAR_HEIGHT);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self changeToWhiteStateAtVC:nil];
    
    [self getCateogyrList];
}

- (void)getCateogyrList {
    NSString *url = @"http://mobile.ximalaya.com/discovery-category/customCategories/1554002493120?channel=ios-b1&code=43_110000_1100&customCategories=%5B%22recommend%22%2C%22react_native-8%22%2C%22vip%22%2C%22single_category-49%22%2C%22lamia%22%2C%22single_category-6%22%2C%22local_listen%22%2C%22live%22%2C%22paid%22%2C%22single_category-12%22%2C%22single_category-39%22%2C%22single_category-9%22%2C%22single_category-48%22%2C%22single_category-2%22%2C%22single_category-13%22%2C%22single_category-10%22%2C%22single_category-38%22%2C%22single_category-8%22%2C%22html5-9%22%5D&device=iPhone&excludeItemTypes=%5B%22my_listen%22%5D&includeItemTypes=%5B%22vip%22%5D&version=6.5.63";
    
    [GKHttpRequestTool getRequestWithUrl:url success:^(id  _Nonnull responseObject) {
        self.model = [GKHomeModel yy_modelWithDictionary:responseObject];
        
        [self.model.customCategoryList enumerateObjectsUsingBlock:^(GKHomeCategoryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.titles addObject:obj.title];
            
            [self.imgUrls addObject:[NSURL URLWithString:obj.unactiveCoverPath]];
            [self.imgSelectUrls addObject:[NSURL URLWithString:obj.activeCoverPath]];
            
            if (obj.activeCoverPath.length > 0) {
                [self.imgTypes addObject:@(JXCategoryTitleImageType_OnlyImage)];
            }else {
                [self.imgTypes addObject:@(JXCategoryTitleImageType_OnlyTitle)];
            }
        }];
        
        // 加载网络图片
        self.categoryView.loadImageCallback = ^(UIImageView *imageView, NSURL *imageURL) {
            [imageView sd_setImageWithURL:imageURL];
        };
        
        // 刷新标题
        self.categoryView.titles = self.titles;
        self.categoryView.imageURLs = self.imgUrls;
        self.categoryView.selectedImageURLs = self.imgSelectUrls;
        self.categoryView.imageTypes = self.imgTypes;
        [self.categoryView reloadData];
        
        // 刷新内容
        [self.containerView reloadData];
        
        // 默认选中第一个
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self categoryView:self.categoryView didSelectedItemAtIndex:0];
        });
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)changeToWhiteStateAtVC:(GKListViewController *)vc {
    if (self.style == GKHomeThemeStyleWhite) return;
    self.style = GKHomeThemeStyleWhite;
    
    // 状态栏改变
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    
    // 标签栏改变
    self.categoryView.titleColor = [UIColor whiteColor];
    self.categoryView.titleSelectedColor = [UIColor whiteColor];
    self.lineView.indicatorColor = [UIColor whiteColor];
    [self.categoryView refreshCellState];
    
    if (vc) {
        vc.isCriticalPoint = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.coverView.hidden = NO;
            self.headerBgView.backgroundColor = vc.bgColor;
        }];
    }
}

- (void)changeToBlackStateAtVC:(GKListViewController *)vc {
    if (self.style == GKHomeThemeStyleBlack) return;
    self.style = GKHomeThemeStyleBlack;
    
    // 状态栏改变
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    
    // 标签栏改变
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleSelectedColor = [UIColor blackColor];
    self.lineView.indicatorColor = [UIColor redColor];
    [self.categoryView refreshCellState];
    
    // 背景
    if (vc) {
        vc.isCriticalPoint = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.coverView.hidden = YES;
            self.headerBgView.backgroundColor = [UIColor whiteColor];
        }];
    }
}

#pragma mark - JXCateogryViewDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%zd", index);
    
    // 取消所有的选中
    [self.containerView.validListDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, id<JXCategoryListCollectionContentViewDelegate>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GKListViewController class]]) {
            GKListViewController *listVC = (GKListViewController *)obj;
            listVC.isSelected = NO;
        }
    }];
    
    // 选中当前
    UIViewController *vc = (UIViewController *)self.containerView.validListDict[@(index)];
    if ([vc isKindOfClass:[GKListViewController class]]) {
        GKListViewController *listVC = (GKListViewController *)vc;
        listVC.isSelected = YES;
        [listVC loadData];
    }
    GKListViewController *listVC = (GKListViewController *)self.containerView.validListDict[@(index)];
    listVC.isSelected = YES;
    [listVC loadData];
    
    if (listVC.isCriticalPoint) {
        [self changeToBlackStateAtVC:listVC];
    }else {
        [self changeToWhiteStateAtVC:listVC];
    }
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
    GKListViewController *leftVC  = (GKListViewController *)self.containerView.validListDict[@(leftIndex)];
    GKListViewController *rightVC = (GKListViewController *)self.containerView.validListDict[@(rightIndex)];
    
    UIColor *leftColor  = leftVC.isCriticalPoint ? [UIColor whiteColor] : leftVC.bgColor;
    UIColor *rightColor = rightVC.isCriticalPoint ? [UIColor whiteColor] : rightVC.bgColor;
    
    UIColor *color = [JXCategoryFactory interpolationColorFrom:leftColor to:rightColor percent:ratio];
    
    self.headerBgView.backgroundColor = color;
    
    // 两边状态一样，不用改变
    if (leftVC.isCriticalPoint == rightVC.isCriticalPoint) return;
    
    if (leftVC.isCriticalPoint) {
        if (ratio > 0.5) {
            [self changeToWhiteStateAtVC:nil];
        }else {
            [self changeToBlackStateAtVC:nil];
        }
    }else if (rightVC.isCriticalPoint) {
        if (ratio > 0.5) {
            [self changeToBlackStateAtVC:nil];
        }else {
            [self changeToWhiteStateAtVC:nil];
        }
    }
}

#pragma mark - JXCategoryListCollectionContainerViewDataSource
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListCollectionContainerView *)listContainerView {
    return self.titles.count;
}

- (id<JXCategoryListCollectionContentViewDelegate>)listContainerView:(JXCategoryListCollectionContainerView *)listContainerView initListForIndex:(NSInteger)index {
    GKListViewController *listVC = [GKListViewController new];
    listVC.delegate = self;
    listVC.categoryModel = self.model.customCategoryList[index];
    listVC.bgColor = GKHomeBGColor; // 设置默认颜色
    
    return listVC;
}

#pragma mark - GKListContainerViewDelegate
- (void)scrollWillBegin {
    // 开始滑动，开始定时器
    [self.containerView.validListDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, id<JXCategoryListCollectionContentViewDelegate>  _Nonnull obj, BOOL * _Nonnull stop) {
        GKListViewController *listVC = (GKListViewController *)obj;
        [listVC stopScroll];
    }];
}

- (void)scrollDidEnded {
    // 结束滚动，停止定时器
    GKListViewController *currentVC = (GKListViewController *)self.containerView.validListDict[@(self.categoryView.selectedIndex)];
    [currentVC startScroll];
}

#pragma mark - GKListViewControllerDelegate
- (void)listVC:(GKListViewController *)vc didChangeColor:(UIColor *)color {
    self.headerBgView.backgroundColor = color;
}

- (void)listVC:(GKListViewController *)vc didScroll:(UIScrollView *)scrollView {
    if (self.style == GKHomeThemeStyleNone) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) return;
    
    if (offsetY > ADAPTATIONRATIO * 300.0f) {
        [self changeToBlackStateAtVC:vc];
    }else {
        [self changeToWhiteStateAtVC:vc];
    }
}

#pragma mark - 懒加载
- (UIView *)headerBgView {
    if (!_headerBgView) {
        _headerBgView = [UIView new];
        _headerBgView.backgroundColor = GKHomeBGColor;
    }
    return _headerBgView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.3;
    }
    return _coverView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (JXCategoryTitleImageView *)categoryView {
    if (!_categoryView) {
        _categoryView = [JXCategoryTitleImageView new];
        _categoryView.delegate              = self;
        _categoryView.backgroundColor       = [UIColor clearColor];
        _categoryView.titleFont             = [UIFont systemFontOfSize:14.0f];
        _categoryView.titleSelectedFont     = [UIFont boldSystemFontOfSize:16.0f];
        _categoryView.titleColor            = [UIColor whiteColor];
        _categoryView.titleSelectedColor    = [UIColor whiteColor];
        _categoryView.imageSize             = CGSizeMake(46.0f, 28.0f);
        _categoryView.imageZoomEnabled      = YES;  // 图片缩放
        _categoryView.imageZoomScale        = 1.3;  // 图片缩放程度
        _categoryView.titleLabelZoomEnabled = YES;  // 标题缩放
        _categoryView.titleLabelZoomScale   = 1.3;  // 标题缩放程度
        _categoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
        _categoryView.titleLabelAnchorPointStyle = JXCategoryTitleLabelAnchorPointStyleBottom;
        
        _categoryView.indicators    = @[self.lineView];
        
        _categoryView.contentScrollView = self.containerView.collectionView;
    }
    return _categoryView;
}

- (JXCategoryIndicatorLineView *)lineView {
    if (!_lineView) {
        _lineView = [JXCategoryIndicatorLineView new];
        _lineView.indicatorWidth     = ADAPTATIONRATIO * 40.0f;
        _lineView.indicatorHeight    = ADAPTATIONRATIO * 8.0f;
        _lineView.indicatorColor     = [UIColor whiteColor];
        _lineView.lineStyle          = JXCategoryIndicatorLineStyle_Lengthen;
    }
    return _lineView;
}

- (JXCategoryListCollectionContainerView *)containerView {
    if (!_containerView) {
        _containerView = [GKListContainerView new];
        _containerView.dataSource = self;
        _containerView.delegate = self;
        _containerView.collectionView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [NSMutableArray new];
    }
    return _titles;
}

- (NSMutableArray *)imgUrls {
    if (!_imgUrls) {
        _imgUrls = [NSMutableArray new];
    }
    return _imgUrls;
}

- (NSMutableArray *)imgSelectUrls {
    if (!_imgSelectUrls) {
        _imgSelectUrls = [NSMutableArray new];
    }
    return _imgSelectUrls;
}

- (NSMutableArray *)imgTypes {
    if (!_imgTypes) {
        _imgTypes = [NSMutableArray new];
    }
    return _imgTypes;
}

@end
