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
    
    NSMutableArray *arr = [NSMutableArray array];
    if (@available(iOS 13.0, *)) {
        [arr addObject:[GMMSCHomeCellMultiLabelModel source:[UIImage systemImageNamed:@"network"] imgHeight:13]];
    }
    [arr addObject:[GMMSCHomeCellMultiLabelModel sourceText:@"多标签" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    [arr addObject:[GMMSCHomeCellMultiLabelModel sourceText:@"展示" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    [arr addObject:[GMMSCHomeCellMultiLabelModel sourceText:@"控件" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    self.multiLabel.sourceArray = arr;
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
