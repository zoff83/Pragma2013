//
//  ShadowViewController.h
//  Performance
//
//  Created by Marco Zoffoli on 14/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShadowViewController : UIViewController

@property (nonatomic, weak, readwrite) IBOutlet UILabel     *numberOfViewsLabel;
@property (nonatomic, weak, readwrite) IBOutlet UISlider    *numberOfViewsSlider;
@property (nonatomic, weak, readwrite) IBOutlet UISwitch    *shadowSwitch;
@property (nonatomic, weak, readwrite) IBOutlet UISwitch    *shadowPathSwitch;
@property (nonatomic, weak, readwrite) IBOutlet UIView      *containerView;

@end
