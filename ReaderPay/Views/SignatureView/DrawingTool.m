//
//  DrawingTool.m
//
//  Created by Sergey Anisiforov on 19.04.16.
//  Copyright © 2016 Sergey Anisiforov. All rights reserved.
//

#import "DrawingTool.h"

@interface DrawingTool () {
    NSString *toolUID;
}

@end

@implementation DrawingTool

- (NSString *)uid {
    if (!toolUID) {
        toolUID = [[NSUUID UUID] UUIDString];
    }
    return toolUID;
}

- (void)adjustWithRatio:(CGVector)ratio {
}

- (void)setFirstPoint:(CGPoint)firstPoint {
}

- (void)draw {
}

@end
