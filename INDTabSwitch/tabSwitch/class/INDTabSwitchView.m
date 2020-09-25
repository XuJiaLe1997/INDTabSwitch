//
//  INDTabSwitchView.m
//  Indie
//
//  Created by guangzhuiyuandev on 2020/9/24.
//  Copyright © 2020 guangzhuiyuandev. All rights reserved.
//

#define weak(x)     __weak typeof(self) weakSelf = self
#define strong(x)   __strong typeof(weakSelf) self = weakSelf

#import "INDTabSwitchView.h"

@interface INDTabSwitchView ()

@property (strong, nonatomic) IBOutlet UIView *xibContentView;

@property (nonatomic) UIView *contentView;

@property (nonatomic) NSArray<UIGestureRecognizer *> *gestureArray;

@property (nonatomic) BOOL onceFlag;
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) CGPoint lastCenter;

@end

@implementation INDTabSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.xibContentView.frame = self.bounds;
    if (!self.onceFlag) {
        [self _installContentView];
        self.onceFlag = YES;
    }
}

- (void)_commonInit {
    [self _loadNib];
    [self _setupGesture];
    
    _duration = 0.3; // 默认动画时间
}

- (void)_loadNib {
    [NSBundle.mainBundle loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    self.xibContentView.frame = self.bounds;
    [self addSubview:self.xibContentView];
}

- (void)dealloc {
    NSLog(@"%@ dealloc.", self);
}

#pragma mark -
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
}

#pragma mark -
- (void)_installContentView {
    CGFloat x = [self xOffsetForItemAt:self.selectedIndex];
    
    _contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(CGRectGetWidth(self.bounds) / 2 - x, 0, self.contentSize.width, self.contentSize.height);
    
    CGFloat xOffset = 0.0;
    for (int i = 0; i < self.numberOfItems; ++i) {
        UIView<INDTabSwitchCellInterface> *cell = [_dataSource tabSwitch:self tabItemViewFor:i];
        NSAssert(cell, @"xxxxx");
        CGFloat w = [_dataSource tabSwitch:self tabItemWidthFor:i];
        cell.frame = CGRectMake(xOffset, 0, w, self.contentSize.height);
        [_contentView addSubview:cell];
        xOffset += w;
    }
    
    [self addSubview:_contentView];
    
    [self _reloadSeleted];
}

- (void)_uninstallContentView {
    [_contentView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}

- (void)_setupGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:pan];
    
    _gestureArray = @[tap, pan];
}

- (void)_reloadSeleted {
    NSAssert(self.selectedIndex >= 0 && self.selectedIndex < [_dataSource numberOfItems:self], @"xxxxx");
    
    for (int i = 0; i < _contentView.subviews.count; ++i) {
        UIView<INDTabSwitchCellInterface> *cell = _contentView.subviews[i];
        [cell setSelected:self.selectedIndex == i];
    }
}

#pragma mark -
- (CGSize)contentSize {
    NSAssert(_dataSource, @"------ No dataSource. -----");
    NSInteger count = [_dataSource numberOfItems:self];
    CGFloat width = 0.0;
    for (int i = 0; i < count; ++i) {
        width += [self.dataSource tabSwitch:self tabItemWidthFor:i];
    }
    return CGSizeMake(width, self.bounds.size.height);
}

- (NSInteger)numberOfItems {
    NSAssert(_dataSource, @"------ No dataSource. -----");
    return [_dataSource numberOfItems:self];
}

// 取中点
- (CGFloat)xOffsetForItemAt:(NSInteger)index {
    NSAssert(_dataSource, @"------ No dataSource. -----");
    CGFloat xOffset = 0.0;
    for (int i = 0; i <= index; ++i) {
        CGFloat w = [_dataSource tabSwitch:self tabItemWidthFor:i];
        w = i == index ? w / 2. : w;
        xOffset += w;
    }
    
    return xOffset;
}

- (NSInteger)indexForXoffset:(CGFloat)xOffset {
    NSInteger index = 0;
    CGFloat w = 0.0;
    for (int i = 0; i < self.numberOfItems; ++i) {
        w += [_dataSource tabSwitch:self tabItemWidthFor:i];
        if (w >= xOffset) {
            index = i;
            break;
        }
    }
    return index;
}

