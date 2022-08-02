//
//  ZCSwipeVC.m
//  ZCCollectionView
//
//  Created by wzc on 2021/9/2.
//

#import "ZCSwipeVC.h"
#import "ZCSwipeViewCell.h"
#import "ZCSwipeView.h"

#define MyCell   @"MyCell"

@interface ZCSwipeVC ()
<UICollectionViewDelegate,
UICollectionViewDataSource
>
@property(nonatomic, strong) ZCSwipeView *exchangeView;

@end

@implementation ZCSwipeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exchangeView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
        self.exchangeView.frame = CGRectMake(0, safeAreaInsets.top, screenSize.width, screenSize.height - safeAreaInsets.top - safeAreaInsets.bottom);
    }
    self.exchangeView.delegate = self;
    self.exchangeView.dataSource = self;
}

- (IBAction)reload:(UIBarButtonItem *)sender {
    [[(ZCSwipeViewCell *)self.exchangeView.nowShowCell itemVC].collectionView reloadData];
}
#pragma mark - 懒加载
- (UICollectionView *)exchangeView {
    if (_exchangeView == nil) {
        _exchangeView = [ZCSwipeView exchangeView];
        [_exchangeView registerClass:[ZCSwipeViewCell class] forCellWithReuseIdentifier:MyCell];
        [self.view addSubview:_exchangeView];
    }
    
    return _exchangeView;
}

- (IBAction)showTargetIndex:(UIBarButtonItem *)sender {
    [self.exchangeView scrollToItemAtIndex:2];
}

#pragma mark - UICollectionViewDataSource
// 设置组数（默认1组）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView { return 1; }

// 每组中cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZCSwipeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyCell forIndexPath:indexPath];
    cell.itemVC.indexPath = indexPath;
    cell.itemVC.model = self.exchangeView.exchangeModel[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(ZCSwipeViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    cell.itemVC.collectionView.contentOffset = self.exchangeView.exchangeModel[indexPath.row].contentOffset;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(ZCSwipeViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    self.exchangeView.exchangeModel[indexPath.row].contentOffset = cell.itemVC.collectionView.contentOffset;
}

@end
