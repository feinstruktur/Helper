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
    UIBezierPath *path = [UIBezierPath new];
    CGPoint start = self.arrowFrame.origin;
    CGFloat w = CGRectGetWidth(self.arrowFrame);
    CGFloat h = CGRectGetHeight(self.arrowFrame);
    CGPoint end = CGPointMake(start.x + w, start.y + h);
    CGPoint control = CGPointMake(start.x + w, start.y);
    [path moveToPoint:start];
    [path addQuadCurveToPoint:end controlPoint:control];
    path.lineWidth = 4;
    [path stroke];
}


@end
