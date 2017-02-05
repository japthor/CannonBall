//  GameScene.h
//  CannonBall
//
//  Created by PASTOR SERRANO, JAVIER on 10/01/2017.
//  Copyright © 2017 PASTOR SERRANO, JAVIER. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MainMenuScene.h"
#import "GameOverScene.h"

typedef enum{
    kObjectType_MainMenu,
    kObjectType_Game,
    kObjectType_GameOver,
} GameObjectType;

@interface GameScene : SKScene

// Cannon
@property(nonatomic) SKSpriteNode* Cannon;
@property(nonatomic)bool CannonHasShoot;
@property(nonatomic) bool CannonHasReload;

-(void) InitCannon:(CGPoint)point;
-(void) MoveCannon:(float)velocity;
-(void) ReloadCannon:(float) position;
-(void) ShootCannon;

// CannonBall
@property(nonatomic) SKSpriteNode* CannonBall;
@property(nonatomic) bool CannonIsMovingUp;
@property(nonatomic) bool CannonBallMoveToNewPosition;
@property(nonatomic)float CannonBallVelocity;

-(void) InitCannonBall:(CGPoint)point;
-(void) MoveCannonBall:(float)position velocity:(float)velocity;
-(void) CheckCollisionCannonBall;

// Target
@property(nonatomic) SKSpriteNode* Target;
@property(nonatomic) float TargetGoToPosition;
@property(nonatomic) bool TargetIsMovingLeft;
@property(nonatomic) bool TargetIsMovingRight;
@property(nonatomic) bool TargetSaveNewPosition;
@property(nonatomic) int TargetsLeft;

-(void) InitTarget:(CGPoint)point;
-(void) MoveTarget:(float)position velocity:(float)velocity;
-(void) NewRandomPositionEnemy:(int)maxX minX:(int)minX maxY:(int)maxY minY:(int)minY;

// Game Scene
@property(nonatomic) SKSpriteNode* BackGround;
@property(nonatomic) SKSpriteNode* SkyBackGround;
@property(nonatomic) SKSpriteNode* SkyBackGround2;
@property(nonatomic) SKSpriteNode* SkyBackGround3;
@property(nonatomic) SKSpriteNode* House;

-(void) InitBackGround:(CGPoint)point;

// Label
@property(nonatomic) SKLabelNode* LabelTargets;
@property(nonatomic) SKLabelNode* LabelTimer;
@property(nonatomic) NSTimeInterval StartTimer;
@property(nonatomic) bool HasStartTimer;
@property(nonatomic) int SecondsTimer;

-(void) InitLabelTarget:(CGPoint)point;
-(void) InitLabelTimer:(CGPoint)point;
-(void) ReduceEnemiesLabel;
-(void) CountDown:(CFTimeInterval) time;

// Init
-(void) InitGameVariables;
-(void) InitGame;
-(void) RepositionGameElements;

// Explosion
@property(nonatomic) SKSpriteNode* Explosion;
@property(nonatomic) NSArray* ExplosionFrames;
@property(nonatomic) SKAction* ExplosionAction;

-(void) InitExplosion:(CGPoint)point;
-(void) ActionExplosion:(float) positionX positionY:(float)positionY;

// Main Menu Scene
@property(nonatomic) MainMenuScene* MainMenuScene;
@property(nonatomic) bool  MainMenuActive;

-(void) InitMainMenuScene;

// GameOver Scene
@property(nonatomic) GameOverScene* GameOverScene;
@property(nonatomic) bool GameOverAtive;

-(void) InitGameOverScene;

// Hidden All Element
-(void) HiddenGameElements:(GameObjectType)type hidden:(bool)hidden;
-(void) TouchedPoint:(CGPoint)touchedPoint;

// View Controller
@property(nonatomic) bool IsBlowing;
@property(nonatomic) bool IsShaking;
@property(nonatomic) int Pitch;
@end
