//
//  SignatureView.m
//
//  Created by Sergey Anisiforov on 13/06/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "SignatureView.h"

@interface SignatureView () <DrawingViewDelegate>

@end

@implementation SignatureView {
    NSMutableArray *_arrayGlyph;
    NSMutableArray *_arrayPoint;
    NSDate *_startDrawing;
    int _pointX;
    int _pointY;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    _arrayGlyph = [NSMutableArray array];
    self.penColor = [UIColor blackColor];
    self.penAlpha = 1.0;
    self.penWidth = 4.0;
    self.delegate = self;
}

- (UIColor *)penColor {
    return self.lineColor;
}

- (void)setPenColor:(UIColor *)penColor {
    self.lineColor = penColor;
}

- (CGFloat)penWidth {
    return self.lineWidth;
}

- (void)setPenWidth:(CGFloat)penWidth {
    self.lineWidth = penWidth;
}

- (CGFloat)penAlpha {
    return self.lineAlpha;
}

- (void)setPenAlpha:(CGFloat)penAlpha {
    self.lineAlpha = penAlpha;
}

- (void)clear {
    [super clear];
    [_arrayGlyph removeAllObjects];
    [self clearHistory];
}

- (void)clearHistory {
    _arrayPoint = nil;
    _startDrawing = nil;
    _pointX = -1;
    _pointY = -1;
}

- (UIImage *)imageSignature {
    return self.image;
}

- (NSDictionary *)jsonSignature {
    if (_arrayGlyph.count)
        return @{@"width": @(self.frame.size.width), @"height": @(self.frame.size.height), @"glyphs": _arrayGlyph};
    return nil;
}

#pragma mark - Internal methods

- (void)appendGlyphPoint:(CGPoint)point withInterval:(CGFloat)interval {
    int pointX = (int)point.x;
    int pointY = (int)point.y;
    if (pointX != _pointX && pointY != _pointY) {
        [_arrayPoint addObject:@[@(pointX), @(pointY), @((int)interval)]];
        _pointX = pointX;
        _pointY = pointY;
    }
}

#pragma mark - DrawingViewDelegate

- (void)drawingView:(DrawingView *)view willBeginDrawInPoint:(CGPoint)point {
    _startDrawing = [NSDate date];
    _arrayPoint = [NSMutableArray array];
    [self appendGlyphPoint:point withInterval:0];
}

- (void)drawingView:(DrawingView *)view didContinueDrawInPoint:(CGPoint)point {
    [self appendGlyphPoint:point withInterval:[_startDrawing timeIntervalSinceNow]*-1000.0];
}

- (void)drawingView:(DrawingView *)view didEndDrawInPoint:(CGPoint)point {
    [_arrayGlyph addObject:_arrayPoint];
    [self clearHistory];
}

@end
