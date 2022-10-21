//
//  ZCMenuView.h
//  ZCCollectionView
//
//  Created by wzc on 2021/9/4.
//  Copyright © 2021 Gome. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ZCMenuViewCell : UICollectionViewCell
@property(nonatomic, strong) UIButton *titleBtn;
@end




@interface ZCMenuView : UICollectionView

/// 设置选项个数，title在setupCellType中设置
@property(nonatomic, assign) int itemCount;

/// 设置选中的选项
@property(nonatomic, assign) int selectIndex;

/// 定制选项宽度
@property(nonatomic, copy) CGFloat(^setupCellWidth)(NSInteger index);

/// 定制选项 被选中/未选中 时的样式
@property(nonatomic, copy) void(^setupCellType)(ZCMenuViewCell *cell, NSInteger index, BOOL isSelect);


/// 选项被选中时的回调
@property(nonatomic, copy) void(^selectIndexBlock)(int selectIndex, int oldSelectIndex);

@end

NS_ASSUME_NONNULL_END
