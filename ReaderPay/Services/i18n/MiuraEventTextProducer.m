//
//  MiuraEventTextProducer.m
//  ReaderExample
//
//  Created by Evgeniy Sinev on 30/06/16.
//  Copyright © 2016 payneteasy. All rights reserved.
//

#import <PaynetEasyReader/MiuraCardStatusMessage.h>
#import <PaynetEasyReader/MiuraDeviceStatusMessage.h>
#import <PaynetEasyReader/MiuraBatteryStatusResponse.h>
#import <PaynetEasyReader/MiuraResetDeviceResponse.h>
#import "MiuraEventTextProducer.h"
#import "ReaderLocalize.h"

@implementation MiuraEventTextProducer

- (NSString *)deviceInfo:(id)aMessage {
    if(![aMessage isKindOfClass:[MiuraResetDeviceResponse class]]) {
        return [NSString stringWithFormat:@"Unknown class: %@", aMessage];
    }

    MiuraResetDeviceResponse * info = aMessage;
    return LocalizedReaderFormatString(@"PNEReaderState_MIURA_DEVICE_INFO", info.deviceSerialNumber);
}

- (NSString *)battery:(id)aMessage {
    if(![aMessage isKindOfClass:[MiuraBatteryStatusResponse class]]) {
        return [NSString stringWithFormat:@"Unknown class: %@", aMessage];
    }

    MiuraBatteryStatusResponse * battery = aMessage;

    NSString * status;
    switch (battery.batteryStatus) {
        case MiuraBatteryStatusType_CHARGING:
            status = LocalizedReaderString(@"MiuraBatteryStatusType_CHARGING");
            break;

        case MiuraBatteryStatusType_FULLY_CHARGED:
            status = LocalizedReaderString(@"MiuraBatteryStatusType_FULLY_CHARGED");
            break;

        case MiuraBatteryStatusType_NOT_CHARGING:
            status = LocalizedReaderString(@"MiuraBatteryStatusType_NOT_CHARGING");
            break;

        default:
            status = LocalizedReaderFormatString(@"MiuraBatteryStatusType_UNKNOWN", @(battery.batteryStatus));
            break;
    }

    return LocalizedReaderFormatString(@"PNEReaderState_MIURA_BATTERY_STATUS_RESPONSE"
            , status, @(battery.batteryPercentage)
    );
}

//     <MiuraDeviceStatusMessage: self.pinDigits=0, self.pinEntryStatus=5, self.type=1, self.text=Enter PIN>
- (NSString *)miuraDeviceStatus:(id)aMessage {
    if(![aMessage isKindOfClass:[MiuraDeviceStatusMessage class]]) {
        return [NSString stringWithFormat:@"Unknown class: %@", aMessage];
    }

    MiuraDeviceStatusMessage * device = aMessage;
    if(device.type == MiuraDeviceStatusType_PIN_ENTRY_EVENT) {
        switch (device.pinEntryStatus) {
            case MiuraPinEntryStatus_INCORRECT_PIN:         return LocalizedReaderString(@"MiuraPinEntryStatus_INCORRECT_PIN");
            case MiuraPinEntryStatus_LAST_POSSIBLE_ATTEMPT: return LocalizedReaderString(@"MiuraPinEntryStatus_LAST_POSSIBLE_ATTEMPT");
            case MiuraPinEntryStatus_PIN_ENTRY_COMPLETED:   return LocalizedReaderString(@"MiuraPinEntryStatus_PIN_ENTRY_COMPLETED");
            case MiuraPinEntryStatus_PIN_ENTRY_ERROR:       return LocalizedReaderString(@"MiuraPinEntryStatus_PIN_ENTRY_ERROR");
            case MiuraPinEntryStatus_PIN_OK:                return LocalizedReaderString(@"MiuraPinEntryStatus_PIN_OK");

                // pin entering
            case 5:
                return [self enteringPin:device.pinDigits];

            default:

                return LocalizedReaderString(@"MiuraPinEntryStatus_UNKNOWN");
        }
    }

    if(device.type == MiuraDeviceStatusType_APPLICATION_SELECTION) {
        return LocalizedReaderString(@"PNEReaderState_MIURA_DEVICE_INFO__APPLICATION_SELECTION");
    }

    if(device.type == MiuraDeviceStatusType_DEVICE_POWERING_OFF) {
        return LocalizedReaderString(@"PNEReaderState_MIURA_DEVICE_INFO__DEVICE_POWERING_OFF");
    }

    if(device.type == MiuraDeviceStatusType_MPI_RESTARTING) {
        return LocalizedReaderString(@"PNEReaderState_MIURA_DEVICE_INFO__MPI_RESTARTING");
    }

    if(device.type == MiuraDeviceStatusType_DEVICE_POWER_ON) {
        return LocalizedReaderString(@"PNEReaderState_MIURA_DEVICE_INFO__MPI_RESTARTING");
    }

    return LocalizedReaderString(@"PNEReaderState_MIURA_DEVICE_INFO__PROCESSING");
}

- (NSString *)enteringPin:(NSUInteger)aDigits {
    if(aDigits == 0) {
        return LocalizedReaderString(@"MiuraPinEntryStatus__ENTER_PIN");
    }

    NSMutableString * pinDigits = [[NSMutableString alloc] init];
    for(int i=0; i<aDigits; i++) {
        [pinDigits appendString:@"*"];
    }

    return LocalizedReaderFormatString(@"MiuraPinEntryStatus__ENTERING_PIN", pinDigits);
}

- (NSString *)miuraCardStatus:(id)aMessage {
    if(![aMessage isKindOfClass:[MiuraCardStatusMessage class]]) {
        return [NSString stringWithFormat:@"Unknown class: %@", aMessage];
    }

    MiuraCardStatusMessage * miuraMessage = aMessage;

    if( miuraMessage.isCardPresent ) {
        return LocalizedReaderString(@"PNEReaderState_MIURA_CARD_STATUS__READING_CARD" );
    }

    return LocalizedReaderString(@"PNEReaderState_MIURA_CARD_STATUS__INSERT_CARD");
}

@end
