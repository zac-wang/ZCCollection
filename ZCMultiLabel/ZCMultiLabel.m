//
//  ZCMultiLabel.m
//  ZCCollectionView
//
//  Created by wzc on 2021/1/20.
//  Copyright © 2021 Gome. All rights reserved.
//

#import "ZCMultiLabel.h"

@implementation ZCMultiLabelCell

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor orangeColor];
        _textLabel.font = [UIFont systemFontOfSize:10.f];
        
        _textLabel.layer.borderColor  = [UIColor orangeColor].CGColor;
        _textLabel.layer.borderWidth  = 0.5f;
        _textLabel.layer.cornerRadius = 2.f;
        [self.contentView addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imgView];
    }
    return _imgView;
}

- (void)setSource:(id)source {
    if ([source isKindOfClass:[NSAttributedString class]]) {
        self.textLabel.hidden = NO;
        self.imgView.hidden = YES;
        
        self.textLabel.attributedText = source;
    } else if ([source isKindOfClass:[NSString class]]) {
        self.textLabel.hidden = NO;
        self.imgView.hidden = YES;
        
        self.textLabel.text = source;
    } else if ([source isKindOfClass:[UIImage class]]) {
        self.textLabel.hidden = YES;
        self.imgView.hidden = NO;
        
        self.imgView.image = (UIImage *)source;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = self.bounds;
    self.imgView.frame   = self.bounds;
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
    CGFloat cellHeight = self.frame.size.height - self.collectionViewLayout.sectionInset.top - self.collectionViewLayout.sectionInset.bottom;
    CGFloat cellWidth = 0.f;
    CGFloat cellPadding = 3.f;
    if (self.setupLayout) {
        self.setupLayout(indexPath.row, &cellHeight, &cellWidth, &cellPadding);
        
        /// 若设置了cell大小，则按照指定大小展示，否则根据source计算
        if (cellHeight > 0 && cellWidth > 0) {
            return CGSizeMake(cellWidth, cellHeight);
        }
    }
    
    id source = self.sourceArray[indexPath.row];
    if ([source isKindOfClass:[NSAttributedString class]]
        && [(NSAttributedString *)source length] > 0) {
        self.calculateLayoutCell.textLabel.attributedText = source;
        if (self.setupStyle) self.setupStyle(indexPath.row, self.calculateLayoutCell);
        CGRect rect = [self.calculateLayoutCell.textLabel textRectForBounds:CGRectMake(0, 0, self.frame.size.width, cellHeight) limitedToNumberOfLines:self.calculateLayoutCell.textLabel.numberOfLines];
        return CGSizeMake(rect.size.width + cellPadding*2, cellHeight);
    } else if ([source isKindOfClass:[NSString class]]) {
        self.calculateLayoutCell.textLabel.text = source;
        if (self.setupStyle) self.setupStyle(indexPath.row, self.calculateLayoutCell);
        CGRect rect = [self.calculateLayoutCell.textLabel textRectForBounds:CGRectMake(0, 0, self.frame.size.width, cellHeight) limitedToNumberOfLines:self.calculateLayoutCell.textLabel.numberOfLines];
        return CGSizeMake(rect.size.width + cellPadding*2, cellHeight);
    } else if ([source isKindOfClass:[UIImage class]]) {
        CGSize size = [(UIImage *)source size];
        if (size.height > 0) {
            return CGSizeMake(size.width/size.height*cellHeight + cellPadding*2, cellHeight);
        }
    }
    return CGSizeMake(0.0001, 0);
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
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
    [self setupCollection];

    NSMutableArray *arr = [NSMutableArray array];
    if (@available(iOS 13.0, *)) {
        [arr addObject:[UIImage systemImageNamed:@"network"]];
    }
    [arr addObjectsFromArray:@[@"多标签", @"展示"]];
    self.sourceArray = arr;
}

@end
