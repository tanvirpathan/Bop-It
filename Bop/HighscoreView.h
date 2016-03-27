//
//  HighscoreView.h
//  Bop
//
//  Created by Tanvir Pathan on 2016-03-20.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SpriteKit;
@interface HighscoreView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *scoreHistory;
@property (nonatomic, retain) NSArray *testing;
@property(nonatomic) BOOL *didEnterFromMenu;

@property (nonatomic, strong) UILabel *bopstats;
@property (nonatomic, strong) UILabel *stretchstats;
@property (nonatomic, strong) UILabel *flickstats;
@property (nonatomic, strong) UILabel *gearstats;
@property (nonatomic, strong) UILabel *pullstats;
@end
