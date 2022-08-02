//
//  ZCSwipeView.h
//  ZCCollectionView
//
//  Created by wzc on 2022/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCSwipeItemModel : NSObject
@property(nonatomic, strong) id      model;
@property(nonatomic, assign) CGPoint contentOffset;
@end

@interface ZCSwipeModel : NSObject
- (ZCSwipeItemModel *)objectAtIndexedSubscript:(NSUInteger)idx;
- (ZCSwipeItemModel *)objectForKeyedSubscript:(id)key;
@end


@interface ZCSwipeView : UICollectionView

@property(class, nonatomic, readonly) ZCSwipeView *exchangeView;

@property(nonatomic, readonly) ZCSwipeModel *exchangeModel;

@property(nonatomic, readonly) NSIndexPath *nowIndexPath;

@property(nonatomic, readonly) UICollectionViewCell *nowShowCell;

- (void)scrollToItemAtIndex:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
