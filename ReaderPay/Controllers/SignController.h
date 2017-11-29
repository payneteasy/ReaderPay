//
//  SignController.h
//
//  Created by Sergey Anisiforov on 08/06/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PNECard.h>

@class SignController;

@protocol SignControllerDelegate <NSObject>
- (void)signController:(SignController *)controller completeWithSignature:(NSDictionary *)signature;
@end


@protocol SignControllerDataSource
- (SignController *)signControllerInstance;
@end


@protocol SignControllerProtocol
- (void)showPaymentAmount:(NSDecimalNumber *)amount;
- (void)showPaymentCard:(NSString *)card;
- (UIView *)viewForSignature;
@end


@interface SignController : UIViewController <SignControllerProtocol>

@property (nonatomic, strong) PNECard *card;
@property (nonatomic, weak) id<SignControllerDelegate> delegate;

- (void)setAmount:(NSDecimalNumber *)amount currency:(NSString *)currency;

- (void)clear;
- (NSDictionary *)signature;

@end
