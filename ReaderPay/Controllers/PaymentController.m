//
//  PaymentController.m
//
//  Created by Sergey Anisiforov on 25/09/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "PaymentController.h"
#import "ReceiptController.h"
#import "SignController.h"
#import "PaymentService.h"

@interface PaymentController () <PaymentServiceDelegate, ReceiptControllerDelegate, SignControllerDelegate>

@end

@implementation PaymentController {
    BOOL _completed;
    NSDecimalNumber *_amount;
    NSString *_currency;
    NSNumber *_invoiceId;
    PNECard *_card;
    PaynetStatusResponse *_response;
    PaymentService *_paymentService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self restartPayment];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self stopPayment];
}

- (void)setAmount:(NSDecimalNumber *)amount currency:(NSString *)currency invoiceId:(NSNumber *)invoiceId {
    _amount = amount;
    _currency = currency;
    _invoiceId = invoiceId;
    
    if (_paymentService)
        [self startPayment];
}

- (void)updateInterface {
    [self showPaymentAmount:_amount];
    [self showMerchantStatus:_paymentService.invoiceId];
}

- (void)startPayment {
    if (_paymentService) {
        [_paymentService startPayment:_amount currency:_currency invoiceId:_invoiceId.stringValue];
        [self updateInterface];
    }
}

- (void)stopPayment {
    [_paymentService stopPayment];
    _paymentService.delegate = nil;
}

- (void)restartPayment {
    [self stopPayment];
    
    NSDictionary *config = [_dataSource readerConfig];
    _paymentService = [[PaymentService alloc] initWithConfigurationBaseUrl:config[configReaderConfigurationBaseUrl]
                                                         processingBaseUrl:config[configReaderProcessingBaseUrl]
                                                             merchantLogin:config[configReaderMerchantLogin]
                                                               merchantKey:config[configReaderMerchantKey]
                                                        merchantEndPointId:config[configReaderMerchantEndPointId]
                                                              merchantName:config[configReaderMerchantName]];
    [_paymentService setSignatureBaseUrl:config[configReaderSignatureBaseUrl]];
    _paymentService.customerEmail = self.customerEmail;
    _paymentService.delegate = self;
    
    if (_amount) {
        [self startPayment];
    }
}

- (void)putSignature {
    SignController *signController = [_dataSource signControllerInstance];
    if (signController) {
        signController.delegate = self;
        [signController setCard:_card];
        [signController setAmount:_amount currency:_currency];
        [self.navigationController pushViewController:signController animated:YES];
    }
}

- (void)showReceipt {
    ReceiptController *receiptController = [_dataSource receiptControllerInstance];
    if (receiptController) {
        receiptController.delegate = self;
        receiptController.response = _response;
        [receiptController setAmount:_amount currency:_currency invoiceId:_invoiceId];
        [self.navigationController pushViewController:receiptController animated:YES];
    }
}

#pragma mark - PaymentControllerProtocol

- (void)showPaymentAmount:(NSDecimalNumber *)amount {
}

- (void)showPaymentStatus:(NSString *)status {
}

- (void)showPaymentStatus:(NSString *)status withSuccess:(NSString *)success {
}

- (void)showPaymentStatus:(NSString *)status withError:(NSString *)error {
}

- (void)showMerchantStatus:(NSString *)status {
}

#pragma mark - PaymentServiceDelegate

- (void)paymentDidSetCard:(PNECard *)card {
    if (_completed)
        return;
    _card = card;
}

- (void)paymentDidChangeWithStatus:(NSString *)status {
    if (_completed)
        return;
    [self showPaymentStatus:status];
}

- (void)paymentDidFailWithError:(NSString *)error {
    if (_completed)
        return;
    
    _completed = YES;
    
    [self showPaymentStatus:error withError:@"ERROR"];
}

- (void)paymentDidFailWithIncorrectPin {
    [self restartPayment];
}

- (void)paymentDidCompleteWithResponse:(PaynetStatusResponse *)response needSignature:(BOOL)needSignature {
    if (_completed)
        return;
    
    _completed = YES;
    _response = response;
    switch (response.status) {
        case PaynetStatusTypeApproved:
            [self showPaymentStatus:nil withSuccess:@"APPROVED"];
            if (needSignature)
                [self performSelector:@selector(putSignature) withObject:nil afterDelay:0.8];
            else
                [self performSelector:@selector(showReceipt) withObject:nil afterDelay:0.8];
            break;
        default:
            [self showPaymentStatus:_response.errorMessage withError:@"DECLINED"];
            if (_response.paynetOrderId)
                [self performSelector:@selector(showReceipt) withObject:nil afterDelay:0.8];
            break;
    }
}

#pragma mark - SignControllerDelegate

- (void)signController:(SignController *)controller completeWithSignature:(NSDictionary *)signature {
    if (signature)
        [_paymentService sendSignature:signature orderId:_response.paynetOrderId];
    [self showReceipt];
}

#pragma mark - ReceiptControllerDelegate

- (void)receiptControllerDidComplete:(ReceiptController *)controller {
    [_delegate paymentController:self completeWithSuccess:YES];
}

@end
