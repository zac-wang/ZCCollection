//
//  ZCMenuVC.m
//  ZCCollectionView
//
//  Created by wzc on 2022/7/26.
//

#import "ZCMenuVC.h"
#import "ZCMenuView.h"

@interface ZCMenuVC ()

/// 分类view
@property(nonatomic, strong) ZCMenuView *navBar;

@end

@implementation ZCMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *arr = @[@"全部", @"精选", @"热度", @"排名", @"人气"];
    
    self.navBar = [[ZCMenuView alloc] initWithFrame:CGRectMake(0, 100, 375, 45)];
    self.navBar.setupCellWidth = ^CGFloat(NSInteger index) { return 50.f; };
    [self.view addSubview:self.navBar];
    self.navBar.setupCellType = ^(ZCMenuViewCell * _Nonnull cell, NSInteger index, BOOL isSelect) {
        [cell.titleBtn setTitle:arr[index] forState:UIControlStateNormal];
    };
    self.navBar.selectIndexBlock = ^BOOL(int selectIndex) {
        NSLog(@"%d", selectIndex);
        return YES;
    };
    
    self.navBar.itemCount = (int)arr.count;
    [self.navBar reloadData];
}

@end
