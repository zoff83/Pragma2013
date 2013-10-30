//
//  EmittersViewController.m
//  LayerEffects
//
//  Created by Marco Zoffoli on 15/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "EmittersViewController.h"
#import "PocketSVG.h"
#import "UIBezierPath+Points.h"


#define kAnimationDuration  30.0

#define kShapeLayerKey      @"shapeLayer"
#define kBezierPathKey      @"bezierPath"

@interface EmittersViewController ()

@property (nonatomic, assign, readwrite)    BOOL            animating;
@property (nonatomic, strong, readwrite)    CAEmitterLayer  *emitterLayer;
@property (nonatomic, strong, readwrite)    CAEmitterCell   *sparkEmitterCell;
@property (nonatomic, assign, readwrite)    CGFloat         totalLength;
@property (nonatomic, strong, readwrite)    NSMutableArray  *itemsArray;

@end


@implementation EmittersViewController

// Called when the view controller's view is loaded into memory
- (void)viewDidLoad {
    CAShapeLayer        *shapeLayer;
    CGFloat             scaleX;
    CGFloat             scaleY;
    CGRect              originalPathBounds;
    CGRect              pathRect;
    NSArray             *svgFilesArray;
    NSArray             *svgPathRectArray;
    PocketSVG           *svgReader;
    UIBezierPath        *bezierPath;
    UIBezierPath        *translatedBezierPath;
    
    self.totalLength = 0;
    self.itemsArray = [NSMutableArray array];
    
    // Create the spark emitter cell
    self.sparkEmitterCell = [CAEmitterCell emitterCell];
    self.sparkEmitterCell.birthRate = 300;
    self.sparkEmitterCell.lifetime = 3;
    self.sparkEmitterCell.scale = 0.4;
    self.sparkEmitterCell.scaleRange = 0.25;
    self.sparkEmitterCell.emissionRange = 2 * M_PI;
    self.sparkEmitterCell.velocity = 60;
    self.sparkEmitterCell.velocityRange = 8;
    self.sparkEmitterCell.yAcceleration = -400;
    self.sparkEmitterCell.alphaRange = 0.5;
    self.sparkEmitterCell.alphaSpeed = -1;
    self.sparkEmitterCell.spin = 1;
    self.sparkEmitterCell.spinRange = 6;
    self.sparkEmitterCell.alphaRange = 0.8;
    self.sparkEmitterCell.redRange = 2;
    self.sparkEmitterCell.greenRange = 1;
    self.sparkEmitterCell.blueRange = 1;
    self.sparkEmitterCell.contents = (__bridge id)[UIImage imageNamed: @"Spark.png"].CGImage;
    
    // Create the paths from the SVG files
    svgFilesArray = @[ @"#", @"#_inner", @"p", @"p_inner", @"r", @"a", @"a_inner", @"g", @"g_inner", @"m", @"a", @"a_inner", @"m", @"a", @"a_inner", @"r", @"k" ];
    svgPathRectArray = @[ [NSValue valueWithCGRect: CGRectMake(90, 40, 418, 476)],    // #
                          [NSValue valueWithCGRect: CGRectMake(251, 219, 110, 147)],  // # inner
                          [NSValue valueWithCGRect: CGRectMake(531, 166, 57, 90)],    // p
                          [NSValue valueWithCGRect: CGRectMake(548, 180, 24, 39)],    // p inner
                          [NSValue valueWithCGRect: CGRectMake(609, 166, 50, 66)],    // r
                          [NSValue valueWithCGRect: CGRectMake(667, 167, 59, 66)],    // a
                          [NSValue valueWithCGRect: CGRectMake(686, 201, 23, 21)],    // a inner
                          [NSValue valueWithCGRect: CGRectMake(737, 167, 58, 88)],    // g
                          [NSValue valueWithCGRect: CGRectMake(754, 180, 24, 38)],    // g inner
                          [NSValue valueWithCGRect: CGRectMake(806, 167, 61, 65)],    // m
                          [NSValue valueWithCGRect: CGRectMake(876, 167, 59, 66)],    // a
                          [NSValue valueWithCGRect: CGRectMake(894, 201, 23, 21)],    // a inner
                          [NSValue valueWithCGRect: CGRectMake(531, 326, 61, 65)],    // m
                          [NSValue valueWithCGRect: CGRectMake(601, 327, 59, 66)],    // a
                          [NSValue valueWithCGRect: CGRectMake(620, 361, 23, 21)],    // a inner
                          [NSValue valueWithCGRect: CGRectMake(682, 326, 50, 66)],    // r
                          [NSValue valueWithCGRect: CGRectMake(745, 303, 59, 89)]     // k
                          ];
    
    for(NSUInteger i = 0; i < svgFilesArray.count; i++) {
        // Read the SVG file
        svgReader = [[PocketSVG alloc] initFromSVGFileNamed: svgFilesArray[i]];
        bezierPath = svgReader.bezier;
        
        // Scale the path to the right size
        pathRect = [svgPathRectArray[i] CGRectValue];
        originalPathBounds = bezierPath.bounds;
        
        scaleX = CGRectGetWidth(pathRect) / CGRectGetWidth(originalPathBounds);
        scaleY = CGRectGetHeight(pathRect) / CGRectGetHeight(originalPathBounds);
        [bezierPath applyTransform: CGAffineTransformMakeScale(scaleX, scaleY)];
        
        // Create a copy of the path and move it to the right position.
        // It will be used for animating emitter layer's emitterPosition
        translatedBezierPath = [bezierPath copy];
        [translatedBezierPath applyTransform: CGAffineTransformMakeTranslation(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect))];
        
        // Create the shape layer
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.frame = pathRect;
        shapeLayer.lineWidth = 2;
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeEnd = 0;
        shapeLayer.actions = @{ @"strokeEnd" : [NSNull null] };
        [self.containerView.layer addSublayer: shapeLayer];
        
        self.totalLength += bezierPath.length;
        
        [self.itemsArray addObject: @{ kShapeLayerKey   : shapeLayer,
                                       kBezierPathKey   : translatedBezierPath }];
    }
}

