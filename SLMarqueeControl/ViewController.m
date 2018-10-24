//
//  ViewController.m
//  SLMarqueeControl
//
//  Created by sl on 2018/10/24.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import "ViewController.h"
#import "SLMarqueeControl.h"

@interface ViewController ()

@property (nonatomic, weak) SLMarqueeControl *marqueeControl;
@property (nonatomic, weak) SLMarqueeControl *attrMarqueeControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 160.f, CGRectGetWidth(self.view.bounds), 30.f)];
    label.text = @"NSString类型：";
    [self.view addSubview:label];
    
    NSString *string = @"我是跑马灯，我只能不停的滚动才能体现我的价值！请注意，前方高能；呃、其实啥也没有~~~";
    self.marqueeControl.marqueeLabel.text = string;
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 300.f, CGRectGetWidth(self.view.bounds), 30.f)];
    label2.text = @"NSAttributedString类型：";
    [self.view addSubview:label2];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]}
                  range:NSMakeRange(5, 9)];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],
                          NSFontAttributeName:[UIFont systemFontOfSize:12.f]}
                  range:NSMakeRange(18, 8)];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]}
                  range:NSMakeRange(30, 6)];
    
    self.attrMarqueeControl.marqueeLabel.attributedText = attr;
}

#pragma mark - Getter
- (SLMarqueeControl *)marqueeControl {
    if (!_marqueeControl) {
        SLMarqueeControl *control = [[SLMarqueeControl alloc] initWithFrame:CGRectMake(0.f, 200.f, CGRectGetWidth(self.view.bounds), 40.f)];
        control.backgroundColor = [UIColor colorWithRed:30.f / 255 green:144.f / 255 blue:255.f / 255 alpha:1.f];
        [self.view addSubview:control];
        
        _marqueeControl = control;
    }
    
    return _marqueeControl;
}

- (SLMarqueeControl *)attrMarqueeControl {
    if (!_attrMarqueeControl) {
        SLMarqueeControl *control = [[SLMarqueeControl alloc] initWithFrame:CGRectMake(0.f, 340.f, CGRectGetWidth(self.view.bounds), 40.f)];
        control.backgroundColor = [UIColor colorWithRed:30.f / 255 green:144.f / 255 blue:255.f / 255 alpha:1.f];
        [self.view addSubview:control];
        
        _attrMarqueeControl = control;
    }
    
    return _attrMarqueeControl;
}

@end
