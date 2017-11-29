//
//  UIView+Constraints.m
//
//  Created by Sergey Anisiforov on 28/11/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "UIView+Constraints.h"

@implementation UIView (Constraints)

 - (void)autoPinToSuperview {
    [[NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeLeft
                                 multiplier:1
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeRight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeRight
                                 multiplier:1
                                   constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:0] setActive:YES];

    [[NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeBottom
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.superview
                                  attribute:NSLayoutAttributeBottom
                                 multiplier:1
                                   constant:0] setActive:YES];
}

@end
