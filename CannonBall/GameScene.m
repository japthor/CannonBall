//
//  GameScene.m
//  CannonBall
//
//  Created by PASTOR SERRANO, JAVIER on 10/01/2017.
//  Copyright © 2017 PASTOR SERRANO, JAVIER. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    [self InitMainMenuScene];
    [self InitGame];
    [self InitGameOverScene];
    
    
    [self HiddenGameElements:kObjectType_MainMenu hidden:false];
    [self HiddenGameElements:kObjectType_GameOver hidden:true];
    [self HiddenGameElements:kObjectType_Game hidden:true];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IsBlowing:) name:@"IsBlowing" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IsShaking:) name:@"IsShaking" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendGyroInfo:) name:@"SendGyroInfo" object:nil];
    
    _MainMenuActive = true;
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (!_GameOverAtive && !_MainMenuActive) {
        if (_SkyBackGround.position.x >= self.frame.size.width * 1.5f) {
            _SkyBackGround.position = CGPointMake(self.frame.size.width * -0.5,CGRectGetMidY(self.frame));
        }else{
            _SkyBackGround.position = CGPointMake(_SkyBackGround.position.x + 0.5 + 0.00001, _SkyBackGround.position.y);
        }
        
        if (_SkyBackGround2.position.x >= self.frame.size.width * 1.5f) {
            _SkyBackGround2.position = CGPointMake(self.frame.size.width * -0.5,CGRectGetMidY(self.frame));
        }else{
            _SkyBackGround2.position = CGPointMake(_SkyBackGround2.position.x + 0.5, _SkyBackGround2.position.y);
        }
        [self MoveCannon:self.frame.size.width * 0.01f];
        [self MoveTarget:self.frame.size.width * 0.15f velocity:self.frame.size.width * 0.004f];
        
        if (_CannonHasShoot){
            if (_IsShaking){
                if (_CannonBallVelocity < 0.025f) {
                    _CannonBallVelocity += 0.025f;
                    [self MoveCannonBall:self.frame.size.height * 1.0f velocity:self.frame.size.height * _CannonBallVelocity];
                }else{
                    [self MoveCannonBall:self.frame.size.height * 1.0f velocity:self.frame.size.height * _CannonBallVelocity];
                }
            }else
                [self MoveCannonBall:self.frame.size.height * 1.0f velocity:self.frame.size.height * 0.0035f];
        }else
            _IsShaking = false;
        
        [self ShootCannon];
        [self ReloadCannon: self.frame.size.width * 0.18f];
        [self CountDown:currentTime];
    }

}

-(void)InitCannon:(CGPoint)point{
    _Cannon = [SKSpriteNode spriteNodeWithImageNamed:@"Cannon.png"];
    _Cannon.position = CGPointMake(point.x,point.y);
    [self addChild:_Cannon];
    
}

-(void)MoveCannon:(float)velocity {
    if (_Cannon.position.x > self.frame.size.width * 0.03)
    {
        if(_Pitch <= -5)
            _Cannon.position = CGPointMake(_Cannon.position.x - velocity, _Cannon.position.y);
    }
    
    if (_Cannon.position.x < self.frame.size.width * 0.97) {
        if(_Pitch >= 5)
            _Cannon.position = CGPointMake(_Cannon.position.x + velocity, _Cannon.position.y);
    }
}

-(void) ReloadCannon:(float)position{
    
    if (_Cannon.position.x <= position && !_CannonHasReload) {
        [self runAction:[SKAction playSoundFileNamed:@"Reload.wav" waitForCompletion:NO]];
        _CannonHasReload = true;
    }
}
-(void) ShootCannon{
    if ((_CannonHasReload && !_CannonHasShoot) && _IsBlowing) {
        _CannonHasShoot = true;
        _CannonHasReload = false;
    }
    
    if(_IsBlowing)
        _IsBlowing = false;
}

-(void) InitCannonBall:(CGPoint)point{
    _CannonBall = [SKSpriteNode spriteNodeWithImageNamed:@"CannonBall.png"];
    _CannonBall.position = CGPointMake(point.x,point.y);
    [self addChild:_CannonBall];
}

