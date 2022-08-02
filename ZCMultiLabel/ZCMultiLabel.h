//
//  ZCMultiLabel.h
//  ZCCollectionView
//
//  Created by wzc on 2021/1/20.
//  Copyright © 2021 Gome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCMultiLabelCell : UICollectionViewCell

@property(nonatomic, strong) UILabel *textLabel;

@property(nonatomic, strong) UIImageView *imgView;

@end



IB_DESIGNABLE

/// 多标签展示：支持文本、图片、NSAttributedString
@interface ZCMultiLabel : UICollectionView

+ (instancetype)multiLabelWithFrame:(CGRect)frame;

/// 布局属性
@property(nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;




/// 数据源 (文本、图片、NSAttributedString)
@property(nonatomic, strong) NSArray *sourceArray;

/// 样式
@property(nonatomic, copy) void(^setupStyle)(NSUInteger row, ZCMultiLabelCell *cell);

/// 不设置，则会自动设置大小 (不设置width，则会自动计算width)
@property(nonatomic, copy) void(^setupLayout)(NSUInteger row, CGFloat *height, CGFloat *width, CGFloat *paddingLR);

/// 设置item点击事件，与回调的model
@property(nonatomic, copy) void(^clickEvent)(NSUInteger row);




/// 未展示完全的标签，是否隐藏（默认展示）
@property(nonatomic, assign) IBInspectable BOOL hiddenLeakItem;

@end
