//
//  ZCLeftTitleButton.h
//  ZCCollectionView
//
//  Created by wzc on 2021/3/19.
//

#import <UIKit/UIKit.h>

/**
 /// 使用方法
 ZCLeftTitleButton *btn = [[ZCLeftTitleButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
 btn.textLabel.text = @"测试";
 btn.imgView.image  = [UIImage imageNamed:@"sch_staff_recommend_people"];
 //btn.imgWidth  = 10; 
 btn.textAndImgGap  = 5;
 btn.contentEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
 btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
 [self.view addSubview:btn];
 */

IB_DESIGNABLE

@interface ZCLeftTitleButton : UIButton

@property(nonatomic, strong) UILabel *textLabel;

@property(nonatomic, strong) UIImageView *imgView;


/// 设置文字图片间距
@property(nonatomic, assign) IBInspectable CGFloat textAndImgGap;
/// 图片高度，默认取imgView.image宽度
@property(nonatomic, assign) IBInspectable CGFloat imgWidth;


/// 手动刷新frame(基本不用用到)
- (void)updateView;

@end
