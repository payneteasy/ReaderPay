//
//  ReceiptCell.h
//
//  Created by Sergey Anisiforov on 27/09/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptItem.h"

@interface ReceiptCell : UITableViewCell

- (void)setReceiptItem:(ReceiptItem *)receiptItem;

@end
