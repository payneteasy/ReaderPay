//
//  PaymentService.m
//
//  Created by Sergey Anisiforov on 18/05/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "PaymentService.h"
#import <CommonCrypto/CommonDigest.h>
#import <PNEReaderPresenter.h>
#import <PNEReaderFactory.h>
#import <PNEReaderEvent.h>
#import <PNECardError.h>
#import <PNEReaderInfo.h>
#import <PNEProcessingEvent.h>
#import <PNEReaderManager.h>
#import <PNEProcessingContinuation.h>
#import <PNEConfigurationContinuation.h>
#import "ReaderEventTextProducer.h"
#import "ProcessingEventTextProducer.h"
#import "ErrorEventTextProducer.h"
#import "HexUtil.h"
#import "TDOAuth.h"
#import <ExternalAccessory/ExternalAccessory.h>

@interface PaymentService () <PNEReaderPresenter>

@end

@implementation PaymentService {
    NSString *_configurationBaseUrl;
    NSString *_processingBaseUrl;
    NSString *_signatureBaseUrl;
    NSString *_merchantLogin;
    NSString *_merchantKey;
    NSUInteger _merchantEndPointId;
    NSString *_merchantName;
    NSString *_invoiceId;
    
    ReaderEventTextProducer * _readerEventTextProducer;
    ProcessingEventTextProducer * _processingEventTextProducer;
    ErrorEventTextProducer * _errorEventTextProducer;
    
    BOOL _configurationCompleted;
    NSString *_accessorySerialNumber;
    
    id <PNEReaderManager> _manager;
}

