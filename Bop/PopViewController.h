//
//  PopViewController.h
//  Bop
//
//  Created by Navid Mia on 2016-02-23.
//  Copyright © 2016 Tanvir Pathan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@import SpriteKit;

@interface PopViewController : UIViewController

{

    
    AVAudioPlayer *BoingSoundID;
    AVAudioPlayer *SlideWhistleID;
    AVAudioPlayer *GearID;
    AVAudioPlayer *StretchID;
    AVAudioPlayer *BopitID;
    AVAudioPlayer *FailedID;

    AVAudioPlayer *audioplayer;
}

@property(nonatomic) BOOL *didEnterFromMenu;



@end
