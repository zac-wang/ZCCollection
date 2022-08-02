//
//  ZCLeftTitleButton.m
//  ZCCollectionView
//
//  Created by wzc on 2021/3/19.
//

#import "ZCLeftTitleButton.h"

#define GMK_Str_Not_Valid(str) ((!str) || (![str isKindOfClass:[NSString class]]) || ([str length] <= 0))
#define GMKCGRectRectify(_frame_) ({_frame_.size.width=MAX(_frame_.size.width,0);_frame_.size.height=MAX(_frame_.size.height,0);_frame_;})

@implementation ZCLeftTitleButton
@synthesize textAndImgGap, imgWidth;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:GMKCGRectRectify(frame)];
    if (self) {
        self.textAndImgGap  = 0;
        self.contentEdgeInsets = UIEdgeInsetsZero;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return self;
}

#pragma mark - View
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.text = @"";
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [_textLabel addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
        [_textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;
        [_imgView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (void)dealloc {
    [_textLabel removeObserver:self forKeyPath:@"attributedText"];
    [_textLabel removeObserver:self forKeyPath:@"text"];
    [_imgView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - 重写
- (void)setContentHorizontalAlignment:(UIControlContentHorizontalAlignment)align {
    super.contentHorizontalAlignment = align;
    [self updateView];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    super.contentEdgeInsets = contentEdgeInsets;
    [self updateView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"attributedText"]
        || [keyPath isEqualToString:@"text"]
        || [keyPath isEqualToString:@"image"]) {
        [self updateView];
    }
}

- (void)setFrame:(CGRect)frame {
    super.frame = GMKCGRectRectify(frame);
    [self updateView];
}

#pragma mark - 刷新布局
- (void)updateView {
    CGFloat textW = self.textSize.width;
    
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.frame = CGRectMake(self.contentX, self.contentY, textW, self.contentH);
        
        CGFloat imgX = CGRectGetMaxX(self.textLabel.frame) + self.textAndImgGap;
        self.imgView.frame = CGRectMake(imgX, self.contentY, self.imgWidth, self.contentH);
    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentCenter) {
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        CGFloat textX = (self.contentW - textW - self.textAndImgGap - self.imgWidth)/2 + self.contentX;
        self.textLabel.frame = CGRectMake(textX, self.contentY, textW, self.contentH);
        
        CGFloat imgX = CGRectGetMaxX(self.textLabel.frame) + self.textAndImgGap;
        self.imgView.frame = CGRectMake(imgX, self.contentY, self.imgWidth, self.contentH);
    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentFill) {
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        CGFloat textW = self.contentW - self.imgWidth - self.textAndImgGap;
        self.textLabel.frame = CGRectMake(self.contentX, self.contentY, textW, self.contentH);
        
        CGFloat imgX = self.contentX + self.contentW - self.imgWidth;
        self.imgView.frame = CGRectMake(imgX, self.contentY, self.imgWidth, self.contentH);
    } else if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
        CGFloat imgX = self.contentX + self.contentW - self.imgWidth;
        self.imgView.frame = CGRectMake(imgX, self.contentY, self.imgWidth, self.contentH);
        
        CGFloat textX = CGRectGetMinX(self.imgView.frame) - self.textAndImgGap - textW;
        self.textLabel.textAlignment = NSTextAlignmentRight;
        self.textLabel.frame = CGRectMake(textX, self.contentY, textW, self.contentH);
    }
}

#pragma mark -
- (CGFloat)contentX {
    return self.contentEdgeInsets.left;
}

- (CGFloat)contentY {
    return self.contentEdgeInsets.top;
}

- (CGFloat)contentW {
    return self.frame.size.width - self.contentX - self.contentEdgeInsets.right;
}

- (CGFloat)contentH {
    return self.frame.size.height - self.contentY - self.contentEdgeInsets.bottom;
}

/// 矫正
- (CGFloat)textAndImgGap {
    return (GMK_Str_Not_Valid(self.textLabel.text) || !self.imgView.image) ? 0 : textAndImgGap;
}

- (void)setTextAndImgGap:(CGFloat)gap {
    textAndImgGap = gap;
    [self updateView];
}

/// 图片宽度
- (CGFloat)imgWidth {
    return imgWidth ?: self.imgView.image.size.width;
}

- (void)setImgWidth:(CGFloat)width {
    imgWidth = width;
    [self updateView];
}

- (CGSize)textSize {
    if (self.textLabel.attributedText.length > 0 || self.textLabel.text.length > 0) {
        CGFloat textMaxWidth = self.contentW - self.textAndImgGap - self.imgWidth;
        CGRect rect = [self.textLabel textRectForBounds:CGRectMake(0, 0, textMaxWidth, self.contentH) limitedToNumberOfLines:self.textLabel.numberOfLines];
        return rect.size;
    }
    return CGSizeZero;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];

    if (GMK_Str_Not_Valid(self.textLabel.text)) self.textLabel.text = @"左标题，右图片";
    if (@available(iOS 13.0, *)) {
        self.imgView.image  = [UIImage systemImageNamed:@"network"];
    }
}

@end
