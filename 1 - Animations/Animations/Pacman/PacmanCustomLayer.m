//
//  PacmanCustomLayer.m
//  Animations
//
//  Created by Marco Zoffoli on 03/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "PacmanCustomLayer.h"


@implementation PacmanCustomLayer

@dynamic angle;
@dynamic fillColor;
@dynamic strokeColor;
@dynamic strokeWidth;

@synthesize slowAnimations;

// Returns a Boolean indicating whether changes to the specified key require the layer to be redisplayed.
+ (BOOL)needsDisplayForKey: (NSString *)key {
    BOOL    needsDisplay;
    
    if([key isEqualToString: @"angle"]       ||
       [key isEqualToString: @"fillColor"]   ||
       [key isEqualToString: @"strokeColor"] ||
       [key isEqualToString: @"strokeWidth"])
        needsDisplay = YES;
    else
        needsDisplay = [super needsDisplayForKey: key];
    
    return needsDisplay;
}

// Initializes the receiving object
- (id)init {
    
    self = [super init];
    if(self) {
        self.angle = 1.0 / 6.0;
        self.fillColor = [UIColor colorWithRed: 235.0 / 255.0 green: 238.0 / 255.0 blue: 1.0 / 255.0 alpha: 1.0];
        self.strokeColor = [UIColor blackColor];
        self.strokeWidth = 4;
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    
    return self;
}

// Draws the layer's contents
- (void)drawInContext: (CGContextRef)context {
    CGFloat         angle;
    CGFloat         radius;
    CGPoint         centerPoint;
    UIBezierPath    *path;
    
    [super drawInContext: context];

    // A value of 1.0 for angle (corresponing to M_PI) will render as a full circle, instead of an empty one
    angle = (self.angle != 1.0) ? self.angle : (1.0 - 0.000001);
    
    // Build the path for drawing the shape
    centerPoint.x = self.bounds.size.width / 2;
    centerPoint.y = self.bounds.size.height / 2;
    radius = (self.bounds.size.width - self.strokeWidth) / 2;
    
    path = [[UIBezierPath alloc] init];
    
    [path moveToPoint: CGPointMake(0, centerPoint.y)];
    [path addArcWithCenter: centerPoint radius: radius startAngle: M_PI endAngle: (M_PI * angle) clockwise: NO];
    [path addLineToPoint: centerPoint];
    
    [path moveToPoint: CGPointMake(0, centerPoint.y)];
    [path addArcWithCenter: centerPoint radius: radius startAngle: M_PI endAngle: -(M_PI * angle) clockwise: YES];
    [path addLineToPoint: centerPoint];
    
    // Fill and stroke the path
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    CGContextSetLineWidth(context, self.strokeWidth);
    
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    
    if(self.angle != 1.0) {
        CGContextAddPath(context, path.CGPath);
        CGContextStrokePath(context);
    }
}

// Starts the animation
- (void)startAnimating {
    CABasicAnimation    *animation;
    
    animation = [CABasicAnimation animationWithKeyPath: @"angle"];
    animation.duration = !self.slowAnimations ? 0.3 : 1;
    animation.autoreverses = YES;
    animation.repeatCount = 1e100;
    animation.toValue = @(0);
    [self addAnimation: animation forKey: @"animation"];
}

// Stops the animation
- (void)stopAnimating {
    CABasicAnimation    *animation;
    
    animation = [CABasicAnimation animationWithKeyPath: @"angle"];
    animation.duration = !self.slowAnimations ? 0.3 : 1;
    animation.fromValue = @([self.presentationLayer angle]);
    animation.toValue = @(1.0 / 6.0);
    [self addAnimation: animation forKey: @"animation"];
    
    self.angle = 1.0 / 6.0;
}

// "Kills" pacman
- (void)die: (void (^)())completionBlock {
    CABasicAnimation    *animation;
    
    self.angle = 1.0;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock: completionBlock];
    
    animation = [CABasicAnimation animationWithKeyPath: @"angle"];
    animation.duration = !self.slowAnimations ? 0.5 : 3;
    animation.fromValue = @([self.presentationLayer angle]);
    animation.toValue = @(1.0);
    [self addAnimation: animation forKey: @"animation"];
    
    [CATransaction commit];
}

// Resets Pacman
- (void)newLife {
    self.angle = 1.0 / 6.0;
}

@end
