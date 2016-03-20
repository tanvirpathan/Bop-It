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
//#import "RainScene.h"
//#import "SmokeScene.h"
#import "Firefly.h"


@interface PopViewController () <POPAnimationDelegate>
{
    
    //__weak IBOutlet SKView *particleBackground;
    //Game buttons
    
    BOOL isGameOver;
    __weak IBOutlet SKView *particleBackground;
    UIImageView *circle;
    UIImageView *bopit;
    UIImageView *pinchit;
    UIImageView *gear;
    UIImageView *flick;
    
    //Timer
    NSTimer *myTimer;
    
    UIImageView* gameStatus;
    UIImageView* overlay;
    UILabel* currentScoreLabel;
    UILabel* HighScoreLabel;
    UILabel* currentScoreCounter;
    NSUserDefaults *defaults;
    NSInteger high;
    UIButton *startButton;
    
    UIImage *bopitText;
    UIImage *pullitText;
    UIImage *stretchitText;
    UIImage *spinitText;
    UIImage *flickitText;
    
    
    int counter;
    int score;
    int speed;
    int random;


}
@end

@implementation PopViewController


- (void)viewDidLoad {
    
   
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
   
    
    
    [self sounds];
    [self buildLayout];
    [self PullIt];
    [self Flickit];
    [self SpinIt];
    [self BopIt];
    [self PinchIt];
    [self overlay];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Build Game Layout

- (void) overlay {
    
    UIImage *overlaypic = [UIImage imageNamed:@"overlay.png"];
    overlay=[[UIImageView alloc]initWithFrame:self.view.frame];
    overlay.image = overlaypic;
    [self.view addSubview:overlay];
}

- (void) buildLayout {
    
    //Saving Highscores
    defaults = [NSUserDefaults standardUserDefaults];
    high = [defaults integerForKey:@"HighScore"];
    speed = 6;

    
    //Background Image
    UIImage *backgroundImage = [UIImage imageNamed:@"backgroundGameScreen.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    Firefly *scene = [Firefly sceneWithSize:particleBackground.bounds.size];
   // RainScene *scene2 = [RainScene sceneWithSize:particleBackground2.bounds.size];
//    SmokeScene *scene = [SmokeScene sceneWithSize:particleBackground.bounds.size];
//    
//
    scene.scaleMode = SKSceneScaleModeAspectFill;
    particleBackground.allowsTransparency = YES;
    scene.backgroundColor = [UIColor clearColor];
    [particleBackground presentScene:scene];
    
    //Current Score Label
    currentScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 485, 485, 200)];
    [currentScoreLabel setText:@"GET READY"];
    currentScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:28];
    [currentScoreLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:currentScoreLabel];
    
    //High Score Label
    HighScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(750, 25, 300, 100)];
    HighScoreLabel.text = [NSString stringWithFormat:@"HIGHSCORE: %ld",(long)high];
    HighScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:28];
    [HighScoreLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:HighScoreLabel];
    
    //Current Score Counter Label
    currentScoreCounter=[[UILabel alloc]initWithFrame:CGRectMake(55, 580, 300, 200)];
    [currentScoreCounter setText:@"0"];//Set text in label.
    currentScoreCounter.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:120];
    [currentScoreCounter setTextColor:[UIColor whiteColor]];
    [self.view addSubview:currentScoreCounter];
    
    //Score screen
    UIButton *scoreScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    scoreScreen.frame = CGRectMake(810, 700, 190, 50);
    [scoreScreen setBackgroundImage:[UIImage imageNamed:@"highscore.png"] forState:UIControlStateNormal];
    [scoreScreen addTarget:self action:@selector(handleScoreScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scoreScreen];
    
    //Start Button
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(810, 640, 190, 50);
    [startButton setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:startButton];
    
    //GameStatus
    bopitText = [UIImage imageNamed:@"bopitText.png"];
    pullitText = [UIImage imageNamed:@"pullitText.png"];
    stretchitText = [UIImage imageNamed:@"strechitText.png"];
    spinitText = [UIImage imageNamed:@"spinitText.png"];
    flickitText = [UIImage imageNamed:@"flickitText.png"];
    
    gameStatus=[[UIImageView alloc]initWithFrame:self.view.frame];
    UIImage *pressStart = [UIImage imageNamed:@"pressStart.png"];
    gameStatus.image = pressStart;
    [self.view addSubview:gameStatus];

}

- (void) Flickit{
    
    //Make view
    flick = [[UIImageView alloc] initWithFrame:CGRectMake(350, -38, 230, 230)];
    [flick setImage:[UIImage imageNamed:@"flickit"]];
    flick.contentMode = UIViewContentModeScaleAspectFit;
    flick.clipsToBounds = YES;
    flick.userInteractionEnabled = YES;
    
    //Add gesture
    UISwipeGestureRecognizer *recognizer5 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFlick:)];
    [recognizer5 setDirection:( UISwipeGestureRecognizerDirectionDown)];
    [flick addGestureRecognizer:recognizer5];
    [self.view addSubview:flick];
}

