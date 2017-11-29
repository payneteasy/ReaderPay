//
//  SignatureView.h
//
//  Created by Sergey Anisiforov on 13/06/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "DrawingView.h"

@interface SignatureView : DrawingView

@property (nonatomic, strong) UIColor *penColor;
@property (nonatomic, assign) CGFloat penWidth;
@property (nonatomic, assign) CGFloat penAlpha;

- (void)clear;

- (UIImage *)imageSignature;
- (NSDictionary *)jsonSignature;

@end
