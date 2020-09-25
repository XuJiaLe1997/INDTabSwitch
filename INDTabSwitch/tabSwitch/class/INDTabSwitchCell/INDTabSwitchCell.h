//
//  INDTabSwitchCell.h
//  example
//
//  Created by guangzhuiyuandev on 2020/9/24.
//  Copyright © 2020 guangzhuiyuandev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol INDTabSwitchCellInterface <NSObject>
@required

- (void)setSelected:(BOOL)selected;

@end

@interface INDTabSwitchCell : UIView <INDTabSwitchCellInterface>

- (void)setText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