// Run the animation for the layer at the given index
- (void)animateLayerAtIndex: (NSUInteger)index completionBlock: (void (^)())completionBlock {
    CABasicAnimation    *strokeAnimation;
    CAKeyframeAnimation *emitterPositionAnimation;
    CAShapeLayer        *shapeLayer;
    NSDictionary        *itemDictionary;
    UIBezierPath        *bezierPath;
    
    [CATransaction setCompletionBlock: completionBlock];
    
    itemDictionary = self.itemsArray[index];
    
    shapeLayer = itemDictionary[kShapeLayerKey];
    bezierPath = itemDictionary[kBezierPathKey];
    
    // Create the stroke animation
    shapeLayer.strokeEnd = 1.0;
    
    strokeAnimation = [CABasicAnimation animationWithKeyPath: @"strokeEnd"];
    strokeAnimation.fromValue = @(0.0);
    strokeAnimation.toValue = @(1.0);
    strokeAnimation.duration = kAnimationDuration * (bezierPath.length / self.totalLength);
    [shapeLayer addAnimation: strokeAnimation forKey: @"animation"];
    
    // Animate the emitter position and start emitting
    emitterPositionAnimation = [CAKeyframeAnimation animationWithKeyPath: @"emitterPosition"];
    emitterPositionAnimation.path = bezierPath.CGPath;
    emitterPositionAnimation.keyTimes = [bezierPath pointPercentArray];
    emitterPositionAnimation.duration = kAnimationDuration * (bezierPath.length / self.totalLength);
    [self.emitterLayer addAnimation: emitterPositionAnimation forKey: @"animation"];
}

// Starts the animation
- (void)startAnimating {
    CAShapeLayer        *shapeLayer;
    __block NSUInteger  currentLayerIndex;
    __block void        (^completionBlock)();
    __weak __block void (^weakCompletionBlock)();
    
    if(!self.animating) {
        currentLayerIndex = 0;
        
        completionBlock = ^{
            currentLayerIndex++;
            if(currentLayerIndex < self.itemsArray.count) {
                [self animateLayerAtIndex: currentLayerIndex completionBlock: weakCompletionBlock];
            } else {
                self.emitterLayer.birthRate = 0;
                self.animating = NO;
            }
        };
        weakCompletionBlock = completionBlock;  // For avoiding retain cycles
        
        // Reset all previous shape layers
        for(NSDictionary *itemDictionary in self.itemsArray) {
            shapeLayer = itemDictionary[kShapeLayerKey];
            shapeLayer.strokeEnd = 0;
        }
        
        // Create the emitter layer, if needed
        if(!self.emitterLayer) {
            self.emitterLayer = [CAEmitterLayer layer];
            self.emitterLayer.frame = self.containerView.layer.bounds;
            self.emitterLayer.emitterCells = @[ self.sparkEmitterCell ];
            [self.containerView.layer addSublayer: self.emitterLayer];
        } else {
            self.emitterLayer.birthRate = 1;
        }
        
        [self animateLayerAtIndex: currentLayerIndex completionBlock: completionBlock];
        
        self.animating = YES;
    }
}

// Called every time the view is tapped
- (IBAction)tapDetected: (id)sender {
    [self startAnimating];
}

@end
