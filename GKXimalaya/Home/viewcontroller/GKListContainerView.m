//
//  GKListContainerView.m
//  GKXimalaya
//
//  Created by gaokun on 2019/4/1.
//  Copyright © 2019 gaokun. All rights reserved.
//

#import "GKListContainerView.h"

@interface GKListContainerView()<UIScrollViewDelegate>

@end

@implementation GKListContainerView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollWillBegin)]) {
        [self.delegate scrollWillBegin];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollDidEnded)]) {
        [self.delegate scrollDidEnded];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if ([self.delegate respondsToSelector:@selector(scrollDidEnded)]) {
            [self.delegate scrollDidEnded];
        }
    }
}

@end
