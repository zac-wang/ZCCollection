//
//  ZCCollectionViewLayout+cache.m
//  ZCCollectionView
//
//  Created by wzc on 2022/7/20.
//

#import "ZCCollectionViewLayout+cache.h"
#import "ZCCollectionView.h"
#import "ZCCollectionBackView.h"


@implementation ZCCollectionViewLayout (cache)

#pragma mark -
+ (Class)layoutAttributesClass {
    return [ZCCollectionViewLayoutAttributes class];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerClass:[ZCCollectionBackView class] forDecorationViewOfKind:ZCCollectionElementKindSectionBackground];
    }
    return self;
}

#pragma mark -
- (UIEdgeInsets)getSectionInset:(NSUInteger)section {
    UIEdgeInsets sectionInset = self.sectionInset;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return sectionInset;
}

- (CGFloat)getMinimumLineSpacing:(NSUInteger)section {
    CGFloat minimumLineSpacing = self.minimumLineSpacing;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        minimumLineSpacing = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return minimumLineSpacing;
}

- (CGFloat)getMinimumInteritemSpacing:(NSUInteger)section {
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        minimumInteritemSpacing = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return minimumInteritemSpacing;
}

- (CGFloat)headViewHeight {
    CGFloat height = 0;
    if ([(ZCCollectionView *)self.collectionView respondsToSelector:@selector(headerView)]) {
        UIView *view = [(ZCCollectionView *)self.collectionView headerView];
        if (view) {
            height = view.frame.size.height;
        }
    }
    return height;
}

#pragma mark - 缓存
- (NSArray *)cacheAttributesList {
    return self.cacheFlowLayoutAttributes.allValues;
}

- (NSString *)cacheFlowLayoutAttributesKeyFor:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSString *Kind = elementKind ?: @"";
    NSString *key = [NSString stringWithFormat:@"%ld-%ld-%@", (long)indexPath.section, (long)indexPath.row, Kind];
    return key;
}

- (void)cacheFlowLayoutAttributes:(ZCCollectionViewLayoutAttributes *)att {
    NSString *key = [self cacheFlowLayoutAttributesKeyFor:att.representedElementKind atIndexPath:att.indexPath];
    if (att) {
        [self.cacheFlowLayoutAttributes setObject:att forKey:key];
    }
}

- (ZCCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self cacheFlowLayoutAttributesKeyFor:elementKind atIndexPath:indexPath];
    ZCCollectionViewLayoutAttributes *att = [self.cacheFlowLayoutAttributes objectForKey:key];
    if (!att) {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            att = (ZCCollectionViewLayoutAttributes *)[super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            att = (ZCCollectionViewLayoutAttributes *)[super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
        } else if ([elementKind isEqualToString:ZCCollectionElementKindSectionBackground]) {
            att = (ZCCollectionViewLayoutAttributes *)[ZCCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
            att.frame = ({CGRect r = att.frame; r.size = CGSizeMake(1, 1); r;});
        } else {
            att = (ZCCollectionViewLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
        }
        
        /// 无效元素忽略
        if (att.frame.size.width <= 0 || att.frame.size.height <= 0) {
            att = nil;
        } else if (att) {
            /// 去除警告
            att = [att copy];
            [self cacheFlowLayoutAttributes:att];
        }
    }
    return att;
}
#pragma mark -

@end
