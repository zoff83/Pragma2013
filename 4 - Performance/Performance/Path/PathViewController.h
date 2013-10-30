//
//  PathViewController.h
//  Performance
//
//  Created by Marco Zoffoli on 14/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PathViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak, readwrite) IBOutlet UILabel         *numberOfLayersLabel;
@property (nonatomic, weak, readwrite) IBOutlet UISlider        *numberOfLayersSlider;
@property (nonatomic, weak, readwrite) IBOutlet UISwitch        *rasterizeSwitch;
@property (nonatomic, weak, readwrite) IBOutlet UISwitch        *rasterizationScaleSwitch;
@property (nonatomic, weak, readwrite) IBOutlet UIScrollView    *scrollView;
@property (nonatomic, weak, readwrite) IBOutlet UIView          *containerView;

@end
