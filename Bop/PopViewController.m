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
    UIImageView *circle;
    UIImageView *bopit;
    UIImageView *pinchit;
    UIImageView *gear;
    UIImageView *flick;
    NSTimer *myTimer;
    
    UIImageView* gameStatus;
    UIImageView* overlay;
    
    UILabel* currentScoreLabel;
    UILabel* HighScoreLabel;
    UILabel* currentScoreCounter;
    NSUserDefaults *defaults;
    NSInteger high;
    
    UIButton *startButton;
    
    int counter;
    int score;
    int speed;
    int random;
    

}
@end

@implementation PopViewController

- (void)viewDidLoad {
    
    NSURL *BoingURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Cartoon_Boing" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)BoingURL, &BoingSoundID);
    NSURL *SlideWhistleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Slide_Whistle" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)SlideWhistleURL, &SlideWhistleID);
    NSURL *GearURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gear" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)GearURL, &GearID);
    NSURL *StretchURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"stretch" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)StretchURL, &StretchID);
    NSURL *BopitURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bopit" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)BopitURL, &BopitID);
    NSURL *FailedURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"failed" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)FailedURL, &FailedID);
    
    
    NSString *sound = [[NSBundle mainBundle]pathForResource:@"backgroundbeat" ofType:@"mp3"];
    audioplayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:sound] error:NULL];
    audioplayer.delegate = self;
    audioplayer.numberOfLoops = -1;
    audioplayer.volume = 0.3;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildLayout];
    [self PullIt];
    [self Flickit];
    [self SpinIt];
    [self BopIt];
    [self PinchIt];
    [self overlay];
    
}
- (void) overlay{
    UIImage *overlaypic = [UIImage imageNamed:@"overlay.png"];
    overlay=[[UIImageView alloc]initWithFrame:self.view.frame];
    overlay.image = overlaypic;
    [self.view addSubview:overlay];

}

- (void) buildLayout {
    defaults = [NSUserDefaults standardUserDefaults];
    high = [defaults integerForKey:@"HighScore"];
    speed = 6;
    
    //Background Image
    UIImage *backgroundImage = [UIImage imageNamed:@"backgroundGameScreen.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    //Current Score Label
    currentScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 485, 485, 200)];//Set frame of label in your viewcontroller.
    [currentScoreLabel setText:@"GET READY"];//Set text in label.
    currentScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:28];
    [currentScoreLabel setTextColor:[UIColor whiteColor]];//Set text color in label.
    [self.view addSubview:currentScoreLabel];//Add it to the view of your choice.
    
    //High Score Label
    HighScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(750, 25, 300, 100)];//Set frame of label in your viewcontroller.
    HighScoreLabel.text = [NSString stringWithFormat:@"HIGHSCORE: %ld",(long)high];//Set text in label.
    HighScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:28];
    [HighScoreLabel setTextColor:[UIColor whiteColor]];//Set text color in label.
    [self.view addSubview:HighScoreLabel];//Add it to the view of your choice.
    
    //Current Score Counter Label
    currentScoreCounter=[[UILabel alloc]initWithFrame:CGRectMake(55, 580, 300, 200)];//Set frame of label in your viewcontroller.
    [currentScoreCounter setText:@"0"];//Set text in label.
    currentScoreCounter.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:120];
    [currentScoreCounter setTextColor:[UIColor whiteColor]];//Set text color in label.
    [self.view addSubview:currentScoreCounter];//Add it to the view of your choice.
    
    
    
    
    
    
    //Start Button
    
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(750, 690, 250, 50);

    [startButton setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:startButton];
    
    //GameStatus
    gameStatus=[[UIImageView alloc]initWithFrame:self.view.frame];
    UIImage *pressStart = [UIImage imageNamed:@"pressStart.png"];
    gameStatus.image = pressStart;
    [self.view addSubview:gameStatus];
    
    
    
}

- (void)buttonTouchDown:(UIButton *)button{
    NSLog(@"we here fam");
    audioplayer.currentTime = 0;
    [audioplayer play];
    startButton.userInteractionEnabled = NO;
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    layerScaleAnimation.springBounciness = 15.f;
    [button.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    score = 0;
    currentScoreCounter.text = @"0";
    currentScoreLabel.text = @"LETS START EASY";
    [myTimer invalidate];
    [self randomGen];
    //myTimer = nil;
    
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(timerAction:)
                                   userInfo:nil
                                    repeats:YES];
    
   
}

