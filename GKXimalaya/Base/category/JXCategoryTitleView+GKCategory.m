//
//  JXCategoryTitleView+GKCategory.m
//  GKXimalaya
//
//  Created by gaokun on 2019/4/12.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "JXCategoryTitleView+GKCategory.h"

@implementation JXCategoryTitleView (GKCategory)

- (void)refreshCellState {
    [self.dataSource enumerateObjectsUsingBlock:^(JXCategoryBaseCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self reloadCellAtIndex:idx];
    }];
    
    CGRect selectedCellFrame = CGRectZero;
    JXCategoryIndicatorCellModel *selectedCellModel = nil;
    for (int i = 0; i < self.dataSource.count; i++) {
        JXCategoryIndicatorCellModel *cellModel = (JXCategoryIndicatorCellModel *)self.dataSource[i];
        cellModel.sepratorLineShowEnabled = self.isSeparatorLineShowEnabled;
        cellModel.separatorLineColor = self.separatorLineColor;
        cellModel.separatorLineSize = self.separatorLineSize;
        cellModel.backgroundViewMaskFrame = CGRectZero;
        cellModel.cellBackgroundColorGradientEnabled = self.isCellBackgroundColorGradientEnabled;
        cellModel.cellBackgroundSelectedColor = self.cellBackgroundSelectedColor;
        cellModel.cellBackgroundUnselectedColor = self.cellBackgroundUnselectedColor;
        if (i == self.dataSource.count - 1) {
            cellModel.sepratorLineShowEnabled = NO;
        }
        if (i == self.selectedIndex) {
            selectedCellModel = cellModel;
            selectedCellFrame = [self getTargetCellFrame:i];
        }
    }
    
    for (UIView<JXCategoryIndicatorProtocol> *indicator in self.indicators) {
        if (self.dataSource.count <= 0) {
            indicator.hidden = YES;
        }else {
            indicator.hidden = NO;
            JXCategoryIndicatorParamsModel *indicatorParamsModel = [[JXCategoryIndicatorParamsModel alloc] init];
            indicatorParamsModel.selectedIndex = self.selectedIndex;
            indicatorParamsModel.selectedCellFrame = selectedCellFrame;
            [indicator jx_refreshState:indicatorParamsModel];
        }
    }
}

@end
