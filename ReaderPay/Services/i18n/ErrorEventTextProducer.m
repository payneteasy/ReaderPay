//
//  ErrorEventTextProducer.m
//  ReaderExample
//
//  Created by Evgeniy Sinev on 01/07/16.
//  Copyright © 2016 payneteasy. All rights reserved.
//

#import <PaynetEasyReader/PNECardError.h>
#import "ErrorEventTextProducer.h"
#import "ReaderLocalize.h"

@implementation ErrorEventTextProducer

-(NSString *) textForError:(PNECardError *)aError {
    switch (aError.type) {
        case PNECardErrorType_PARSE_PACKET_ERROR                                   : return LocalizedReaderString(@"PNECardErrorType_PARSE_PACKET_ERROR");

        case PNECardErrorType_PARSE_TRACK_ERROR                                    : return LocalizedReaderString(@"PNECardErrorType_PARSE_TRACK_ERROR");

        case PNECardErrorType_EMPTY_CARD_INFO                                      : return LocalizedReaderString(@"PNECardErrorType_EMPTY_CARD_INFO");

        case PNECardErrorType_UNKNOWN_CARD_TYPE                                    : return LocalizedReaderString(@"PNECardErrorType_UNKNOWN_CARD_TYPE");

        case PNECardErrorType_CARD_NOT_VALID                                       : return LocalizedReaderString(@"PNECardErrorType_CARD_NOT_VALID");

        case PNECardErrorType_SKIP                                                 : return LocalizedReaderString(@"PNECardErrorType_SKIP");

        case PNECardErrorType_BAD_PACKET_LRC                                       : return LocalizedReaderString(@"PNECardErrorType_BAD_PACKET_LRC");

        case PNECardErrorType_ERROR_DOWNLOADING_CONFIGURATION                      : return LocalizedReaderString(@"PNECardErrorType_ERROR_DOWNLOADING_CONFIGURATION");

        case PNECardErrorType_NO_CONFIGURATION_CONTINUATION                        : return LocalizedReaderString(@"PNECardErrorType_NO_CONFIGURATION_CONTINUATION");

        case PNECardErrorType_NOT_SRED_READY                                       : return LocalizedReaderString(@"PNECardErrorType_NOT_SRED_READY");

        case PNECardErrorType_INVALID_DATA_IN_COMMAND_APDU                         : return LocalizedReaderString(@"PNECardErrorType_INVALID_DATA_IN_COMMAND_APDU");

        case PNECardErrorType_TERMINAL_NOT_READY                                   : return LocalizedReaderString(@"PNECardErrorType_TERMINAL_NOT_READY");

        case PNECardErrorType_NO_SMART_CARD_IN_SLOT                                : return LocalizedReaderString(@"PNECardErrorType_NO_SMART_CARD_IN_SLOT");

        case PNECardErrorType_INVALID_CARD                                         : return LocalizedReaderString(@"PNECardErrorType_INVALID_CARD");

        case PNECardErrorType_TRANSACTION_ALREADY_IN_PROGRESS                      : return LocalizedReaderString(@"PNECardErrorType_TRANSACTION_ALREADY_IN_PROGRESS");

        case PNECardErrorType_DATA_MISSING_FROM_COMMAND_APDU                       : return LocalizedReaderString(@"PNECardErrorType_DATA_MISSING_FROM_COMMAND_APDU");

        case PNECardErrorType_UNSUPPORTED_CARD                                     : return LocalizedReaderString(@"PNECardErrorType_UNSUPPORTED_CARD");

        case PNECardErrorType_MISSING_FILE                                         : return LocalizedReaderString(@"PNECardErrorType_MISSING_FILE");

        case PNECardErrorType_ICC_READ_ERROR                                       : return LocalizedReaderString(@"PNECardErrorType_ICC_READ_ERROR");

        case PNECardErrorType_INVALID_ISSUER_PUBLIC_KEY                            : return LocalizedReaderString(@"PNECardErrorType_INVALID_ISSUER_PUBLIC_KEY");

        case PNECardErrorType_USER_CANCELLED                                       : return LocalizedReaderString(@"PNECardErrorType_USER_CANCELLED");

        case PNECardErrorType_TRANSACTION_TIMED_OUT                                : return LocalizedReaderString(@"PNECardErrorType_TRANSACTION_TIMED_OUT");

        case PNECardErrorType_TRANSACTION_ABORTED_BY_INSERTED                      : return LocalizedReaderString(@"PNECardErrorType_TRANSACTION_ABORTED_BY_INSERTED");

        case PNECardErrorType_TRANSACTION_ABORTED_BY_SWIPED                        : return LocalizedReaderString(@"PNECardErrorType_TRANSACTION_ABORTED_BY_SWIPED");

        case PNECardErrorType_NO_APPLICATIONS                                      : return LocalizedReaderString(@"PNECardErrorType_NO_APPLICATIONS");

        case PNECardErrorType_TRANSACTION_NOT_POSSIBLE                             : return LocalizedReaderString(@"PNECardErrorType_TRANSACTION_NOT_POSSIBLE");

        case PNECardErrorType_USE_ICC                                              : return LocalizedReaderString(@"PNECardErrorType_USE_ICC");

        case PNECardErrorType_HARDWARE_ERROR                                       : return LocalizedReaderString(@"PNECardErrorType_HARDWARE_ERROR");

        case PNECardErrorType_SPIRE_GENERAL_FAILURE                                : return LocalizedReaderString(@"PNECardErrorType_SPIRE_GENERAL_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_APPLICATION_SELECTION_FAILURE             : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_APPLICATION_SELECTION_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_INITIATE_APPLICATION_PROCESSING_FAILURE   : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_INITIATE_APPLICATION_PROCESSING_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_READ_APPLICATION_DATA_FAILURE             : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_READ_APPLICATION_DATA_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_OFFLINE_DATA_AUTHENTICATION_FAILURE       : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_OFFLINE_DATA_AUTHENTICATION_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_PROCESS_RESTRICTIONS_FAILURE              : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_PROCESS_RESTRICTIONS_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_TERMINAL_RISK_MANAGEMENT_FAILURE          : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_TERMINAL_RISK_MANAGEMENT_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_CARDHOLDER_VERIFICATION_METHOD_FAILURE    : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_CARDHOLDER_VERIFICATION_METHOD_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_TERMINAL_ACTION_ANALYSIS_FAILURE          : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_TERMINAL_ACTION_ANALYSIS_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_CARD_ACTION_ANALYSIS_FAILURE              : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_CARD_ACTION_ANALYSIS_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_COMPLETION_FAILURE                        : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_COMPLETION_FAILURE");

        case PNECardErrorType_SPIRE_EPOS_TRANSACTION_TERMINATED                    : return LocalizedReaderString(@"PNECardErrorType_SPIRE_EPOS_TRANSACTION_TERMINATED");

        case PNECardErrorType_SPIRE_CHIP_NO_ANSWER_TO_RESET                        : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_NO_ANSWER_TO_RESET");

        case PNECardErrorType_SPIRE_SWIPE_READ_FAILURE                             : return LocalizedReaderString(@"PNECardErrorType_SPIRE_SWIPE_READ_FAILURE");

        case PNECardErrorType_SPIRE_CHIP_CARD_REMOVED                              : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_CARD_REMOVED");

        case PNECardErrorType_SPIRE_MPOS_USER_CANCELLED                            : return LocalizedReaderString(@"PNECardErrorType_SPIRE_MPOS_USER_CANCELLED");

        case PNECardErrorType_SPIRE_CHIP_NO_SUPPORTED_APPLICATIONS                 : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_NO_SUPPORTED_APPLICATIONS");

        case PNECardErrorType_SPIRE_CHIP_CARD_BLOCKED                              : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_CARD_BLOCKED");

        case PNECardErrorType_SPIRE_CHIP_READ_FAILURE                              : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CHIP_READ_FAILURE");

        case PNECardErrorType_SPIRE_MPOS_USER_TIME_OUT                             : return LocalizedReaderString(@"PNECardErrorType_SPIRE_MPOS_USER_TIME_OUT");

        case PNECardErrorType_SPIRE_MPOS_DUKPT_KEY_FAILURE                         : return LocalizedReaderString(@"PNECardErrorType_SPIRE_MPOS_DUKPT_KEY_FAILURE");

        case PNECardErrorType_SPIRE_MPOS_MK_SK_KEY_FAILURE                         : return LocalizedReaderString(@"PNECardErrorType_SPIRE_MPOS_MK_SK_KEY_FAILURE");

        case PNECardErrorType_SPIRE_CONTACTLESS_NOT_ALLOWED                        : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CONTACTLESS_NOT_ALLOWED");

        case PNECardErrorType_SPIRE_CONTACTLESS_ABORTED                            : return LocalizedReaderString(@"PNECardErrorType_SPIRE_CONTACTLESS_ABORTED");

        default:
            return aError.errorMessage;
    }


}
@end
