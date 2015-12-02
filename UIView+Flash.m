//
//  UIView+Flash.m
//  HLLClock
//
//  Created by admin on 15/12/2.
//  Copyright © 2015年 HLL. All rights reserved.
//

#import "UIView+Flash.h"
#import <objc/runtime.h>

/**
 *  default animation duration
 */
const CGFloat AnimationDuration = .9f;
/**
 *  default circle raius
 */
const CGFloat FlashInnerCircleInitialRaius = 20.0f;
/**
 *  the layer scale animation key
 */
static NSString * const circleShaperLayer = @"circleShaperLayer";

@implementation UIView (Flash)

- (void) hll_openFlashEffectAndSetFlashColor:(UIColor *)flashColor{

    objc_setAssociatedObject(self, @selector(getFlashColor), flashColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hll_flashViewDidTap:)];
    [self addGestureRecognizer:tap];
}

- (UIColor *) getFlashColor{

    return objc_getAssociatedObject(self, _cmd);
}
- (void) hll_flashViewDidTap:(UITapGestureRecognizer *)tapGestureHandler{

    CGPoint tapLocation = [tapGestureHandler locationInView:self];

    CGFloat scale = 1.0f;
    self.clipsToBounds = YES;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat biggerEdge = width > height ? width : height;
    CGFloat smallerEdge = width > height ? height : width;
    
    CGFloat radius = smallerEdge / 2 > FlashInnerCircleInitialRaius ? FlashInnerCircleInitialRaius : smallerEdge / 2;
    
    scale = biggerEdge / radius + 0.5;
    CGPoint position = CGPointMake(tapLocation.x, tapLocation.y);
    CGRect pathRect = CGRectMake(0, 0, radius * 2, radius * 2);
    CAShapeLayer * circleShape = [self hll_createCircleShapeWithPosition:position
                                                          pathoundedRect:pathRect
                                                            cornerRadius:radius];
    
    [self.layer addSublayer:circleShape];
    
    CAAnimationGroup *groupAnimation = [self hll_createFlashAnimationWithScale:scale duration:AnimationDuration];
    
    [groupAnimation setValue:circleShape forKey:circleShaperLayer];
    
    [circleShape addAnimation:groupAnimation forKey:nil];
    [circleShape setDelegate:self];
}

// creat shape layer with position 、layer rect 、corner radius
- (CAShapeLayer *) hll_createCircleShapeWithPosition:(CGPoint)position pathoundedRect:(CGRect)rect cornerRadius:(CGFloat)radius
{
    CAShapeLayer *circleShape = [CAShapeLayer layer];
    circleShape.path = [self hll_createCirclePathWithRoundedRect:rect cornerRadius:radius];
    circleShape.position = position;
    
    circleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
    UIColor * flashColor = [self getFlashColor];
    circleShape.fillColor = flashColor ? flashColor.CGColor : [UIColor whiteColor].CGColor;
    
    circleShape.opacity = 0;
    circleShape.lineWidth = 1;
    
    return circleShape;
}

// layer group animation for the shape layer
- (CAAnimationGroup *) hll_createFlashAnimationWithScale:(CGFloat)scale duration:(CGFloat)duration
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.delegate = self;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return animation;
}
// through BezierPath creat Path for the shape layer
- (CGPathRef) hll_createCirclePathWithRoundedRect:(CGRect)frame cornerRadius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CALayer *layer = [anim valueForKey:circleShaperLayer];
    if (layer) {
        [layer removeFromSuperlayer];
    }
}

@end