-(void)MoveCannonBall:(float)position velocity:(float)velocity{
    if (_CannonHasShoot) {
        if (!_CannonBallMoveToNewPosition) {
            _CannonBall.position = CGPointMake(_Cannon.position.x,_Cannon.position.y + 50.0f);
            _CannonBall.hidden = false;
            _CannonBallMoveToNewPosition = true;
            
        }
        
        [self CheckCollisionCannonBall];
        
        if(_CannonBall.position.y >= position){
            _CannonHasShoot = false;
            _CannonBallMoveToNewPosition = false;
            _CannonBall.hidden = true;
            _CannonBallVelocity = 0.0035f;
        }else{
            _CannonBall.position = CGPointMake(_CannonBall.position.x, _CannonBall.position.y + velocity);
        }
    }
}

-(void)CheckCollisionCannonBall{
    if ([_CannonBall intersectsNode:_Target]) {
        _CannonBall.position = CGPointMake(_CannonBall.position.x,_CannonBall.position.y + 500.0f);
        [self ActionExplosion:_Target.position.x positionY:_Target.position.y];
        _TargetsLeft -= 1;
        _CannonHasShoot = false;
        _CannonBallVelocity = 0.0035f;
        [self ReduceEnemiesLabel];
        [self NewRandomPositionEnemy:150 minX:-100 maxY:100 minY:0];
        
    }
}

-(void)InitTarget:(CGPoint)point{
    _Target = [SKSpriteNode spriteNodeWithImageNamed:@"Target.png"];
    _Target.position = CGPointMake(point.x,point.y);
    [self addChild:_Target];
}

-(void) MoveTarget:(float)position velocity:(float)velocity {
    
    if (!_TargetSaveNewPosition) {
        _TargetGoToPosition = _Target.position.x;
        _TargetSaveNewPosition = true;
    }
    
    if(_TargetIsMovingRight){
        if (_TargetGoToPosition + position <= _Target.position.x) {
            _TargetIsMovingRight = false;
            _TargetIsMovingLeft = true;
        }else{
            _Target.position = CGPointMake(_Target.position.x + velocity, _Target.position.y);
        }
        
    }
    
    if(_TargetIsMovingLeft){
        if (_TargetGoToPosition - position >= _Target.position.x) {
            _TargetIsMovingRight = true;
            _TargetIsMovingLeft = false;
        }else{
            _Target.position = CGPointMake(_Target.position.x - velocity, _Target.position.y);
        }
        
    }
}

-(void)NewRandomPositionEnemy:(int)maxX minX:(int)minX maxY:(int)maxY minY:(int)minY{
    int newX = minX + arc4random() % (maxX-minX+1);
    int newY = minY + arc4random() % (maxY-minY+1);
    _Target.position = CGPointMake(CGRectGetMidX(self.frame) + newX, CGRectGetMidY(self.frame) + newY);
    
    _TargetIsMovingLeft = false;
    _TargetIsMovingRight = true;
    _TargetSaveNewPosition = false;
}

-(void) InitBackGround:(CGPoint)point{
    _SkyBackGround3 = [SKSpriteNode spriteNodeWithImageNamed:@"Sky2"];
    _SkyBackGround3.position = CGPointMake(point.x,point.y);
    [self addChild:_SkyBackGround3];
    
    _SkyBackGround = [SKSpriteNode spriteNodeWithImageNamed:@"Sky"];
    _SkyBackGround.position = CGPointMake(point.x,point.y);
    [self addChild:_SkyBackGround];
    
    _SkyBackGround2 = [SKSpriteNode spriteNodeWithImageNamed:@"Sky"];
    _SkyBackGround2.position = CGPointMake(self.frame.size.width * -0.5 ,point.y);
    [self addChild:_SkyBackGround2];

    
    _BackGround = [SKSpriteNode spriteNodeWithImageNamed:@"BackGround2"];
    _BackGround.position = CGPointMake(point.x,point.y);
    [self addChild:_BackGround];
    
    _House = [SKSpriteNode spriteNodeWithImageNamed:@"House"];
    _House.size = self.frame.size;
    _House.position = CGPointMake(point.x,point.y);
    [self addChild:_House];
    
}

