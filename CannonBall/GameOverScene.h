//
//  GameOverScene.h
//  CannonBallGame
//
//  Created by Javier Pastor on 29/12/16.
//  Copyright © 2016 Javier Pastor Serrano. All rights reserved.
//

#ifndef GameOverScene_h
#define GameOverScene_h

#import <SpriteKit/SpriteKit.h>

typedef enum{
    kObjectType_PlayAgain,
    kObjectType_YouWinLose,
    kObjectType_BackGroundLose,
    kObjectType_BackGroundWin,
} GameOverObjectType;

@interface GameOverScene : SKNode

@property(nonatomic) SKLabelNode* PlayAgain;
@property(nonatomic) SKLabelNode* PlayAgainYes;
@property(nonatomic) SKLabelNode* PlayAgainNo;
@property(nonatomic) SKLabelNode* YouWinLose;

@property(nonatomic) SKSpriteNode* BackGroundLose;
@property(nonatomic) SKSpriteNode* BackGroundWin;

-(void) InitPlayAgain:(CGPoint)point;
-(void) InitPlayAgainYes:(CGPoint)point;
-(void) InitPlayAgainNo:(CGPoint)point;
-(void) InitYouWinLose:(CGPoint)point;
-(void) InitBackGroundLose:(CGPoint)point size:(CGSize)size;
-(void) InitBackGroundWin:(CGPoint)point size:(CGSize) size;
-(void) SetWinLoseText:(NSString*)string;
-(void) HiddenObject:(GameOverObjectType)type hide:(bool)hide;

@end
#endif /* GameOver_h */
