//
//  PacmanPathView.h
//  Animations
//
//  Created by Marco Zoffoli on 05/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PacmanPathView;

@protocol PacmanPathViewDelegate <NSObject>

- (void)pacmanViewDidEndAnimation: (PacmanPathView *)view isDead: (BOOL)dead;

@end


@interface PacmanPathView : UIView

@property (nonatomic, weak, readwrite)  IBOutlet id <PacmanPathViewDelegate> delegate;

- (void)restart;
- (void)startAnimating;
- (void)stopAnimating;

@end
