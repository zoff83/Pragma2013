//
//  PacmanPathViewController.m
//  Animations
//
//  Created by Marco Zoffoli on 04/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "PacmanPathViewController.h"


@interface PacmanPathViewController () <PacmanPathViewDelegate>

@property (nonatomic, assign, readwrite)    BOOL    animating;
@property (nonatomic, assign, readwrite)    BOOL    dead;

@end


@implementation PacmanPathViewController

// Called when the start button is pressed
- (IBAction)startPressed: (id)sender {
    if(!self.animating) {
        if(self.dead) {
            [self.pacmanPathView restart];
            [self.startStopButton setTitle: @"Start" forState: UIControlStateNormal];
            self.dead = NO;
        } else {
            [self.pacmanPathView startAnimating];
            [self.startStopButton setTitle: @"Stop" forState: UIControlStateNormal];
            self.animating = YES;
        }
    } else {
        [self.pacmanPathView stopAnimating];
        [self.startStopButton setTitle: @"Start" forState: UIControlStateNormal];
        self.animating = NO;
    }
}

#pragma mark PacmanPathViewDelegate methods

// Calle when the view ends animating
- (void)pacmanViewDidEndAnimation: (PacmanPathView *)view isDead: (BOOL)dead {
    
    [self.startStopButton setTitle: (dead ? @"Restart" : @"Start") forState: UIControlStateNormal];
    self.dead = dead;
    self.animating = NO;
}

@end
