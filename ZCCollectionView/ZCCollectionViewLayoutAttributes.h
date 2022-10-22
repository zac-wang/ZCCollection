//
//  ZCCollectionViewLayoutAttributes.h
//  ZCCollectionView
//
//  Created by wzc on 2021/4/14.
//

#import <UIKit/UIKit.h>

@class ZCCollectionViewLayout;
@interface ZCCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

/// 摆放在哪一列
@property(nonatomic, assign) NSUInteger column;

@property(nonatomic, weak  ) UICollectionView *collectionView;

@property(nonatomic, assign) CGFloat minFrameY;

@property(nonatomic, assign) CGFloat maxFrameY;

@end