- (void) PullIt {
    
    //Make view
    circle = [[UIImageView alloc] initWithFrame:CGRectMake(479, 625, 120, 110)];
    [circle setImage:[UIImage imageNamed:@"pullitnew"]];
    circle.contentMode = UIViewContentModeScaleAspectFit;
    circle.userInteractionEnabled = YES;
    circle.clipsToBounds = YES;
    
    //Add gesture
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [circle addGestureRecognizer:recognizer];
    [self.view addSubview:circle];
}

- (void)SpinIt {
    
    //Make view
    gear = [[UIImageView alloc] initWithFrame:CGRectMake(69, 250, 190, 190)];
    [gear setImage:[UIImage imageNamed:@"gearnew"]];
    gear.contentMode = UIViewContentModeScaleAspectFit;
    gear.clipsToBounds = YES;
    gear.userInteractionEnabled = YES;


    //Add gesture
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *recognizer3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
    [recognizer3 setDirection:( UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp)];
    [gear addGestureRecognizer:recognizer2];
    [gear addGestureRecognizer:recognizer3];
    [self.view addSubview:gear];
    
}

- (void) BopIt{
    
    //Make view
    bopit = [[UIImageView alloc] initWithFrame:CGRectMake(420, 220, 220, 220)];
    bopit.contentMode = UIViewContentModeScaleAspectFit;
    bopit.userInteractionEnabled = YES;
    bopit.clipsToBounds = YES;

    //Add gesture
    UITapGestureRecognizer *recognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [bopit addGestureRecognizer:recognizer4];
    [self.view addSubview:bopit];
}

- (void) PinchIt{
    
    //Make view
    pinchit = [[UIImageView alloc] initWithFrame:CGRectMake(720, 230, 130, 130)];
    [pinchit setImage:[UIImage imageNamed:@"pinchitnew"]];
    pinchit.contentMode = UIViewContentModeScaleAspectFit;
    pinchit.userInteractionEnabled = YES;
    pinchit.clipsToBounds = YES;
    
    //Add gesture
    UIPinchGestureRecognizer *recognizer5 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [pinchit addGestureRecognizer:recognizer5];
    [self.view addSubview:pinchit];
    
}

#pragma mark -
#pragma mark Game Logic and Timer

- (void)timerAction:(NSTimer *)timer {
    
    //Game prompt

    

    
    //Speed change based on current user score
    //Motivation messages
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
       
    }
    
    //Checks if user is within the game timer
    if (counter >= speed) {
        [self gameFailed];
    }
    counter++;
   
}

//Generates random number
- (void) randomGen {
    if (isGameOver != YES) {
        random = arc4random_uniform(6);
        
        if (random == 0){
            random++;
        }
        //Game Logic
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
            gameStatus.image = stretchitText;
            
        }
        else if (random == 5) {
            gameStatus.image = flickitText;
            
        }
        [self AnimateGameScreen];
    }

}

- (void) gameFailed{
    
    //Stops background music and plays failed game sound
    [audioplayer stop];
    [FailedID play];
    
    //Resets game logic
    isGameOver = YES;
    currentScoreLabel.text = @"SO CLOSE!";
    startButton.userInteractionEnabled = YES;
    UIImage *gameOverText = [UIImage imageNamed:@"gameOver.png"];
    gameStatus.image = gameOverText;
    speed = 6;
    counter = 0;
    [myTimer invalidate];
    
    //Checks for highscore and updates accordingly
    if (score >high) {
        [defaults setInteger:score forKey:@"HighScore"];
        [defaults synchronize];
        HighScoreLabel.text = [NSString stringWithFormat:@"HIGHSCORE: %d",score];
    }
    
}
#pragma mark -
#pragma mark Handle User Interactions

