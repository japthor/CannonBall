//
//  MainMenuScene.m
//  CannonBall
//
//  Created by Javier Pastor on 24/12/16.
//  Copyright © 2016 Javier Pastor Serrano. All rights reserved.
//
#import "MainMenuScene.h"

@implementation MainMenuScene

-(void)InitTitle:(CGPoint)point{
    
    _Title = [SKLabelNode labelNodeWithFontNamed:@"bernadette"];
    _Title.position = CGPointMake(point.x,point.y);
    _Title.text = [NSString stringWithFormat:@"CannonBall"];
    _Title.fontColor = [UIColor blackColor];
    //_Title.name = @"InitPlay";
    _Title.xScale = 2.0f;
    _Title.yScale = 2.0f;
    [self addChild:_Title];
    
}

-(void)InitPlay:(CGPoint)point{
    
    _Play = [SKLabelNode labelNodeWithFontNamed:@"bernadette"];
    _Play.position = CGPointMake(point.x,point.y);
    _Play.text = [NSString stringWithFormat:@"Play"];
    _Play.fontColor = [UIColor blackColor];
    _Play.name = @"Play";
    [self addChild:_Play];
    
}

-(void) InitBackGround:(CGPoint)point size:(CGSize)size{
    
    _BackGround = [SKSpriteNode spriteNodeWithImageNamed:@"BackGround"];
    _BackGround.position = CGPointMake(point.x,point.y);
    _BackGround.size = size;
    
    [self addChild:_BackGround];
}


-(void) HiddenObject:(MainMenuObjectType)type hide:(bool)hide{
    
    switch (type) {
        case kObkectType_Title:
            
            if (hide)
                _Title.hidden = true;
            else
                _Title.hidden = false;
            
            break;
        
        case kObjectType_Play:
            
            if (hide)
                _Play.hidden = true;
            else
                _Play.hidden = false;
            
            break;
            
        case kObjectType_BackGround:
            
            if (hide)
                _BackGround.hidden = true;
            else
                _BackGround.hidden = false;
            
            break;
            
        default:
            break;
    }
}

@end
