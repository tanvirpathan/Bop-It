//
//  RotateViewController.m
//  Bop
//
//  Created by Navid Mia on 2016-02-23.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import "RotateViewController.h"
#import <pop/POP.h>
#import <UIKitPlus/UIKitPlus.h>

@interface RotateViewController ()
{
    UIImageView *circle;
}
@end

@implementation RotateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) buildUI
{
    circle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [circle centerInWidth:[[UIScreen mainScreen] bounds].size.width];
    [circle centerInHeight:[[UIScreen mainScreen] bounds].size.height];
    [circle setImage:[UIImage imageNamed:@"gear"]];
    circle.contentMode = UIViewContentModeScaleAspectFit;
    circle.clipsToBounds = YES;
    circle.userInteractionEnabled = YES;
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
    [recognizer2 setDirection:( UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp)];
    [circle addGestureRecognizer:recognizer];
    [circle addGestureRecognizer:recognizer2];
    [self.view addSubview:circle];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [circle setTransform:CGAffineTransformRotate(circle.transform, M_PI)];
    }completion:^(BOOL finished){
    }];
//    [UIView animateWithDuration:1.0f animations:^{
//        circle.transform = CGAffineTransformMakeRotation(M_PI);
//    }];
    
//    [UIView animateWithDuration:1.0
//                          delay:0.0
//                        options:0
//                     animations:^{
//                         circle.transform = CGAffineTransformMakeRotation(M_PI);
//                     }
//                     completion:^(BOOL finished){
//                     }];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [circle setTransform:CGAffineTransformRotate(circle.transform, M_PI)];
        }completion:^(BOOL finished){
        }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
