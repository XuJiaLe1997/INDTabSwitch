//
//  INDTabSwitchCell.m
//  example
//
//  Created by guangzhuiyuandev on 2020/9/24.
//  Copyright © 2020 guangzhuiyuandev. All rights reserved.
//

#import "INDTabSwitchCell.h"

@interface INDTabSwitchCell ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation INDTabSwitchCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

- (void)_commonInit {
    [self _loadNib];
}

- (void)_loadNib {
    [NSBundle.mainBundle loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
        self.label.textColor = UIColor.blackColor;
    } else {
        self.label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightLight];
        self.label.textColor = UIColor.lightGrayColor;
    }
}

- (void)setText:(NSString *)text {
    self.label.text = text;
}

@end