-(void) InitLabelTarget:(CGPoint)point{
    _LabelTargets = [SKLabelNode labelNodeWithFontNamed:@"bernadette"];
    _LabelTargets.position = CGPointMake(point.x,point.y);
    _LabelTargets.text = [NSString stringWithFormat:@"Targets Left: %d",_TargetsLeft];
    _LabelTargets.fontColor = [UIColor blackColor];
    [self addChild:_LabelTargets];
}

-(void) InitLabelTimer:(CGPoint)point{
    _LabelTimer = [SKLabelNode labelNodeWithFontNamed:@"bernadette"];
    _LabelTimer.position = CGPointMake(point.x,point.y);
    _LabelTimer.fontColor = [UIColor blackColor];
    [self addChild:_LabelTimer];
}
-(void) ReduceEnemiesLabel{
    _LabelTargets.text = [NSString stringWithFormat:@"Targets Left: %d",_TargetsLeft];
}

-(void) CountDown:(CFTimeInterval)time{
    
    if(!_HasStartTimer){
        _StartTimer = time;
        _HasStartTimer = true;
    }
    
    int countDown = _SecondsTimer - (int)(time - _StartTimer);
    _LabelTimer.text = [NSString stringWithFormat:@" Current Time: %d", countDown];
    
    
    if(countDown <= 0 || _TargetsLeft == 0){
        _GameOverAtive = true;
        [self HiddenGameElements:kObjectType_Game hidden:true];
        
        if (_TargetsLeft > 0) {
            [self HiddenGameElements:kObjectType_GameOver hidden:false];
            [_GameOverScene SetWinLoseText:@"You Lose!"];
            [_GameOverScene HiddenObject:kObjectType_BackGroundWin hide:true];
            [_GameOverScene HiddenObject:kObjectType_BackGroundLose hide:false];
        } else {
            [self HiddenGameElements:kObjectType_GameOver hidden:false];
            [_GameOverScene SetWinLoseText:@"You Win!"];
            [_GameOverScene HiddenObject:kObjectType_BackGroundWin hide:false];
            [_GameOverScene HiddenObject:kObjectType_BackGroundLose hide:true];
        }
        
    }
}

-(void) InitGameVariables {
    _CannonHasShoot = false;
    _CannonBallMoveToNewPosition = false;
    _CannonHasReload = true;
    
    _CannonBall.hidden = true;
    _CannonBallVelocity = 0.0035f;
    
    _TargetIsMovingLeft = false;
    _TargetIsMovingRight = true;
    _TargetSaveNewPosition = false;
    _TargetGoToPosition = 0.0f;
    _TargetsLeft = 10;
    
    _SecondsTimer = 60;
    _HasStartTimer = false;
    _StartTimer = 0.0f;
    
    _GameOverAtive = false;
    
    _IsBlowing = false;
    _IsShaking = false;
}

-(void) InitGame{
    [self InitGameVariables];
    
    [self InitBackGround:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    _BackGround.yScale = self.frame.size.height / _BackGround.frame.size.height;
    _BackGround.xScale = self.frame.size.width / _BackGround.frame.size.width;
    
    _SkyBackGround.yScale = self.frame.size.height / _SkyBackGround.frame.size.height;
    _SkyBackGround.xScale = self.frame.size.width / _SkyBackGround.frame.size.width;
    
    _SkyBackGround2.yScale = self.frame.size.height / _SkyBackGround2.frame.size.height;
    _SkyBackGround2.xScale = self.frame.size.width / _SkyBackGround2.frame.size.width;
    
    _SkyBackGround3.yScale = self.frame.size.height / _SkyBackGround3.frame.size.height;
    _SkyBackGround3.xScale = self.frame.size.width / _SkyBackGround3.frame.size.width;
    
    [self InitCannon:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.frame.size.width * 0.2f)];
    _Cannon.yScale = self.frame.size.height / 375.0f;
    _Cannon.xScale = self.frame.size.width / 667.0f;
    
    [self InitTarget:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.frame.size.width * 0.26f)];
    _Target.yScale = self.frame.size.height / 375.0f;
    _Target.xScale = self.frame.size.width / 667.0f;
    
    [self InitCannonBall:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.frame.size.height * 0.26f)];
    _CannonBall.yScale = self.frame.size.height / 375.0f;
    _CannonBall.xScale = self.frame.size.width / 667.0f;
    
    [self InitLabelTarget:CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width * 0.3f, CGRectGetMidY(self.frame) + self.frame.size.height * 0.4f)];
    _LabelTargets.yScale = self.frame.size.height / 375.0f;
    _LabelTargets.xScale = self.frame.size.width / 667.0f;
    
    [self InitLabelTimer:CGPointMake(CGRectGetMidX(self.frame) - self.frame.size.width * 0.3f , CGRectGetMidY(self.frame) + self.frame.size.height * 0.4f)];
    _LabelTimer.yScale = self.frame.size.height / 375.0f;
    _LabelTimer.xScale = self.frame.size.width / 667.0f;
    
    [self InitExplosion:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    [self TouchedPoint:location];
}