- (void)timerAction:(NSTimer *)timer {
    NSLog(@"we here fam 2");
    
    //gameStatus.text = [NSString stringWithFormat:@"%d",random];
    
    UIImage *bopitText = [UIImage imageNamed:@"bopitText.png"];
    UIImage *pullitText = [UIImage imageNamed:@"pullitText.png"];
    UIImage *strechitText = [UIImage imageNamed:@"strechitText.png"];
    UIImage *spinitText = [UIImage imageNamed:@"spinitText.png"];
    UIImage *flickitText = [UIImage imageNamed:@"flickitText.png"];
    
    
    
    
    
    
    if (random == 1) {
        gameStatus.image = pullitText;
    }
    else if (random == 2) {
        gameStatus.image = spinitText;
    }
    else if (random == 3) {
        gameStatus.image = bopitText;
    }
    else if (random == 4) {
        gameStatus.image = strechitText;
    }
    else if (random == 5) {
        gameStatus.image = flickitText;
    }
    
    
    if (score == 10) {
        currentScoreLabel.text = @"KEEP IT GOING";
        speed = 5;
    }
    if (score == 20) {
        currentScoreLabel.text = @"IT'S GETTING FASTER!";
        speed = 4;
    }
    if (score == 35) {
        currentScoreLabel.text = @"WOW!";
        speed = 3;
    }
    if (score == 50) {
        currentScoreLabel.text = @"ON FIREEEE";
        speed = 2;
    }
    if (score == 75) {
        currentScoreLabel.text = @"LEGENDARY";
        speed = 1;
    }
    
    
    if (counter >= speed) {
        [self gameFailed];
    }
    counter++;
    
}

- (void) randomGen {
    random = arc4random_uniform(6);
    if (random == 0){
        random++;
    }
}

- (void) gameFailed{
    [audioplayer stop];
    AudioServicesPlaySystemSound(FailedID);
    currentScoreLabel.text = @"SO CLOSE!";
    startButton.userInteractionEnabled = YES;
    UIImage *gameOverText = [UIImage imageNamed:@"gameOver.png"];
    gameStatus.image = gameOverText;
    
    if (score >high) {
        [defaults setInteger:score forKey:@"HighScore"];
        [defaults synchronize];
        HighScoreLabel.text = [NSString stringWithFormat:@"HIGHSCORE: %d",score];
    }
    
    
    
    
    counter = 0;
    
    
    [myTimer invalidate];
    //myTimer = nil;
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}













- (void) Flickit{
    flick = [[UIImageView alloc] initWithFrame:CGRectMake(350, -38, 230, 230)];
    [flick setImage:[UIImage imageNamed:@"flickit"]];
    flick.contentMode = UIViewContentModeScaleAspectFit;
    flick.clipsToBounds = YES;
    flick.userInteractionEnabled = YES;

    UISwipeGestureRecognizer *recognizer5 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFlick:)];

    [recognizer5 setDirection:( UISwipeGestureRecognizerDirectionDown)];

    [flick addGestureRecognizer:recognizer5];
    [self.view addSubview:flick];
}

- (void) PullIt
{
    
    circle = [[UIImageView alloc] initWithFrame:CGRectMake(479, 625, 120, 110)];
    
//    [circle centerInWidth:[[UIScreen mainScreen] bounds].size.width];
//    [circle centerInHeight:[[UIScreen mainScreen] bounds].size.height];
//        [circle alignRightToXPosition:[[UIScreen mainScreen] bounds].size.width - 10.0f];
//        [circle setYPosition:10.0f];
    [circle setImage:[UIImage imageNamed:@"pullitnew"]];
    circle.contentMode = UIViewContentModeScaleAspectFit;
    circle.userInteractionEnabled = YES;
    circle.clipsToBounds = YES;
    
   // [circle addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    [circle addGestureRecognizer:recognizer];
    [self.view addSubview:circle];
}

