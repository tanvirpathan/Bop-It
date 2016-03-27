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
#import "HighscoreView.h"


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
    UILabel* HighScoreCounter;
    UILabel* HighScoreLabel;
    UILabel* currentScoreCounter;
    NSUserDefaults *defaults;
    NSUserDefaults *scoresDefaults;
    
    
    NSInteger high;
    UIButton *startButton;
    UIButton *scoreScreen;
    
    UIImage *bopitText;
    UIImage *pullitText;
    UIImage *stretchitText;
    UIImage *spinitText;
    UIImage *flickitText;
    
    UILabel *bopstats;
    UILabel *stretchstats;
    UILabel *flickstats;
    UILabel *gearstats;
    UILabel *pullstats;
    
    int x;
    int y;
    int opacity;
    double duration;
    double fromRotationValue;
    double toRotationValue;
    int LabelNumber;
    
    POPBasicAnimation *layerOpacity;
    POPSpringAnimation *positionAnimation;
    double waitTime;
    
    
    
    int counter;
    NSInteger score;
    int speed;
    int random;
    
    NSMutableArray *highScores;
    
    POPBasicAnimation *opacityAnimation;
    //NSMutableArray *savedScores;


}
@end

@implementation PopViewController


- (void)viewDidLoad {
    
   
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    _didEnterFromMenu = NO;
     bopstats= [[UILabel alloc]init];
    stretchstats= [[UILabel alloc]init];
    flickstats= [[UILabel alloc]init];
    gearstats= [[UILabel alloc]init];
    pullstats= [[UILabel alloc]init];
    
    bopstats.text = @"3";
    
    stretchstats.text = @"34";
    flickstats.text = @"34";
    gearstats.text = @"32";
    pullstats.text = @"345";
    
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"highscorekey"] mutableCopy]) {
        highScores = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highscorekey"] mutableCopy];
    }
    else{
        highScores = @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0 ].mutableCopy;
    }
    

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
    overlay.alpha = 0;
    overlay.image = overlaypic;
    [self.view addSubview:overlay];
    
}
- (void) overlayAnimation {
    POPBasicAnimation *overlayOpacity = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    overlayOpacity.duration = duration;
    overlayOpacity.beginTime = CACurrentMediaTime() + waitTime;
    overlayOpacity.toValue = @(opacity);
    
    POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotationAnimation.beginTime = CACurrentMediaTime() + waitTime;
    rotationAnimation.fromValue = @(fromRotationValue);
    rotationAnimation.toValue = @(toRotationValue);
    rotationAnimation.springBounciness = 20.f;
    rotationAnimation.springSpeed = 5;
    
    [overlay.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    rotationAnimation.delegate = self;
    
    [overlay.layer pop_addAnimation:overlayOpacity forKey:@"overlayOpacity"];
    overlayOpacity.delegate = self;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"scoreScreen"]){
        HighscoreView *controller = (HighscoreView *)segue.destinationViewController;
        controller.testing = highScores;
        controller.bopstats = bopstats;
        controller.stretchstats = stretchstats;
        controller.flickstats = flickstats;
        controller.gearstats = gearstats;
        controller.pullstats = pullstats;
    
    }
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
    scene.scaleMode = SKSceneScaleModeAspectFill;
    particleBackground.allowsTransparency = YES;
    scene.backgroundColor = [UIColor clearColor];
    [particleBackground presentScene:scene];

    //Current Score Label
    currentScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 270, 485, 100)];
    [currentScoreLabel setText:@"GET READY"];
    currentScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:28];
    [currentScoreLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:currentScoreLabel];
    
    //High Score Label
    HighScoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(890, 270, 485, 100)];
    [HighScoreLabel setText:@"BEST"];
    HighScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:28];
    [HighScoreLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:HighScoreLabel];
    
    //High Score Counter
    HighScoreCounter=[[UILabel alloc]initWithFrame:CGRectMake(835, 300, 300, 200)];
    HighScoreCounter.text = [NSString stringWithFormat:@"%ld",(long)high];
    HighScoreCounter.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:120];
    [HighScoreCounter setTextColor:[UIColor whiteColor]];
    [self.view addSubview:HighScoreCounter];
    
    //Current Score Counter Label
    currentScoreCounter=[[UILabel alloc]initWithFrame:CGRectMake(45, 300, 300, 200)];
    [currentScoreCounter setText:@"0"];//Set text in label.
    currentScoreCounter.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:120];
    [currentScoreCounter setTextColor:[UIColor whiteColor]];
    [self.view addSubview:currentScoreCounter];
    
    //Score screen
    scoreScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    scoreScreen.frame = CGRectMake(425, 640, 190, 50);
    [scoreScreen setBackgroundImage:[UIImage imageNamed:@"highscore.png"] forState:UIControlStateNormal];
    [scoreScreen addTarget:self action:@selector(handleScoreScreen:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:scoreScreen];
    
    //Start Button
    startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startButton.frame = CGRectMake(420, 580, 190, 50);
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

- (void) LeftLabelAnimations{
    
    //[self LayerOpacity];
    [self PositionAnimation];
    if (LabelNumber == 1) {
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        
        [currentScoreLabel.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
    else if (LabelNumber == 2){
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [currentScoreCounter.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];

    }
    else if (LabelNumber == 3){
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [HighScoreCounter.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
    else{
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [HighScoreLabel.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    }
    

    positionAnimation.delegate = self;

}

- (void) Flickit{
    
    //Make view
    flick = [[UIImageView alloc] initWithFrame:CGRectMake(600, 800, 230, 230)];
    [flick setImage:[UIImage imageNamed:@"flickit"]];
    flick.contentMode = UIViewContentModeScaleAspectFit;
    flick.alpha = 0;
    flick.clipsToBounds = YES;
    flick.userInteractionEnabled = YES;
    
    //Add gesture
    UISwipeGestureRecognizer *recognizer5 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleFlick:)];
    [recognizer5 setDirection:( UISwipeGestureRecognizerDirectionDown)];
    [flick addGestureRecognizer:recognizer5];
    [self.view addSubview:flick];

    
    
    
}
- (void) FlickitAnimation{
    
    [self LayerOpacity];
    [self PositionAnimation];
    
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    [flick.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    [flick.layer pop_addAnimation:layerOpacity forKey:@"layerOpacity"];
    positionAnimation.delegate = self;
    layerOpacity.delegate = self;
}

- (void) PullIt {
    
    //Make view
    circle = [[UIImageView alloc] initWithFrame:CGRectMake(479, 0, 120, 110)];
    [circle setImage:[UIImage imageNamed:@"pullitnew"]];
    circle.contentMode = UIViewContentModeScaleAspectFit;
    circle.alpha = 0;
    circle.userInteractionEnabled = YES;
    circle.clipsToBounds = YES;
    
    //Add gesture
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [circle addGestureRecognizer:recognizer];
    [self.view addSubview:circle];
    

}
- (void) PullitAnimation{
    
    [self LayerOpacity];
    [self PositionAnimation];
    
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    [circle.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    [circle.layer pop_addAnimation:layerOpacity forKey:@"layerOpacity"];
    positionAnimation.delegate = self;
    layerOpacity.delegate = self;
}

- (void)SpinIt {
    
    //Make view
    gear = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 190, 190)];
    [gear setImage:[UIImage imageNamed:@"gearnew"]];
    gear.contentMode = UIViewContentModeScaleAspectFit;
    gear.alpha = 0;
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

- (void) SpinitAnimation{
    
    [self LayerOpacity];
    [self PositionAnimation];
    
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    [gear.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    [gear.layer pop_addAnimation:layerOpacity forKey:@"layerOpacity"];
    positionAnimation.delegate = self;
    layerOpacity.delegate = self;
}

- (void) BopIt{
    
    //Make view
    bopit = [[UIImageView alloc] initWithFrame:CGRectMake(0, 220, 220, 220)];
    bopit.contentMode = UIViewContentModeScaleAspectFit;
    bopit.alpha = 0;
    bopit.userInteractionEnabled = YES;
    bopit.clipsToBounds = YES;

    //Add gesture
    UITapGestureRecognizer *recognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [bopit addGestureRecognizer:recognizer4];
    [self.view addSubview:bopit];

   
}
- (void) BopitAnimation{
    
    [self LayerOpacity];
    [self PositionAnimation];
    
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    [bopit.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    [bopit.layer pop_addAnimation:layerOpacity forKey:@"layerOpacity"];
    positionAnimation.delegate = self;
    layerOpacity.delegate = self;
}

- (void) PinchIt{
    
    //Make view
    pinchit = [[UIImageView alloc] initWithFrame:CGRectMake(1000, 400, 140, 140)];
    [pinchit setImage:[UIImage imageNamed:@"pinchitnew"]];
    pinchit.contentMode = UIViewContentModeScaleAspectFit;
    pinchit.alpha = 0;
    pinchit.userInteractionEnabled = YES;
    pinchit.clipsToBounds = YES;
    
    //Add gesture
    UIPinchGestureRecognizer *recognizer5 = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [pinchit addGestureRecognizer:recognizer5];
    [self.view addSubview:pinchit];

    
    
}
- (void) PinchitAnimation{
    
    [self LayerOpacity];
    [self PositionAnimation];
    
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    [pinchit.layer pop_addAnimation:positionAnimation forKey:@"layerPositionAnimation"];
    [pinchit.layer pop_addAnimation:layerOpacity forKey:@"layerOpacity"];
    positionAnimation.delegate = self;
    layerOpacity.delegate = self;
}

#pragma mark -
#pragma mark Game Logic and Timer

- (void)timerAction:(NSTimer *)timer {
    
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
    opacity = 0;
    duration = 0.1;
    fromRotationValue = 0;
    toRotationValue = 1.2;
    [self overlayAnimation];
    x = 600; y = 800;
    [self FlickitAnimation];
    x = 479; y = 0;
    [self PullitAnimation];
    x = 0; y = 0;
    [self SpinitAnimation];
    x = 0; y = 220;
    [self BopitAnimation];
    x = 1000; y = 400;
    [self PinchitAnimation];
    
    x = 290; y = 320; LabelNumber = 1;
    [self LeftLabelAnimations];
    x = 190; y = 400; LabelNumber = 2;
    [self LeftLabelAnimations];
    x = 980; y = 400; LabelNumber = 3;
    [self LeftLabelAnimations];
    x = 1135; y = 320; LabelNumber = 4;
    [self LeftLabelAnimations];
    
    opacityAnimation.toValue = @(1);
    [startButton.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [scoreScreen.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    
    
    
    //Resets game logic
    isGameOver = YES;
    currentScoreLabel.text = @"SCORE";
    startButton.userInteractionEnabled = YES;
    scoreScreen.userInteractionEnabled = YES;
    UIImage *gameOverText = [UIImage imageNamed:@"gameOver.png"];
    gameStatus.image = gameOverText;
    speed = 6;
    counter = 0;
    [myTimer invalidate];
    
    NSLog(@"[%d]",score);
    

    NSMutableArray *sorted1 = [highScores sortedArrayUsingSelector:@selector(compare:)].mutableCopy;
    for (int i=0; i< [sorted1 count]; i++){
        NSLog(@"[%d]:%@",i,sorted1[i]);
        if (score >= [sorted1[0] intValue]) {
            sorted1[0] = @(score);
        }
    }
    
    highScores = [sorted1 sortedArrayUsingSelector:@selector(compare:)].mutableCopy;
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self"
                                                                ascending: NO];
    highScores =  [sorted1 sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]].mutableCopy;
    for (int i=0; i< [highScores count]; i++){
        NSLog(@"[%d]:%@",i,highScores[i]);
       
    }
    [[NSUserDefaults standardUserDefaults] setObject:highScores forKey:@"highscorekey"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[NSUserDefaults standardUserDefaults] synchronize];
    });

    if (score >high) {
        [defaults setInteger:score forKey:@"HighScore"];
        [defaults synchronize];
        HighScoreCounter.text = [NSString stringWithFormat:@"BEST %ld",(long)score];
    }
    
}
#pragma mark -
#pragma mark Handle User Interactions

- (void)handleScoreScreen:(UIButton *)button{
    
//    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
//    layerScaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
//    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
//    layerScaleAnimation.springBounciness = 15.f;
//    [button.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];

    
    
    
    [self performSegueWithIdentifier:@"scoreScreen" sender:self];
    
}

- (void)buttonTouchDown:(UIButton *)button{
    
    //Start background music
    waitTime = 0.1;
    opacity = 1;
    duration = 0.3;
    fromRotationValue = 1.2;
    toRotationValue = 0;
    
    x = 290; y = 610; LabelNumber = 1;
    [self LeftLabelAnimations];
    x = 200; y = 690; LabelNumber = 2;
    [self LeftLabelAnimations];
    x = 990; y = 140; LabelNumber = 3;
    [self LeftLabelAnimations];
    x = 1150; y = 60; LabelNumber = 4;
    [self LeftLabelAnimations];
    
    [self overlayAnimation];
    
    x = 460; y = 80;
    [self FlickitAnimation];
    x = 539; y = 680;
    [self PullitAnimation];
    x = 150; y = 350;
    [self SpinitAnimation];
    x = 515; y = 340;
    [self BopitAnimation];
    x = 820; y = 330;
    [self PinchitAnimation];
    
    
    audioplayer.currentTime = 0;
    [audioplayer play];
    startButton.userInteractionEnabled = NO;
    scoreScreen.userInteractionEnabled = NO;
    isGameOver = NO;
    
    opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0);
    [button.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [scoreScreen.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    
    
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
    if(isGameOver == NO){
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
    
}

- (void)handleFlick:(UISwipeGestureRecognizer *)recognizer
{
    //Play sound and animate
    //AudioServicesPlaySystemSound(BoingSoundID);
    [BoingSoundID play];
    
 
        [UIView animateWithDuration:0.15f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [flick setTransform:CGAffineTransformRotate(flick.transform, M_PI/5)];
        }completion:^(BOOL finished){
        }];
        [UIView animateWithDuration:0.15f delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [flick setTransform:CGAffineTransformRotate(flick.transform, -M_PI/5)];
        }completion:^(BOOL finished){
        }];
    
    
    //Handle game logic
    if(isGameOver == NO){
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
    
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    //Track pan movement
    BOOL passedBoundaries = NO;
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

    //Check if user panned far enough
    if (((recognizer.view.center.x + translation.x) <= 450) || (recognizer.view.center.y + translation.y) <= 500) {
        
        
        //Play sound
        [SlideWhistleID play];
        
        passedBoundaries = YES;
        
    }
   
    //Handle animation when user lets go
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (passedBoundaries == YES){
            
            //Handle game logic
            
            if(isGameOver == NO){
                if (random != 1) {
                    
                    [self gameFailed];
                }
                else {
                    
                    score++;
                    currentScoreCounter.text = [NSString stringWithFormat:@"%d",score];
                    counter = 0;
                    [self randomGen];
                }
                
            }
            
            passedBoundaries = NO;
      
        //Animate back into position
        
        }
    }
    CGPoint velocity = [recognizer velocityInView:self.view];
    POPSpringAnimation *returnPan = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    returnPan.velocity = [NSValue valueWithCGPoint:velocity];
    returnPan.toValue = [NSValue valueWithCGPoint:CGPointMake(539, 680)];
    [circle.layer pop_addAnimation:returnPan forKey:@"returnPan"];
    returnPan.delegate = self;

}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    //Play sound and animate
    //AudioServicesPlaySystemSound(BopitID);
    [BopitID play];
    bopit.userInteractionEnabled = NO;
    [self AnimateGameScreen];
    
    //Handle game logic
    if(isGameOver == NO){
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
    
}

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    
    //Check game logic
    if(isGameOver == NO){
        if (random != 4) {
            [self gameFailed];
        }
        else {
            counter = 0;
        }
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
        if(isGameOver == NO){
            score++;
        }
        
        currentScoreCounter.text = [NSString stringWithFormat:@"%d",score];
        [self randomGen];
        [StretchID play];
        
        
    }
    
}
- (void) AnimateGameScreen{
    POPSpringAnimation *animateGameScreen = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animateGameScreen.velocity = @400;
    animateGameScreen.springBounciness = 5.f;
    [animateGameScreen setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        bopit.userInteractionEnabled = YES;
    }];
    [gameStatus.layer pop_addAnimation:animateGameScreen forKey:@"positionAnimation"];
    animateGameScreen.delegate = self;
}
- (void) LayerOpacity{
    layerOpacity = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    layerOpacity.duration = duration;
    layerOpacity.beginTime = CACurrentMediaTime() + waitTime;
    layerOpacity.toValue = @(opacity);
}
- (void) PositionAnimation{
    positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.beginTime = CACurrentMediaTime() + waitTime;
    positionAnimation.springBounciness = 13.f;
    positionAnimation.springSpeed = 5;
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