-(void) RepositionGameElements{
    _Cannon.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.frame.size.height * 0.30f);
    _CannonBall.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.frame.size.height * 0.26f);
    _Target.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.frame.size.height * 0.26f);
    _SkyBackGround.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    _SkyBackGround2.position = CGPointMake(self.frame.size.width * -0.5 ,CGRectGetMidY(self.frame));
}

-(void) InitExplosion:(CGPoint)point{
    
    NSMutableArray* ExplosionFrames = [NSMutableArray array];
    SKTextureAtlas* ExplosionAnimatedAtlas = [SKTextureAtlas atlasNamed:@"ExplosionImages"];
    
    NSUInteger numberOfImages = ExplosionAnimatedAtlas.textureNames.count;
    for(int i=1; i<= numberOfImages; i++){
        NSString* textureName = [NSString stringWithFormat:@"Explosion%d",i];
        SKTexture* tmp = [ExplosionAnimatedAtlas textureNamed:textureName];
        [ExplosionFrames addObject:tmp];
    }
    
    _ExplosionFrames = ExplosionFrames;
    
    SKTexture* tmp = _ExplosionFrames[0];
    
    _Explosion = [SKSpriteNode spriteNodeWithTexture:tmp];
    _Explosion.position = CGPointMake(point.x,point.y);
    _Explosion.hidden = true;
    [self addChild:_Explosion];
}

-(void) ActionExplosion:(float)positionX positionY:(float)positionY{
    _Explosion.hidden = false;
    _Explosion.position = CGPointMake(positionX,positionY);
    [_Explosion runAction:[SKAction repeatAction:[SKAction animateWithTextures:_ExplosionFrames timePerFrame:0.1f resize:NO restore:YES] count:1] completion:^{
        _Explosion.hidden = true;
    }];
}

-(void) InitMainMenuScene {
    _MainMenuScene = [[MainMenuScene alloc] init];
    [_MainMenuScene InitBackGround:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)) size:self.frame.size];
    [_MainMenuScene InitTitle:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.frame.size.height *0.26f)];
    [_MainMenuScene InitPlay:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    
    [self addChild:_MainMenuScene];
}

-(void) InitGameOverScene {
    _GameOverScene = [[GameOverScene alloc] init];
    
    [_GameOverScene InitBackGroundLose:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)) size:self.frame.size];
    [_GameOverScene InitBackGroundWin:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)) size:self.frame.size];
    [_GameOverScene InitYouWinLose:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.frame.size.height *0.26f)];
    [_GameOverScene InitPlayAgain:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)- self.frame.size.height * 0.1f)];
    [_GameOverScene InitPlayAgainYes:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.frame.size.height * 0.23f)];
    [_GameOverScene InitPlayAgainNo:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - self.frame.size.height *0.36f)];
    
    [self addChild:_GameOverScene];
}

