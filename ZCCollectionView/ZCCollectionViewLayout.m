//
//  ZCCollectionViewLayout.m
//  ZCCollectionView
//
//  Created by wzc on 2021/4/14.
//

#import "ZCCollectionViewLayout.h"
#import "ZCCollectionViewLayout+cache.h"


@interface ZCCollectionViewLayout ()
@property(nonatomic, assign) CGFloat contentMaxY;
@end

@implementation ZCCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.cacheFlowLayoutAttributes removeAllObjects];
    
    NSInteger sections = [self.collectionView numberOfSections];
    if (sections <= 0) {
        return;
    }
    
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    self.contentMaxY = self.headViewHeight;
    
    for (int section = 0; section < sections; section++) {
        CGFloat sectionStartY = self.contentMaxY;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        ZCCollectionViewLayoutAttributes *headerAtt = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (headerAtt != nil) {
            headerAtt.frame = ({CGRect r = headerAtt.frame; r.origin.y = self.contentMaxY; r;});
            self.contentMaxY = CGRectGetMaxY(headerAtt.frame);
        }
        
        CGFloat sectionItemStartY = self.contentMaxY;
        
        /// 列数
        NSUInteger lineMaxCount = self.getLineMaxCountForSection ? self.getLineMaxCountForSection(section) : 1;
        if (lineMaxCount <= 0) {
            lineMaxCount = 1;
        }
        
        /// 存储各列最短值
        NSMutableArray *topMinYArr = [NSMutableArray array];
        /// padding
        UIEdgeInsets sectionInset = [self getSectionInset:section];
        /// 行间距
        CGFloat minimumLineSpacing = [self getMinimumLineSpacing:section];
        /// 列间距
        CGFloat minimumInteritemSpacing = [self getMinimumInteritemSpacing:section];
        /// cellW
        CGFloat cellW = (collectionW - sectionInset.left - sectionInset.right + minimumInteritemSpacing)/lineMaxCount - minimumInteritemSpacing;
        
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        self.contentMaxY += sectionInset.top;
        for (int row = 0; row < rows; row++) {
            NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            ZCCollectionViewLayoutAttributes *rowAtt = [self layoutAttributesForSupplementaryViewOfKind:nil atIndexPath:rowIndexPath];
            if (!rowAtt) {
                continue;
            }
            
            /// 获取最短列对应originY
            NSUInteger topMinY = 0;
            if (topMinYArr.count < lineMaxCount) {
                rowAtt.column = topMinYArr.count;
                topMinY = self.contentMaxY;
            } else {
                NSNumber *minNum = [self getMinNumForNumAry:topMinYArr];
                rowAtt.column = [topMinYArr indexOfObject:minNum];
                topMinY = [minNum doubleValue] + minimumLineSpacing;
            }
            
            CGFloat rowX = sectionInset.left + (cellW + minimumInteritemSpacing) * rowAtt.column + (cellW-rowAtt.frame.size.width)/2;
            rowAtt.frame = ({CGRect r = rowAtt.frame; r.origin.y = topMinY; r.origin.x = rowX; r;});
            
            if (rowAtt.frame.size.height <= 0) {
                // 高度为0，忽略
            } else if (topMinYArr.count < lineMaxCount) {
                [topMinYArr addObject:@(CGRectGetMaxY(rowAtt.frame))];
            } else {
                [topMinYArr replaceObjectAtIndex:rowAtt.column withObject:@(CGRectGetMaxY(rowAtt.frame))];
            }
        }
        if (topMinYArr.count > 0) {
            /// topMinYArr个数不为0时，最大值才是有效的
            self.contentMaxY = [[topMinYArr valueForKeyPath:@"@max.floatValue"] doubleValue];
        }
        CGFloat sectionItemEndY = self.contentMaxY + sectionInset.bottom;
        
        ZCCollectionViewLayoutAttributes *footerAtt = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
        if (footerAtt != nil) {
            footerAtt.frame = ({CGRect r = footerAtt.frame; r.origin.y = sectionItemEndY; r;});
            self.contentMaxY = CGRectGetMaxY(footerAtt.frame);
        }
        
        /// 背景
        id<ZCCollectionViewDelegateLayout> delegate = (id<ZCCollectionViewDelegateLayout>)self.collectionView.delegate;
        if ([delegate respondsToSelector:@selector(collectionView:setupBackgound:forSection:)]) {
            ZCCollectionBackStyle style = [delegate collectionView:self.collectionView setupBackgound:nil forSection:section];
            
            if (style != ZCCollectionBackStyleNone) {
                ZCCollectionViewLayoutAttributes *backAttr = [self layoutAttributesForSupplementaryViewOfKind:GMKCollectionElementKindSectionBackground atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
                if (style == ZCCollectionBackStyleSectionHeadAndItem) {
                    backAttr.frame = CGRectMake(0, sectionStartY, collectionW, sectionItemEndY - sectionStartY);
                } else if (style == ZCCollectionBackStyleSectionHeadToFoot) {
                    backAttr.frame = CGRectMake(0, sectionStartY, collectionW, self.contentMaxY - sectionStartY);
                } else if (style == ZCCollectionBackStyleSectionAllItem) {
                    backAttr.frame = CGRectMake(0, sectionItemStartY, collectionW, sectionItemEndY - sectionItemStartY);
                }
                backAttr.zIndex = -1;
                backAttr.layout = self;
            }
        }
    }
}

- (NSNumber *)getMinNumForNumAry:(NSArray *)arr {
    NSNumber *minNum = arr.firstObject;
    for (NSNumber *num in arr) {
        if ([minNum doubleValue] > [num doubleValue]) {
            minNum = num;
        }
    }
    return minNum;
}

- (NSMutableDictionary<NSString *,ZCCollectionViewLayoutAttributes *> *)cacheFlowLayoutAttributes {
    if (!_cacheFlowLayoutAttributes) {
        _cacheFlowLayoutAttributes = [[NSMutableDictionary alloc] init];
    }
    return _cacheFlowLayoutAttributes;
}

#pragma mark -
/// 显示范围变化、Bounds变化、刷新时，重新进行布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

- (NSArray<ZCCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.cacheAttributesList;
}

/// 用来计算collectionView的contentSize
- (CGSize)collectionViewContentSize {
    CGFloat contentH = self.contentMaxY;
    if (self.autoInsatiableScroll) {
        /// contentSize不满一页，设置为collectionView.height以支持下拉刷新手势
        contentH = MAX(contentH, self.collectionView.frame.size.height);
    } else if (self.contentMaxY <= 0 || self.cacheAttributesList.count <= 0) {
        /// 无数据不支持滑动
        contentH = 0.f;
    }
    return CGSizeMake(self.collectionView.contentSize.width, contentH);
}

#pragma mark - 替换最终滑动的contentOffset, proposedContentOffset是预期滑动停止的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    return proposedContentOffset;
}

@end
