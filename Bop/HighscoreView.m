//
//  HighscoreView.m
//  Bop
//
//  Created by Tanvir Pathan on 2016-03-20.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import "HighscoreView.h"
#import <pop/POP.h>
#import "PopViewController.h"
#import <UIKitPlus/UIKitPlus.h>
#import "Firefly.h"
@interface HighscoreView ()<POPAnimationDelegate>{
UIImageView* stats;
    
    __weak IBOutlet SKView *particleBackground;
    
}
@end

@implementation HighscoreView

- (void)viewDidLoad {
    [super viewDidLoad];
    Firefly *scene = [Firefly sceneWithSize:particleBackground.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    particleBackground.allowsTransparency = YES;
    scene.backgroundColor = [UIColor clearColor];
    [particleBackground presentScene:scene];
    [self buildLayout];
    [self stats];
    
   
}

- (void) stats {
    
    UIImage *statspic = [UIImage imageNamed:@"stats.png"];
    stats=[[UIImageView alloc]initWithFrame:self.view.frame];
    stats.image = statspic;
     [self.view addSubview:stats];
    
//    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//    positionAnimation.toValue = @(0.8);
//    positionAnimation.autoreverses = YES;
//    positionAnimation.repeatForever = YES;
//    [stats.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
//    positionAnimation.delegate = self;
//    
   
}
- (void) buildLayout {
    
    //Background Image
    UIImage *backgroundImage = [UIImage imageNamed:@"backgroundGameScreen.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    //New Game button
    UIButton *newGame = [UIButton buttonWithType:UIButtonTypeCustom];
    newGame.frame = CGRectMake(425, 200, 190, 50);
    [newGame setBackgroundImage:[UIImage imageNamed:@"newgame.png"] forState:UIControlStateNormal];
    [newGame addTarget:self action:@selector(handleNewGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newGame];
    
    //Stats separator
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(40,525, 320, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(665,525, 320, 2)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView2];
    
    //Cause of death
    UILabel *causeOfDeath = [[UILabel alloc] initWithFrame:CGRectMake(420, 475, 200, 100)];
    causeOfDeath.text = @"CAUSE OF DEATH";
    causeOfDeath.textColor = [UIColor whiteColor];
    causeOfDeath.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:22];
    [self.view addSubview:causeOfDeath];
    
    //Achievements
    UILabel *achievements = [[UILabel alloc] initWithFrame:CGRectMake(785, 30, 200, 50)];
    achievements.text = @"ACHIEVEMENTS";
    achievements.textColor = [UIColor whiteColor];
    achievements.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:22];
    [self.view addSubview:achievements];
    
    //Top ten
    UILabel *topTen = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 200, 50)];
    topTen.text = @"HIGHSCORES";
    topTen.textColor = [UIColor whiteColor];
    topTen.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:22];
    [self.view addSubview:topTen];
    
    NSLog(@"bopstats: %@", _bopstats.text);
    UILabel *bopstats = [[UILabel alloc] initWithFrame:CGRectMake(80, 710, 100, 30)];
    bopstats.text = _bopstats.text;
    //bopstats.textColor = [UIColor colorWithRed:(241/255.f) green:(115/255.f) blue:(115/255.f) alpha:1.0];
    bopstats.textColor = [UIColor whiteColor];
    bopstats.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:35];
    [self.view addSubview:bopstats];
    
    UILabel *stretchstats = [[UILabel alloc] initWithFrame:CGRectMake(285, 710, 100, 30)];
    stretchstats.text = _stretchstats.text;
    //stretchstats.textColor = [UIColor colorWithRed:(241/255.f) green:(241/255.f) blue:(115/255.f) alpha:1.0];
    stretchstats.textColor = [UIColor whiteColor];
    stretchstats.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:35];
    [self.view addSubview:stretchstats];
    
    UILabel *flickstats = [[UILabel alloc] initWithFrame:CGRectMake(490, 710, 100, 30)];
    flickstats.text = _flickstats.text;
    //flickstats.textColor = [UIColor colorWithRed:(122/255.f) green:(243/255.f) blue:(168/255.f) alpha:1.0];
    flickstats.textColor = [UIColor whiteColor];
    flickstats.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:35];
    [self.view addSubview:flickstats];
    
    UILabel *gearstats = [[UILabel alloc] initWithFrame:CGRectMake(695, 710, 100, 30)];
    gearstats.text = _gearstats.text;
    //gearstats.textColor = [UIColor colorWithRed:(104/255.f) green:(203/255.f) blue:(239/255.f) alpha:1.0];
    gearstats.textColor = [UIColor whiteColor];
    gearstats.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:35];
    [self.view addSubview:gearstats];
    
    UILabel *pullstats = [[UILabel alloc] initWithFrame:CGRectMake(895, 710, 100, 30)];
    pullstats.text = _pullstats.text;
    //pullstats.textColor = [UIColor colorWithRed:(243/255.f) green:(175/255.f) blue:(101/255.f) alpha:1.0];
    pullstats.textColor = [UIColor whiteColor];
    pullstats.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:35];
    [self.view addSubview:pullstats];

    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.testing count];
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
- (void)handleNewGame:(UIButton *)button{
    if (_didEnterFromMenu == YES) {
        [self performSegueWithIdentifier:@"gameScreen" sender:self];
    }
    //
    else{
        [self dismissViewControllerAnimated:NO completion:^(void){
            NSLog(@"View controller dismissed");
            // things to do after dismissing
        }];
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.userInteractionEnabled = NO;
    NSString *SimpleIdentifier = @"SimpleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleIdentifier];
    }
   
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    
    //UIImage *image1 = [UIImage imageNamed:@"your_pic.png"];
    //cell.imageView.image = image1;
    
    cell.textLabel.text = [NSString stringWithFormat: @"%@", self.testing[indexPath.row]];
    //cell.textLabel.text=[self.scoreHistory objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor clearColor];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = YES;
    tableView.backgroundView = nil;

    return cell;
}


@end
