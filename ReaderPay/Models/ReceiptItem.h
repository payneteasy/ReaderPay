//
//  ReceiptItem.h
//
//  Created by Sergey Anisiforov on 27/09/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ReceiptItemAlignment) {
    ReceiptItemAlignmentLeft,
    ReceiptItemAlignmentCenter,
    ReceiptItemAlignmentRight,
    ReceiptItemAlignmentJustified
};


@interface ReceiptItem : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *value;
@property (nonatomic, readonly) NSString *secondName;
@property (nonatomic, readonly) NSString *secondValue;
@property (nonatomic, readonly) ReceiptItemAlignment alignment;
@property (nonatomic, readonly) NSInteger count;

- (instancetype)initWithName:(NSString *)name
                       value:(NSString *)value
                   alignment:(ReceiptItemAlignment)alignment;

- (instancetype)initWithName:(NSString *)name
                       value:(NSString *)value
                  secondName:(NSString *)secondName
                 secondValue:(NSString *)secondValue;

@end
