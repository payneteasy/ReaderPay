//
//  DrawingToolList.m
//
//  Created by Sergey Anisiforov on 20.04.16.
//  Copyright © 2016 Sergey Anisiforov. All rights reserved.
//

#import "DrawingToolList.h"

@interface DrawingToolList () {
    NSMutableArray *array;
    NSMutableDictionary *dict;
}

@end

@implementation DrawingToolList

+ (instancetype)list {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        array = [NSMutableArray array];
        dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSInteger)count {
    return array.count;
}

- (void)clear {
    [array removeAllObjects];
    [dict removeAllObjects];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [array countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSInteger)indexOfTool:(DrawingTool *)tool {
    return [array indexOfObject:tool];
}

- (void)appendTool:(DrawingTool *)tool {
    [array addObject:tool];
    [dict setObject:tool forKey:tool.uid];
}

- (BOOL)removeTool:(DrawingTool *)tool {
    DrawingTool *findTool = [dict objectForKey:tool.uid];
    if (findTool) {
        [array removeObject:findTool];
        [dict removeObjectForKey:tool.uid];
        return YES;
    }
    return NO;
}

- (DrawingTool *)findTool:(NSString *)uid {
    return [dict objectForKey:uid];
}

- (DrawingTool *)toolAtIndex:(NSInteger)index {
    if (index >= 0 && index < array.count)
        return [array objectAtIndex:index];
    return nil;
}

- (DrawingTool *)getPrevTool:(DrawingTool *)tool {
    NSUInteger index = [array indexOfObject:tool];
    if (index >= 1 && index < array.count)
        return [array objectAtIndex:index-1];
    return nil;
}

- (DrawingTool *)getFirstTool {
    if (array.count)
        return [array objectAtIndex:0];
    return nil;
}

- (DrawingTool *)getLastTool {
    if (array.count)
        return [array objectAtIndex:array.count-1];
    return nil;
}

- (DrawingTool *)removeFirstTool {
    DrawingTool *tool = [self getFirstTool];
    if (tool)
        [self removeTool:tool];
    return tool;
}

- (DrawingTool *)removeLastTool {
    DrawingTool *tool = [self getLastTool];
    if (tool)
        [self removeTool:tool];
    return tool;
}

@end
