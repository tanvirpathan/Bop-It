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
        controller.testing = highScores;
        controller.didEnterFromMenu = YES;
        
    }
}

- (void) buildLayout {
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    UIButton *newGame = [UIButton buttonWithType:UIButtonTypeCustom];
    newGame.frame = CGRectMake(425, 560, 190, 50);
    [newGame setBackgroundImage:[UIImage imageNamed:@"newgame.png"] forState:UIControlStateNormal];
    [newGame addTarget:self action:@selector(handleNewGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newGame];
    
    UIButton *highscore = [UIButton buttonWithType:UIButtonTypeCustom];
    highscore.frame = CGRectMake(425, 640, 190, 50);
    [highscore setBackgroundImage:[UIImage imageNamed:@"highscore.png"] forState:UIControlStateNormal];
    [highscore addTarget:self action:@selector(handleHighscore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:highscore];
}

- (void)handleNewGame:(UIButton *)button{

    
    [self performSegueWithIdentifier:@"newGameSegue" sender:self];
    
}
- (void)handleHighscore:(UIButton *)button{
    
    [self performSegueWithIdentifier:@"highScore" sender:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
