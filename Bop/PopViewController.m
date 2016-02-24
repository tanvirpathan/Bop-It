//
//  PopViewController.m
//  Bop
//
//  Created by Navid Mia on 2016-02-23.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import "PopViewController.h"
#import <pop/POP.h>
#import <UIKitPlus/UIKitPlus.h>

@interface PopViewController () <POPAnimationDelegate>
{
    UIControl *circle;
}
@end

@implementation PopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) buildUI
{
    circle = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [circle centerInWidth:[[UIScreen mainScreen] bounds].size.width];
    [circle centerInHeight:[[UIScreen mainScreen] bounds].size.height];
    //    [circle alignRightToXPosition:[[UIScreen mainScreen] bounds].size.width - 10.0f];
    //    [circle setYPosition:10.0f];
    circle.backgroundColor = [UIColor blueColor];
    circle.layer.cornerRadius = 50.0f;
    circle.clipsToBounds = YES;
    
    [circle addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [circle addGestureRecognizer:recognizer];
    [self.view addSubview:circle];
}

- (void)touchDown:(UIControl *)sender {
    [sender.layer pop_removeAllAnimations];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [recognizer velocityInView:self.view];
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        positionAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
        [circle.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
//        positionAnimation.delegate = self;
    }
}

#pragma mark - Pop Animation Delegate
- (void)pop_animationDidApply:(POPDecayAnimation *)anim
{
//    BOOL isDragViewOutsideOfSuperView = !CGRectContainsRect(self.view.frame, circle.frame);
//    if (isDragViewOutsideOfSuperView) {
//        CGPoint currentVelocity = [anim.velocity CGPointValue];
//        CGPoint velocity = CGPointMake(currentVelocity.x, -currentVelocity.y);
//        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
//        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
//        positionAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
//        [circle.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
//    }
}

@end
