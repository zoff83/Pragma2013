//
//  PacmanPathViewController.h
//  Animations
//
//  Created by Marco Zoffoli on 04/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PacmanPathView.h"

@interface PacmanPathViewController : UIViewController

@property (nonatomic, weak, readwrite) IBOutlet PacmanPathView  *pacmanPathView;
@property (nonatomic, weak, readwrite) IBOutlet UIButton        *startStopButton;


@end
