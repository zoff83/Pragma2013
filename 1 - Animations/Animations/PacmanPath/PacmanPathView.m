//
//  PacmanPathView.m
//  Animations
//
//  Created by Marco Zoffoli on 05/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "PacmanPathView.h"
#import "PacmanCustomLayer.h"


@interface PacmanPathView ()

@property (nonatomic, assign, readwrite)    BOOL                dead;
@property (nonatomic, strong, readwrite)    CALayer             *enemyLayer;
@property (nonatomic, strong, readwrite)    PacmanCustomLayer   *pacmanLayer;
@property (nonatomic, strong, readwrite)    NSArray             *enemyPathPoints;
@property (nonatomic, strong, readwrite)    NSArray             *pacmanPathPoints;
@property (nonatomic, strong, readwrite)    NSMutableArray      *foodPoints;
@property (nonatomic, strong, readwrite)    NSTimer             *collisionTimer;
@property (nonatomic, strong, readwrite)    UIBezierPath        *pacmanPath;

@end


@implementation PacmanPathView

// Called after the receiver has been loaded from a nib file
- (void)awakeFromNib {
    CGPoint point;
    UIImage *image;
    
    // Create the path points (and bezier path) for Pacman
    self.pacmanPathPoints = @[[NSValue valueWithCGPoint: CGPointMake(270, 457)],
                              [NSValue valueWithCGPoint: CGPointMake(281, 457)],
                              
                              [NSValue valueWithCGPoint: CGPointMake(300, 457)],
                              [NSValue valueWithCGPoint: CGPointMake(300, 438)],
                              [NSValue valueWithCGPoint: CGPointMake(300, 419)],
                              [NSValue valueWithCGPoint: CGPointMake(300, 400)],
                              
                              [NSValue valueWithCGPoint: CGPointMake(319, 400)],
                              [NSValue valueWithCGPoint: CGPointMake(338, 400)],
                              [NSValue valueWithCGPoint: CGPointMake(357, 400)],
                              
                              [NSValue valueWithCGPoint: CGPointMake(357, 381)],
                              [NSValue valueWithCGPoint: CGPointMake(357, 362)],
                              [NSValue valueWithCGPoint: CGPointMake(357, 343)],
                              [NSValue valueWithCGPoint: CGPointMake(357, 324)],
                              [NSValue valueWithCGPoint: CGPointMake(357, 305)],
                              [NSValue valueWithCGPoint: CGPointMake(357, 286)],
                              [NSValue valueWithCGPoint: CGPointMake(357, 267)],
                              [NSValue valueWithCGPoint: CGPointMake(357, 248)],
                              [NSValue valueWithCGPoint: CGPointMake(357, 229)]];
    
    self.pacmanPath = [[UIBezierPath alloc] init];
    for(NSUInteger i = 0; i < self.pacmanPathPoints.count; i++) {
        point = [self.pacmanPathPoints[i] CGPointValue];
        if(i == 0)
            [self.pacmanPath moveToPoint: point];
        else
            [self.pacmanPath addLineToPoint: point];
    }
    
    // Create the path points for food
    self.foodPoints = [self.pacmanPathPoints mutableCopy];
    [self.foodPoints removeObjectAtIndex: 0];
    
    // Create the path points for the enemy
    self.enemyPathPoints = @[[NSValue valueWithCGPoint: CGPointMake(272, 286)],
                             [NSValue valueWithCGPoint: CGPointMake(272, 267)],
                             [NSValue valueWithCGPoint: CGPointMake(272, 248)],
                             [NSValue valueWithCGPoint: CGPointMake(272, 229)],
                             
                             [NSValue valueWithCGPoint: CGPointMake(289, 229)],
                             [NSValue valueWithCGPoint: CGPointMake(306, 229)],
                             [NSValue valueWithCGPoint: CGPointMake(323, 229)],
                             [NSValue valueWithCGPoint: CGPointMake(340, 229)],
                             
                             [NSValue valueWithCGPoint: CGPointMake(357, 229)],
                             [NSValue valueWithCGPoint: CGPointMake(357, 248)],
                             [NSValue valueWithCGPoint: CGPointMake(357, 267)],
                             [NSValue valueWithCGPoint: CGPointMake(357, 286)],
                             [NSValue valueWithCGPoint: CGPointMake(357, 305)],
                             [NSValue valueWithCGPoint: CGPointMake(357, 324)],
                             [NSValue valueWithCGPoint: CGPointMake(357, 343)],
                             [NSValue valueWithCGPoint: CGPointMake(357, 362)],
                             [NSValue valueWithCGPoint: CGPointMake(357, 381)],
                             [NSValue valueWithCGPoint: CGPointMake(357, 400)]];
    
    // Create the Pacman layer
    self.pacmanLayer = [PacmanCustomLayer layer];
    self.pacmanLayer.position = [self.pacmanPathPoints[0] CGPointValue];
    self.pacmanLayer.bounds = CGRectMake(0, 0, 22, 22);
    self.pacmanLayer.strokeWidth = 0;
    [self.layer addSublayer: self.pacmanLayer];
    
    // Create the enemy layer
    image =  [UIImage imageNamed: @"Enemy.png"];
    self.enemyLayer = [CALayer layer];
    self.enemyLayer.contents = (id)image.CGImage;
    self.enemyLayer.position = [self.enemyPathPoints[0] CGPointValue];
    self.enemyLayer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [self.layer insertSublayer: self.enemyLayer below: self.pacmanLayer];
}