- (void)handleScoreScreen:(UIButton *)button{
    
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    layerScaleAnimation.springBounciness = 15.f;
    [button.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    [self performSegueWithIdentifier:@"scoreScreen" sender:self];
    
}

- (void)buttonTouchDown:(UIButton *)button{
    
    //Start background music
    [self sounds];
    audioplayer.currentTime = 0;
    [audioplayer play];
    startButton.userInteractionEnabled = NO;
    isGameOver = NO;
    
    //Animate start button
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    layerScaleAnimation.springBounciness = 15.f;
    [button.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    //Set game logic
    score = 0;
    currentScoreCounter.text = @"0";
    currentScoreLabel.text = @"LETS START EASY";
    [myTimer invalidate];
    [self randomGen];
    
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.62
                                               target:self
                                             selector:@selector(timerAction:)
                                             userInfo:nil
                                              repeats:YES];
    
    
}

- (void)touchDown:(UIControl *)sender {
    [sender.layer pop_removeAllAnimations];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    //Play sound and animate
    //AudioServicesPlaySystemSound(GearID);
    
    [GearID play];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [gear setTransform:CGAffineTransformRotate(gear.transform, M_PI)];
    }completion:^(BOOL finished){
    }];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [gear setTransform:CGAffineTransformRotate(gear.transform, -M_PI)];
    }completion:^(BOOL finished){
    }];

    //Handle game logic
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
    //Play sound and animate
    //AudioServicesPlaySystemSound(BoingSoundID);
    [BoingSoundID play];
    [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [flick setTransform:CGAffineTransformRotate(flick.transform, M_PI/3)];
    }completion:^(BOOL finished){
    }];
    [UIView animateWithDuration:0.15f delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [flick setTransform:CGAffineTransformRotate(flick.transform, -M_PI/3)];
    }completion:^(BOOL finished){
    }];
    
    //Handle game logic
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
    //Track pan movement
    BOOL passedBoundaries = NO;
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    //Check if user panned far enough
    if (((recognizer.view.center.x + translation.x) <= 400) || (recognizer.view.center.y + translation.y) <= 400) {
        
        //Play sound
        //AudioServicesPlaySystemSound(SlideWhistleID);
        [SlideWhistleID play];
        passedBoundaries = YES;
    }
   
    //Handle animation when user lets go
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        if (passedBoundaries == YES){
            
            //Handle game logic
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
        
        //Animate back into position
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
    //Play sound and animate
    //AudioServicesPlaySystemSound(BopitID);
    [BopitID play];
    bopit.userInteractionEnabled = NO;
    [self AnimateGameScreen];
    
    //Handle game logic
    if (random != 3) {
        [self gameFailed];
    }
    else {
        score++;
        currentScoreCounter.text = [NSString stringWithFormat:@"%d",score];
        counter = 0;
        [self randomGen];
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    
    //Check game logic
    if (random != 4) {
        [self gameFailed];
    }
    else {
        counter = 0;
    }
    
    //Animate
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 15.f;
    [pinchit.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    //Check when user lets go
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        //Play sound
        score++;
        currentScoreCounter.text = [NSString stringWithFormat:@"%d",score];
        [self randomGen];
        [StretchID play];
        
        
    }
    
}
- (void) AnimateGameScreen{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @400;
    positionAnimation.springBounciness = 5.f;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        bopit.userInteractionEnabled = YES;
    }];
    [gameStatus.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    positionAnimation.delegate = self;
}

- (void) sounds{
    
    //Flick it sound

        NSString *Boing = [[NSBundle mainBundle]pathForResource:@"Cartoon_Boing" ofType:@"mp3"];
        BoingSoundID = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:Boing] error:NULL];
        //BoingSoundID.delegate = self;
        BoingSoundID.volume = 0.3;

   //Pull it sound
    NSString *SlideWhistle = [[NSBundle mainBundle]pathForResource:@"Slide_Whistle" ofType:@"wav"];
    SlideWhistleID = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:SlideWhistle] error:NULL];
    //SlideWhistleID.delegate = self;
    SlideWhistleID.volume = 0.3;

   //Spin it sound
    NSString *Gear = [[NSBundle mainBundle]pathForResource:@"gear" ofType:@"mp3"];
    GearID = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:Gear] error:NULL];
    //GearID.delegate = self;
    GearID.volume = 0.3;

   //Stretch it sound
    NSString *Stretch = [[NSBundle mainBundle]pathForResource:@"stretch" ofType:@"mp3"];
    StretchID = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:Stretch] error:NULL];
    //StretchID.delegate = self;
    StretchID.volume = 0.6;

   //Bopit sound
    NSString *Bopit = [[NSBundle mainBundle]pathForResource:@"bopit" ofType:@"wav"];
    BopitID = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:Bopit] error:NULL];
    //BopitID.delegate = self;
    BopitID.volume = 0.3;

   //Failed sound
    NSString *Failed = [[NSBundle mainBundle]pathForResource:@"failed" ofType:@"wav"];
    FailedID = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:Failed] error:NULL];
    //FailedID.delegate = self;
    FailedID.volume = 0.3;
   
    
    
    //Background music
  

        NSString *sound = [[NSBundle mainBundle]pathForResource:@"backgroundbeat" ofType:@"mp3"];
        audioplayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:sound] error:NULL];

    //audioplayer.delegate = self;
    audioplayer.numberOfLoops = -1;
    audioplayer.volume = 0.3;
    
}

@end
