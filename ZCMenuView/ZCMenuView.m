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

- (void)setSelected:(BOOL)selected {
    self.titleBtn.titleLabel.font = selected ? [UIFont boldSystemFontOfSize:18] : [UIFont systemFontOfSize:15];
    [self.titleBtn setTitleColor:(selected ? [UIColor blackColor] : [UIColor grayColor]) forState:UIControlStateNormal];
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
    
    [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - 数据处理
- (void)setItemCount:(int)itemCount {
    _itemCount = itemCount;
    
    [self reloadData];
}

- (void)setSelectIndex:(int)selectIndex {
    [self updateSelectIndex:selectIndex isSelectItem:YES];
}

- (void)reloadData {
    [super reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectIndex inSection:0];
    [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
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
    cell.selected = self.selectIndex == indexPath.row;
    if (self.setupCellType) {
        self.setupCellType(cell, indexPath.row, self.selectIndex == indexPath.row);
    }
    return cell;
}

#pragma mark 选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateSelectIndex:(int)indexPath.row isSelectItem:NO];
}

- (void)updateSelectIndex:(int)selectIndex isSelectItem:(BOOL)isSelect {
    int oldIndex = _selectIndex;
    _selectIndex = selectIndex;
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:selectIndex inSection:0];
    if (isSelect) {
        [self selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    [self scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    if (self.selectIndexBlock) {
        self.selectIndexBlock(selectIndex, oldIndex);
    }
}

@end
