//
//  ProcessingEventTextProducer.m
//  ReaderExample
//
//  Created by Evgeniy Sinev on 30/06/16.
//  Copyright © 2016 payneteasy. All rights reserved.
//

#import "ProcessingEventTextProducer.h"
#import <PaynetStatusResponse.h>
#import <PNEProcessingEvent.h>
#import "ReaderLocalize.h"

@implementation ProcessingEventTextProducer

- (NSString *)textFor:(PNEProcessingEvent *)aEvent {

    switch (aEvent.type) {
        case PNEProcessingEventType_EXCEPTION               : return LocalizedReaderString(@"PNEProcessingEventType_EXCEPTION");
        case PNEProcessingEventType_ADVICE_REQUIRED         : return LocalizedReaderString(@"PNEProcessingEventType_ADVICE_REQUIRED");
        case PNEProcessingEventType_ADVICE_RESPONSE_WAITING : return LocalizedReaderString(@"PNEProcessingEventType_ADVICE_RESPONSE_WAITING");
        case PNEProcessingEventType_ADVICE_SENDING          : return LocalizedReaderString(@"PNEProcessingEventType_ADVICE_SENDING");
        case PNEProcessingEventType_ERROR_3D_SECURE         : return LocalizedReaderString(@"PNEProcessingEventType_ERROR_3D_SECURE");
        case PNEProcessingEventType_SALE_SENDING            : return LocalizedReaderString(@"PNEProcessingEventType_SALE_SENDING");
        case PNEProcessingEventType_SALE_RESPONSE_WAITING   : return LocalizedReaderString(@"PNEProcessingEventType_SALE_RESPONSE_WAITING");
        case PNEProcessingEventType_RESULT                  : return [self result:aEvent.result];

        default:
            return LocalizedReaderString(@"PNEProcessingEventType_UNKNOWN");
    }

    return nil;
}

- (NSString *)result:(PaynetStatusResponse *)aResponse {
    switch (aResponse.status) {
        case PaynetStatusTypeApproved:
            return LocalizedReaderString(@"PaynetStatusTypeApproved");

        case PaynetStatusTypeDeclined:
            return LocalizedReaderString(@"PaynetStatusTypeDeclined");

        case PaynetStatusTypeError:
            return LocalizedReaderString(@"PaynetStatusTypeError");

        case PaynetStatusTypeFiltered:
            return LocalizedReaderString(@"PaynetStatusTypeFiltered");

        case PaynetStatusTypeProcessing:
            return LocalizedReaderString(@"PaynetStatusTypeProcessing");

        default:
            return LocalizedReaderString(@"PaynetStatusTypeUnknown");

    }
    return nil;
}
@end
