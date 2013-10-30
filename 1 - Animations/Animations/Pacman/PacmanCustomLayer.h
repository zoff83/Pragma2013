//
//  PacmanCustomLayer.h
//  Animations
//
//  Created by Marco Zoffoli on 03/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PacmanAnimation.h"


@interface PacmanCustomLayer : CALayer <PacmanAnimation>

@property (nonatomic, assign, readwrite)    CGFloat angle;
@property (nonatomic, assign, readwrite)    CGFloat strokeWidth;
@property (nonatomic, strong, readwrite)    UIColor *fillColor;
@property (nonatomic, strong, readwrite)    UIColor *strokeColor;

@end