// Draws the view's contents
- (void)drawRect: (CGRect)rect {
    CGPoint         point;
    CGRect          frame;
    UIBezierPath    *path;
    
    [super drawRect: rect];

    for(NSValue *value in self.foodPoints) {
        point = [value CGPointValue];
        frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
        path = [UIBezierPath bezierPathWithOvalInRect: frame];
        [[UIColor yellowColor] setFill];
        [path fill];
    }
}

// Called repeatedly for checking collisions between Pacman and the enemy or Pacman and food
- (void)checkForCollision {
    BOOL        found;
    CGPoint     point;
    NSUInteger  i;
    
    // Pacman and the enemy
    found = CGRectIntersectsRect([self.pacmanLayer.presentationLayer frame], [self.enemyLayer.presentationLayer frame]);
    if(found) {
        self.dead = YES;
        self.pacmanLayer.position = [self.pacmanLayer.presentationLayer position];
        self.enemyLayer.position = [self.enemyLayer.presentationLayer position];
        
        // This will trigger the completionBlock for the startAnimating CATransaction
        [self.pacmanLayer removeAnimationForKey: @"pathAnimation"];
        [self.enemyLayer removeAnimationForKey: @"pathAnimation"];
        [self.enemyLayer removeAnimationForKey: @"flipAnimation"];
    }
    
    // Pacman and food
    i = 0;
    found = NO;
    while(!found && (i < self.foodPoints.count)) {
        point = [self.foodPoints[i] CGPointValue];
        found = CGRectContainsPoint([self.pacmanLayer.presentationLayer frame], point);
        if(!found)
            i++;
    }
    
    if(found) {
        [self.foodPoints removeObjectAtIndex: i];
        [self setNeedsDisplay];
    }
}

// Resets Pacman and enemy position and state
- (void)restart {
    [self.pacmanLayer newLife];
    self.pacmanLayer.position = [self.pacmanPathPoints[0] CGPointValue];
    self.enemyLayer.position = [self.enemyPathPoints[0] CGPointValue];
    
    self.foodPoints = [self.pacmanPathPoints mutableCopy];
    [self setNeedsDisplay];
}

// Starts the animation
- (void)startAnimating {
    CAKeyframeAnimation *animation;
    CAKeyframeAnimation *flipAnimation;
    
    self.dead = NO;
    
    [self.pacmanLayer startAnimating];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock: ^ {
        [self stopAnimating];
    }];
    
    // Pacman
    animation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    animation.duration = 5;
    animation.rotationMode = kCAAnimationRotateAuto;
    animation.path = self.pacmanPath.CGPath;
    [self.pacmanLayer addAnimation: animation forKey: @"pathAnimation"];
    
    // Enemy
    animation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    animation.duration = 5;
    animation.values = self.enemyPathPoints;
    [self.enemyLayer addAnimation: animation forKey: @"pathAnimation"];
    
    flipAnimation = [CAKeyframeAnimation animationWithKeyPath: @"transform"];
    flipAnimation.values = @[[NSValue valueWithCATransform3D: CATransform3DMakeScale(1, 1, 1)],
                             [NSValue valueWithCATransform3D: CATransform3DMakeScale(-1, 1, 1)]];
    flipAnimation.calculationMode = kCAAnimationDiscrete;
    flipAnimation.duration = 0.2;
    flipAnimation.autoreverses = YES;
    flipAnimation.repeatCount = 1e100;
    [self.enemyLayer addAnimation: flipAnimation forKey: @"flipAnimation"];
    
    [CATransaction commit];
    
    self.collisionTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(checkForCollision) userInfo: nil repeats: YES];
}

// Stops the animations
- (void)stopAnimating {
    
    if(self.dead) {
        [self.pacmanLayer die: ^ {
            [self.delegate pacmanViewDidEndAnimation: self isDead: YES];
        }];
    } else {
        [self.pacmanLayer stopAnimating];
        
        self.pacmanLayer.position = [self.pacmanPathPoints[0] CGPointValue];
        self.enemyLayer.position = [self.enemyPathPoints[0] CGPointValue];
        
        [self.pacmanLayer removeAnimationForKey: @"pathAnimation"];
        [self.enemyLayer removeAnimationForKey: @"pathAnimation"];
        
        self.foodPoints = [self.pacmanPathPoints mutableCopy];
        [self setNeedsDisplay];
        
        [self.delegate pacmanViewDidEndAnimation: self isDead: NO];
    }
    
    [self.collisionTimer invalidate];
    self.collisionTimer = nil;
}

@end
