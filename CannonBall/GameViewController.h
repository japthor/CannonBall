//
//  GameViewController.h
//  CannonBall
//
//  Created by PASTOR SERRANO, JAVIER on 10/01/2017.
//  Copyright © 2017 PASTOR SERRANO, JAVIER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <CoreMotion/CoreMotion.h>

@interface GameViewController : UIViewController{
    NSTimer* RecorderTimer;
    AVAudioRecorder* Recorder;
    
    CMMotionManager* MotionManager;
    NSOperationQueue* OperationQueue;
    NSTimer* MotionTimer;
    
}

@property(nonatomic) bool IsBlowing;

-(void) InitAudioRecorder;
-(void) RecorderTimerCallBack:(NSTimer *)timer;

-(void) InitCoreMotion;


@end
