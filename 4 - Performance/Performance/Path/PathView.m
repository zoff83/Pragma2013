//
//  PathView.m
//  Performance
//
//  Created by Marco Zoffoli on 14/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "PathView.h"

@implementation PathView

// Returns the class used to create the layer for instances of this class
+ (Class)layerClass {
    return [CAShapeLayer class];
}

// Sets the view's path
- (void)setPath: (UIBezierPath *)path {
    CAShapeLayer    *layer;
    
    _path = path;
    
    layer = (CAShapeLayer *)self.layer;
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1.0;
}

@end
