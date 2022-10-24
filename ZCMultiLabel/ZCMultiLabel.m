//
//  ZCMultiLabel.m
//  ZCCollectionView
//
//  Created by wzc on 2021/1/20.
//  Copyright © 2021 Gome. All rights reserved.
//

#import "ZCMultiLabel.h"

@implementation ZCMultiLabelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _button.titleLabel.font = [UIFont systemFontOfSize:10.f];
        _button.userInteractionEnabled = NO;
        [_button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
    return _button;
}

- (void)setSource:(id)source {
    _source = source;
    if ([source isKindOfClass:[NSAttributedString class]]) {
        [self.button setAttributedTitle:source forState:UIControlStateNormal];
    } else if ([source isKindOfClass:[NSString class]]) {
        [self.button setTitle:source forState:UIControlStateNormal];
    } else if ([source isKindOfClass:[UIImage class]]) {
        [self.button setImage:(UIImage *)source forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    self.button.frame = self.bounds;
}

- (CGSize)cellSize:(CGSize)maxSize {
    if (([_source isKindOfClass:[NSAttributedString class]] || [_source isKindOfClass:[NSString class]])
        && [(NSString *)_source length] > 0) {
        CGSize size = [self.button.titleLabel textRectForBounds:CGRectMake(0, 0, maxSize.width, maxSize.height) limitedToNumberOfLines:self.button.titleLabel.numberOfLines].size;
        return size;
    } else if ([_source isKindOfClass:[UIImage class]]) {
        CGSize size = [(UIImage *)_source size];
        if (size.height > 0) {
            return CGSizeMake(size.width/size.height*maxSize.height, maxSize.height);
        }
    }
    return CGSizeZero;
}

@end

@interface ZCMultiLabel ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property(nonatomic, strong) ZCMultiLabelCell *calculateLayoutCell;

@end

#define GMKSCHomeCellReuseIdentifier @"ReuseIdentifier"

@implementation ZCMultiLabel
@dynamic collectionViewLayout;

+ (instancetype)multiLabelWithFrame:(CGRect)frame {
    ZCMultiLabel *collectionView = [[self alloc] initWithFrame:frame collectionViewLayout:[self getFlowLayout]];
    [collectionView setupCollection];
    return collectionView;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setCollectionViewLayout:[[self class] getFlowLayout] animated:NO];
        [self setupCollection];
    }
    return self;
}

+ (UICollectionViewFlowLayout *)getFlowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    return layout;
}

- (void)setupCollection {
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = NO;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;

    [self registerClass:[ZCMultiLabelCell class] forCellWithReuseIdentifier:GMKSCHomeCellReuseIdentifier];
}

- (void)setSourceArray:(NSArray *)sourceArray {
    _sourceArray = sourceArray;
    [self reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.calculateLayoutCell.source = self.sourceArray[indexPath.row];
    if (self.setupStyle) self.setupStyle(indexPath.row, self.calculateLayoutCell);
    CGSize maxSize = self.frame.size;
    if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *layout = self.collectionViewLayout;
        maxSize.height -= layout.sectionInset.top + layout.sectionInset.bottom;
    }
    CGSize itemSize = [self.calculateLayoutCell cellSize:maxSize];
    
    if (self.setupLayoutSize) {
        return self.setupLayoutSize(indexPath.row, itemSize);
    }
    return itemSize;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCMultiLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GMKSCHomeCellReuseIdentifier forIndexPath:indexPath];
    cell.source = self.sourceArray[indexPath.row];
    if (self.setupStyle) self.setupStyle(indexPath.row, cell);
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout minimumInteritemSpacing];
}

#pragma mark 选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickEvent) {
        self.clickEvent(indexPath.row);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hiddenLeakItem) {
        cell.hidden = CGRectGetMaxX(cell.frame) > self.frame.size.width;
    }
}

/*
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}
*/

- (ZCMultiLabelCell *)calculateLayoutCell {
    if (!_calculateLayoutCell) {
        _calculateLayoutCell = [[ZCMultiLabelCell alloc] initWithFrame:self.bounds];
    }
    return _calculateLayoutCell;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    
    [self setCollectionViewLayout:[[self class] getFlowLayout] animated:NO];
    if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        [(UICollectionViewFlowLayout *)self.collectionViewLayout setSectionInset:UIEdgeInsetsMake(2, 0, 2, 0)];
    }
    [self setupCollection];

    NSMutableArray *arr = [NSMutableArray array];
    if (@available(iOS 13.0, *)) {
        [arr addObject:[UIImage systemImageNamed:@"network"]];
    }
    [arr addObjectsFromArray:@[@"多标签", @"展示"]];
    self.sourceArray = arr;
}

@end
