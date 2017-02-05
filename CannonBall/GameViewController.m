//
//  GameViewController.m
//  CannonBall
//
//  Created by PASTOR SERRANO, JAVIER on 10/01/2017.
//  Copyright © 2017 PASTOR SERRANO, JAVIER. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKView *skView = (SKView *)self.view;

    SKScene* scene = [[GameScene alloc] initWithSize:CGSizeMake(skView.bounds.size.width, skView.bounds.size.height)];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
    
    [self InitAudioRecorder];
    [self InitCoreMotion];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)dealloc{
    Recorder = nil;
    RecorderTimer = nil;
    MotionManager = nil;
    OperationQueue = nil;
    MotionTimer = nil;
}

- (void)InitAudioRecorder{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    
    Recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if (Recorder) {
        [Recorder prepareToRecord];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        Recorder.meteringEnabled = YES;
        [Recorder record];
        RecorderTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target:self selector: @selector(RecorderTimerCallBack:) userInfo: nil repeats: YES];
    } else
        NSLog(@"%@",[error description]);
}

-(void)RecorderTimerCallBack:(NSTimer *)timer{
    [Recorder updateMeters];
    
    NSLog(@"Peak: %f",[Recorder peakPowerForChannel:0]);
    
    
    if([Recorder peakPowerForChannel:0] > -0.05 && [Recorder averagePowerForChannel:0] > -3.0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IsBlowing" object:self];
    }
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    // Accelerometer System
    if (UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IsShaking" object:self];
    }
}

-(void) InitCoreMotion{
    MotionManager = [[CMMotionManager alloc] init];
    MotionManager.deviceMotionUpdateInterval = 1/60;
    [MotionManager startDeviceMotionUpdates];
    
    MotionTimer = [NSTimer scheduledTimerWithTimeInterval:(1/60) target:self selector:@selector(CalculateGyroscopeDegrees) userInfo:nil repeats:YES];
    
}

-(void) CalculateGyroscopeDegrees{
    CMAttitude* Attitude;
    CMDeviceMotion* Motion = MotionManager.deviceMotion;
    Attitude = Motion.attitude;
    
    int Pitch = 180 * Attitude.pitch / M_PI;
    
    NSDictionary* gyroInfo = @{@"Pitch": @(Pitch)};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendGyroInfo" object:self userInfo:gyroInfo];
    
}

@end
