//
//  ReaderPay.m
//
//  Created by Sergey Anisiforov on 26/09/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "ReaderPay.h"
#import <PNECard.h>

@interface ReaderPay () <PaymentControllerDataSource, PaymentControllerDelegate>

@end

@implementation ReaderPay {
    __weak UINavigationController *_navigationController;
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

- (void)pushPaymentControllerWithAmount:(NSDecimalNumber *)amount
                               currency:(NSString *)currency
                              invoiceId:(NSNumber *)invoiceId
                          customerEmail:(NSString *)customerEmail
                               animated:(BOOL)animated {

    PaymentController *paymentController = [_dataSource paymentControllerInstance];
    if (paymentController) {
        paymentController.dataSource = self;
        paymentController.delegate = self;
        paymentController.customerEmail = customerEmail;
        [paymentController setAmount:amount currency:currency invoiceId:invoiceId];
        [_navigationController pushViewController:paymentController animated:animated];
    }
}

#pragma mark - PaymentControllerDataSource

- (NSDictionary *)readerConfig {
    return [_dataSource readerConfig];
}

- (ReceiptController *)receiptControllerInstance {
    return [_dataSource receiptControllerInstance];
}

- (SignController *)signControllerInstance {
    return [_dataSource signControllerInstance];
}

#pragma mark - PaymentControllerDelegate

- (void)paymentController:(PaymentController *)controller completeWithSuccess:(BOOL)success {
    [_delegate ReaderPayCompleteWithSuccess:success];
}

@end