-(void) HiddenGameElements:(GameObjectType)type hidden:(bool)hidden{
    
    switch (type) {
        case kObjectType_MainMenu:
            
            if (hidden) {
                [_MainMenuScene HiddenObject:kObkectType_Title hide:true];
                [_MainMenuScene HiddenObject:kObjectType_Play hide:true];
                [_MainMenuScene HiddenObject:kObjectType_BackGround hide:true];
                _MainMenuScene.hidden = true;
            } else {
                [_MainMenuScene HiddenObject:kObkectType_Title hide:false];
                [_MainMenuScene HiddenObject:kObjectType_Play hide:false];
                [_MainMenuScene HiddenObject:kObjectType_BackGround hide:false];
                _MainMenuScene.hidden = false;
            }
            break;
            
        case kObjectType_Game:
            
            if (hidden) {
                _Cannon.hidden = true;
                _CannonBall.hidden = true;
                _Target.hidden = true;
                _BackGround.hidden = true;
                _SkyBackGround.hidden = true;
                _SkyBackGround2.hidden = true;
                _SkyBackGround3.hidden = true;
                _House.hidden = true;
                _LabelTargets.hidden = true;
                _LabelTimer.hidden = true;
                _Explosion.hidden = true;
            }else{
                _Cannon.hidden = false;
                _CannonBall.hidden = true;
                _Target.hidden = false;
                _BackGround.hidden = false;
                _SkyBackGround.hidden = false;
                _SkyBackGround2.hidden = false;
                _SkyBackGround3.hidden = false;
                _House.hidden = false;
                _LabelTargets.hidden = false;
                _LabelTimer.hidden = false;
                _Explosion.hidden = true;
            }
            break;
            
        case kObjectType_GameOver:
            
            if (hidden) {
                [_GameOverScene HiddenObject:kObjectType_BackGroundWin hide:true];
                [_GameOverScene HiddenObject:kObjectType_PlayAgain hide:true];
                [_GameOverScene HiddenObject:kObjectType_YouWinLose hide:true];
                [_GameOverScene HiddenObject:kObjectType_BackGroundLose hide:true];
                _GameOverScene.hidden = true;
                
            } else {
                [_GameOverScene HiddenObject:kObjectType_BackGroundWin hide:false];
                [_GameOverScene HiddenObject:kObjectType_PlayAgain hide:false];
                [_GameOverScene HiddenObject:kObjectType_YouWinLose hide:false];
                [_GameOverScene HiddenObject:kObjectType_BackGroundLose hide:false];
                
                _GameOverScene.hidden = false;
            }
            
            break;
            
        default:
            break;
    }
}

-(void) TouchedPoint:(CGPoint)touchedPoint{
    SKNode*touchedNode = [self nodeAtPoint:touchedPoint];
    
    
    NSLog(@"Node: %@", touchedNode.name);
    
    if (_MainMenuScene.hidden == false) {
        if([touchedNode.name isEqualToString:@"Play"]){
            [self RepositionGameElements];
            [self HiddenGameElements:kObjectType_Game hidden:false];
            _MainMenuActive = false;
            [self HiddenGameElements:kObjectType_MainMenu hidden:true];
            [self InitGameVariables];
            _LabelTargets.text = [NSString stringWithFormat:@"Targets Left: %d",_TargetsLeft];
        }
    }
    
    if (_GameOverScene.hidden == false){
        if([touchedNode.name isEqualToString:@"Yes"]){
            [self RepositionGameElements];
            [self HiddenGameElements:kObjectType_Game hidden:false];
            [self HiddenGameElements:kObjectType_GameOver hidden:true];
            [self InitGameVariables];
            _LabelTargets.text = [NSString stringWithFormat:@"Targets Left: %d",_TargetsLeft];
        }
        
        if([touchedNode.name isEqualToString:@"No"]){
            _MainMenuActive = false;
            [self HiddenGameElements:kObjectType_GameOver hidden:true];
            [self HiddenGameElements:kObjectType_MainMenu hidden:false];
            [self HiddenGameElements:kObjectType_Game hidden:true];
            
        }
    }
}

-(void)IsShaking:(NSNotification *) notification
{
    _IsShaking = true;
}

-(void)IsBlowing:(NSNotification *) notification
{
    _IsBlowing = true;
}

-(void)SendGyroInfo:(NSNotification *) notification
{
    NSDictionary* info = notification.userInfo;
    NSNumber* pitch = (NSNumber*)info[@"Pitch"];
    _Pitch = pitch.intValue;
}

@end
