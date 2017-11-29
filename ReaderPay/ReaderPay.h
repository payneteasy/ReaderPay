//
//  ReaderPay.h
//
//  Created by Sergey Anisiforov on 26/09/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "PaymentController.h"
#import "ReceiptController.h"
#import "SignController.h"


@protocol ReaderPayDelegate
- (void)ReaderPayCompleteWithSuccess:(BOOL)success;
@end


@protocol ReaderPayDataSource
- (NSDictionary *)readerConfig;
- (PaymentController *)paymentControllerInstance;
- (ReceiptController *)receiptControllerInstance;
- (SignController *)signControllerInstance;
@end


@interface ReaderPay : NSObject

@property (nonatomic, weak) id<ReaderPayDelegate> delegate;
@property (nonatomic, weak) id<ReaderPayDataSource> dataSource;

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)pushPaymentControllerWithAmount:(NSDecimalNumber *)amount
                               currency:(NSString *)currency
                              invoiceId:(NSNumber *)invoiceId
                          customerEmail:(NSString *)customerEmail
                               animated:(BOOL)animated;

@end