- (void)_selectItemAt:(NSInteger)index animated:(BOOL)animated afterAnimation:(nullable void (^)(void))completion {
    if (index < 0 || index >= self.numberOfItems) {
        return;
    }
    
    CGFloat xOffset = [self xOffsetForItemAt:index];
    xOffset = CGRectGetWidth(self.bounds) / 2 - xOffset + CGRectGetWidth(_contentView.bounds) / 2 ;
    if (animated) {
        weak(self);
        [UIView animateWithDuration:_duration animations:^{
            strong(self);
            self.contentView.center = CGPointMake(xOffset, self.contentView.center.y);
        } completion:^(BOOL finished) {
            if (finished && completion) completion();
            self.selectedIndex = index;
            [self _reloadSeleted];
        }];
    } else {
        _contentView.center = CGPointMake(xOffset, _contentView.center.y);
        if (completion) completion();
        self.selectedIndex = index;
        [self _reloadSeleted];
    }
}

#pragma mark - Gesture
- (void)tapAction:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationOfTouch:0 inView:_contentView];
    NSInteger index = [self indexForXoffset:point.x];
    if (_delegate && [_delegate respondsToSelector:@selector(tabSwitch:willSelectedItemAt:)]) {
        [_delegate tabSwitch:self willSelectedItemAt:index];
    }
    weak(self);
    [self _selectItemAt:index animated:YES afterAnimation:^{
        strong(self);
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabSwitch:didSelectedItemAt:)]) {
            [self.delegate tabSwitch:self didSelectedItemAt:index];
        }
    }];
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _lastCenter = _contentView.center;
    } else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        CGFloat endOffset = CGRectGetWidth(self.bounds) / 2 - _contentView.center.x + CGRectGetWidth(_contentView.bounds) / 2;
        NSInteger index = [self indexForXoffset:endOffset];
        if (_delegate && [_delegate respondsToSelector:@selector(tabSwitch:willSelectedItemAt:)]) {
            [_delegate tabSwitch:self willSelectedItemAt:index];
        }
        weak(self);
        [self _selectItemAt:index animated:YES afterAnimation:^{
            strong(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(tabSwitch:didSelectedItemAt:)]) [self.delegate tabSwitch:self didSelectedItemAt:index];
        }];
        
        if (_delegate && [_delegate respondsToSelector:@selector(tabSwitch:didEndedDragAt:)]) [_delegate tabSwitch:self didEndedDragAt:index];
    } else {
        CGPoint offset = [gesture translationInView:_contentView];
        CGFloat xOffset = MIN(CGRectGetWidth(self.bounds) / 2 + CGRectGetWidth(_contentView.bounds) / 2, MAX(CGRectGetWidth(self.bounds) / 2 - CGRectGetWidth(_contentView.bounds) / 2, _lastCenter.x + offset.x));
        _contentView.center = CGPointMake(xOffset, _contentView.center.y);
    }
}

- (void)enableGesture {
    [_gestureArray enumerateObjectsUsingBlock:^(UIGestureRecognizer *obj, NSUInteger idx, BOOL *stop) {
        obj.enabled = YES;
    }];
}

- (void)disableGesture {
    [_gestureArray enumerateObjectsUsingBlock:^(UIGestureRecognizer *obj, NSUInteger idx, BOOL *stop) {
        obj.enabled = NO;
    }];
}

#pragma mark - Public
- (void)selectItemAt:(NSInteger)index animated:(BOOL)animated {
    [self disableGesture];
    if (animated) {
        weak(self);
        [self _selectItemAt:index animated:YES afterAnimation:^{
            strong(self);
            if (self.delegate && [self.delegate respondsToSelector:@selector(tabSwitch:didSelectedItemAt:)]) {
                [self.delegate tabSwitch:self didSelectedItemAt:index];
            }
            [self enableGesture];
        }];
    } else {
        [self _selectItemAt:index animated:NO afterAnimation:nil];
        if (_delegate && [_delegate respondsToSelector:@selector(tabSwitch:didSelectedItemAt:)]) {
            [_delegate tabSwitch:self didSelectedItemAt:index];
        }
        [self enableGesture];
    }
}

- (void)reloadData {
    self.selectedIndex = 0;
    [self _uninstallContentView];
    [self _installContentView];
}

@end
