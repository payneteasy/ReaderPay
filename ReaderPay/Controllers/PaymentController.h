//
//  PaymentController.h
//
//  Created by Sergey Anisiforov on 25/09/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "ReceiptController.h"
#import "SignController.h"

#define configReaderConfigurationBaseUrl     @"ReaderConfigurationBaseUrl"
#define configReaderProcessingBaseUrl        @"ReaderProcessingBaseUrl"
#define configReaderSignatureBaseUrl         @"ReaderSignatureBaseUrl"
#define configReaderReceiptBaseUrl           @"ReaderReceiptBaseUrl"
#define configReaderMerchantLogin            @"ReaderMerchantLogin"
#define configReaderMerchantKey              @"ReaderMerchantKey"
#define configReaderMerchantEndPointId       @"ReaderMerchantEndPointId"
#define configReaderMerchantName             @"ReaderMerchantName"

@class PaymentController;

@protocol PaymentControllerDelegate
- (void)paymentController:(PaymentController *)controller completeWithSuccess:(BOOL)success;
@end


@protocol PaymentControllerDataSource
- (NSDictionary *)readerConfig;
- (ReceiptController *)receiptControllerInstance;
- (SignController *)signControllerInstance;
@end


@protocol PaymentControllerProtocol
- (void)showPaymentAmount:(NSDecimalNumber *)amount;
- (void)showPaymentStatus:(NSString *)status;
- (void)showPaymentStatus:(NSString *)status withSuccess:(NSString *)success;
- (void)showPaymentStatus:(NSString *)status withError:(NSString *)error;
- (void)showMerchantStatus:(NSString *)status;
@end


@interface PaymentController : UIViewController <PaymentControllerProtocol>

@property (nonatomic, copy) NSString *customerEmail;
@property (nonatomic, weak) id<PaymentControllerDataSource> dataSource;
@property (nonatomic, weak) id<PaymentControllerDelegate> delegate;

- (void)setAmount:(NSDecimalNumber *)amount currency:(NSString *)currency invoiceId:(NSNumber *)invoiceId;

@end
