//
//  ZCMenuView.m
//  ZCCollectionView
//
//  Created by wzc on 2021/9/4.
//  Copyright © 2021 Gome. All rights reserved.
//

#import "ZCMenuView.h"


@implementation ZCMenuViewCell
- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _titleBtn.userInteractionEnabled = NO;
        _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_titleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self addSubview:_titleBtn];
    }
    return _titleBtn;
}

- (void)setIsSelect:(BOOL)isSelect {
    self.titleBtn.titleLabel.font = isSelect ? [UIFont boldSystemFontOfSize:18] : [UIFont systemFontOfSize:15];
    [self.titleBtn setTitleColor:(isSelect ? [UIColor darkGrayColor] : [UIColor grayColor]) forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleBtn.frame = self.bounds;
}

@end



@interface ZCMenuView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>
@end


@implementation ZCMenuView

#pragma mark - 初始化视图、懒加载
- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        [self initMainViews];
    }
    return self;
}

- (void)initMainViews {
    self.delegate = self;
    self.dataSource = self;
    self.allowsSelection = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self registerClass:[ZCMenuViewCell class] forCellWithReuseIdentifier:@"MyCell"];
}

#pragma mark - 数据处理
- (void)setSelectIndex:(int)selectIndex {
    if (self.selectIndexBlock
        && !self.selectIndexBlock(selectIndex)) {
        return;
    }
    
    _selectIndex = selectIndex;
    
    [self reloadData];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:selectIndex inSection:0];
    [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellW = self.setupCellWidth ? self.setupCellWidth(indexPath.row) : 55.f;
    return CGSizeMake(cellW, self.frame.size.height);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCMenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    [cell setIsSelect:self.selectIndex == indexPath.row];
    if (self.setupCellType) {
        self.setupCellType(cell, indexPath.row, self.selectIndex == indexPath.row);
    }
    return cell;
}

#pragma mark 选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = (int)indexPath.row;
}

@end
