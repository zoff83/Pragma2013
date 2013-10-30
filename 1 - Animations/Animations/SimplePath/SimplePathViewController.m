//
//  SimplePathViewController.m
//  Animations
//
//  Created by Marco Zoffoli on 02/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "SimplePathViewController.h"


@interface SimplePathViewController ()

@property (nonatomic, assign, readwrite)    BOOL            animating;
@property (nonatomic, strong, readwrite)    CAShapeLayer    *shapeLayer;
@property (nonatomic, assign, readwrite)    NSUInteger      numberOfVertices;

@end


@implementation SimplePathViewController

// Called when the view controller's view is loaded into memory
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.containerView.layer.bounds;
    self.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
    self.shapeLayer.fillColor = [UIColor blackColor].CGColor;
    [self.containerView.layer addSublayer: self.shapeLayer];
    
    [self drawPolygon];
}

// Returns a bezier path for a star with the given number of vertices which is enclosed in a circle having the given radius.
// numberOfVertices must be an odd number greater than 2.
- (UIBezierPath *)bezierPathForStarWithNumberOfVertices: (NSUInteger)numberOfVertices enclosingCircleRadius: (CGFloat)radius {
    CGFloat         angle;
    CGFloat         startAngle;
    CGPoint         point;
    UIBezierPath    *path;
    
    path = [[UIBezierPath alloc] init];
    
    startAngle = M_PI / 2;
    
    for(NSUInteger i = 0, iVertex = 0; i <= numberOfVertices; i++, iVertex += (numberOfVertices / 2)) {
        angle = startAngle + (iVertex * 2 * M_PI / numberOfVertices);
        point.x = radius + (radius * cos(-angle));
        point.y = radius + (radius * sin(-angle));
        
        if(i == 0)
            [path moveToPoint: point];
        else
            [path addLineToPoint: point];
    }
    
    return path;
}

// Returns a bezier path for a polygon with the given number of sides which is enclosed in a circle having the given radius.
// numberOfVertices must be greater than 3.
- (UIBezierPath *)bezierPathForPolygonWithNumberOfSides: (NSUInteger)numberOfVertices enclosingCircleRadius: (CGFloat)radius {
    CGFloat         angle;
    CGFloat         startAngle;
    CGPoint         point;
    UIBezierPath    *path;
    
    path = [[UIBezierPath alloc] init];
    
    startAngle = M_PI / 2;
    for(NSUInteger i = 0; i <= numberOfVertices; i++) {
        angle = startAngle + (i * 2 * M_PI / numberOfVertices);
        point.x = radius + (radius * cos(-angle));
        point.y = radius + (radius * sin(-angle));
        
        if(i == 0)
            [path moveToPoint: point];
        else
            [path addLineToPoint: point];
    }
    
    return path;
}

// Returns a bezier path for a circle with the given radius
- (UIBezierPath *)bezierPathForCircleWithRadius: (CGFloat)radius {
    return [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, radius * 2, radius * 2)];
}

// Redraws the current polygon
- (void)drawPolygon {
    self.numberOfVertices = (round(self.numberOfVerticesSlider.value) * 2) + 1;
    self.shapeLayer.path = [self bezierPathForStarWithNumberOfVertices: self.numberOfVertices enclosingCircleRadius: self.shapeLayer.frame.size.width / 2].CGPath;
    self.numberOfVerticesLabel.text = [NSString stringWithFormat: @"Number of vertices: %i", self.numberOfVertices];
}

// Called when the slider controlling the number of polygon sides is changed
- (IBAction)sliderChanged: (UISlider *)sender {
    [self drawPolygon];
}

// Called when the start button is pressed
- (IBAction)startPressed: (id)sender {
    CABasicAnimation    *animation;
    CGFloat             radius;
    UIBezierPath        *path;
    
    if(!self.animating) {
        radius = self.shapeLayer.frame.size.width / 2;
        
        path = [self bezierPathForPolygonWithNumberOfSides: self.numberOfVertices enclosingCircleRadius: radius];
        
        animation = [CABasicAnimation animationWithKeyPath: @"path"];
        animation.toValue = (id)path.CGPath;
        animation.duration = 2;
        animation.repeatCount = 1e100;
        animation.autoreverses = YES;
        [self.shapeLayer addAnimation: animation forKey: @"animation"];
        
        [self.startStopButton setTitle: @"Stop" forState: UIControlStateNormal];
        self.animating = YES;
    } else {
        [self.shapeLayer removeAnimationForKey: @"animation"];
        
        [self.startStopButton setTitle: @"Start" forState: UIControlStateNormal];
        self.animating = NO;
    }
}

@end
