//
//  ZCCollectionView.m
//  ZCCollectionView
//
//  Created by wzc on 2021/4/14.
//

#import "ZCCollectionView.h"

@implementation ZCCollectionView

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    
    headerView.frame = ({CGRect r = headerView.frame; r.origin.y = 0; r;});
    
    [self addSubview:headerView];
}

- (void)newReloadData {
    [ZCCollectionView setAnimationsEnabled:NO];
    [self performBatchUpdates:^{
        [self reloadData];
    } completion:^(BOOL finished){
        [ZCCollectionView setAnimationsEnabled:YES];
    }];
}

@end
