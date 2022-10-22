//
//  ZCCollectionVC.m
//  ZCCollectionView
//
//  Created by wzc on 2022/7/12.
//

#import "ZCCollectionVC.h"
#import "ZCCollectionViewLayout.h"

#define MyCell   @"MyCell"
#define MyHeader @"MyHeader"
#define MyFooter @"MyFooter"

@interface ZCCollectionVC ()
<UICollectionViewDelegate,
UICollectionViewDataSource
>

@end

@implementation ZCCollectionVC
@synthesize collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.frame = self.view.bounds;
}

#pragma mark -
- (ZCCollectionView *)collectionView {
    if (!collectionView) {
        //UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        ZCCollectionViewLayout *flowLayout = [[ZCCollectionViewLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 30);
        flowLayout.footerReferenceSize = CGSizeZero;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        flowLayout.sectionHeadersPinToVisibleBounds = YES;
        
        flowLayout.getLineMaxCountForSection = ^NSUInteger(NSUInteger section) {
            return section == 0 ? 1 : 5;
        };
        
        collectionView = [[ZCCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        if (@available(iOS 10.0, *)) {
            UIRefreshControl *refreshControl=[[UIRefreshControl alloc]init];
            refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
            [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
            collectionView.refreshControl = refreshControl;
        }
        
        // 注册cell
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MyCell];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyHeader];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MyFooter];
        
        [self.view addSubview:collectionView];
    }
    return collectionView;
}

- (void)setModel:(ZCSwipeItemModel *)model {
    _model = model;
    [self reloadData];
}

- (void)reloadData {
    [self.collectionView newReloadData];
}

- (void)refreshData:(CGRect)frame {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
        if (@available(iOS 10.0, *)) {
            [self.collectionView.refreshControl endRefreshing];
        }
    });
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? CGSizeMake(collectionView.frame.size.width-10, 50) : CGSizeMake(50, arc4random()%75+30);
}

// 动态设置cells的上下左右边界缩进
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(20, 20, 20, 20);
//}

// 动态设置cell行间的间距最小距离
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}

// 动态设置cell列间的间距最小距离
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 20;
//}

// 动态设置组头视图大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 33);
//}

// 动态设置组尾视图大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 33);
//}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? 3 : 19;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyCell forIndexPath:indexPath];
    cell.layer.cornerRadius = indexPath.section == 0 ? 12 : 0;
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%256)/255.f green:(arc4random()%256)/255.f blue:(arc4random()%256)/255.f alpha:1.f];
    if (!cell.backgroundView) cell.backgroundView = [[UILabel alloc] initWithFrame:CGRectZero];
    ((UILabel *)cell.backgroundView).textAlignment = NSTextAlignmentCenter;
    ((UILabel *)cell.backgroundView).text = [NSString stringWithFormat:@"%d-%d", (int)indexPath.section, (int)indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {          // Header视图
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyHeader forIndexPath:indexPath];
        headerView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        return headerView;
        
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {    // Footer视图
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MyFooter forIndexPath:indexPath];
        footerView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        return footerView;
    }
    
    return nil;
}

#pragma mark 选中
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中cell: %ld", indexPath.row);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (ZCCollectionBackStyle)collectionView:(UICollectionView *)collectionView setupBackgound:(ZCCollectionBackView *)backView forSection:(NSUInteger)section {
    if (section != 2) {
        return ZCCollectionBackStyleNone;
    }
    
//    backView.layer.backgroundColor = [UIColor orangeColor].CGColor;
    backView.layer.startPoint = CGPointMake(0, 0.5);
    backView.layer.endPoint = CGPointMake(1.0, 0.5);
    backView.layer.colors = @[(__bridge id)[[UIColor orangeColor] colorWithAlphaComponent:0.5].CGColor,(__bridge id)[[UIColor yellowColor] colorWithAlphaComponent:0.5].CGColor];
    backView.layer.cornerRadius = 20;
    return ZCCollectionBackStyleSectionAllItem;
}

@end
