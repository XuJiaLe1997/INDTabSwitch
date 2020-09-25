//
//  INDTabSwitchDemoVC.m
//  Indie
//
//  Created by guangzhuiyuandev on 2020/9/24.
//  Copyright © 2020 guangzhuiyuandev. All rights reserved.
//

#define Log(FORMAT, ...) [self logToString:[NSString stringWithFormat:FORMAT, ##__VA_ARGS__]]

#import "INDTabSwitchDemoVC.h"
#import "INDTabSwitchView.h"
#import "INDTabSwitchCell.h"

#import "UITextView+Attributed.h"

@interface INDTabSwitchDemoVC () <INDTabSwitchViewDataSource, INDTabSwitchViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *logLabel;
@property (weak, nonatomic) IBOutlet UITextView *logTextView;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) INDTabSwitchView *tabSwitch;

@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger state; // 某些状态

@end

@implementation INDTabSwitchDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    self.tabSwitch = ({
        INDTabSwitchView *tabSwitch = [[INDTabSwitchView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 40)];
        tabSwitch.duration = 0.2;
        tabSwitch.delegate = self;
        tabSwitch.dataSource = self;
        tabSwitch;
    });
    [self.containerView addSubview:self.tabSwitch];
    
    // 初始化到状态 1
    [self.tabSwitch selectItemAt:1 animated:NO];
    self.state = 1;
}

#pragma mark - INDTabSwitchViewDataSource
- (NSInteger)numberOfItems:(INDTabSwitchView *)tabSwitch {
    return self.count == 0 ? 3 : self.count;
}

- (CGFloat)tabSwitch:(INDTabSwitchView *)tabSwitch tabItemWidthFor:(NSInteger)index {
    return 60;
}

- (UIView<INDTabSwitchCellInterface> *)tabSwitch:(INDTabSwitchView *)tabSwitch tabItemViewFor:(NSInteger)index {
    INDTabSwitchCell *cell = [[INDTabSwitchCell alloc] init];
    [cell setText:@"测试"];
    return cell;
}

#pragma mark - INDTabSwitchViewDelegate
- (void)tabSwitch:(INDTabSwitchView *)tabSwitch didEndedDragAt:(NSInteger)index {}

- (void)tabSwitch:(INDTabSwitchView *)tabSwitch willSelectedItemAt:(NSInteger)index {}

- (void)tabSwitch:(INDTabSwitchView *)tabSwitch didSelectedItemAt:(NSInteger)index {
    if (index != self.state) {
        self.state = index;
        self.logLabel.text = [NSString stringWithFormat:@"状态 %lu", self.state];
        Log(@"选中%lu 切换到状态 %lu", index, self.state);
    } else {
        Log(@"选中%lu 不切换状态", index);
    }
}

#pragma mark -
- (void)logToString:(NSString *)s {
    static NSInteger count = 0;
    NSString *logStr = [NSString stringWithFormat:@"%ld: %@", (long)++count, s];
    self.logTextView.text = [[self.logTextView.text stringByAppendingString:logStr] stringByAppendingString:@"\n"];
    
    [self.logTextView setLineSpacing:4];
    [self.logTextView scrollRangeToVisible:NSMakeRange( self.logTextView.text.length, 1)];
    
}

#pragma mark -
- (IBAction)changeDataSource:(id)sender {
    NSInteger newCount = arc4random() % 9 + 1;
    while (newCount == self.count) {
        newCount = arc4random() % 9 + 1;
    }
    self.count = newCount;
    
    [self.tabSwitch reloadData];
    [self.tabSwitch selectItemAt:0 animated:NO];
}

@end
