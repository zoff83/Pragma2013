//
//  ViewController.m
//  Transforms
//
//  Created by Marco Zoffoli on 08/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "ViewController.h"


#define kCubeFaceSize   150
#define kPanSensitivity 500


@interface ViewController ()

@property (nonatomic, assign, readwrite)    BOOL            folded;
@property (nonatomic, strong, readwrite)    CALayer         *containerLayer;
@property (nonatomic, strong, readwrite)    CALayer         *backLayer;
@property (nonatomic, strong, readwrite)    CALayer         *frontLayer;
@property (nonatomic, strong, readwrite)    CALayer         *leftLayer;
@property (nonatomic, strong, readwrite)    CALayer         *rightLayer;
@property (nonatomic, strong, readwrite)    CALayer         *topLayer;
@property (nonatomic, strong, readwrite)    CALayer         *bottomLayer;
@property (nonatomic, assign, readwrite)    CATransform3D   perspectiveTransform;
@property (nonatomic, assign, readwrite)    CATransform3D   rotationTransform;
@property (nonatomic, strong, readwrite)    NSArray         *colorsArray;

@end


@implementation ViewController

// Called when the view controller's view is loaded into memory
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.rotationTransform = CATransform3DIdentity;
    
    self.colorsArray = @[[UIColor redColor],
                         [UIColor yellowColor],
                         [UIColor purpleColor],
                         [UIColor blueColor],
                         [UIColor greenColor],
                         [UIColor orangeColor]];
    
    [self createLayers];
}

// Creates the cube layers
- (void)createLayers {
    
    [self.containerLayer removeFromSuperlayer];
    [self.backLayer removeFromSuperlayer];
    [self.frontLayer removeFromSuperlayer];
    [self.leftLayer removeFromSuperlayer];
    [self.rightLayer removeFromSuperlayer];
    [self.topLayer removeFromSuperlayer];
    [self.bottomLayer removeFromSuperlayer];
    
    self.containerLayer = self.transformLayerSwitch.on ? [CATransformLayer layer] : [CALayer layer];
    self.containerLayer.frame = self.containerView.layer.bounds;
    self.containerLayer.actions = @{@"transform" : [NSNull null]}; // Disables implicit animations for the transform property
    [self.containerView.layer addSublayer: self.containerLayer];
    
    // Back face
    self.backLayer = [CALayer layer];
    self.backLayer.bounds = CGRectMake(0, 0, kCubeFaceSize, kCubeFaceSize);
    self.backLayer.position = CGPointMake(CGRectGetMidX(self.containerLayer.frame), CGRectGetMidY(self.containerLayer.frame));
    self.backLayer.backgroundColor = [self.colorsArray[0] CGColor];
    self.backLayer.shouldRasterize = YES;
    [self.containerLayer addSublayer: self.backLayer];
    
    // Top face
    self.topLayer = [CALayer layer];
    self.topLayer.bounds = CGRectMake(0, 0, kCubeFaceSize, kCubeFaceSize);
    self.topLayer.anchorPoint = CGPointMake(0.5, 1.0);
    self.topLayer.position = CGPointMake(CGRectGetMidX(self.backLayer.frame), CGRectGetMinY(self.backLayer.frame));
    self.topLayer.backgroundColor = [self.colorsArray[1] CGColor];
    self.topLayer.shouldRasterize = YES;
    [self.containerLayer addSublayer: self.topLayer];
    
    // Bottom face
    self.bottomLayer = [CALayer layer];
    self.bottomLayer.bounds = CGRectMake(0, 0, kCubeFaceSize, kCubeFaceSize);
    self.bottomLayer.anchorPoint = CGPointMake(0.5, 0.0);
    self.bottomLayer.position = CGPointMake(CGRectGetMidX(self.backLayer.frame), CGRectGetMaxY(self.backLayer.frame));
    self.bottomLayer.backgroundColor = [self.colorsArray[2] CGColor];
    self.bottomLayer.shouldRasterize = YES;
    [self.containerLayer addSublayer: self.bottomLayer];
    
    // Left face
    self.leftLayer = [CALayer layer];
    self.leftLayer.bounds = CGRectMake(0, 0, kCubeFaceSize, kCubeFaceSize);
    self.leftLayer.anchorPoint = CGPointMake(1.0, 0.5);
    self.leftLayer.position = CGPointMake(CGRectGetMinX(self.backLayer.frame), CGRectGetMidY(self.backLayer.frame));
    self.leftLayer.backgroundColor = [self.colorsArray[3] CGColor];
    self.leftLayer.shouldRasterize = YES;
    [self.containerLayer addSublayer: self.leftLayer];
    
    // Right face
    self.rightLayer = [CALayer layer];
    self.rightLayer.bounds = CGRectMake(0, 0, kCubeFaceSize, kCubeFaceSize);
    self.rightLayer.anchorPoint = CGPointMake(0.0, 0.5);
    self.rightLayer.position = CGPointMake(CGRectGetMaxX(self.backLayer.frame), CGRectGetMidY(self.backLayer.frame));
    self.rightLayer.backgroundColor = [self.colorsArray[4] CGColor];
    self.rightLayer.shouldRasterize = YES;
    [self.containerLayer addSublayer: self.rightLayer];
    
    // Front face
    self.frontLayer = [CALayer layer];
    self.frontLayer.bounds = CGRectMake(0, 0, kCubeFaceSize, kCubeFaceSize);
    self.frontLayer.position = CGPointMake(CGRectGetMidX(self.backLayer.frame), CGRectGetMidY(self.backLayer.frame));
    self.frontLayer.backgroundColor = [self.colorsArray[5] CGColor];
    self.frontLayer.shouldRasterize = YES;
    [self.containerLayer addSublayer: self.frontLayer];
    
    [self applyPerspective];
    self.rotationTransform = CATransform3DIdentity;
    self.folded = NO;
}

