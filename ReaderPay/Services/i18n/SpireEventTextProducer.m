//
//  SpireEventTextProducer.m
//  ReaderExample
//
//  Created by Evgeniy Sinev on 30/06/16.
//  Copyright © 2016 payneteasy. All rights reserved.
//

#import "SpireEventTextProducer.h"
#import "SpireStatusReport49Event.h"
#import "ReaderLocalize.h"

@implementation SpireEventTextProducer

- (NSString *)statusReport:(id)aMessage {

    if(![aMessage isKindOfClass:[SpireStatusReport49Event class]]) {
        return [NSString stringWithFormat:@"Unknown class: %@", aMessage];
    }

    SpireStatusReport49Event * status = aMessage;
    
    switch (status.status) {
        case SpireStatusType_CardEntryPrompted                : return LocalizedReaderString(@"SpireStatusType_CardEntryPrompted");
        case SpireStatusType_SmartcardInserted                : return LocalizedReaderString(@"SpireStatusType_SmartcardInserted");
        case SpireStatusType_SmartcardRemovePrompted          : return LocalizedReaderString(@"SpireStatusType_SmartcardRemovePrompted");
        case SpireStatusType_SmartcardRemoved                 : return LocalizedReaderString(@"SpireStatusType_SmartcardRemoved");
        case SpireStatusType_CardEntryBypassed                : return LocalizedReaderString(@"SpireStatusType_CardEntryBypassed");
        case SpireStatusType_CardEntryTimedOut                : return LocalizedReaderString(@"SpireStatusType_CardEntryTimedOut");
        case SpireStatusType_CardEntryAborted                 : return LocalizedReaderString(@"SpireStatusType_CardEntryAborted");
        case SpireStatusType_CardSwiped                       : return LocalizedReaderString(@"SpireStatusType_CardSwiped");
        case SpireStatusType_CardSwipeError                   : return LocalizedReaderString(@"SpireStatusType_CardSwipeError");
        case SpireStatusType_ContactlessCardTapped            : return LocalizedReaderString(@"SpireStatusType_ContactlessCardTapped");
        case SpireStatusType_ContactlessCardTapError          : return LocalizedReaderString(@"SpireStatusType_ContactlessCardTapError");
        case SpireStatusType_ApplicationSelectionStarted      : return LocalizedReaderString(@"SpireStatusType_ApplicationSelectionStarted");
        case SpireStatusType_ApplicationSelectionCompleted    : return LocalizedReaderString(@"SpireStatusType_ApplicationSelectionCompleted");
        case SpireStatusType_PinEntryStarted                  : return LocalizedReaderString(@"SpireStatusType_PinEntryStarted");
        case SpireStatusType_PinEntryCompleted                : return LocalizedReaderString(@"SpireStatusType_PinEntryCompleted");
        case SpireStatusType_PinEntryAborted                  : return LocalizedReaderString(@"SpireStatusType_PinEntryAborted");
        case SpireStatusType_PinEntryBypassed                 : return LocalizedReaderString(@"SpireStatusType_PinEntryBypassed");
        case SpireStatusType_PinEntryTimedOut                 : return LocalizedReaderString(@"SpireStatusType_PinEntryTimedOut");
        case SpireStatusType_LastPinEntry                     : return LocalizedReaderString(@"SpireStatusType_LastPinEntry");
        case SpireStatusType_AmountConfirmationStarted        : return LocalizedReaderString(@"SpireStatusType_AmountConfirmationStarted");
        case SpireStatusType_AmountConfirmationCompleted      : return LocalizedReaderString(@"SpireStatusType_AmountConfirmationCompleted");
        case SpireStatusType_AmountConfirmationAborted        : return LocalizedReaderString(@"SpireStatusType_AmountConfirmationAborted");
        case SpireStatusType_AmountConfirmationBypassed       : return LocalizedReaderString(@"SpireStatusType_AmountConfirmationBypassed");
        case SpireStatusType_AmountConfirmationTimedOut       : return LocalizedReaderString(@"SpireStatusType_AmountConfirmationTimedOut");
        case SpireStatusType_DCCSelectionStarted              : return LocalizedReaderString(@"SpireStatusType_DCCSelectionStarted");
        case SpireStatusType_DCCCardholderCurrencySelected    : return LocalizedReaderString(@"SpireStatusType_DCCCardholderCurrencySelected");
        case SpireStatusType_DCCCardholderCurrencyNotSelected : return LocalizedReaderString(@"SpireStatusType_DCCCardholderCurrencyNotSelected");
        case SpireStatusType_DCCSelectionTimedOut             : return LocalizedReaderString(@"SpireStatusType_DCCSelectionTimedOut");
        case SpireStatusType_GratuityEntryStarted             : return LocalizedReaderString(@"SpireStatusType_GratuityEntryStarted");
        case SpireStatusType_GratuityEntered                  : return LocalizedReaderString(@"SpireStatusType_GratuityEntered");
        case SpireStatusType_GratuityNotEntered               : return LocalizedReaderString(@"SpireStatusType_GratuityNotEntered");
        case SpireStatusType_GratuityEntryTimedOut            : return LocalizedReaderString(@"SpireStatusType_GratuityEntryTimedOut");

        default:
            return LocalizedReaderString(@"SpireStatusType_Unknown");
    }
}
@end
