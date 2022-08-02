//
//  ZCSwipeView.m
//  ZCCollectionView
//
//  Created by wzc on 2022/7/7.
//

#import "ZCSwipeView.h"

@implementation ZCSwipeItemModel
@end


@interface ZCSwipeModel()
@property(nonatomic, strong) NSMutableDictionary<NSNumber *, ZCSwipeItemModel *> *models;
@end

@implementation ZCSwipeModel
- (NSDictionary<NSNumber *,ZCSwipeItemModel *> *)models {
    if (!_models) {
        _models = [NSMutableDictionary dictionary];
    }
    return _models;
}
- (ZCSwipeItemModel *)objectAtIndexedSubscript:(NSUInteger)idx {
    return self[@(idx)];
}
- (ZCSwipeItemModel *)objectForKeyedSubscript:(id)key {
    ZCSwipeItemModel *itemModel = self.models[key];
    if (!itemModel) {
        itemModel = [[ZCSwipeItemModel alloc] init];
        [self.models setObject:itemModel forKey:key];
    }
    return itemModel;
}
@end



@implementation ZCSwipeView
@synthesize exchangeModel;

+ (ZCSwipeView *)exchangeView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    flowLayout.footerReferenceSize = CGSizeMake(0, 0);
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    ZCSwipeView *collectionView = [[ZCSwipeView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    return collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        exchangeModel = [[ZCSwipeModel alloc] init];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize = frame.size;
}

- (UICollectionViewCell *)nowShowCell {
    return self.visibleCells.firstObject;
}

- (void)scrollToItemAtIndex:(NSInteger)row {
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
    [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

@end