- (instancetype)initWithConfigurationBaseUrl:(NSString *)configurationBaseUrl
                           processingBaseUrl:(NSString *)processingBaseUrl
                               merchantLogin:(NSString *)merchantLogin
                                 merchantKey:(NSString *)merchantKey
                          merchantEndPointId:(NSNumber *)merchantEndPointId
                                merchantName:(NSString *)merchantName {
    self = [super init];
    if (self) {
        _configurationBaseUrl = configurationBaseUrl;
        _processingBaseUrl = processingBaseUrl;
        _merchantLogin = merchantLogin;
        _merchantKey = merchantKey;
        _merchantEndPointId = [merchantEndPointId integerValue];
        _merchantName = merchantName;
        _readerEventTextProducer = [[ReaderEventTextProducer alloc] init];
        _processingEventTextProducer = [[ProcessingEventTextProducer alloc] init];
        _errorEventTextProducer = [[ErrorEventTextProducer alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidConnect:)  name:EAAccessoryDidConnectNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidDisconnectNotification object:nil];
}

+ (NSString *)version {
    return [PNEReaderFactory sdkVersion];
}

- (void)startPayment:(NSDecimalNumber *)amount currency:(NSString *)currency invoiceId:(NSString *)invoiceId {
    if (invoiceId.length)
        _invoiceId = invoiceId;
    else
        _invoiceId = [self generateMerchantId];
    
    PNEReaderFactory *factory = [[PNEReaderFactory alloc] init];
    PNEReaderInfo *reader = [PNEReaderInfo infoWithType:PNEReaderType_MIURA_OR_SPIRE];
    _manager = [factory createManager:reader
                               amount:amount
                             currency:currency
                            presenter:self];
    [_manager start];
}

- (void)stopPayment {
    [_manager stop];
}

- (NSString *)invoiceId {
    return _invoiceId;
}

#pragma mark - PNEReaderPresenter

- (void)stateChanged:(PNEReaderEvent *)aEvent {
    NSString *text = [_readerEventTextProducer textFor:aEvent];
    switch (aEvent.state) {
        case PNEReaderState_NOT_CONNECTED:
            if (!_configurationCompleted)
                [_delegate paymentDidFailWithError:text];
            break;
        case PNEReaderState_CONFIGURATION_COMPLETE:
            _configurationCompleted = YES;
            break;
        default:
            [_delegate paymentDidChangeWithStatus:text];
            break;
    }
}

- (PNEProcessingContinuation *)onCard:(PNECard *)aCard {
    [_delegate paymentDidSetCard:aCard];

    PNEProcessingContinuation *processingContinuation;

    if( [self isTestTerminal:aCard.terminalSerialNumber]) {
        processingContinuation = [PNEProcessingContinuation continuationWithBaseUrl:@"https://sandbox.payneteasy.com/paynet"
                                                                      merchantLogin:@"paynet-merchant"
                                                                        merchantKey:@"712ABF90-DE7A-4798-9A96-7494F8C1A35B"
                                                                 merchantEndPointId:357
                                                                 orderInvoiceNumber:_invoiceId];
    } else {
        processingContinuation = [PNEProcessingContinuation continuationWithBaseUrl:_processingBaseUrl
                                                                      merchantLogin:_merchantLogin
                                                                        merchantKey:_merchantKey
                                                                 merchantEndPointId:_merchantEndPointId
                                                                 orderInvoiceNumber:_invoiceId];
    }

    processingContinuation.customerEmail = _customerEmail;
    return processingContinuation;
}

- (BOOL)isTestTerminal:(NSString *)aSerialNumber {
    return [aSerialNumber isEqualToString:@"20048170"] || [aSerialNumber isEqualToString:@"10000462"];
}

- (void)onCardError:(PNECardError *)aError {
    [_delegate paymentDidFailWithError:[_errorEventTextProducer textForError:aError]];
}

- (void)onProcessingEvent:(PNEProcessingEvent *)aEvent {
    NSString *text = [_processingEventTextProducer textFor:aEvent];
    switch (aEvent.type) {
        case PNEProcessingEventType_EXCEPTION:
            [_delegate paymentDidFailWithError:text];
        case PNEProcessingEventType_RESULT:
            if ([aEvent.result.responseCode isEqualToString:@"55"])
                [_delegate paymentDidFailWithIncorrectPin];
            else
                [_delegate paymentDidCompleteWithResponse:aEvent.result needSignature:aEvent.shouldGetSignature == PNEShouldGetSignature_YES];
            break;
        default:
            [_delegate paymentDidChangeWithStatus:text];
            break;
    }
}

- (PNEConfigurationContinuation *)onConfiguration {
    return [[PNEConfigurationContinuation alloc]
            initWithBaseUrl:_configurationBaseUrl
            merchantLogin:_merchantLogin
            merchantKey:_merchantKey
            merchantEndPointId:_merchantEndPointId
            merchantName:_merchantName
            ];
}

#pragma mark - Signature

- (void)setSignatureBaseUrl:(NSString *)signatureBaseUrl {
    _signatureBaseUrl = signatureBaseUrl;
}

- (void)sendSignature:(NSDictionary *)signature orderId:(int64_t)orderId {
    if (!signature.count || !orderId || !_merchantEndPointId)
        return;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:signature options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *sign = [self sha1ForString:jsonString];
    
    NSURL *url = [NSURL URLWithString:_signatureBaseUrl];
    url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%lu", (unsigned long)_merchantEndPointId]];
    url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%lld", orderId]];
    url = [url URLByAppendingPathComponent:sign];
    
    NSURLRequest *request = [TDOAuth URLRequestForPath:url.relativePath
                                            parameters:signature
                                                  host:url.host
                                           consumerKey:_merchantLogin
                                        consumerSecret:_merchantKey
                                           accessToken:nil
                                           tokenSecret:nil
                                                scheme:@"https"
                                         requestMethod:@"POST"
                                          dataEncoding:TDOAuthContentTypeJsonObject
                                          headerValues:nil
                                       signatureMethod:TDOAuthSignatureMethodHmacSha1];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {}];
    [task resume];
}

#pragma mark - Notifications

- (void)accessoryDidConnect:(NSNotification *)notification {
    EAAccessory *connectedAccessory = [notification userInfo][EAAccessoryKey];
    if (_accessorySerialNumber && [_accessorySerialNumber isEqualToString:connectedAccessory.serialNumber]) {
        _accessorySerialNumber = nil;
        if (_configurationCompleted) {
            _configurationCompleted = NO;
            [_manager start];
        }
    }
}

- (void)accessoryDidDisconnect:(NSNotification *)notification {
    EAAccessory *disconnectedAccessory = [notification userInfo][EAAccessoryKey];
    _accessorySerialNumber = disconnectedAccessory.serialNumber;
}

#pragma mark - internal

- (NSDateFormatter *)dateTimeFormatter {
    static dispatch_once_t onceInput;
    static NSDateFormatter *formatter;
    dispatch_once(&onceInput, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd-HHmm"];
    });
    return formatter;
}

- (NSString *)generateMerchantId {
    return [NSString stringWithFormat:@"%lu-%@", (unsigned long)_merchantEndPointId, [[self dateTimeFormatter] stringFromDate:[NSDate date]]];
}

- (NSString *)sha1ForString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
