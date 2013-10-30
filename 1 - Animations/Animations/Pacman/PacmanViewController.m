//
//  PacmanViewController.m
//  Animations
//
//  Created by Marco Zoffoli on 03/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "PacmanViewController.h"
#import "PacmanShapeLayer.h"
#import "PacmanCustomLayer.h"


@interface PacmanViewController ()

@property (nonatomic, assign, readwrite)    BOOL                       animating;
@property (nonatomic, strong, readwrite)    CALayer <PacmanAnimation>  *pacmanLayer;

@end


@implementation PacmanViewController

// Called when the view controller's view is loaded into memory
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLayer];
}

// Creates the pacman layer
- (void)createLayer {
    CALayer <PacmanAnimation> *layer;
    
    [self.pacmanLayer removeFromSuperlayer];
    
    if(self.customLayerSwitch.on)
        layer = [PacmanCustomLayer layer];
    else
        layer = [PacmanShapeLayer layer];
    
    layer.slowAnimations = YES;
    layer.frame = self.containerView.layer.bounds;
    [self.containerView.layer addSublayer: layer];
    
    self.pacmanLayer = layer;
}

// Called when the custom layer switch is changed
- (IBAction)customLayerSwitchChanged: (id)sender {
    [self createLayer];
}

// Called when the start button is pressed
- (IBAction)startPressed: (id)sender {
    if(!self.animating) {
        [self.pacmanLayer startAnimating];
        [self.startStopButton setTitle: @"Stop" forState: UIControlStateNormal];
        self.animating = YES;
    } else {
        [self.pacmanLayer die: ^{
            dispatch_time_t popTime;
            
            popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                [self.pacmanLayer newLife];
            });
        }];
        [self.startStopButton setTitle: @"Start" forState: UIControlStateNormal];
        self.animating = NO;
    }
}

@end
