//
//  ZCSwipeViewCell.m
//  ZCCollectionView
//
//  Created by wzc on 2022/7/7.
//

#import "ZCSwipeViewCell.h"

@interface ZCSwipeViewCell ()
@end

@implementation ZCSwipeViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemVC.view.frame = self.bounds;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    self.itemVC.view.frame = self.bounds;
    self.itemVC.collectionView.frame = self.bounds;
}

- (ZCCollectionVC *)itemVC {
    if (!_itemVC) {
        _itemVC = [[ZCCollectionVC alloc] init];
        [self addSubview:_itemVC.view];
    }
    return _itemVC;
}

@end
