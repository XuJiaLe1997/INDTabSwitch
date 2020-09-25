//
//  INDTabSwitchView.h
//  Indie
//
//  Created by guangzhuiyuandev on 2020/9/24.
//  Copyright © 2020 guangzhuiyuandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INDTabSwitchCell/INDTabSwitchCell.h"

NS_ASSUME_NONNULL_BEGIN

@class INDTabSwitchView;

@protocol INDTabSwitchViewDataSource <NSObject>
@required

- (NSInteger)numberOfItems:(INDTabSwitchView *)tabSwitch;
- (UIView<INDTabSwitchCellInterface> *)tabSwitch:(INDTabSwitchView *)tabSwitch tabItemViewFor:(NSInteger)index;
- (CGFloat)tabSwitch:(INDTabSwitchView *)tabSwitch tabItemWidthFor:(NSInteger)index;

@end

@protocol INDTabSwitchViewDelegate <NSObject>
@optional

- (void)tabSwitch:(INDTabSwitchView *)tabSwitch willSelectedItemAt:(NSInteger)index;    // 如果有动画，将在动画开始前调用
- (void)tabSwitch:(INDTabSwitchView *)tabSwitch didSelectedItemAt:(NSInteger)index;     // 如果有动画，将在动画结束后调用

- (void)tabSwitch:(INDTabSwitchView *)tabSwitch didEndedDragAt:(NSInteger)index;        // 拖动结束，拖动结束时会调用上面两个选中方法，故此方法不建议使用

@end

@interface INDTabSwitchView : UIView

@property (weak, nonatomic) id<INDTabSwitchViewDataSource> dataSource;
@property (weak, nonatomic) id<INDTabSwitchViewDelegate> delegate;

@property (nonatomic) NSTimeInterval duration; // 动画时间

- (void)selectItemAt:(NSInteger)index animated:(BOOL)animated; // 注意，会走delegate的选中方法选中方法
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
