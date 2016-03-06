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
    UIControl *bopit;
    UIControl *pinchit;
    UIImageView *gear;
    NSTimer *myTimer;
    
    UILabel* gameStatus;
    
    int counter;
    int score;
    int high;
    int random;
    

}
@end

@implementation PopViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildLayout];
    [self PullIt];
    [self SpinIt];
    [self BopIt];
    [self PinchIt];
    
}

- (void) buildLayout {
    
    //Start Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"START" forState:UIControlStateNormal];
    
    button.bounds = CGRectMake(0, 0, 140, 44);
    button.backgroundColor = [UIColor redColor];
    button.center = CGPointMake(500, 600);
    
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:button];
    
    //GameStatus
    gameStatus = [[UILabel alloc] initWithFrame:CGRectMake(500, 150, 200, 200)];
    gameStatus.text = @"Press start to begin";
    [self.view addSubview:gameStatus];
    
    
    
}

- (void)buttonTouchDown:(UIButton *)button{
    NSLog(@"we here fam");
    [myTimer invalidate];
    myTimer = nil;
    [self randomGen];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(timerAction:)
                                   userInfo:nil
                                    repeats:YES];
   
}

- (void)timerAction:(NSTimer *)timer {
    NSLog(@"we here fam 2");
    gameStatus.text = [NSString stringWithFormat:@"%d",random];
    if (counter >= 7) {
        [self gameFailed];
    }
    counter++;
    
}

- (void) randomGen {
    random = arc4random_uniform(5);
    if (random == 0){
        random++;
    }
}

- (void) gameFailed{
    _score.text = [NSString stringWithFormat:@"New score: %d",score];
    score =0;
    [myTimer invalidate];
    myTimer = nil;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}















- (void) PullIt
{
    
    circle = [[UIControl alloc] initWithFrame:CGRectMake(95, 95, 100, 100)];
//    [circle centerInWidth:[[UIScreen mainScreen] bounds].size.width];
//    [circle centerInHeight:[[UIScreen mainScreen] bounds].size.height];
//        [circle alignRightToXPosition:[[UIScreen mainScreen] bounds].size.width - 10.0f];
//        [circle setYPosition:10.0f];
    circle.backgroundColor = [UIColor blueColor];
    circle.layer.cornerRadius = 50.0f;
    circle.clipsToBounds = YES;
    
    [circle addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [circle addGestureRecognizer:recognizer];
    [self.view addSubview:circle];
}

- (void) SpinIt
{
    gear = [[UIImageView alloc] initWithFrame:CGRectMake(750, 80, 150, 150)];
//    [circle centerInWidth:[[UIScreen mainScreen] bounds].size.width];
//    [circle centerInHeight:[[UIScreen mainScreen] bounds].size.height];
    [gear setImage:[UIImage imageNamed:@"gear"]];
    gear.contentMode = UIViewContentModeScaleAspectFit;
    gear.clipsToBounds = YES;
    gear.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *recognizer3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    //    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
    [recognizer3 setDirection:( UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp)];
    [gear addGestureRecognizer:recognizer2];
    [gear addGestureRecognizer:recognizer3];
    [self.view addSubview:gear];
}

- (void) BopIt{
    bopit = [[UIControl alloc] initWithFrame:CGRectMake(95, 450, 150, 150)];
    bopit.backgroundColor = [UIColor blueColor];
    bopit.layer.cornerRadius = 10.0f;
    bopit.clipsToBounds = YES;
    
    [bopit addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    UITapGestureRecognizer *recognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [bopit addGestureRecognizer:recognizer4];
    [self.view addSubview:bopit];
}

- (void) PinchIt{
    pinchit = [[UIControl alloc] initWithFrame:CGRectMake(750, 450, 150, 150)];
    pinchit.backgroundColor = [UIColor blueColor];
    pinchit.layer.cornerRadius = 25.0f;
    pinchit.clipsToBounds = YES;
    
    [pinchit addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    UIPinchGestureRecognizer *recognizer5 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [pinchit addGestureRecognizer:recognizer5];
    [self.view addSubview:pinchit];
    
}




















- (void)touchDown:(UIControl *)sender {
    [sender.layer pop_removeAllAnimations];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [gear setTransform:CGAffineTransformRotate(gear.transform, M_PI)];
    }completion:^(BOOL finished){
    }];
    if (random != 2) {
        [self gameFailed];
    }
    score++;
    counter = 0;
    [self randomGen];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    BOOL passedBoundaries = NO;
    CGPoint translation = [recognizer translationInView:self.view];

    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
    
  
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    if (((recognizer.view.center.x + translation.x) >= 300) || (recognizer.view.center.y + translation.y) >= 300) {
        passedBoundaries = YES;

    }
   
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        if (passedBoundaries == YES){
            if (random != 1) {
                [self gameFailed];
            }
            score++;
            counter = 0;
            [self randomGen];
            passedBoundaries = NO;
        }
        CGPoint velocity = [recognizer velocityInView:self.view];
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 150)];
        [circle.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
        positionAnimation.delegate = self;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if (random != 3) {
        [self gameFailed];
    }
    score++;
    counter = 0;
    [self randomGen];
    
    bopit.userInteractionEnabled = NO;
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @800;
    positionAnimation.springBounciness = 15.f;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        bopit.userInteractionEnabled = YES;
    }];
    [bopit.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.delegate = self;
    
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(2.0, 2.0)];
    [pinchit.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (random != 4) {
            [self gameFailed];
        }
        score++;
        counter = 0;
        [self randomGen];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
        scaleAnimation.springBounciness = 20.f;
        
    }
    
}



@end
