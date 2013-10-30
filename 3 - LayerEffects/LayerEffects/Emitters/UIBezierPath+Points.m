//
//  UIBezierPath+Points.m
//  LayerEffects
//
//  Created by Marco Zoffoli on 16/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "UIBezierPath+Points.h"


#define CGPointDistance(p1, p2)  sqrt(((p2.x - p1.x) * (p2.x - p1.x)) + ((p2.y - p1.y) * (p2.y - p1.y)))


@implementation UIBezierPath (Points)

// This function is called for every point in the bezier path
void getPointsFromBezier(void *info, const CGPathElement *element) {
    CGPathElementType   type;
    CGPoint             *points;
    NSMutableArray      *bezierPoints;
    
    bezierPoints = (__bridge NSMutableArray *)info;
    
    type = element->type;
    points = element->points;
    
    switch(type) {
        case kCGPathElementMoveToPoint:
        case kCGPathElementAddLineToPoint:
            [bezierPoints addObject: [NSValue valueWithCGPoint: points[0]]];
            break;
        case kCGPathElementAddQuadCurveToPoint:
            [bezierPoints addObject: [NSValue valueWithCGPoint: points[1]]];
            break;
        case kCGPathElementAddCurveToPoint:
            [bezierPoints addObject: [NSValue valueWithCGPoint: points[2]]];
            break;
        default:
            break;
    }
}

// Returns the points defining each segment in the receiving path
- (NSArray *)points {
    NSMutableArray *points;
    
    points = [NSMutableArray array];
    CGPathApply(self.CGPath, (__bridge void *)points, getPointsFromBezier);
    
    return points;
}

// Returns the length of the receiving path
- (CGFloat)length {
    CGFloat length;
    CGPoint p1;
    CGPoint p2;
    NSArray *points;
    
    length = 0;
    points = self.points;
    
    for(NSUInteger i = 1; i < points.count; i++) {
        p1 = [points[i - 1] CGPointValue];
        p2 = [points[i] CGPointValue];
        length += CGPointDistance(p1, p2);
    }
    
    return length;
}

// Returns an array containing the normalized length of each segment in the receiving path
- (NSArray *)normalizedSegmentsLengths {
    CGFloat         length;
    CGFloat         segmentLength;
    CGPoint         p1;
    CGPoint         p2;
    NSArray         *points;
    NSMutableArray  *array;
    
    points = self.points;
    length = self.length;
    
    array = [NSMutableArray array];
    
    for(NSUInteger i = 1; i < points.count; i++) {
        p1 = [points[i - 1] CGPointValue];
        p2 = [points[i] CGPointValue];
        segmentLength = CGPointDistance(p1, p2) / length;
        
        [array addObject: @(segmentLength)];
    }
    
    return array;
}

// Returns an array containing the percent of path consumed at each point in the receiving path
- (NSArray *)pointPercentArray {
    CGFloat         percent;
    NSMutableArray  *array;
    
    array = [NSMutableArray array];
    
    percent = 0;
    [array addObject: @(percent)];
    
    for(NSNumber *number in self.normalizedSegmentsLengths) {
        percent += [number doubleValue];
        
        [array addObject: @(percent)];
    }
        
    return array;
}

@end
