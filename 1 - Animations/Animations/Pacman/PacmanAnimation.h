//
//  PacmanAnimation.h
//  Animations
//
//  Created by Marco Zoffoli on 03/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PacmanAnimation <NSObject>

@property (nonatomic, assign, readwrite)    BOOL    slowAnimations;

- (void)startAnimating;
- (void)stopAnimating;
- (void)die: (void (^)())completionBlock;
- (void)newLife;

@end
