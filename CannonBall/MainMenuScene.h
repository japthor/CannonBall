//
//  MainMenuScene.h
//  CannonBall
//
//  Created by Javier Pastor on 24/12/16.
//  Copyright © 2016 Javier Pastor Serrano. All rights reserved.
//

#ifndef MainMenuScene_h
#define MainMenuScene_h

#import <SpriteKit/SpriteKit.h>

typedef enum{
    kObkectType_Title,
    kObjectType_Play,
    kObjectType_BackGround,
} MainMenuObjectType;

@interface MainMenuScene : SKNode

@property(nonatomic) SKLabelNode* Play;
@property(nonatomic) SKLabelNode* Title;
@property(nonatomic) SKSpriteNode* BackGround;

-(void) InitTitle:(CGPoint)point;
-(void) InitPlay:(CGPoint)point;
-(void) InitBackGround:(CGPoint)point size:(CGSize) size;
-(void) HiddenObject:(MainMenuObjectType)type hide:(bool)hide;

@end
#endif /* MainMenuScene_h */
