//
//  ReceiptController.h
//
//  Created by Sergey Anisiforov on 13/06/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PaynetStatusResponse.h>

@class ReceiptController;

@protocol ReceiptControllerDelegate <NSObject>
- (void)receiptControllerDidComplete:(ReceiptController *)controller;
@end


@protocol ReceiptControllerProtocol
- (void)showReceiptId:(NSString *)url;
- (UIView *)viewForReceipt;
- (void)customizeReceiptCell:(UITableViewCell *)cell;
@end


@interface ReceiptController : UIViewController <ReceiptControllerProtocol>

@property (nonatomic, weak) PaynetStatusResponse *response;
@property (nonatomic, weak) id<ReceiptControllerDelegate> delegate;

- (void)setAmount:(NSDecimalNumber *)amount currency:(NSString *)currency invoiceId:(NSNumber *)invoiceId;

@end
