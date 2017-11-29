//
//  DrawingTool.h
//
//  Created by Sergey Anisiforov on 19.04.16.
//  Copyright © 2016 Sergey Anisiforov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingTool : NSObject

@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) UIImage *image;

- (void)adjustWithRatio:(CGVector)ratio;
- (void)setFirstPoint:(CGPoint)firstPoint;
- (void)draw;

@end
