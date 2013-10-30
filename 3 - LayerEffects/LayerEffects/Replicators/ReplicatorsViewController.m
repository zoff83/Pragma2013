//
//  ReplicatorsViewController.m
//  LayerEffects
//
//  Created by Marco Zoffoli on 14/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "ReplicatorsViewController.h"


@interface ReplicatorsViewController ()

@property (nonatomic, assign, readwrite)    BOOL                animating;
@property (nonatomic, strong, readwrite)    CALayer             *sourceLayer;
@property (nonatomic, strong, readwrite)    CATransformLayer    *containerLayer;
@property (nonatomic, strong, readwrite)    CAReplicatorLayer   *xReplicatorLayer;
@property (nonatomic, strong, readwrite)    CAReplicatorLayer   *yReplicatorLayer;

@end


@implementation ReplicatorsViewController

// Called whe the view controller's view is loaded into memory
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Create the container layer
    self.containerLayer = [CATransformLayer layer];
    self.containerLayer.frame = self.containerView.layer.bounds;
    
    // Create the source layer
    self.sourceLayer = [CALayer layer];
    self.sourceLayer.cornerRadius = 5;
    self.sourceLayer.backgroundColor = [UIColor yellowColor].CGColor;
    self.sourceLayer.position = CGPointMake(100, 52);
    self.sourceLayer.bounds = CGRectMake(0, 0, 50, 50);
    
    // Create the replicator for the x-axis
    self.xReplicatorLayer = [CAReplicatorLayer layer];
    self.xReplicatorLayer.instanceCount = 16;
    self.xReplicatorLayer.instanceRedOffset = -0.04;
    self.xReplicatorLayer.instanceBlueOffset = -0.04;
    self.xReplicatorLayer.instanceDelay = 0.2;
    self.xReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(55, 0, 0);
    self.xReplicatorLayer.preservesDepth = YES;
    
    // Create the replicator for the y-axis
    self.yReplicatorLayer = [CAReplicatorLayer layer];
    self.yReplicatorLayer.frame = self.containerLayer.bounds;
    self.yReplicatorLayer.instanceCount = 10;
    self.yReplicatorLayer.instanceGreenOffset = -0.06;
    self.xReplicatorLayer.instanceBlueOffset = -0.02;
    self.yReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, 55, 0);
    self.yReplicatorLayer.instanceDelay = 0.1;
    self.yReplicatorLayer.preservesDepth = YES;
    
    [self.xReplicatorLayer addSublayer: self.sourceLayer];
    [self.yReplicatorLayer addSublayer: self.xReplicatorLayer];
    [self.containerLayer addSublayer: self.yReplicatorLayer];
    [self.containerView.layer addSublayer: self.containerLayer];
}

// Called whe the view controller's view is removed from a view hierarchy
- (void)viewDidDisappear: (BOOL)animated {
    [super viewDidDisappear: animated];
    self.animating = NO;
}

// Starts or stops the animation
- (void)setAnimating: (BOOL)animating {
    CATransform3D   containerLayerTransform;
    
    _animating = animating;
    
    if(_animating) {
        
        // Sets the transform for the container layer
        containerLayerTransform = CATransform3DIdentity;
        containerLayerTransform.m34 = -1.0 / 2000.0;
        containerLayerTransform = CATransform3DTranslate(containerLayerTransform, 0, 0, 0);
        containerLayerTransform = CATransform3DRotate(containerLayerTransform, M_PI * 3 / 8, 1, 0, 0);
        containerLayerTransform = CATransform3DRotate(containerLayerTransform, M_PI * 1 / 32, 0, 1, 0);
        
        [CATransaction setAnimationDuration: 2.0];
        [CATransaction setCompletionBlock: ^{
            CABasicAnimation    *positionAnimation;
            CAKeyframeAnimation *colorAnimation;
            CATransform3D       sourceLayerTransform;
            
            if(self.animating) {
                // Sets the transforms for the source layer
                sourceLayerTransform = CATransform3DMakeTranslation(0, 0, 100);
                
                positionAnimation = [CABasicAnimation animationWithKeyPath: @"transform"];
                positionAnimation.duration = 1.5;
                positionAnimation.toValue = [NSValue valueWithCATransform3D: sourceLayerTransform];
                positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
                positionAnimation.autoreverses = YES;
                positionAnimation.repeatCount = 1e100;
                [self.sourceLayer addAnimation: positionAnimation forKey: @"positionAnimation"];
                
                colorAnimation = [CAKeyframeAnimation animationWithKeyPath: @"backgroundColor"];
                colorAnimation.duration = 1.5;
                colorAnimation.autoreverses = YES;
                colorAnimation.repeatCount = 1e100;
                colorAnimation.values = @[ (id)self.sourceLayer.backgroundColor,
                                           (id)[UIColor cyanColor].CGColor];
                [self.sourceLayer addAnimation: colorAnimation forKey: @"colorAnimation"];
            }
        }];
        self.containerLayer.transform = containerLayerTransform;
        
    } else {
        self.containerLayer.transform = CATransform3DIdentity;
        [self.sourceLayer removeAnimationForKey: @"positionAnimation"];
        [self.sourceLayer removeAnimationForKey: @"colorAnimation"];
    }
}

// Called every time the container view is tapped
- (IBAction)tapDetected: (id)sender {
    self.animating = !self.animating;
}

@end
