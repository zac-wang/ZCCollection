//
//  ViewController.m
//  ZCCollectionView
//
//  Created by wzc on 2022/7/26.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "ZCMultiLabel.h"


@interface Test : NSObject
@property(nonatomic, copy) NSString *desc;
@end
@implementation Test
- (void)dealloc {
    NSLog(@"%@ 被释放了", self.desc?:@"");
}
@end


@interface ViewController ()
@property (weak, nonatomic) IBOutlet ZCMultiLabel *multiLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"多标签", @"展示", @"控件", nil];
    if (@available(iOS 13.0, *)) [arr addObject:[UIImage systemImageNamed:@"network"]];
    self.multiLabel.sourceArray = arr;
//    self.multiLabel.setupStyle = ^(NSUInteger row, ZCMultiLabelCell *cell) {
//        cell.textLabel.textColor = row%2 ? [UIColor orangeColor] : [UIColor grayColor];
//        cell.textLabel.layer.borderColor = cell.textLabel.textColor.CGColor;
//    };
    self.multiLabel.setupLayout = ^(NSUInteger row, CGFloat *height, CGFloat *width, CGFloat *paddingLR) {
        *height = 13.f;
        *paddingLR = 3.5f;
    };
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = [segue destinationViewController];
    
    Test *t = [[Test alloc] init];
    t.desc = NSStringFromClass(vc.class);
    objc_setAssociatedObject(vc, @"param", t, OBJC_ASSOCIATION_RETAIN);
}

@end
