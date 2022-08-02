//
//  ZCMultiLabel.h
//  ZCCollectionView
//
//  Created by wzc on 2021/1/20.
//  Copyright © 2021 Gome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCMultiLabelModel.h"

IB_DESIGNABLE

/// 多标签展示：支持文本、图片、NSAttributedString
@interface ZCMultiLabel : UICollectionView

+ (instancetype)multiLabelWithFrame:(CGRect)frame;

/// 布局属性
@property(nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

/// 数据源
@property(nonatomic, strong) NSArray<GMMSCHomeCellMultiLabelModel *> *sourceArray;

/// 未展示完全的标签，是否隐藏（默认展示）
@property(nonatomic, assign) IBInspectable BOOL hiddenLeakItem;

@end
