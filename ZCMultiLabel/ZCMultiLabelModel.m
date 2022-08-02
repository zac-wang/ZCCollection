//
//  GMMSCHomeCellMultiLabelModel.m
//  ZCCollectionView
//
//  Created by wzc on 2021/3/4.
//

#import "ZCMultiLabelModel.h"

#define screenW [UIScreen mainScreen].bounds.size.width

@interface GMMSCHomeCellMultiLabelModel()
/// 监听点击事件，并设置触发事件回调的model
@property(nonatomic,  copy ) void(^clickEvent)(id model);
@property(nonatomic, strong) id clickEventModel;

/// 设置高度, 默认13
@property(nonatomic, assign) CGFloat  imgHeight;

@end

@implementation GMMSCHomeCellMultiLabelModel
@synthesize source;

+ (instancetype)source:(id)source imgHeight:(CGFloat)imgHeight {
    if ([source isKindOfClass:[NSString class]]) {
        return [self sourceText:source attributes:nil];
    }
    GMMSCHomeCellMultiLabelModel *model = [[GMMSCHomeCellMultiLabelModel alloc] init];
    model->source = source;
    model.imgHeight = imgHeight;
    return model;
}

+ (instancetype)sourceText:(NSString *)text attributes:(NSDictionary<NSAttributedStringKey,id> *)attributes {
    NSMutableDictionary *style = [[NSMutableDictionary alloc] initWithDictionary:attributes];
    if (!style[NSFontAttributeName]) {
        style[NSFontAttributeName] = [UIFont systemFontOfSize:10.f];
    }
    if (!style[NSForegroundColorAttributeName]) {
        style[NSForegroundColorAttributeName] = [UIColor orangeColor];
    }
    if (!style[NSParagraphStyleAttributeName]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        style[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    NSAttributedString *source = [[NSAttributedString alloc] initWithString:text attributes:style];
    
    GMMSCHomeCellMultiLabelModel *model = [[GMMSCHomeCellMultiLabelModel alloc] init];
    model->source = source;
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imgHeight = 13;
        self.cellPadding = 3;
        self.cornerRadius = 2;
    }
    return self;
}

- (UIColor *)borderColor {
    if (_borderColor) {
        return _borderColor;
    }
    if ([self.source isKindOfClass:[NSAttributedString class]]
        && [(NSAttributedString *)self.source length] > 0) {
        UIColor *color = [(NSAttributedString *)self.source attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
        return color;
    }
    return nil;
}

- (void)setClickEvent:(void (^)(id))clickEvent andModel:(id)model {
    self.clickEvent = clickEvent;
    self.clickEventModel = model;
}

- (void)sendClickEvent {
    if (self.clickEvent) {
        self.clickEvent(self.clickEventModel);
    }
}

- (CGSize)cellSize {
    CGFloat cellHeight = self.imgHeight ?: 13;
    
    /// 若设置了cell大小，则按照指定大小展示，否则根据source计算
    if (!CGSizeEqualToSize(_cellSize, CGSizeZero)) {
        return _cellSize;
    } else if ([self.source isKindOfClass:[NSAttributedString class]]
               && [(NSAttributedString *)self.source length] > 0) {
        NSAttributedString *att = self.source;
        CGSize size = [att boundingRectWithSize:CGSizeMake(screenW, cellHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        return CGSizeMake(size.width + self.cellPadding*2, cellHeight);
    } else if ([self.source isKindOfClass:[UIImage class]]) {
        CGSize size = [(UIImage *)self.source size];
        if (size.height > 0) {
            return CGSizeMake(size.width/size.height*cellHeight + self.cellPadding*2, cellHeight);
        }
    }
    return CGSizeMake(0.0001, 0);
}

@end
