//
//  GKListViewController.m
//  GKXimalaya
//
//  Created by gaokun on 2019/3/29.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "GKListViewController.h"
#import "GKHttpRequestTool.h"
#import "GKHomeBannerModel.h"
#import "GKHomeBannerViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <JXCategoryViewExt/JXCategoryView.h>
#import "UIImage+Palette.h"
#import "UIColor+GKCategory.h"
#import <GKCycleScrollView/GKCycleScrollView.h>

#define kBannerW (kScreenW - ADAPTATIONRATIO * 60.0f)
#define kBannerH kBannerW * 335.0f / 839.0f

@interface GKListViewController ()<UITableViewDataSource, UITableViewDelegate, JXCategoryViewDelegate, GKCycleScrollViewDataSource, GKCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic, strong) GKCycleScrollView *bannerScrollView;
@property (nonatomic, strong) UIPageControl     *pageControl;

@property (nonatomic, assign) NSInteger         *count;

@property (nonatomic, strong) NSMutableArray<GKHomeBannerModel *> *bannerLists;

@property (nonatomic, assign) CGFloat           lastOffsetX;
@property (nonatomic, assign) NSInteger         scrollingIndex;

@property (nonatomic, assign) BOOL              isAppear;
@property (nonatomic, assign) BOOL              isLoaded;

@end

@implementation GKListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationBar.hidden = YES;
    self.bgColor = GKColorRGB(92, 88, 89);
    self.titleColor = [UIColor whiteColor];
    self.scrollingIndex = -1;   // 默认是-1
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView reloadData];
}

#pragma mark - Public Methods
- (void)loadData {
    if (self.isLoaded) return;
    self.isLoaded = YES;
    [self getData];
}

- (void)getData {
    // 是否是推荐
    if ([self.categoryModel.cat_id isEqualToString:@"recommend"]) {
        NSString *url = @"http://mobile.ximalaya.com/discovery-feed/v3/mix/ts-1554023437223?appid=0&scale=2&outSideNewUser=false&uid=105682927&version=6.5.63&channel=ios-b1&deviceId=7452C340-6659-4F0B-8BBA-5F7C45041255&xt=1554023437223&traitKey=&onlyBody=false&offset=30&operator=3&traitValue=&network=WIFI&code=43_110000_1100&device=iPhone&categoryId=-2";
        
        [GKHttpRequestTool getRequestWithUrl:url success:^(id  _Nonnull responseObject) {
            NSArray *data = responseObject[@"header"][0][@"item"][@"list"][0][@"data"];
            
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GKHomeBannerModel *model = [GKHomeBannerModel yy_modelWithDictionary:obj];
                [self.bannerLists addObject:model];
            }];
            
//            NSMutableArray *imgUrls = [NSMutableArray new];
//            [self.bannerLists enumerateObjectsUsingBlock:^(GKHomeBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [imgUrls addObject:obj.cover];
//            }];
//
//            // 轮播图
//             self.cycleScrollView.imageURLStringsGroup = imgUrls;
            self.pageControl.numberOfPages = self.bannerLists.count;
//            [self.flowView reloadData];
            [self.bannerScrollView reloadData];
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    }else if (self.categoryModel.categoryId.length > 0) { // 是否有分类id
        NSString *url = [NSString stringWithFormat:@"http://mobile.ximalaya.com/discovery-category/v3/category/recommend/ts-1554023897933?appid=0&device=iPhone&deviceId=7452C340-6659-4F0B-8BBA-5F7C45041255&gender=9&inreview=false&isHomepage=true&network=WIFI&operator=3&scale=2&uid=105682927&version=6.5.63&xt=1554023897934&categoryId=%@", self.categoryModel.categoryId];
        
        [GKHttpRequestTool getRequestWithUrl:url success:^(id  _Nonnull responseObject) {
            NSArray *data = responseObject[@"focusImages"][@"data"];
            
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GKHomeBannerModel *model = [GKHomeBannerModel yy_modelWithDictionary:obj];
                [self.bannerLists addObject:model];
            }];
            
            // 轮播图
            self.pageControl.numberOfPages = self.bannerLists.count;
//            [self.flowView reloadData];
            [self.bannerScrollView reloadData];
            
//            NSMutableArray *imgUrls = [NSMutableArray new];
//            [self.bannerLists enumerateObjectsUsingBlock:^(GKHomeBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [imgUrls addObject:obj.cover];
//            }];
//
//            // SDCycleScrollView
//             self.cycleScrollView.imageURLStringsGroup = imgUrls;
        } failure:^(NSError * _Nonnull error) {
            NSArray *banners = @[
                @"https://upload-images.jianshu.io/upload_images/1598505-a1be3eff58b036cf.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                @"https://upload-images.jianshu.io/upload_images/1598505-9d5fefd9e08c398b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                @"https://upload-images.jianshu.io/upload_images/1598505-594492e704dce1e8.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                @"https://upload-images.jianshu.io/upload_images/1598505-c57b15c77a047156.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                @"https://upload-images.jianshu.io/upload_images/1598505-ab4bfe225b394c9b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                @"https://upload-images.jianshu.io/upload_images/1598505-01ffc92bebb6a56e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
            
            [banners enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GKHomeBannerModel *model = [GKHomeBannerModel new];
                model.cover = obj;
                [self.bannerLists addObject:model];
//                if (idx == 0) {
//                    model.headerBgColor = UIColor.greenColor;
//                }else if (idx == banners.count - 1) {
//                    model.headerBgColor = UIColor.redColor;
//                }
            }];
            self.pageControl.numberOfPages = self.bannerLists.count;
            [self.bannerScrollView reloadData];
            
            self.bgColor = [self.bannerLists.firstObject headerBgColor];
        }];
    }else {
        NSString *headerBGColor = self.categoryModel.tabTheme[@"headerBGColor"];
        if (![headerBGColor isKindOfClass:[NSNull class]] && headerBGColor.length > 0) { // 是否有背景颜色
            self.bgColor = [UIColor colorWithHexString:headerBGColor];
            self.titleColor = self.bgColor;
            
            self.bannerScrollView.backgroundColor = self.bgColor;
        }else {
            self.bgColor = [UIColor whiteColor];
            self.titleColor = [UIColor blackColor];
            
            self.tableView.tableHeaderView = nil;
            [self.tableView reloadData];
        }
    }
}

