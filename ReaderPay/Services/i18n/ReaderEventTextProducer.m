//
//  ReaderEventTextProducer.m
//  ReaderExample
//
//  Created by Evgeniy Sinev on 30/06/16.
//  Copyright © 2016 payneteasy. All rights reserved.
//

#import <PaynetEasyReader/PNEReaderEvent.h>
#import "ReaderEventTextProducer.h"
#import "MiuraEventTextProducer.h"
#import "SpireEventTextProducer.h"
#import "ReaderLocalize.h"

@implementation ReaderEventTextProducer {
    MiuraEventTextProducer * _miura;
    SpireEventTextProducer * _spire;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _miura = [[MiuraEventTextProducer alloc] init];
        _spire = [[SpireEventTextProducer alloc] init];
    }

    return self;
}

- (NSString *) textFor:(PNEReaderEvent *)aEvent {
    switch (aEvent.state) {
        case PNEReaderState_STARTED:
            return LocalizedReaderString(@"PNEReaderState_STARTED");

        case PNEReaderState_CONNECTING:
            return LocalizedReaderString(@"PNEReaderState_CONNECTING");

        case PNEReaderState_CONNECTED:
            return LocalizedReaderString(@"PNEReaderState_CONNECTED");

        case PNEReaderState_NOT_CONNECTED:
            return LocalizedReaderString(@"PNEReaderState_NOT_CONNECTED");

        case PNEReaderState_MIURA_DEVICE_INFO:
            return [_miura deviceInfo:aEvent.message];

        case PNEReaderState_MIURA_CARD_STATUS:
            return [_miura miuraCardStatus:aEvent.message];

        case PNEReaderState_MIURA_DEVICE_STATUS_CHANGE:
            return [_miura miuraDeviceStatus:aEvent.message];

        case PNEReaderState_MIURA_BATTERY_STATUS_RESPONSE:
            return [_miura battery:aEvent.message];

        case PNEReaderState_CONFIGURATION_DOWNLOADING:
            return LocalizedReaderString(@"PNEReaderState_CONFIGURATION_DOWNLOADING");

        case PNEReaderState_CONFIGURATION_UPLOADING:
            return LocalizedReaderString(@"PNEReaderState_CONFIGURATION_UPLOADING");

        case PNEReaderState_CONFIGURATION_COMPLETE:
            return LocalizedReaderString(@"PNEReaderState_CONFIGURATION_COMPLETE");

        case PNEReaderState_SENDING_SALE:
            return LocalizedReaderString(@"PNEReaderState_SENDING_SALE");

        case PNEReaderState_SENDING_EMF_FINAL_ADVICE:
            return LocalizedReaderString(@"PNEReaderState_SENDING_EMF_FINAL_ADVICE");

        case PNEReaderState_SPIRE_COMPLETE_TRANSACTION:
            return LocalizedReaderString(@"PNEReaderState_SPIRE_COMPLETE_TRANSACTION");

        case PNEReaderState_SPIRE_GET_AMOUNT:
            return LocalizedReaderString(@"PNEReaderState_SPIRE_GET_AMOUNT");

        case PNEReaderState_SPIRE_GET_SWIPED_DATA:
            return LocalizedReaderString(@"PNEReaderState_SPIRE_GET_SWIPED_DATA");

        case PNEReaderState_SPIRE_GET_TRANSACTION_DATA:
            return LocalizedReaderString(@"PNEReaderState_SPIRE_GET_TRANSACTION_DATA");

        case PNEReaderState_SPIRE_GO_ONLINE:
            return LocalizedReaderString(@"PNEReaderState_SPIRE_GO_ONLINE");

        case PNEReaderState_SPIRE_PROCESS_SWIPED_DATA:
            return LocalizedReaderString(@"PNEReaderState_SPIRE_PROCESS_SWIPED_DATA");

        case PNEReaderState_SPIRE_TERMINATE_TRANSACTION:
            return LocalizedReaderString(@"PNEReaderState_SPIRE_TERMINATE_TRANSACTION");

        case PNEReaderState_SPIRE_INIT_TRANSACTION:
            return LocalizedReaderString(@"PNEReaderState_SPIRE_INIT_TRANSACTION");

        case PNEReaderState_SPIRE_STATUS_REPORT:
            return [_spire statusReport:aEvent.message];

        default:
            return aEvent.description;
    }
    return nil;
}


@end
