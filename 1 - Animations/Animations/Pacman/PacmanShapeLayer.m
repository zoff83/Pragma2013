//
//  PacmanShapeLayer.m
//  Animations
//
//  Created by Marco Zoffoli on 03/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "PacmanShapeLayer.h"


@implementation PacmanShapeLayer

@synthesize slowAnimations;

// Initializes the receiving object
- (id)init {
    
    self = [super init];
    if(self) {
        self.fillColor = [UIColor colorWithRed: 235.0 / 255.0 green: 238.0 / 255.0 blue: 1.0 / 255.0 alpha: 1.0].CGColor;
        self.strokeColor = [UIColor blackColor].CGColor;
        self.lineWidth = 4;
    }
    
    return self;
}

// Sets the receiver's bounds
- (void)setBounds: (CGRect)bounds {
    super.bounds = bounds;
    self.path = [self pathWithAngle: M_PI / 6].CGPath;
}

// Returns a bezier path for a Pacman shape with a "mouth" open by the given angle
- (UIBezierPath *)pathWithAngle: (CGFloat)angle {
    CGFloat             radius;
    CGPoint             centerPoint;
    UIBezierPath        *path;
    
    centerPoint.x = self.bounds.size.width / 2;
    centerPoint.y = self.bounds.size.height / 2;
    radius = (self.bounds.size.width / 2) - 2;
    
    path = [[UIBezierPath alloc] init];
    
    [path moveToPoint: CGPointMake(0, centerPoint.y)];
    [path addArcWithCenter: centerPoint radius: radius startAngle: M_PI endAngle: angle clockwise: NO];
    [path addLineToPoint: centerPoint];
    
    [path moveToPoint: CGPointMake(0, centerPoint.y)];
    [path addArcWithCenter: centerPoint radius: radius startAngle: M_PI endAngle: -angle clockwise: YES];
    [path addLineToPoint: centerPoint];
    
    return path;
}

// Starts the animation
- (void)startAnimating {
    CABasicAnimation    *animation;
    CGPathRef           path;
    
    path = [self pathWithAngle: 0.001].CGPath;
    
    animation = [CABasicAnimation animationWithKeyPath: @"path"];
    animation.duration = !self.slowAnimations ? 0.3 : 1;
    animation.autoreverses = YES;
    animation.repeatCount = 1e100;
    animation.toValue = (__bridge id)path;
    [self addAnimation: animation forKey: @"animation"];
}

// Stops the animation
- (void)stopAnimating {
    CABasicAnimation    *animation;
    
    self.path = [self pathWithAngle: M_PI / 6].CGPath;
    
    animation = [CABasicAnimation animationWithKeyPath: @"path"];
    animation.duration = !self.slowAnimations ? 0.3 : 1;
    animation.autoreverses = YES;
    animation.repeatCount = 1e100;
    animation.toValue = (__bridge id)self.path;
    [self addAnimation: animation forKey: @"animation"];
}

// "Kills" pacman
- (void)die: (void (^)())completionBlock {
    CABasicAnimation    *animation;
    CGPathRef           path;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock: completionBlock];
    
    path = [self pathWithAngle: M_PI - 0.001].CGPath;
    
    animation = [CABasicAnimation animationWithKeyPath: @"path"];
    animation.duration = !self.slowAnimations ? 0.5 : 3;
    animation.fromValue = (__bridge id)[self.presentationLayer path];
    animation.toValue = (__bridge id)path;
    [self addAnimation: animation forKey: @"animation"];
    
    self.path = NULL;
    
    [CATransaction commit];
}

// Resets Pacman
- (void)newLife {
    self.path = [self pathWithAngle: M_PI / 6].CGPath;
}

@end
