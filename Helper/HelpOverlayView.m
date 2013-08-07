//
//  HelpOverlayView.m
//  Helper
//
//  Created by Sven A. Schmidt on 07/08/2013.
//  Copyright (c) 2013 Sven A. Schmidt. All rights reserved.
//

#import "HelpOverlayView.h"

@implementation HelpOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.arrowFrame = CGRectMake(0, 0,
                                     0.3*CGRectGetWidth(self.frame),
                                     0.3*CGRectGetHeight(self.frame));
    }
    return self;
}


- (void)layoutSubviews
{
    if (self.descriptionView) {
        // assuming a top left position of the arrow frame for now
        CGFloat x = CGRectGetWidth(self.arrowFrame);
        CGFloat y = CGRectGetHeight(self.arrowFrame);
        self.descriptionView.frame = CGRectMake(x, y,
                                                CGRectGetWidth(self.frame) - x,
                                                CGRectGetHeight(self.frame) - y);
        [self addSubview:self.descriptionView];
    }
}


- (void)drawRect:(CGRect)rect
{
    CGPoint start = self.arrowFrame.origin;
    CGFloat w = CGRectGetWidth(self.arrowFrame);
    CGFloat h = CGRectGetHeight(self.arrowFrame);
    CGPoint end = CGPointMake(start.x + w, start.y + h);
    CGFloat inset = 20;
    CGPoint cp = CGPointMake(start.x + w - inset, start.y + inset);

    { // arrow line
        UIBezierPath *p = [UIBezierPath new];
        [p moveToPoint:start];
        [p addQuadCurveToPoint:end controlPoint:cp];
        p.lineWidth = 4;
        [p stroke];
    }
    { // arrow tip
        const CGFloat l = 20; // "hat" length
        const CGFloat theta = 20/180.*M_PI; // opening angle
        CGFloat alpha = tan(cp.y/cp.x); // TODO handle /0
        CGPoint a1 = CGPointMake(l * cos(alpha - theta), l * sin(alpha - theta));
        CGPoint a2 = CGPointMake(l * cos(alpha + theta), l * sin(alpha + theta));
        UIBezierPath *p = [UIBezierPath new];
        p.lineWidth = 4;
        [p moveToPoint:start];
        [p addLineToPoint:a1];
        [p addLineToPoint:a2];
        [p fill];
    }
}


@end
