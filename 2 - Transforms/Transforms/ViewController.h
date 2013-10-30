//
//  ViewController.h
//  Transforms
//
//  Created by Marco Zoffoli on 08/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

@property (nonatomic, weak, readwrite) IBOutlet UILabel     *perspectiveAmountLabel;
@property (nonatomic, weak, readwrite) IBOutlet UISlider    *perspectiveAmountSlider;
@property (nonatomic, weak, readwrite) IBOutlet UISwitch    *transformLayerSwitch;
@property (nonatomic, weak, readwrite) IBOutlet UIView      *containerView;

@end
