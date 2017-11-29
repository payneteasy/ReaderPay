//
//  DrawingPenTool.h
//
//  Created by Sergey Anisiforov on 19.04.16.
//  Copyright © 2016 Sergey Anisiforov. All rights reserved.
//

#import "DrawingTool.h"

@interface DrawingPenTool : DrawingTool {
    CGMutablePathRef path;
}

- (CGRect)addPathPreviousPreviousPoint:(CGPoint)p2Point withPreviousPoint:(CGPoint)p1Point withCurrentPoint:(CGPoint)cpoint;

@end
