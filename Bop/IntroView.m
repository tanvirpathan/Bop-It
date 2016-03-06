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
@interface IntroView () <POPAnimationDelegate>
{
    
    
}
@end
@implementation IntroView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildLayout];
    
}

- (void) buildLayout {
    UIImage *backgroundImage = [UIImage imageNamed:@"background.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    UIButton *newGame = [UIButton buttonWithType:UIButtonTypeCustom];
    newGame.frame = CGRectMake(390, 570, 250, 50);
    [newGame setBackgroundImage:[UIImage imageNamed:@"newgame.png"] forState:UIControlStateNormal];
    [newGame addTarget:self action:@selector(handleNewGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newGame];
    
    UIButton *highscore = [UIButton buttonWithType:UIButtonTypeCustom];
    highscore.frame = CGRectMake(390, 640, 250, 50);
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
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