- (void)startScroll {
//    [self.cycleScrollView startTimer];
//    [self.flowView startTimer];
    [self.bannerScrollView startTimer];
}

- (void)stopScroll {
//    [self.cycleScrollView stopTimer];
//    [self.flowView stopTimer];
    [self.bannerScrollView stopTimer];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    self.isAppear = YES;
}

- (void)listDidDisappear {
    self.isAppear = NO;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行", indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(listVC:didScroll:)]) {
        [self.delegate listVC:self didScroll:scrollView];
    }
}

//// 滑动-颜色渐变 - SDCyclScrollView处理方法
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScroll:(UIScrollView *)scrollView {
//    CGFloat offsetX = scrollView.contentOffset.x - scrollView.contentSize.width / 2;
//
//    CGFloat maxW = self.bannerLists.count * scrollView.bounds.size.width;
//
//    while (offsetX > maxW) offsetX = offsetX - maxW;    // 左滑
//    while (offsetX < 0) offsetX = offsetX + maxW;       // 右滑
//
//    CGFloat ratio = (offsetX/scrollView.bounds.size.width);
////    NSLog(@"%f", ratio);
//    if (ratio > self.bannerLists.count || ratio < 0) {
//        //超过了边界，不需要处理
//        return;
//    }
//    ratio = MAX(0, MIN(self.bannerLists.count, ratio));
//
//
//    NSInteger baseIndex = floorf(ratio);
//
//    if (baseIndex + 1 > self.bannerLists.count) {
//        //右边越界了，不需要处理
//        baseIndex = 0;
//    }
//    NSLog(@"%zd", baseIndex);
//
//    CGFloat remainderRatio = ratio - baseIndex;
//
//    if (remainderRatio <= 0 || remainderRatio >= 1) return; // 处理边界
//
//    GKHomeBannerModel *leftModel  = self.bannerLists[baseIndex];
//
//    NSInteger nextIndex = 0;
//    if (baseIndex == self.bannerLists.count - 1) {
//        nextIndex = 0;
//    }else {
//        nextIndex = baseIndex + 1;
//    }
//
//    GKHomeBannerModel *rightModel = self.bannerLists[nextIndex];
//
//    UIColor *leftColor  = leftModel.headerBgColor ? leftModel.headerBgColor : GKHomeBGColor;
//    UIColor *rightColor = rightModel.headerBgColor ? rightModel.headerBgColor : GKHomeBGColor;
//
//    UIColor *color = [JXCategoryFactory interpolationColorFrom:leftColor to:rightColor percent:remainderRatio];
//
//    self.bgColor = color;
//    if (self.isAppear && [self.delegate respondsToSelector:@selector(listVC:didChangeColor:)]) {
//        [self.delegate listVC:self didChangeColor:color];
//    }
//}
//
//// 自定义cell
//- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
//    return [GKHomeBannerViewCell class];
//}
//
//- (void)setupCustomCell:(GKHomeBannerViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
//    GKHomeBannerModel *model = self.bannerLists[index];
//
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        if (!model.headerBgColor) {
//            model.headerBgColor = [UIColor colorWithMostImage:image scale:0.05];
//
//            if (index == view.curIndex) {
//                self.bgColor = model.headerBgColor;
//
//                if ([self.delegate respondsToSelector:@selector(listVC:didChangeColor:)]) {
//                    [self.delegate listVC:self didChangeColor:self.bgColor];
//                }
//            }
////            model.headerBgColor = [self mainColorOfImage:image];
////            model.headerBgColor = [self mostColor:image scale:0.1];
//        }
//    }];
//}

#pragma mark - GKCycleScrollViewDataSource
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return self.bannerLists.count;
}

- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
        cell.tag = index;
        cell.layer.cornerRadius = 4.0f;
        cell.layer.masksToBounds = YES;
    }
    NSLog(@"%zd", index);
    GKHomeBannerModel *model = self.bannerLists[index];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!model.headerBgColor) {
            model.headerBgColor = [UIColor colorWithMostImage:image scale:0.05];
        }
        if (index == self.bannerScrollView.currentSelectIndex) {
            self.bgColor = model.headerBgColor;
            if ([self.delegate respondsToSelector:@selector(listVC:didChangeColor:)]) {
                [self.delegate listVC:self didChangeColor:self.bgColor];
            }
        }
    }];
    
    return cell;
}