// Applies perspective to the container layer
- (void)applyPerspective {
    CATransform3D   perspectiveTransform;
    
    perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = -1.0 / self.perspectiveAmountSlider.value;
    self.perspectiveTransform = perspectiveTransform;
    
    self.perspectiveAmountLabel.text = [NSString stringWithFormat: @"%.0f", self.perspectiveAmountSlider.value];
}

// Sets the current perspective transform
- (void)setPerspectiveTransform: (CATransform3D)perspectiveTransform {
    _perspectiveTransform  = perspectiveTransform;
    self.containerLayer.transform = CATransform3DConcat(self.rotationTransform, _perspectiveTransform);
}

// Sets the current rotation transform
- (void)setRotationTransform: (CATransform3D)rotationTransform {
    _rotationTransform = rotationTransform;
    self.containerLayer.transform = CATransform3DConcat(_rotationTransform, self.perspectiveTransform);
}

// Called every time a pan is performed on the container view
- (IBAction)panDetected: (UIPanGestureRecognizer *)gestureRecognizer {
    CATransform3D   transform;
    CGFloat         totalRotation;
    CGPoint         rotation;
    
    rotation = [gestureRecognizer translationInView: gestureRecognizer.view];
    totalRotation = sqrt((rotation.x * rotation.x) + (rotation.y * rotation.y)) * M_PI / 180.0;
    if(totalRotation) {
        rotation.x /= totalRotation;
        rotation.y /= totalRotation;
        
        transform = self.rotationTransform;
        transform = CATransform3DRotate(transform, totalRotation, (rotation.x * transform.m12 - rotation.y * transform.m11),
                                                                  (rotation.x * transform.m22 - rotation.y * transform.m21),
                                                                  (rotation.x * transform.m32 - rotation.y * transform.m31));
        self.rotationTransform = transform;
        
        [gestureRecognizer setTranslation: CGPointZero inView: gestureRecognizer.view];
    }
}

// Folds or unfolds the cube
- (void)setFolded: (BOOL)folded {
    CATransform3D   translation;
    
    _folded = folded;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration: 5.0];
    
    translation = CATransform3DMakeTranslation(0, 0, -kCubeFaceSize / 2);
    
    if(self.folded) {
        self.backLayer.transform = translation;
        self.frontLayer.transform = CATransform3DMakeTranslation(0, 0, kCubeFaceSize / 2);
        self.topLayer.transform = CATransform3DRotate(translation, -M_PI / 2, 1, 0, 0);
        self.bottomLayer.transform = CATransform3DRotate(translation, M_PI / 2, 1, 0, 0);
        self.leftLayer.transform = CATransform3DRotate(translation, M_PI / 2, 0, 1, 0);
        self.rightLayer.transform = CATransform3DRotate(translation, -M_PI / 2, 0, 1, 0);
    } else {
        self.backLayer.transform = CATransform3DIdentity;
        self.frontLayer.transform = CATransform3DIdentity;
        self.topLayer.transform = CATransform3DIdentity;
        self.bottomLayer.transform = CATransform3DIdentity;
        self.leftLayer.transform = CATransform3DIdentity;
        self.rightLayer.transform = CATransform3DIdentity;
    }
    
    [CATransaction commit];
}

// Called every time the "use transform layer" switch is changed
- (IBAction)transformLayerSwitchChanged: (id)sender {
    [self createLayers];
}

// Called every time the slider for altering the perspective is changed
- (IBAction)transformValueSliderChanged: (id)sender {
    [self applyPerspective];
}

// Called whenever the main view is pressed
- (IBAction)viewPressed: (id)sender {
    self.folded = !self.folded;
}

@end
