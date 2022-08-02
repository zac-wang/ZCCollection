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

@property(nonatomic, weak  ) ZCCollectionViewLayout *layout;

@end
