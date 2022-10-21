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
    __weak typeof(self)weakSelf = self;
    self.navBar.selectIndexBlock = ^(int selectIndex, int oldSelectIndex) {
        NSLog(@"%d", selectIndex);
        
        // 特殊场景：指定标签不需要被选中，执行特定操作
        if (selectIndex == 2) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.navBar.selectIndex = oldSelectIndex;
            });
        }
    };
    
    self.navBar.itemCount = (int)arr.count;
}

@end
