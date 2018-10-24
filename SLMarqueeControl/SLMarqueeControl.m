//
//  SLMarqueeControl.m
//  SLMarqueeControl
//
//  Created by sl on 2018/10/24.
//  Copyright © 2018年 WSonglin. All rights reserved.
//

#import "SLMarqueeControl.h"

static CGFloat const kLabelOffset = 20.f;

@interface SLMarqueeControl ()

@property (nonatomic, weak) UIView *innerContainer;
@property (nonatomic, weak) UILabel *label;

@end

@implementation SLMarqueeControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil
         ];
        
        [self.marqueeLabel addObserver:self
                            forKeyPath:@"text"
                               options:NSKeyValueObservingOptionNew
                               context:nil
         ];
        
        [self.marqueeLabel addObserver:self
                            forKeyPath:@"attributedText"
                               options:NSKeyValueObservingOptionNew
                               context:nil
         ];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [self startAnimation];
    }
    
    [super willMoveToWindow:newWindow];
}

+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}

#pragma mark - NSNotification
- (void)appBecomeActive:(NSNotification *)note {
    [self startAnimation];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self startAnimation];
}

#pragma mark - Private method
- (void)startAnimation {
    if (0 == CGRectGetWidth(self.bounds)
        || 0 == CGRectGetHeight(self.bounds)) {
        return;
    }
    
    [self.innerContainer.layer removeAnimationForKey:@"Marquee"];
    [self bringSubviewToFront:self.innerContainer];
    CGSize size = [self evaluateMarqueeLabelContentSize];
    
    for (UIView *view in self.innerContainer.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGRect rect = CGRectMake(0.f, 0.f, size.width + kLabelOffset, CGRectGetHeight(self.bounds));
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.marqueeLabel.text;
    label.attributedText = self.marqueeLabel.attributedText;
    
    [self.innerContainer addSubview:label];
    
    if (size.width > CGRectGetWidth(self.bounds)) {
        CGRect nextRect = rect;
        nextRect.origin.x = size.width + kLabelOffset;
        
        UILabel *nextLabel = [[UILabel alloc] initWithFrame:nextRect];
        nextLabel.backgroundColor = [UIColor clearColor];
        nextLabel.text = self.marqueeLabel.text;
        nextLabel.attributedText = self.marqueeLabel.attributedText;
        
        [self.innerContainer addSubview:nextLabel];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        animation.keyTimes = @[@0.f, @1.f];
        animation.duration = size.width / 50.f;
        animation.values = @[@0, @(-(size.width + kLabelOffset))];
        animation.repeatCount = INT16_MAX;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
        [self.innerContainer.layer addAnimation:animation forKey:@"Marquee"];
    } else {
        label.frame = self.bounds;
    }
}

- (CGSize)evaluateMarqueeLabelContentSize {
    CGSize size = CGSizeZero;
    if (self.marqueeLabel && self.marqueeLabel.text.length > 0) {
        size = [self.marqueeLabel.text sizeWithAttributes:@{NSFontAttributeName:self.marqueeLabel.font}];
    }
    
    return size;
}

#pragma mark - Getter
- (UILabel *)marqueeLabel {
    return self.label;
}

- (UIView *)innerContainer {
    if (!_innerContainer) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor clearColor];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:view];
        _innerContainer = view;
    }
    
    return _innerContainer;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        _label = label;
    }
    
    return _label;
}

@end
