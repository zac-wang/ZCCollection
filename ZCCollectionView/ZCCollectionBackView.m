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

- (void)applyLayoutAttributes:(ZCCollectionViewLayoutAttributes *)att {
    if ([att isKindOfClass:[ZCCollectionViewLayoutAttributes class]]) {
        id<ZCCollectionViewDelegateLayout> delegate = (id<ZCCollectionViewDelegateLayout>)att.collectionView.delegate;
        if ([delegate respondsToSelector:@selector(collectionView:setupBackgound:forSection:)]) {
            [delegate collectionView:att.collectionView setupBackgound:self forSection:att.indexPath.section];
        }
    }
}

@end
