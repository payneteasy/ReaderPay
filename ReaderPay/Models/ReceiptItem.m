//
//  ReceiptItem.m
//
//  Created by Sergey Anisiforov on 27/09/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "ReceiptItem.h"

@implementation ReceiptItem {
    NSString *_name;
    NSString *_value;
    NSString *_secondName;
    NSString *_secondValue;
    ReceiptItemAlignment _alignment;
}

- (instancetype)initWithName:(NSString *)name value:(NSString *)value
                   alignment:(ReceiptItemAlignment)alignment {
    self = [super init];
    if (self) {
        _name = name;
        _value = value;
        _alignment = alignment;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name value:(NSString *)value
                  secondName:(NSString *)secondName secondValue:(NSString *)secondValue {
    self = [super init];
    if (self) {
        _name = name;
        _value = value;
        _secondName = secondName;
        _secondValue = secondValue;
    }
    return self;
}

- (NSInteger)count {
    return (_name || _value) ? (_secondName || _secondValue) ? 2 : 1 : 0;
}

@end
