//
//  IntroView.m
//  Bop
//
//  Created by Tanvir Pathan on 2016-03-06.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import "IntroView.h"
#import <pop/POP.h>
#import <UIKitPlus/UIKitPlus.h>
#import "RainScene.h"
#import "Firefly.h"
#import "HighscoreView.h"


@interface IntroView () <POPAnimationDelegate>
{
    
    __weak IBOutlet SKView *particleBackground;
    
}
@end
@implementation IntroView

- (void)viewDidLoad {
    [super viewDidLoad];
    Firefly *scene = [Firefly sceneWithSize:particleBackground.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    particleBackground.allowsTransparency = YES;
    scene.backgroundColor = [UIColor clearColor];
    
    [particleBackground presentScene:scene];
    [self buildLayout];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSMutableArray *highScores;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"highscorekey"] mutableCopy]) {
        highScores = [[[NSUserDefaults standardUserDefaults] objectForKey:@"highscorekey"] mutableCopy];
    }
    else{
        highScores = @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0 ].mutableCopy;
    }

    if([segue.identifier isEqualToString:@"highScore"]){
        HighscoreView *controller = (HighscoreView *)segue.destinationViewController;
        //controller.testing = @[@(752),@(64),@(53),@(42),@(41),@(39),@(36),@(35),@(30),@(29) ];
        controller.testing = highScores;
        
    }
}

- (void) buildLayout {
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    UIButton *newGame = [UIButton buttonWithType:UIButtonTypeCustom];
    newGame.frame = CGRectMake(415, 570, 190, 50);
    [newGame setBackgroundImage:[UIImage imageNamed:@"newgame.png"] forState:UIControlStateNormal];
    [newGame addTarget:self action:@selector(handleNewGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newGame];
    
    UIButton *highscore = [UIButton buttonWithType:UIButtonTypeCustom];
    highscore.frame = CGRectMake(415, 640, 190, 50);
    [highscore setBackgroundImage:[UIImage imageNamed:@"highscore.png"] forState:UIControlStateNormal];
    [highscore addTarget:self action:@selector(handleHighscore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:highscore];
}

- (void)handleNewGame:(UIButton *)button{
    NSLog(@"newGame");  
    
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    layerScaleAnimation.springBounciness = 15.f;
    [button.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    [self performSegueWithIdentifier:@"newGameSegue" sender:self];
    
}
- (void)handleHighscore:(UIButton *)button{
    NSLog(@"highscore");
    
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    layerScaleAnimation.springBounciness = 15.f;
    [button.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    [self performSegueWithIdentifier:@"highScore" sender:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
