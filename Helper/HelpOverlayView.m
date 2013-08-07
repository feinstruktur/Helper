//
//  HelpOverlayView.m
//  Helper
//
//  Created by Sven A. Schmidt on 07/08/2013.
//  Copyright (c) 2013 Sven A. Schmidt. All rights reserved.
//

#import "HelpOverlayView.h"


@interface HelpOverlayView ()

@property (nonatomic, readonly) CGPoint arrowTip;
@property (nonatomic, assign) CGPoint controlPoint;
@property (nonatomic, readonly) CGRect controlArea;
@property (nonatomic, assign) BOOL controlPointTouched;

@end


@implementation HelpOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.arrowFrame = CGRectMake(0, 0,
                                     0.3*CGRectGetWidth(self.frame),
                                     0.3*CGRectGetHeight(self.frame));
        { // set control point
            const CGFloat cpInset = 20;
            CGFloat w = CGRectGetWidth(self.arrowFrame);
            self.controlPoint = CGPointMake(self.arrowTip.x + w - cpInset, self.arrowTip.y + cpInset);
        }
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


- (CGPoint)arrowTip
{
    return self.arrowFrame.origin;
}


- (CGRect)controlArea
{
    const CGFloat cpRadius = 4;
    CGRect frame = CGRectMake(self.controlPoint.x, self.controlPoint.y, 2*cpRadius, 2*cpRadius);
    frame = CGRectOffset(frame, -cpRadius, -cpRadius);
    return frame;
}


- (void)drawRect:(CGRect)rect
{
    const CGFloat baseInset = 8;
    CGFloat w = CGRectGetWidth(self.arrowFrame);
    CGFloat h = CGRectGetHeight(self.arrowFrame);
    CGPoint start = self.arrowTip;
    CGPoint e1 = CGPointMake(start.x + w, start.y + h + baseInset);
    CGPoint e2 = CGPointMake(start.x + w + baseInset, start.y + h);

    { // control point
        [[UIColor grayColor] setFill];
        UIBezierPath *p = [UIBezierPath bezierPathWithOvalInRect:self.controlArea];
        [p fill];
    }
    { // arrow line
        [[UIColor blackColor] setFill];
        UIBezierPath *p = [UIBezierPath new];
        [p moveToPoint:start];
        [p addQuadCurveToPoint:e1 controlPoint:self.controlPoint];
        [p addLineToPoint:e2];
        [p addQuadCurveToPoint:start controlPoint:self.controlPoint];
        [p fill];
    }
    { // arrow tip
        [[UIColor blackColor] setFill];
        const CGFloat l = 20; // "hat" length
        const CGFloat theta = 20/180.*M_PI; // opening angle
        CGFloat alpha = atan(self.controlPoint.y/self.controlPoint.x);
        CGPoint a1 = CGPointMake(l * cos(alpha - theta), l * sin(alpha - theta));
        CGPoint a2 = CGPointMake(l * cos(alpha + theta), l * sin(alpha + theta));
        UIBezierPath *p = [UIBezierPath new];
        [p moveToPoint:start];
        [p addLineToPoint:a1];
        [p addLineToPoint:a2];
        [p fill];
    }
}


#pragma mark - Touch handling


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        CGPoint hit = [t locationInView:self];
        if (CGRectContainsPoint(self.controlArea, hit)) {
            self.controlPointTouched = YES;
            return;
        }
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint last = [touch previousLocationInView:self];
    CGPoint current = [touch locationInView:self];
    CGFloat dx = current.x - last.x;
    CGFloat dy = current.y - last.y;
    self.controlPoint = CGPointMake(self.controlPoint.x + dx, self.controlPoint.y + dy);
    [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.controlPointTouched = NO;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.controlPointTouched = NO;
}


@end
