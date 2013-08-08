//
//  HelpOverlayView.m
//  Helper
//
//  Created by Sven A. Schmidt on 07/08/2013.
//  Copyright (c) 2013 Sven A. Schmidt. All rights reserved.
//

#import "HelpOverlayView.h"


const CGFloat TipLength = 20;
const CGFloat TipTheta = 20/180.*M_PI; // tip opening angle
const CGFloat BaseTheta = 5/180.*M_PI; // base opening angle
const CGFloat BaseInset = 8;


@interface HelpOverlayView ()

@property (nonatomic, assign) CGPoint arrowTip;
@property (nonatomic, assign) CGPoint controlPoint;
@property (nonatomic, assign) BOOL arrowTipTouched;
@property (nonatomic, assign) BOOL controlPointTouched;

@end


@implementation HelpOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.arrowFrame = CGRectMake(0, 0,
                                     0.3*CGRectGetWidth(self.frame),
                                     0.3*CGRectGetHeight(self.frame));
        { // set control point
            const CGFloat cpInset = 20;
            CGFloat w = CGRectGetWidth(self.arrowFrame);
            self.controlPoint = CGPointMake(self.arrowTip.x + w - cpInset, self.arrowTip.y + cpInset);
        }
        self.arrowTip = self.arrowFrame.origin;
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
        { // set up shadow to improve readability
            UIColor *shadowColor =  [UIColor colorWithWhite:0.2 alpha:0.5];
            shadowColor = [UIColor blackColor];
            self.descriptionView.clipsToBounds = NO;
            self.descriptionView.layer.masksToBounds = YES;
            self.descriptionView.layer.cornerRadius = 8;
            self.descriptionView.layer.shadowColor = shadowColor.CGColor;
            self.descriptionView.layer.shadowOffset = CGSizeMake(3, 5);
            self.descriptionView.layer.shadowRadius = 4;
            self.descriptionView.layer.shadowOpacity = 1;
        }
       [self addSubview:self.descriptionView];
    }
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
    return [self pointAtRadius:r angle:phi origin:CGPointZero];
}


- (CGPoint)pointAtRadius:(CGFloat)r angle:(CGFloat)phi origin:(CGPoint)origin
{
    return CGPointMake(origin.x + r * cos(phi), origin.y + r * sin(phi));
}


- (CGFloat)alpha
{
    return atan((self.arrowTip.y - self.controlPoint.y)/(self.arrowTip.x - self.controlPoint.x));
}


- (CGPoint)a1
{
    return [self pointAtRadius:TipLength angle:(self.alpha - TipTheta) origin:self.arrowTip];
}


- (CGPoint)a2
{
    return [self pointAtRadius:TipLength angle:(self.alpha + TipTheta) origin:self.arrowTip];
}


- (CGPoint)s1
{
    return [self pointAtRadius:0.95*TipLength angle:(self.alpha - BaseTheta) origin:self.arrowTip];
}


- (CGPoint)s2
{
    return [self pointAtRadius:0.95*TipLength angle:(self.alpha + BaseTheta) origin:self.arrowTip];
}


- (CGPoint)e1
{
    CGFloat w = CGRectGetWidth(self.arrowFrame);
    CGFloat h = CGRectGetHeight(self.arrowFrame);
    return CGPointMake(w + BaseInset, h);
}


- (CGPoint)e2
{
    CGFloat w = CGRectGetWidth(self.arrowFrame);
    CGFloat h = CGRectGetHeight(self.arrowFrame);
    return CGPointMake(w, h + BaseInset);
}


- (void)drawRect:(CGRect)rect
{
    { // arrow line
        [self.mainColor setFill];
        UIBezierPath *p = [UIBezierPath new];
        [p moveToPoint:self.s1];
        [p addQuadCurveToPoint:self.e1 controlPoint:self.controlPoint];
        [p addLineToPoint:self.e2];
        [p addQuadCurveToPoint:self.s2 controlPoint:self.controlPoint];
        [p fill];
    }
    { // arrow tip
        [self.mainColor setFill];
        UIBezierPath *p = [UIBezierPath new];
        [p moveToPoint:self.arrowTip];
        [p addLineToPoint:self.a1];
        [p addLineToPoint:self.a2];
        [p fill];
    }
    { // control point
        [[UIColor grayColor] setFill];
        UIBezierPath *p = [UIBezierPath bezierPathWithOvalInRect:self.controlArea];
        [p fill];
    }
}


#pragma mark - Touch handling


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    const CGFloat touchRadius = 60;
    UITouch *touch = [touches anyObject];
    CGPoint hit = [touch locationInView:self];

    if (CGRectContainsPoint([self squareAroundPoint:self.controlPoint size:touchRadius], hit)) {
        self.controlPointTouched = YES;
    } else if (CGRectContainsPoint([self squareAroundPoint:self.arrowTip size:touchRadius], hit)) {
        self.arrowTipTouched = YES;
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
    } else if (self.arrowTipTouched) {
        self.arrowTip =CGPointMake(self.arrowTip.x + dx, self.arrowTip.y + dy);
    } else {
        self.frame = CGRectOffset(self.frame, dx, dy);
    }
    [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.controlPointTouched = NO;
    self.arrowTipTouched = NO;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.controlPointTouched = NO;
    self.arrowTipTouched = NO;
}


@end
