//
//  ZCCollectionView.h
//  ZCCollectionView
//
//  Created by wzc on 2021/4/14.
//

#import <UIKit/UIKit.h>


@interface ZCCollectionView : UICollectionView

/// 相当于UITableView的headerView
@property(nonatomic, strong) UIView *headerView;

- (void)newReloadData;

@end

