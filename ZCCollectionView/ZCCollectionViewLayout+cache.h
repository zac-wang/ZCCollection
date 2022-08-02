//
//  ZCCollectionViewLayout+cache.h
//  ZCCollectionView
//
//  Created by wzc on 2022/7/20.
//

// 内部处理方法，不希望被外部感知/代码提示

#import "ZCCollectionViewLayout.h"
#import "ZCCollectionViewLayoutAttributes.h"

#define GMKCollectionElementKindSectionBackground @"GMKCollectionElementKindSectionBackground"


@interface ZCCollectionViewLayout ()
@property(nonatomic, strong) NSMutableDictionary<NSString *, ZCCollectionViewLayoutAttributes *> *cacheFlowLayoutAttributes;
@end


@interface ZCCollectionViewLayout (cache)

/// 获取Section四周间距
- (UIEdgeInsets)getSectionInset:(NSUInteger)section;
/// 获取行间距
- (CGFloat)getMinimumLineSpacing:(NSUInteger)section;
/// 获取列间距
- (CGFloat)getMinimumInteritemSpacing:(NSUInteger)section;

/// 获取headView高度
- (CGFloat)headViewHeight;


/// 缓存池
@property(nonatomic, readonly) NSArray *cacheAttributesList;
- (ZCCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

@end
