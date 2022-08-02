//
//  ZCCollectionBackView.m
//  ZCCollectionView
//
//  Created by wzc on 2022/7/28.
//

#import "ZCCollectionBackView.h"
#import "ZCCollectionViewLayoutAttributes.h"
#import "ZCCollectionViewLayout.h"

@implementation ZCCollectionBackView
@dynamic layer;

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)applyLayoutAttributes:(ZCCollectionViewLayoutAttributes *)layoutAttributes {
    if ([layoutAttributes isKindOfClass:[ZCCollectionViewLayoutAttributes class]]) {
        UICollectionView *collectionView = layoutAttributes.layout.collectionView;
        id<ZCCollectionViewDelegateLayout> delegate = (id<ZCCollectionViewDelegateLayout>)collectionView.delegate;
        if ([delegate respondsToSelector:@selector(collectionView:setupBackgound:forSection:)]) {
            [delegate collectionView:collectionView setupBackgound:self forSection:layoutAttributes.indexPath.section];
        }
    }
}

@end
