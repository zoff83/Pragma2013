//
//  SimplePathViewController.h
//  Animations
//
//  Created by Marco Zoffoli on 02/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SimplePathViewController : UIViewController

@property (nonatomic, weak, readwrite) IBOutlet UIButton    *startStopButton;
@property (nonatomic, weak, readwrite) IBOutlet UILabel     *numberOfVerticesLabel;
@property (nonatomic, weak, readwrite) IBOutlet UISlider    *numberOfVerticesSlider;
@property (nonatomic, weak, readwrite) IBOutlet UIView      *containerView;

@end
