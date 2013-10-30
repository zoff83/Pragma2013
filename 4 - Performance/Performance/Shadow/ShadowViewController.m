//
//  ShadowViewController.m
//  Performance
//
//  Created by Marco Zoffoli on 14/10/13.
//  Copyright (c) 2013 #pragma mark. All rights reserved.
//

#import "ShadowViewController.h"


#define kViewSize               100

#define kShadowRadius           8
#define kShadowColor            [UIColor blackColor].CGColor
#define kShadowOffset           CGSizeMake(0, -1)

#define kViewKey                @"view"
#define kPushBehaviorKey        @"pushBehavior"
#define kDynamicItemBehaviorKey @"dynamicItem"


@interface ShadowViewController ()

@property (nonatomic, strong, readwrite) NSMutableArray         *itemsArray;
@property (nonatomic, strong, readwrite) UICollisionBehavior    *collisionBehavior;
@property (nonatomic, strong, readwrite) UIDynamicAnimator      *animator;


@end


@implementation ShadowViewController

// Called when the view controller's view is loaded into memory
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.itemsArray = [NSMutableArray array];
    
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.borderWidth = 5.0;
}

// Called every time the view controller's view is about to be added from a view hierarchy
- (void)viewWillAppear: (BOOL)animated {
    
    [super viewWillAppear: animated];
    
    // Create collision behavior with containerView's bounds
    self.collisionBehavior = [[UICollisionBehavior alloc] init];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    
    // Create the animator
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView: self.containerView];
    [self.animator addBehavior: self.collisionBehavior];
    
    [self updateNumberOfViews];
}

// Called every time the view controller's view is removed from a view hierarchy
- (void)viewDidDisappear: (BOOL)animated {
    UIView  *view;
    
    [super viewDidDisappear: animated];
    
    // Remove all views and behaviors
    for(NSDictionary *itemDictionary in self.itemsArray) {
        view = itemDictionary[kViewKey];
        [view removeFromSuperview];
    }
    [self.itemsArray removeAllObjects];
    
    [self.animator removeAllBehaviors];
    self.animator = nil;
    
    self.collisionBehavior = nil;
}

// Returns the views that are currently animating
- (NSArray *)allAnimationViews {
    return [self.itemsArray valueForKey: kViewKey];
}

// Updates the number of views shown
- (void)updateNumberOfViews {
    NSDictionary            *itemDictionary;
    NSUInteger              numberOfViews;
    UIDynamicItemBehavior   *dynamicItemBehavior;
    UIPushBehavior          *pushBehavior;
    UIView                  *view;
    
    numberOfViews = round(self.numberOfViewsSlider.value);
    
    if(self.itemsArray.count < numberOfViews) {
        while(self.itemsArray.count < numberOfViews) {
            // Create the view
            view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, kViewSize, kViewSize)];
            view.center = CGPointMake(CGRectGetMidX(self.containerView.bounds) + ((arc4random() % 400) - 200.0), CGRectGetMidY(self.containerView.bounds) + ((arc4random() % 400) - 200.0));
            view.backgroundColor = [self randomColor];
            
            // Add shadow and shadow path if needed
            if(self.shadowSwitch.on) {
                view.layer.shadowRadius = kShadowRadius;
                view.layer.shadowColor = kShadowColor;
                view.layer.shadowOpacity = 1.0;
                view.layer.shadowOffset = kShadowOffset;
            }
            
            if(self.shadowPathSwitch.on)
                view.layer.shadowPath = [UIBezierPath bezierPathWithRect: view.bounds].CGPath;
            
            [self.containerView addSubview: view];
            
            // Setup collision, push and dynamic properties for the view
            [self.collisionBehavior addItem: view];
            
            pushBehavior = [[UIPushBehavior alloc] initWithItems: @[view] mode: UIPushBehaviorModeInstantaneous];
            pushBehavior.angle = (((arc4random() % 4) * 2) + 1) * (M_PI / 4.0);
            pushBehavior.magnitude = 2;
            [self.animator addBehavior: pushBehavior];
            
            dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems: @[view]];
            dynamicItemBehavior.elasticity = 1.0;
            dynamicItemBehavior.resistance = 0.0;
            dynamicItemBehavior.friction = 0.0;
            [self.animator addBehavior: dynamicItemBehavior];
            
            itemDictionary = @{ kViewKey                : view,
                                kPushBehaviorKey        : pushBehavior,
                                kDynamicItemBehaviorKey : dynamicItemBehavior };
            
            [self.itemsArray addObject: itemDictionary];
        }
    } else {
        while(self.itemsArray.count > numberOfViews) {
            // Remove the view and its behaviors
            itemDictionary = [self.itemsArray lastObject];
            
            view = itemDictionary[kViewKey];
            [view removeFromSuperview];
            
            [self.collisionBehavior removeItem: view];
            
            pushBehavior = itemDictionary[kPushBehaviorKey];
            [self.animator removeBehavior: pushBehavior];
            
            dynamicItemBehavior = itemDictionary[kDynamicItemBehaviorKey];
            [self.animator removeBehavior: dynamicItemBehavior];
        
            [self.itemsArray removeLastObject];
        }
    }
    
    self.numberOfViewsLabel.text = [NSString stringWithFormat: @"%i", numberOfViews];
}

// Called every time the slider with the number of views is changed
- (IBAction)numberOfViewsSliderChanged: (id)sender {
    [self updateNumberOfViews];
}

// Called every time the "Shadows" switch is changed
- (IBAction)shadowSwitchChanged: (id)sender {
    CGColorRef  shadowColor;
    CGFloat     shadowOpacity;
    CGFloat     shadowRadius;
    CGSize      shadowOffset;
    
    if(self.shadowSwitch.on) {
        shadowRadius = kShadowRadius;
        shadowColor = kShadowColor;
        shadowOpacity = 1.0;
        shadowOffset = kShadowOffset;
    } else {
        shadowRadius = 0;
        shadowColor = NULL;
        shadowOpacity = 0.0;
        shadowOffset = CGSizeZero;
    }
    
    for(UIView *view in self.allAnimationViews) {
        view.layer.shadowRadius = shadowRadius;
        view.layer.shadowColor = shadowColor;
        view.layer.shadowOpacity = shadowOpacity;
        view.layer.shadowOffset = shadowOffset;
    }
}

// Called every time the "Set shadowPath" switch is changed
- (IBAction)shadowPathSwitchChanged: (id)sender {
    CGPathRef   shadowPath;
    
    if(self.shadowPathSwitch.on)
        shadowPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, kViewSize, kViewSize)].CGPath;
    else
        shadowPath = NULL;
    
    for(UIView *view in self.allAnimationViews)
        view.layer.shadowPath = shadowPath;
}

// Returns a random color
- (UIColor *)randomColor {
    CGFloat brightness;
    CGFloat hue;
    CGFloat saturation;
    UIColor *color;
    
    hue = (arc4random() % 256 / 256.0);
    saturation = (arc4random() % 128 / 256.0) + 0.5;
    brightness = (arc4random() % 128 / 256.0) + 0.5;
    color = [UIColor colorWithHue: hue saturation: saturation brightness: brightness alpha: 1.0];
    
    return color;
}

@end
