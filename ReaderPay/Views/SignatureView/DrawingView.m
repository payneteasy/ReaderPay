/*
 * ACEDrawingView: https://github.com/acerbetti/ACEDrawingView
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "DrawingView.h"
#import <QuartzCore/QuartzCore.h>
#import "DrawingToolList.h"
#import "DrawingPenTool.h"

#define kDefaultLineColor       [UIColor blackColor]
#define kDefaultLineWidth       10.0f;
#define kDefaultLineAlpha       1.0f

@interface DrawingView () {
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
}

@property (nonatomic, strong) DrawingToolList *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;
@property (nonatomic, strong) DrawingTool *currentTool;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat originalFrameYPos;
@end

#pragma mark -

@implementation DrawingView {
    NSOperationQueue *operationQueue;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    // init the private arrays
    self.pathArray = [DrawingToolList list];
    self.bufferArray = [NSMutableArray array];
    
    // set the default values for the public properties
    self.lineColor = kDefaultLineColor;
    self.lineWidth = kDefaultLineWidth;
    self.lineAlpha = kDefaultLineAlpha;

    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
    
    self.originalFrameYPos = self.frame.origin.y;
    
    operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 1;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [self.image drawAtPoint:CGPointZero];
    [_currentTool draw];
}

- (void)redrawSinceTool:(DrawingTool *)sinceTool {
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);

    DrawingTool *prevTool = [_pathArray getPrevTool:sinceTool];
    DrawingTool *tool = nil;

    if (prevTool.image) {
        // draw stored image
        [prevTool.image drawAtPoint:CGPointZero];
        tool = sinceTool;
    } else {
        tool = [_pathArray getFirstTool];
    }
    
    NSInteger index = [_pathArray indexOfTool:tool];
    while (tool) {
        [tool draw];
        if (tool == prevTool) {
            tool.image = UIGraphicsGetImageFromCurrentImageContext();
            DrawingTool *prevPrevTool = [_pathArray getPrevTool:prevTool];
            prevPrevTool.image = nil;
        }
        index++;
        tool = [_pathArray toolAtIndex:index];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // add the first touch
    UITouch *touch = [touches anyObject];
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    [operationQueue addOperationWithBlock:^{
        // create new tool
        _currentTool = [[DrawingPenTool alloc] init];
        _currentTool.lineWidth = _lineWidth;
        _currentTool.lineColor = _lineColor;
        _currentTool.lineAlpha = _lineAlpha;
        
        // call the delegate
        if ([self.delegate respondsToSelector:@selector(drawingView:willBeginDrawInPoint:)]) {
            [self.delegate drawingView:self willBeginDrawInPoint:currentPoint];
        }
        
        [_currentTool setFirstPoint:currentPoint];
        [_pathArray appendTool:_currentTool];
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    CGPoint prevPrevPoint = previousPoint2;
    CGPoint prevPoint = previousPoint1;
    CGPoint currPoint = currentPoint;
    
    [operationQueue addOperationWithBlock:^{
        // update tool
        CGRect drawBox = [(DrawingPenTool *)_currentTool addPathPreviousPreviousPoint:prevPrevPoint withPreviousPoint:prevPoint withCurrentPoint:currPoint];
        drawBox.origin.x -= self.lineWidth * 2.0;
        drawBox.origin.y -= self.lineWidth * 2.0;
        drawBox.size.width += self.lineWidth * 4.0;
        drawBox.size.height += self.lineWidth * 4.0;
        
        // redraw
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self setNeedsDisplayInRect:drawBox];
        }];

        // call the delegate
        if ([self.delegate respondsToSelector:@selector(drawingView:didContinueDrawInPoint:)]) {
            [self.delegate drawingView:self didContinueDrawInPoint:currentPoint];
        }
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];
    
    [operationQueue addOperationWithBlock:^{
        // update the image
        [self redrawSinceTool:_currentTool];
        
        // clear the redo queue
        [self.bufferArray removeAllObjects];
        
        // call the delegate
        if ([self.delegate respondsToSelector:@selector(drawingView:didEndDrawInPoint:)]) {
            [self.delegate drawingView:self didEndDrawInPoint:currentPoint];
        }
        
        // clear the current tool
        _currentTool = nil;
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - Load Image

- (void)resetTool {
    _currentTool = nil;
}

#pragma mark - Import

- (void)appendDrawingTool:(DrawingTool *)tool {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [_pathArray appendTool:tool];
        [self redrawSinceTool:tool];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self setNeedsDisplay];
        }];
    }];
    operation.queuePriority = NSOperationQueuePriorityLow;
    [operationQueue addOperation:operation];
}

- (void)removeDrawingTool:(DrawingTool *)tool {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        DrawingTool *findTool = [_pathArray findTool:tool.uid];
        DrawingTool *prevTool = [_pathArray getPrevTool:findTool];
        [_pathArray removeTool:findTool];
        [self redrawSinceTool:prevTool];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self setNeedsDisplay];
        }];
    }];
    operation.queuePriority = NSOperationQueuePriorityLow;
    [operationQueue addOperation:operation];
}

#pragma mark - Actions

- (void)clear {
    [operationQueue addOperationWithBlock:^{
        [self resetTool];
        [_bufferArray removeAllObjects];
        [_pathArray clear];
        [self redrawSinceTool:nil];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self setNeedsDisplay];
        }];
    }];
}

- (void)dealloc {
    self.pathArray = nil;
    self.bufferArray = nil;
    self.currentTool = nil;
    self.image = nil;
}

@end