#pragma mark - GKCycleScrollViewDelegate
- (CGSize)sizeForCellInCycleScrollView:(GKCycleScrollView *)cycleScrollView {
    return CGSizeMake(kBannerW, kBannerH);
}

- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView scrollingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex ratio:(CGFloat)ratio {
    if (self.isCriticalPoint) return;
    
    GKHomeBannerModel *leftModel = self.bannerLists[fromIndex];
    GKHomeBannerModel *rightModel = self.bannerLists[toIndex];
    
    UIColor *leftColor = leftModel.headerBgColor ? leftModel.headerBgColor : GKHomeBGColor;
    UIColor *rightColor = rightModel.headerBgColor ? rightModel.headerBgColor : GKHomeBGColor;
        
    UIColor *color = [JXCategoryFactory interpolationColorFrom:leftColor to:rightColor percent:ratio];
    self.bgColor = color;
    
    if (self.isSelected && [self.delegate respondsToSelector:@selector(listVC:didChangeColor:)]) {
        [self.delegate listVC:self didChangeColor:color];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, ADAPTATIONRATIO * 360.0f)];
        _headerView.backgroundColor = [UIColor clearColor];
        
//        [_headerView addSubview:self.cycleScrollView];
//        [_headerView addSubview:self.flowView];
        [_headerView addSubview:self.bannerScrollView];
    }
    return _headerView;
}

- (GKCycleScrollView *)bannerScrollView {
    if (!_bannerScrollView) {
        _bannerScrollView = [[GKCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, ADAPTATIONRATIO * 360.0f)];
        _bannerScrollView.dataSource = self;
        _bannerScrollView.delegate = self;
//        _bannerScrollView.topBottomMargin = ADAPTATIONRATIO * 16.0f;
        _bannerScrollView.leftRightMargin = ADAPTATIONRATIO * 60.0f;
        _bannerScrollView.minimumCellAlpha = 0.5f;
        [_bannerScrollView addSubview:self.pageControl];
        _bannerScrollView.pageControl = self.pageControl;
        CGPoint point = CGPointMake(kScreenW * 0.5f, ADAPTATIONRATIO * 300.0f);
        _pageControl.center = point;
    }
    return _bannerScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 0, kScreenW, 8.0f);
    }
    return _pageControl;
}

- (NSMutableArray *)bannerLists {
    if (!_bannerLists) {
        _bannerLists = [NSMutableArray new];
    }
    return _bannerLists;
}

@end
