//
//  PaymentService.h
//
//  Created by Sergey Anisiforov on 18/05/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PaynetStatusResponse.h>
#import <PNECard.h>

@class PaymentService;

@protocol PaymentServiceDelegate
- (void)paymentDidSetCard:(PNECard *)card;
- (void)paymentDidChangeWithStatus:(NSString *)status;
- (void)paymentDidFailWithError:(NSString *)error;
- (void)paymentDidFailWithIncorrectPin;
- (void)paymentDidCompleteWithResponse:(PaynetStatusResponse *)response needSignature:(BOOL)needSignature;
@end


@interface PaymentService : NSObject

- (instancetype)initWithConfigurationBaseUrl:(NSString *)configurationBaseUrl
                           processingBaseUrl:(NSString *)processingBaseUrl
                               merchantLogin:(NSString *)merchantLogin
                                 merchantKey:(NSString *)merchantKey
                          merchantEndPointId:(NSNumber *)merchantEndPointId
                                merchantName:(NSString *)merchantName;

+ (NSString *)version;

- (void)startPayment:(NSDecimalNumber *)amount currency:(NSString *)currency invoiceId:(NSString *)invoiceId;
- (void)stopPayment;

- (void)setSignatureBaseUrl:(NSString *)signatureBaseUrl;
- (void)sendSignature:(NSDictionary *)signature orderId:(int64_t)orderId;

@property (nonatomic, readonly) NSString *invoiceId;
@property (nonatomic, strong) NSString *customerEmail;
@property (nonatomic, weak) id<PaymentServiceDelegate> delegate;

@end
