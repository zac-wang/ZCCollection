//
//  ZCMultiLabel.m
//  ZCCollectionView
//
//  Created by wzc on 2021/1/20.
//  Copyright © 2021 Gome. All rights reserved.
//

#import "ZCMultiLabel.h"


@interface GMMSCHomeCellMultiLabelModel ()
- (void)sendClickEvent;
@end


@interface ZCMultiLabelCell : UICollectionViewCell

@property(nonatomic, strong) GMMSCHomeCellMultiLabelModel *model;

@property(nonatomic, strong) UILabel *textLabel;

@property(nonatomic, strong) UIImageView *imgView;

@end

@implementation ZCMultiLabelCell

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
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

- (void)setModel:(GMMSCHomeCellMultiLabelModel *)model {
    _model = model;
    
    self.textLabel.hidden = YES;
    self.imgView.hidden = YES;
    
    if ([model.source isKindOfClass:[NSAttributedString class]]) {
        self.textLabel.hidden = NO;
        
        self.textLabel.attributedText = model.source;
    } else if ([model.source isKindOfClass:[UIImage class]]) {
        self.imgView.hidden = NO;
        
        self.imgView.image = (UIImage *)model.source;
    }
    
    self.textLabel.layer.borderColor  = model.borderColor.CGColor;
    self.textLabel.layer.cornerRadius = model.cornerRadius;
    self.textLabel.layer.borderWidth  = model.cornerRadius > 0 ? 0.5 : 0;
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

- (void)setSourceArray:(NSArray<GMMSCHomeCellMultiLabelModel *> *)sourceArray {
    _sourceArray = sourceArray;
    [self reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.sourceArray[indexPath.row].cellSize;
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
    cell.model = self.sourceArray[indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout minimumInteritemSpacing];
}

#pragma mark 选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GMMSCHomeCellMultiLabelModel *model = self.sourceArray[indexPath.row];
    [model sendClickEvent];
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

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    
    [self setCollectionViewLayout:[[self class] getFlowLayout] animated:NO];
    [self setupCollection];

    NSMutableArray *arr = [NSMutableArray array];
    if (@available(iOS 13.0, *)) {
        [arr addObject:[GMMSCHomeCellMultiLabelModel source:[UIImage systemImageNamed:@"network"] imgHeight:13]];
    }
    [arr addObject:[GMMSCHomeCellMultiLabelModel sourceText:@"多标签" attributes:nil]];
    [arr addObject:[GMMSCHomeCellMultiLabelModel sourceText:@"展示" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}]];
    self.sourceArray = arr;
}

@end
