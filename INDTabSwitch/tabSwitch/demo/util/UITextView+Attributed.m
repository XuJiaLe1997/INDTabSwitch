//
//  UITextView+Attributed.m
//  INDTabSwitch
//
//  Created by guangzhuiyuandev on 2020/9/25.
//  Copyright © 2020 guangzhuiyuandev. All rights reserved.
//

#import "UITextView+Attributed.h"

@implementation UITextView (Attributed)

- (void)setLineSpacing:(CGFloat)spacing {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle};
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
}

@end
