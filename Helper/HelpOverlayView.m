//
//  HelpOverlayView.m
//  Helper
//
//  Created by Sven A. Schmidt on 07/08/2013.
//  Copyright (c) 2013 Sven A. Schmidt. All rights reserved.
//

#import "HelpOverlayView.h"


@interface HelpOverlayView ()

@property (nonatomic, assign) CGPoint controlPoint;
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
    return [self squareAroundPoint:self.controlPoint size:8];
}


- (CGRect)squareAroundPoint:(CGPoint)point size:(CGFloat)size
{
    CGRect frame = CGRectMake(point.x, point.y, size, size);
    frame = CGRectOffset(frame, -size/2, -size/2);
    return frame;
}


- (CGPoint)pointAtRadius:(CGFloat)r angle:(CGFloat)phi
{
    return CGPointMake(r * cos(phi), r * sin(phi));
}


- (void)drawRect:(CGRect)rect
{
    const CGFloat baseInset = 8;
    const CGFloat hatLength = 20;

    CGFloat alpha = atan(self.controlPoint.y/self.controlPoint.x);

    CGPoint tip = self.arrowTip;

    { // control point
        [[UIColor grayColor] setFill];
        UIBezierPath *p = [UIBezierPath bezierPathWithOvalInRect:self.controlArea];
        [p fill];
    }
    { // arrow line
        [[UIColor blackColor] setFill];
        const CGFloat theta = 5/180.*M_PI; // opening angle
        CGFloat w = CGRectGetWidth(self.arrowFrame);
        CGFloat h = CGRectGetHeight(self.arrowFrame);

        CGPoint s1 = [self pointAtRadius:0.95*hatLength angle:(alpha - theta)];
        CGPoint s2 = [self pointAtRadius:0.95*hatLength angle:(alpha + theta)];
        CGPoint e1 = CGPointMake(tip.x + w + baseInset, tip.y + h);
        CGPoint e2 = CGPointMake(tip.x + w, tip.y + h + baseInset);

        UIBezierPath *p = [UIBezierPath new];
        [p moveToPoint:s1];
        [p addQuadCurveToPoint:e1 controlPoint:self.controlPoint];
        [p addLineToPoint:e2];
        [p addQuadCurveToPoint:s2 controlPoint:self.controlPoint];
        [p fill];
    }
    { // arrow tip
        [[UIColor blackColor] setFill];
        const CGFloat theta = 20/180.*M_PI; // opening angle

        CGPoint a1 = [self pointAtRadius:hatLength angle:(alpha - theta)];
        CGPoint a2 = [self pointAtRadius:hatLength angle:(alpha + theta)];

        UIBezierPath *p = [UIBezierPath new];
        [p moveToPoint:tip];
        [p addLineToPoint:a1];
        [p addLineToPoint:a2];
        [p fill];
    }
}


#pragma mark - Touch handling


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint hit = [touch locationInView:self];
    CGRect hitArea = [self squareAroundPoint:self.controlPoint size:44];
    if (CGRectContainsPoint(hitArea, hit)) {
        self.controlPointTouched = YES;
        return;
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint last = [touch previousLocationInView:self];
    CGPoint current = [touch locationInView:self];
    CGFloat dx = current.x - last.x;
    CGFloat dy = current.y - last.y;
    if (self.controlPointTouched) {
        self.controlPoint = CGPointMake(self.controlPoint.x + dx, self.controlPoint.y + dy);
    } else {
        self.frame = CGRectOffset(self.frame, dx, dy);
    }
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
