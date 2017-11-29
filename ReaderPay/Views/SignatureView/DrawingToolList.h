//
//  DrawingToolList.h
//
//  Created by Sergey Anisiforov on 20.04.16.
//  Copyright © 2016 Sergey Anisiforov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawingTool.h"

@interface DrawingToolList : NSObject

+ (instancetype)list;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;

- (NSInteger)count;
- (void)clear;
- (NSInteger)indexOfTool:(DrawingTool *)tool;
- (DrawingTool *)findTool:(NSString *)uid;
- (void)appendTool:(DrawingTool *)tool;
- (BOOL)removeTool:(DrawingTool *)tool;
- (DrawingTool *)toolAtIndex:(NSInteger)index;
- (DrawingTool *)getPrevTool:(DrawingTool *)tool;
- (DrawingTool *)getFirstTool;
- (DrawingTool *)getLastTool;
- (DrawingTool *)removeFirstTool;
- (DrawingTool *)removeLastTool;

@end