- (void) SpinIt
{
    gear = [[UIImageView alloc] initWithFrame:CGRectMake(69, 250, 190, 190)];
//    [circle centerInWidth:[[UIScreen mainScreen] bounds].size.width];
//    [circle centerInHeight:[[UIScreen mainScreen] bounds].size.height];
    [gear setImage:[UIImage imageNamed:@"gearnew"]];
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
    bopit = [[UIImageView alloc] initWithFrame:CGRectMake(420, 220, 220, 220)];
    //bopit.backgroundColor = [UIColor blueColor];
    //bopit.layer.cornerRadius = 10.0f;
    //[bopit setImage:[UIImage imageNamed:@"bop-it"]];
    bopit.contentMode = UIViewContentModeScaleAspectFit;
    bopit.userInteractionEnabled = YES;
    bopit.clipsToBounds = YES;
   // [bopit addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    UITapGestureRecognizer *recognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [bopit addGestureRecognizer:recognizer4];
    [self.view addSubview:bopit];
}

- (void) PinchIt{
    pinchit = [[UIImageView alloc] initWithFrame:CGRectMake(720, 230, 130, 130)];
//    pinchit.backgroundColor = [UIColor blueColor];
    
    [pinchit setImage:[UIImage imageNamed:@"pinchitnew"]];
    pinchit.contentMode = UIViewContentModeScaleAspectFit;
    pinchit.userInteractionEnabled = YES;
//    pinchit.layer.cornerRadius = 25.0f;
    pinchit.clipsToBounds = YES;
    
    //[pinchit addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    UIPinchGestureRecognizer *recognizer5 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [pinchit addGestureRecognizer:recognizer5];
    [self.view addSubview:pinchit];
    
}




















- (void)touchDown:(UIControl *)sender {
    [sender.layer pop_removeAllAnimations];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    AudioServicesPlaySystemSound(GearID);
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [gear setTransform:CGAffineTransformRotate(gear.transform, M_PI)];
    }completion:^(BOOL finished){
    }];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [gear setTransform:CGAffineTransformRotate(gear.transform, -M_PI)];
    }completion:^(BOOL finished){
    }];
    if (random != 2) {
        [self gameFailed];
    }
    else {
        score++;
        currentScoreCounter.text = [NSString stringWithFormat:@"%d",score];
        counter = 0;
        [self randomGen];
    }
}

- (void)handleFlick:(UISwipeGestureRecognizer *)recognizer
{
    AudioServicesPlaySystemSound(BoingSoundID);
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [flick setTransform:CGAffineTransformRotate(flick.transform, M_PI/3)];
    }completion:^(BOOL finished){
    }];
    [UIView animateWithDuration:0.25f delay:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [flick setTransform:CGAffineTransformRotate(flick.transform, -M_PI/3)];
    }completion:^(BOOL finished){
    }];
    if (random != 5) {
        [self gameFailed];
    }
    
    else {
        score++;
        currentScoreCounter.text = [NSString stringWithFormat:@"%d",score];
        counter = 0;
        [self randomGen];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    AudioServicesPlaySystemSound(SlideWhistleID);
    BOOL passedBoundaries = NO;
    CGPoint translation = [recognizer translationInView:self.view];

    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
    
  
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    if (((recognizer.view.center.x + translation.x) <= 400) || (recognizer.view.center.y + translation.y) <= 400) {
        passedBoundaries = YES;

    }
   
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        if (passedBoundaries == YES){
            if (random != 1) {
                [self gameFailed];
            }
            else {
                score++;
                currentScoreCounter.text = [NSString stringWithFormat:@"%d",score];
                counter = 0;
                [self randomGen];
            }
            passedBoundaries = NO;
        }
        CGPoint velocity = [recognizer velocityInView:self.view];
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        positionAnimation.velocity = [NSValue valueWithCGPoint:velocity];
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(539, 680)];
        [circle.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
        positionAnimation.delegate = self;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    AudioServicesPlaySystemSound(BopitID);

    if (random != 3) {
        [self gameFailed];
    }
    
    else {
        score++;
        currentScoreCounter.text = [NSString stringWithFormat:@"%d",score];
        counter = 0;
        [self randomGen];
    }
    
    bopit.userInteractionEnabled = NO;
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @800;
    positionAnimation.springBounciness = 15.f;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        bopit.userInteractionEnabled = YES;
    }];
    [gameStatus.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.delegate = self;
    
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 15.f;
    [pinchit.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        AudioServicesPlaySystemSound(StretchID);
        if (random != 4) {
            [self gameFailed];
        }
        else {
            score++;
            currentScoreCounter.text = [NSString stringWithFormat:@"%d",score];
            counter = 0;
            [self randomGen];
        }
    }
    
}



@end
