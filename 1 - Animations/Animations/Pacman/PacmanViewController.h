//
//  PacmanViewController.h
//  Animations
//
//  Created by Marco Zoffoli on 03/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PacmanViewController : UIViewController

@property (nonatomic, weak, readwrite) IBOutlet UIButton    *startStopButton;
@property (nonatomic, weak, readwrite) IBOutlet UISwitch    *customLayerSwitch;
@property (nonatomic, weak, readwrite) IBOutlet UIView      *containerView;

@end
