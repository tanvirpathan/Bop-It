//
//  HighscoreView.m
//  Bop
//
//  Created by Tanvir Pathan on 2016-03-20.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import "HighscoreView.h"
#import <pop/POP.h>
@interface HighscoreView ()

@end

@implementation HighscoreView

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backgroundImage = [UIImage imageNamed:@"backgroundGameScreen.png"];
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    UIButton *newGame = [UIButton buttonWithType:UIButtonTypeCustom];
    newGame.frame = CGRectMake(30, 650, 190, 50);
    [newGame setBackgroundImage:[UIImage imageNamed:@"newgame.png"] forState:UIControlStateNormal];
    [newGame addTarget:self action:@selector(handleNewGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newGame];
    // Do any additional setup after loading the view.
    self.scoreHistory = @[@"75",@"64",@"53",@"42",@"41",@"39",@"36",@"35",@"30",@"29" ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.scoreHistory count];
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 2;
}
- (void)handleNewGame:(UIButton *)button{
    NSLog(@"newGame");
    
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    layerScaleAnimation.springBounciness = 15.f;
    [button.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];
    
    [self performSegueWithIdentifier:@"gameScreen" sender:self];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.userInteractionEnabled = NO;
    NSString *SimpleIdentifier = @"SimpleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SimpleIdentifier];
    }
    cell.detailTextLabel.text = @"01/13/1996";
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:30];
    
    //UIImage *image1 = [UIImage imageNamed:@"your_pic.png"];
    //cell.imageView.image = image1;
    
    cell.textLabel.text = self.scoreHistory[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor clearColor];
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = YES;
    tableView.backgroundView = nil;

    return cell;
}


@end
