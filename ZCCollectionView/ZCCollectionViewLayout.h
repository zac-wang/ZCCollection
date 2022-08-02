//
//  ZCCollectionViewLayout.h
//  ZCCollectionView
//
//  Created by wzc on 2021/4/14.
//

#import <UIKit/UIKit.h>
#import "ZCCollectionBackView.h"

typedef NS_ENUM(NSInteger, ZCCollectionBackStyle) {
    /// 无背景
    ZCCollectionBackStyleNone = 0,
    /// 背景仅覆盖item
    ZCCollectionBackStyleSectionAllItem,
    /// 背景覆盖head和item
    ZCCollectionBackStyleSectionHeadAndItem,
    /// 背景覆盖head到footer
    ZCCollectionBackStyleSectionHeadToFoot,
};

@protocol ZCCollectionViewDelegateLayout <UICollectionViewDelegateFlowLayout>

@optional
/// 设置背景（支持圆角、渐变色、阴影）, 不实现无背景
- (ZCCollectionBackStyle)collectionView:(UICollectionView *)collectionView setupBackgound:(ZCCollectionBackView *)backView forSection:(NSUInteger)section;

@end




@interface ZCCollectionViewLayout : UICollectionViewFlowLayout

/// 不够一页时也可以下拉 (否则此时无法下拉 触发下拉刷新事件), 默认不处理
@property(nonatomic, assign) BOOL autoInsatiableScroll;

/// 设置列数
@property(nonatomic, copy) NSUInteger(^getLineMaxCountForSection)(NSUInteger section);

@end

