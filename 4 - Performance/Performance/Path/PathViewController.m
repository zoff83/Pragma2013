//
//  PathViewController.m
//  Performance
//
//  Created by Marco Zoffoli on 14/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "PathViewController.h"
#import "PathView.h"
#import "PocketSVG.h"


#define kViewSize   200


@interface PathViewController ()

@property (nonatomic, strong, readwrite) NSMutableArray *layersArray;
@property (nonatomic, strong, readwrite) UIBezierPath   *path;

@end


@implementation PathViewController

// Called when the view controller's view is loaded into memory
- (void)viewDidLoad {
    CGAffineTransform   transform;
    CGFloat             scale;
    PocketSVG           *svgReader;
    
    [super viewDidLoad];
    
    self.layersArray = [NSMutableArray array];
    
    self.scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    self.scrollView.layer.borderWidth = 5.0;
    
    // Read the bezier path from the SVG
    svgReader = [[PocketSVG alloc] initFromSVGFileNamed: @"Chair"];
    self.path = svgReader.bezier;
    
    // Scale the path so that it fits in the view
    scale = MAX(CGRectGetWidth(self.path.bounds), CGRectGetHeight(self.path.bounds));
    scale = kViewSize / scale;
    transform = CGAffineTransformMakeScale(scale, scale);
    [self.path applyTransform: transform];
}

// Called every time the view controller's view is about to be added from a view hierarchy
- (void)viewWillAppear: (BOOL)animated {
    
    [super viewWillAppear: animated];
    
    [self updateNumberOfLayers];
}

// Called every time the view controller's view is removed from a view hierarchy
- (void)viewDidDisappear: (BOOL)animated {
    
    [super viewDidDisappear: animated];
    
    // Remove all views
    for(CALayer *layer in self.layersArray)
        [layer removeFromSuperlayer];
    
    [self.layersArray removeAllObjects];
}

// Updates the number of layers shown
- (void)updateNumberOfLayers {
    CABasicAnimation    *animation;
    CAShapeLayer        *layer;
    CGFloat             scale;
    CGPoint             destPoint;
    NSUInteger          numberOfLayers;
    
    numberOfLayers = round(self.numberOfLayersSlider.value);
    
    if(self.layersArray.count < numberOfLayers) {
        while(self.layersArray.count < numberOfLayers) {
            // Create the layer
            if(numberOfLayers == 1)
                scale = 1.0;
            else
                scale = 1.0 - ((arc4random() % 7) / 10.0);
            
            layer = [[CAShapeLayer alloc] init];
            layer.bounds = CGRectMake(0, 0, kViewSize, kViewSize);
            layer.position = CGPointMake(CGRectGetMidX(self.containerView.bounds) + ((arc4random() % 800) - 400.0), CGRectGetMidY(self.containerView.bounds) + ((arc4random() % 100) - 50.0));
            layer.path = self.path.CGPath;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor blackColor].CGColor;
            layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
            layer.lineWidth = 1.0;
            
            // Set shouldRasterize and rasterizationScale if needed
            layer.shouldRasterize = self.rasterizeSwitch.on;
            layer.rasterizationScale = self.rasterizationScaleSwitch.on ? self.scrollView.maximumZoomScale : 1.0;
            [self.containerView.layer addSublayer: layer];
            
            // Setup animation
            destPoint = CGPointMake(layer.position.x + ((arc4random() % 800) - 400.0), layer.position.y + ((arc4random() % 150) - 75.0));
            animation = [CABasicAnimation animationWithKeyPath: @"position"];
            animation.duration = 4.0;
            animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
            animation.toValue = [NSValue valueWithCGPoint: destPoint];
            animation.autoreverses = YES;
            animation.repeatCount = 1e100;
            [layer addAnimation: animation forKey: @"animation"];
            
            [self.layersArray addObject: layer];
        }
    } else {
        while(self.layersArray.count > numberOfLayers) {
            // Remove the view and its behaviors
            layer = [self.layersArray lastObject];
            [layer removeFromSuperlayer];
            [self.layersArray removeLastObject];
        }
    }
    
    self.numberOfLayersLabel.text = [NSString stringWithFormat: @"%i", numberOfLayers];
}

// Called every time the slider with the number of layers is changed
- (IBAction)numberOfLayersSliderChanged: (id)sender {
    [self updateNumberOfLayers];
}

// Called every time the "Rasterize" switch is changed
- (IBAction)rasterizeSwitchChanged: (id)sender {
    BOOL    shouldRasterize;
    
    shouldRasterize = self.rasterizeSwitch.on;
    
    for(CALayer *layer in self.layersArray)
        layer.shouldRasterize = shouldRasterize;
}

// Called every time the "Set rasterizationScale" switch is changed
- (IBAction)rasterizationScaleSwitchChanged: (id)sender {
    CGFloat rasterizationScale;
    
    rasterizationScale = self.rasterizationScaleSwitch.on ? self.scrollView.maximumZoomScale : 1.0;
    
    for(CALayer *layer in self.layersArray)
        layer.rasterizationScale = rasterizationScale;
}

#pragma mark UIScrollView methods

// Returns the view to scale when zooming is about to occur in the scroll view
- (UIView *)viewForZoomingInScrollView: (UIScrollView *)scrollView {
    return self.containerView;
}

@end
