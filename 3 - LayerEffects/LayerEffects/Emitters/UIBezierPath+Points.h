//
//  UIBezierPath+Points.h
//  LayerEffects
//
//  Created by Marco Zoffoli on 16/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBezierPath (Points)

@property (nonatomic, assign, readonly) CGFloat length;
@property (nonatomic, strong, readonly) NSArray *normalizedSegmentsLengths;
@property (nonatomic, strong, readonly) NSArray *points;
@property (nonatomic, strong, readonly) NSArray *pointPercentArray;

@end
