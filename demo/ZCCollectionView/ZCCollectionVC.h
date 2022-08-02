//
//  ZCCollectionVC.h
//  ZCCollectionView
//
//  Created by wzc on 2022/7/12.
//

#import <UIKit/UIKit.h>
#import "ZCCollectionView.h"
#import "ZCSwipeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZCCollectionVC : UIViewController

@property(nonatomic, strong) NSIndexPath *indexPath;

@property(nonatomic, strong) ZCSwipeItemModel *model;

@property(nonatomic, readonly) ZCCollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
