//
//  ReceiptCell.m
//
//  Created by Sergey Anisiforov on 27/09/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "ReceiptCell.h"

@implementation ReceiptCell {
    __weak IBOutlet UILabel *labelName;
    __weak IBOutlet UILabel *labelValue;
    __weak IBOutlet UILabel *labelSecondName;
    __weak IBOutlet UILabel *labelSecondValue;
    __weak IBOutlet NSLayoutConstraint *constraintNameWidth;
    __weak IBOutlet NSLayoutConstraint *constraintValueWidth;
    __weak IBOutlet NSLayoutConstraint *constraintSecondNameWidth;
    __weak IBOutlet NSLayoutConstraint *constraintSecondValueWidth;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setReceiptItem:(ReceiptItem *)receiptItem {
    [self setText:receiptItem.name forLabel:labelName widthConstrain:constraintNameWidth];
    [self setText:receiptItem.value forLabel:labelValue widthConstrain:constraintValueWidth];
    [self setText:receiptItem.secondName forLabel:labelSecondName widthConstrain:constraintSecondNameWidth];
    [self setText:receiptItem.secondValue forLabel:labelSecondValue widthConstrain:constraintSecondValueWidth];
}

- (void)setText:(NSString *)text forLabel:(UILabel *)label widthConstrain:(NSLayoutConstraint *)widthConstrain {
    label.text = text;
    if (widthConstrain && text.length)
        widthConstrain.constant = [text boundingRectWithSize:CGSizeMake(label.superview.frame.size.width, CGFLOAT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:label.font}
                                                     context:nil].size.width;
    else
        widthConstrain.constant = 0;
}

@end
