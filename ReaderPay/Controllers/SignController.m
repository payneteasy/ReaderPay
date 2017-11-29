//
//  SignController.m
//
//  Created by Sergey Anisiforov on 08/06/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "SignController.h"
#import "SignatureView.h"
#import "UIView+Constraints.h"

@implementation SignController {
    NSDecimalNumber *_amount;
    NSString *_currency;

    SignatureView *_signatureView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showPaymentAmount:nil];
    [self showPaymentCard:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_signatureView) {
        UIView *view = [self viewForSignature];
        if (view) {
            _signatureView = [SignatureView new];
            [view addSubview:_signatureView];
            [_signatureView autoPinToSuperview];
            
            _signatureView.penColor = [UIColor blackColor];
            _signatureView.penAlpha = 1.0;
            _signatureView.penWidth = 5.0;
        }
    }
    [self updateInterface];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateInterface];
}

- (void)setAmount:(NSDecimalNumber *)amount currency:(NSString *)currency {
    _amount = amount;
    _currency = currency;
    [self updateInterface];
}

- (void)setCard:(PNECard *)card {
    _card = card;
    [self updateInterface];
}

- (void)updateInterface {
    [self showPaymentAmount:_amount];
    
    NSString *cardNumber;
    if (_card.panFirstDigits && _card.panLastDigits) {
        cardNumber = [NSString stringWithFormat:@"%@ *** %@", _card.panFirstDigits, _card.panLastDigits];
        if (_card.scheme)
            cardNumber = [NSString stringWithFormat:@"%@ %@", _card.scheme, cardNumber];
    } else
        cardNumber = nil;
    [self showPaymentCard:cardNumber];
}

- (void)clear {
    [_signatureView clear];
}

- (NSDictionary *)signature {
    return [_signatureView jsonSignature];
}

#pragma mark - SignControllerProtocol

- (void)showPaymentAmount:(NSDecimalNumber *)amount {
}

- (void)showPaymentCard:(NSString *)card {
}

- (UIView *)viewForSignature {
    return nil;
}

@end
