//
//  HighscoreView.h
//  Bop
//
//  Created by Tanvir Pathan on 2016-03-20.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighscoreView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *scoreHistory;
@end
