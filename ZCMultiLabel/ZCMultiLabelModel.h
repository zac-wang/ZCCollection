//
//  GMMSCHomeCellMultiLabelModel.h
//  ZCCollectionView
//
//  Created by wzc on 2021/3/4.
//
#import <Foundation/Foundation.h>

@interface GMMSCHomeCellMultiLabelModel : NSObject

/// 文本、图片、NSAttributedString
+ (instancetype)source:(id)source imgHeight:(CGFloat)imgHeight;
/// 文本
+ (instancetype)sourceText:(NSString *)text attributes:(NSDictionary<NSAttributedStringKey, id> *)attributes;


/// 文本、图片、NSAttributedString
@property(nonatomic, readonly) id source;


/// 设置边框颜色
@property(nonatomic, strong) UIColor *borderColor;

/// 设置内容左右间距, 默认3
@property(nonatomic, assign) CGFloat  cellPadding;

/// 设置圆角，默认2
@property(nonatomic, assign) CGFloat  cornerRadius;

/// 可设置cell大小，默认根据source自动计算
@property(nonatomic, assign) CGSize   cellSize;

/// 设置item点击事件，与回调的model
- (void)setClickEvent:(void(^)(id model))clickEvent andModel:(id)model;

@end
