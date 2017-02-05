//  GameOver.m
//  CannonBallGame
//
//  Created by Javier Pastor on 29/12/16.
//  Copyright © 2016 Javier Pastor Serrano. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

- (void)InitPlayAgain:(CGPoint)point{
    
    _PlayAgain = [SKLabelNode labelNodeWithFontNamed:@"bernadette"];
    _PlayAgain.position = CGPointMake(point.x,point.y);
    _PlayAgain.text = [NSString stringWithFormat:@"Play Again?"];
    _PlayAgain.fontColor = [UIColor blackColor];
    _PlayAgain.name = @"PlayAgain";
    [self addChild:_PlayAgain];
    
}

-(void) InitPlayAgainYes:(CGPoint)point{
    
    _PlayAgainYes = [SKLabelNode labelNodeWithFontNamed:@"bernadette"];
    _PlayAgainYes.position = CGPointMake(point.x,point.y);
    _PlayAgainYes.text = [NSString stringWithFormat:@"Yes"];
    _PlayAgainYes.fontColor = [UIColor blackColor];
    _PlayAgainYes.name = @"Yes";
    [self addChild:_PlayAgainYes];
    
}

-(void) InitPlayAgainNo:(CGPoint)point{
    
    _PlayAgainNo = [SKLabelNode labelNodeWithFontNamed:@"bernadette"];
    _PlayAgainNo.position = CGPointMake(point.x,point.y);
    _PlayAgainNo.text = [NSString stringWithFormat:@"No"];
    _PlayAgainNo.fontColor = [UIColor blackColor];
    _PlayAgainNo.name = @"No";
    [self addChild:_PlayAgainNo];
    
}

-(void) InitYouWinLose:(CGPoint)point{
    
    _YouWinLose = [SKLabelNode labelNodeWithFontNamed:@"bernadette"];
    _YouWinLose.position = CGPointMake(point.x,point.y);
    _YouWinLose.text = [NSString stringWithFormat:@"You Win!"];
    _YouWinLose.fontColor = [UIColor blackColor];
    [self addChild:_YouWinLose];
    
}

-(void) InitBackGroundLose:(CGPoint)point size:(CGSize)size{
    
    _BackGroundLose = [SKSpriteNode spriteNodeWithImageNamed:@"Flames"];
    _BackGroundLose.position = CGPointMake(point.x,point.y);
    _BackGroundLose.size = size;
    
    [self addChild:_BackGroundLose];
}

-(void) InitBackGroundWin:(CGPoint)point size:(CGSize)size{
    
    _BackGroundWin = [SKSpriteNode spriteNodeWithImageNamed:@"Confetti"];
    _BackGroundWin.position = CGPointMake(point.x,point.y);
    _BackGroundWin.size = size;
    
    [self addChild:_BackGroundWin];
}

-(void) SetWinLoseText:(NSString *)string{
    
    _YouWinLose.text = string;
}

-(void) HiddenObject:(GameOverObjectType)type hide:(bool)hide{
    
    switch (type) {
        case kObjectType_PlayAgain:
            
            if (hide)
                _PlayAgain.hidden = true;
            else
                _PlayAgain.hidden = false;
            break;
            
        case kObjectType_BackGroundLose:
            
            if (hide)
                _BackGroundLose.hidden = true;
            else
                _BackGroundLose.hidden = false;
            break;
            
        case kObjectType_BackGroundWin:
            
            if (hide)
                _BackGroundWin.hidden = true;
            else
                _BackGroundWin.hidden = false;
            break;
            
            
        case kObjectType_YouWinLose:
            
            if (hide)
                _YouWinLose.hidden = true;
            else
                _YouWinLose.hidden = false;
            
            break;
            
        default:
            break;
    }
}

@end
