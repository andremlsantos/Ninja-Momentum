//
//  Gameplay.m
//  NinjaMomentum
//
//  Created by andre on 25/03/16.
//  Copyright © 2016 Apportable. All rights reserved.
//
#import "Level1.h"
#import "Ninja.h"
#import "CCDirector_Private.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "LogUtils.h"
#import "AudioUtils.h"

//auxiliares slowmotion
bool enableSlowMotion = false;
float slowVelocity = 0.3f;
float ninjaCircleOpacity = 0.15f;
float overlayLayerOpacity = 0.3f;
int radiusCircle = 0;

bool asRetryLocation = false;
int numberOfEnemies = 3;

//auxiliares mira
float angleXX = 0.f, angleYY = 0.f;
float scaleAim = 5.0f;

CGPoint retryLocation;
bool isPaused = false;

//TRIES
int numberTries1 = 0;

//LOG VARIABLES
int numberOfDeaths = 0;
int numberOfJumps = 0;
int numberOfWeaponsFired = 0;
int numberOfGrapplingHook = 0;
int numberOfTouches = 0;
int numberOfRetriesPerLevel = 0;
int numberOfSucessKnifes = 0;

NSDate *start;
NSTimeInterval timeInterval;
LogUtils *logUtils;
AudioUtils *audioUtils;

@implementation Level1
{
    //background
    CCSprite *_1plane;
    CCSprite *_2plane;
    CCSprite *_3plane;
    CCSprite *_1plane2;
    CCSprite *_2plane2;
    CCSprite *_3plane2;
    //physic world
    CCPhysicsNode *_physicsNode;
    
    //fix camera
    CCNode *_contentNode;
    
    //ninja
    Ninja *ninja;
    CCNode * ninjaCircle;
    CCNodeColor * overlayLayer;
    
    //botoes
    CCButton *knifeButton;
    CCButton *jumpButton;
    CCButton *resetButton;
    CCButton *grapplingHookButton;
    CCButton *retryButton;
    CCButton *startAgainButton;
    CCButton *nextButton;
    
    //scrore
    CCNodeColor *layerEnd;
    CCLabelTTF * textEnd;
    CCNode *star1;
    CCNode *star2;
    CCNode *star3;
    
    //dark souls
    CCNodeColor * overlayLayer2;
    CCLabelTTF * textMomentum;
    
    //pause
    CCSprite * pauseLayer;
    CCButton * pause;
    CCButton * pause_resume;
    CCButton * pause_menu;
    CCButton * pause_reset;
    
}

// default config
- (void)didLoadFromCCB
{
    [AudioUtils playLevel1Bg];
    
    // enable touch
    
    self.userInteractionEnabled = TRUE;
    //enable delegate colision
    _physicsNode.collisionDelegate = self;
    
    //enable ninja aim
    [self initNinja];
    
    [self enableAllButtons:false];
    
    retryButton.visible = false;
    startAgainButton.visible = false;
    startAgainButton.enabled = false;
    retryButton.enabled = false;
    
    //desactivar proximo nivel
    layerEnd.opacity = 0.0f;
    textEnd.opacity = 0.0f;
    
    resetButton.visible = false;
    nextButton.visible = false;
    
    star1.opacity = 0.0f;
    star2.opacity = 0.0f;
    star3.opacity = 0.0f;
    
    overlayLayer2.opacity = 0.0f;
    textMomentum.opacity = 0.0f;
    pauseLayer.opacity = 0.0f;
    
    //log
    start = [NSDate date];
    logUtils = [LogUtils sharedManager];
    audioUtils = [AudioUtils sharedManager];
    
    pause_resume. visible = false;
    pause_menu. visible = false;
    pause_reset. visible = false;
    
    //pauseLayer.opacity = 0;
    pauseLayer.visible = false;

}

- (void) update:(CCTime)delta
{
    //camera
    [self camera:ninja];
    
    //slow motion
    [self setupSlowMotion];

    //reposicionar mira ninja
    [ninja positionAimAt:ccp(0, 0)];
    
    //[self outsideRoom];
    //[_1plane runAction:[CCActionMoveBy actionWithDuration:delta position: ccp(-0.04f*ninja.physicsBody.velocity.x,0)]];
    [_2plane runAction:[CCActionMoveBy actionWithDuration:delta position: ccp(-0.02f*ninja.physicsBody.velocity.x,0)]];
    [_3plane runAction:[CCActionMoveBy actionWithDuration:delta position: ccp(-0.008f*ninja.physicsBody.velocity.x,0)]];
    //[_1plane2 runAction:[CCActionMoveBy actionWithDuration:delta position: ccp(-0.05f*ninja.physicsBody.velocity.x,0)]];
    [_2plane2 runAction:[CCActionMoveBy actionWithDuration:delta position: ccp(-0.02f*ninja.physicsBody.velocity.x,0)]];
    [_3plane2 runAction:[CCActionMoveBy actionWithDuration:delta position: ccp(-0.008f*ninja.physicsBody.velocity.x,0)]];
}

//----------------------------------------------------------------------------------------------------
//-------------------------------------------------TOUCH----------------------------------------------
//----------------------------------------------------------------------------------------------------

// called on every touch in this scene

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    //log
    numberOfTouches++;
    
    // NINJA
    if (CGRectContainsPoint([ninja boundingBox], touchLocation))
    {
        //acao default = salto
        if ([ninja action] == IDDLE && [ninja canJump]) {
            [ninja setAction:JUMP];
        }
        
        //activar mira
        if(([ninja action] != IDDLE && [ninja canJump]) || ([ninja canShoot])){
            [ninja enableAim:true];
            
            if(![ninja initialJump]){
                [AudioUtils stopEffects];
                [AudioUtils playSlowMotion];
                [self schedule:@selector(reduceCircle) interval:0.05 repeat:20 delay:0];
            }
        }
    }
    
    /*
    //vou ver se cliquei dentro GH
    else if(CGRectContainsPoint([_platformGH boundingBox],touchLocation))
    {
        if([ninja action] == GRAPPLING)
        {
            
            joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:ninja.physicsBody
                                                              bodyB:_platformGH.physicsBody
                                                            anchorA:ninja.anchorPointInPoints
                                                            anchorB:_platformGH.anchorPointInPoints];
            
            drawGrapplingHook = true;
            [self unschedule:@selector(reduceCircle)];
            [self resetCircle];
        }
    }
     
    //cliquei FORA
    else if([ninja action] == GRAPPLING)
    {
        drawGrapplingHook = false;
        [joint invalidate];
        joint = nil;
        [self enableGrapplingHookButton];
        [ninja setAction:IDDLE];
    }
     */

    else
    {
        [ninja setAction:IDDLE];
        [AudioUtils stopEffects];

    }
}

//update touch and rotation
- (void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if ([ninja action] == JUMP || [ninja action] == KNIFE)
    {
        //[ninja enableAim:true];
    
        //localizacao toque
        CGPoint touchLocation = [touch locationInNode:_contentNode];
        
        angleYY = clampf(touchLocation.y - (ninja.boundingBox.origin.y + ninja.boundingBox.size.height/2), -80, 80);
        angleXX = clampf(touchLocation.x - (ninja.boundingBox.origin.x + ninja.boundingBox.size.width/2), -10, 10);

        //actualizar angulo e escala mira
        [ninja updateAim:angleYY withScale:-angleXX/scaleAim];
    }
}

- (void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    //DESACTIVAR BUTOES / TEMPO
    if([ninja action] == KNIFE){
        //log
        numberOfWeaponsFired++;
        [self disableKnifeButton:YES];
        [AudioUtils playThrowKnife];
    }
    
    //else if([ninja action] == GRAPPLING)
      //  [self disableGrapplingButton];
    
    //fazer acao ninja
    [ninja action:_physicsNode withAngleX:angleXX withAngleY:angleYY];
    
    //apagar mira
    [ninja enableAim:false];
    
    [AudioUtils stopEffects];
    
    [self unschedule:@selector(reduceCircle)];
    [self resetCircle];
    
    //desactivar salto
    if(([ninja action] == JUMP) && [ninja canJump])
    {
        [ninja setCanJump:false];
        
        //activat butoes so uma vez
        if([ninja initialJump])
        {
            [self enableAllButtons:true];
            [ninja setInitialJump:false];
        }
    }
}

//----------------------------------------------------------------------------------------------------
//-------------------------------------------------NINJA INIT-----------------------------------------
//----------------------------------------------------------------------------------------------------
- (void) initNinja
{
    //init aim
    [ninja initAim:_physicsNode];
}

//----------------------------------------------------------------------------------------------------
//-------------------------------------------------CAMERA---------------------------------------------
//----------------------------------------------------------------------------------------------------
- (void) camera:(CCNode*) ninja
{
    self.position = ccp(0, 0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:ninja worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
}


//----------------------------------------------------------------------------------------------------
//-------------------------------------------------BUTTONS--------------------------------------------
//----------------------------------------------------------------------------------------------------

-(void) selectGrapplingHook
{
    //if([ninja action] == JUMP)
    [ninja setAction:GRAPPLING];
    
    if([ninja action] == KNIFE)
    {
        [self unschedule:@selector(reduceCircle)];
        [self resetCircle];
    }
    [AudioUtils stopEffects];
    [AudioUtils playSlowMotion];
    [self schedule:@selector(reduceCircle) interval:0.05 repeat:20 delay:0];
}

- (void) enableGrapplingHookButton
{
    grapplingHookButton.background.opacity = 0.8;
    grapplingHookButton.label.opacity = 0.8;
    grapplingHookButton.userInteractionEnabled = YES;
    
}

- (void) disableGrapplingButton
{
    grapplingHookButton.background.opacity = 0.2;
    grapplingHookButton.label.opacity = 0.2;
    grapplingHookButton.userInteractionEnabled = NO;
}

-(void) selectRetry
{
    [[CCDirector sharedDirector] resume];
    //log
    numberOfRetriesPerLevel ++;
    logUtils.totalRetries ++;
    
    retryButton.visible = false;
    startAgainButton.visible = false;
    startAgainButton.enabled = false;
    retryButton.enabled = false;
    
    pause.visible = true;
    //grapplingHookButton.visible = true;
    //knifeButton.visible = true;
    
    if(asRetryLocation)
    {
        [AudioUtils playLevel1Bg];
        ninja.positionInPoints = retryLocation;
        [ninja setCanJump:true];
        [ninja verticalJump];
    }
    else{
        [self selectReset];
    }
    
    
    numberTries1++;
    //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", numberTries1] forKey:@"triesLevel1"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
        
    overlayLayer2.opacity = 0.0f;
    textMomentum.opacity = 0.0f;
}

-(void) startAgainSelected
{
    [[CCDirector sharedDirector] resume];
    retryButton.visible = false;
    startAgainButton.visible = false;
    startAgainButton.enabled = false;
    retryButton.enabled = false;
    
    overlayLayer2.opacity = 0.0f;
    textMomentum.opacity = 0.0f;
    
    [self selectReset];
}

/*
 KNIFE
 */
-(void) selectKnife
{
    //fazer reset ao slow motion, caso tenho selecionado outra arma
    [ninja setAction:KNIFE];
    [AudioUtils stopEffects];
    [AudioUtils playSlowMotion];
    [self schedule:@selector(reduceCircle) interval:0.05 repeat:20 delay:0];
}

- (void) enableKnifeButton
{
    //parar tempo
    [self unschedule:_cmd];
    
    //activar
    knifeButton.background.opacity = 0.8;
    knifeButton.label.opacity = 0.8;
    knifeButton.userInteractionEnabled = YES;
}

- (void) disableKnifeButton:(BOOL)isTimer
{
    //disale button
    knifeButton.background.opacity = 0.2;
    knifeButton.label.opacity = 0.2;
    knifeButton.userInteractionEnabled = NO;
    
    if (isTimer) {
        //setup timer
        [self schedule:@selector(enableKnifeButton) interval:1.0];
    }
}


-(void) selectReset
{
    [[CCDirector sharedDirector] resume];
    
    /*
    if(joint != nil){
        [joint invalidate];
        joint = nil;
        
    }
     */
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/Level1"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    //reset variaveis
    enableSlowMotion=false;
    angleXX = 0.f, angleYY = 0.f;
    scaleAim = 5.0f;
    slowVelocity = 0.3f;
    ninjaCircleOpacity = 0.15f;
    overlayLayerOpacity = 0.3f;
    numberOfEnemies = 3;
    asRetryLocation = false;
    //drawGrapplingHook = false;
    //enteredWater = false;
    //collidedWithWaterEnd = false;
    
    numberTries1=0;
    
    //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", numberTries1] forKey:@"triesLevel1"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    overlayLayer2.opacity = 0.0f;
    textMomentum.opacity = 0.0f;
    
}
-(void) nextLevel
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/Level2"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    //reset variaveis
    enableSlowMotion=false;
    angleXX = 0.f, angleYY = 0.f;
    scaleAim = 5.0f;
    slowVelocity = 0.3f;
    ninjaCircleOpacity = 0.15f;
    overlayLayerOpacity = 0.3f;
    numberOfEnemies = 3;
    asRetryLocation = false;
    
    [[CCDirector sharedDirector] resume];
}

- (void) enableAllButtons:(BOOL)isEnable
{
    if(isEnable)
    {
        //disale button
        //[self enableGrapplingHookButton];
        [self enableKnifeButton];
    }
    else
    {
        [self disableKnifeButton:false];
        [self disableGrapplingButton];
    }
}

//----------------------------------------------------------------------------------------------------
//-------------------------------------------------COLISIONS------------------------------------------
//----------------------------------------------------------------------------------------------------
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair knife:(CCNode *)nodeA enemy:(CCNode *)nodeB
{
    [AudioUtils playKnifeStab];
    //matar inimigo
    [[_physicsNode space] addPostStepBlock:^{
        [self killNode:nodeB];
    } key:nodeB];
    
    //log
    numberOfSucessKnifes++;
    
    numberOfEnemies--;

    if (numberOfEnemies == 0){
        //log
        [AudioUtils stopEverything];
        [AudioUtils playLevelCompleteSoundEffect];
        
        timeInterval = fabs([start timeIntervalSinceNow]);
        [self writeToLog];
        
        //[self nextLevel];
        
        layerEnd.opacity = 1.0f;
        textEnd.opacity = 1.0f;
        resetButton.visible = true;
        nextButton.visible = true;
        
        pause.visible = false;
        grapplingHookButton.visible = false;
        knifeButton.visible = false;
        
        [[CCDirector sharedDirector] pause];
    }
}

//MORRER
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA ground:(CCNode *)nodeB
{
    [AudioUtils stopEverything];
    [AudioUtils playDeathSoundEffect];
    
    //log
    numberOfDeaths++;
    logUtils.totalDeaths++;
    
    retryButton.visible = true;
    startAgainButton.visible = true;
    retryButton.enabled = true;
    startAgainButton.enabled = true;

    textMomentum.opacity = 1.0f;
    overlayLayer2.opacity = 0.9f;
    
    pause.visible = false;
    grapplingHookButton.visible = false;
    knifeButton.visible = false;
    
    [[CCDirector sharedDirector] pause];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA enemy:(CCNode *)nodeB
{
    [AudioUtils stopEffects];
    //[AudioUtils playKnifeStab];
    

        numberOfJumps ++;
        retryLocation = nodeB.positionInPoints;
        CGPoint mult = ccp(1,1.2);
        retryLocation = ccpCompMult(retryLocation, mult);
        asRetryLocation = true;
        
        [self killNode:nodeB];// matar inimigo
        
        //ninja pode saltar
        [ninja setCanJump:true];
        [ninja verticalJump];
        
        numberOfEnemies--;
        if (numberOfEnemies == 0)
        {
            [AudioUtils stopEverything];
            [AudioUtils playLevelCompleteSoundEffect];
            pause.visible = false;
            grapplingHookButton.visible = false;
            knifeButton.visible = false;

            //log
            timeInterval = fabs([start timeIntervalSinceNow]);
            [self writeToLog];
            
            //salvar tries
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", numberTries1] forKey:@"triesLevel1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //acabei nivel
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"endedLevel1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //desbloquei proximo
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"unblockedLevel2"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //[self nextLevel];
            
            layerEnd.opacity = 1.0f;
            textEnd.opacity = 1.0f;
            resetButton.visible = true;
            nextButton.visible = true;
            
            [[CCDirector sharedDirector] pause];
            
            if(numberTries1 == 0)
            {
                star1.opacity = 1.0f;
                star2.opacity = 1.0f;
                star3.opacity = 1.0f;
            }
            else if(numberTries1 >= 1 && numberTries1 <=4)
            {
                star1.opacity = 1.0f;
                star2.opacity = 1.0f;
                star3.opacity = 0.0f;
            }
            else if(numberTries1 >= 5)
            {
                star1.opacity = 1.0f;
                star2.opacity = 0.0f;
                star3.opacity = 0.0f;
            }
        }
    
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(playSlowMotion)
                                   userInfo:nil
                                    repeats:NO];
    
        [self schedule:@selector(reduceCircle) interval:0.05 repeat:20 delay:0];
    
}

- (void) playSlowMotion{
    [AudioUtils playSlowMotion];
}

- (void) writeToLog{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"currentLog.txt"];
    NSString *finalFilePath = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString* deathNumberString = @"\n\nNumber of deaths in Level 1 = ";
    
    deathNumberString = [deathNumberString stringByAppendingString:[NSString stringWithFormat:@"%d", numberOfDeaths]];
    [LogUtils writeAtEndOfFile:deathNumberString withFilePath:finalFilePath];
    
    NSString* numberOfJumpsString = @"\nNumber of jumps in Level 1 = ";
    
    numberOfJumpsString = [numberOfJumpsString stringByAppendingString:[NSString stringWithFormat:@"%d", numberOfJumps]];
    [LogUtils writeAtEndOfFile:numberOfJumpsString withFilePath:finalFilePath];
    
    NSString* numberOfTouchesString = @"\nNumber of touches in Level 1 = ";
    
    numberOfTouchesString = [numberOfTouchesString stringByAppendingString:[NSString stringWithFormat:@"%d", numberOfTouches]];
    [LogUtils writeAtEndOfFile:numberOfTouchesString withFilePath:finalFilePath];
    
    NSString* numberOfRetriesString = @"\nNumber of retries in Level 1 = ";
    
    numberOfRetriesString = [numberOfRetriesString stringByAppendingString:[NSString stringWithFormat:@"%d", numberOfRetriesPerLevel]];
    [LogUtils writeAtEndOfFile:numberOfRetriesString withFilePath:finalFilePath];
    
    NSString* numberOfGrapplingString = @"\nNumber of Grappling Hook used in Level 1 = 0";
    [LogUtils writeAtEndOfFile:numberOfGrapplingString withFilePath:finalFilePath];
    
    NSString* numberOfWeaponsString = @"\nNumber of Knifes used in Level 1 = ";
    
    numberOfWeaponsString = [numberOfWeaponsString stringByAppendingString:[NSString stringWithFormat:@"%d", numberOfWeaponsFired]];
    [LogUtils writeAtEndOfFile:numberOfWeaponsString withFilePath:finalFilePath];
    
    NSString* timeString = @"\nTime to complete Level 1 in seconds = ";
    
    timeString = [timeString stringByAppendingString:[NSString stringWithFormat:@"%f", timeInterval]];
    [LogUtils writeAtEndOfFile:timeString withFilePath:finalFilePath];
    
    NSString* sucessKnifesString = @"\nSucess in using knife to kill enemy ";
    
    sucessKnifesString = [sucessKnifesString stringByAppendingString:[NSString stringWithFormat:@"%d", numberOfSucessKnifes]];
    sucessKnifesString = [sucessKnifesString stringByAppendingString:@" out of "];
    
    sucessKnifesString = [sucessKnifesString stringByAppendingString:[NSString stringWithFormat:@"%d", numberOfWeaponsFired]];
    
    [LogUtils writeAtEndOfFile:sucessKnifesString withFilePath:finalFilePath];

}

//matar inimigo
//matar water end
- (void)killNode:(CCNode *)enemy {
    [enemy removeFromParent];
}
//----------------------------------------------------------------------------------------------------
//---------------------------------------------SLOW MOTION--------------------------------------------
//----------------------------------------------------------------------------------------------------
-(void)setupSlowMotion
{
    if(enableSlowMotion)
    {
        [[[CCDirector sharedDirector] scheduler] setTimeScale:slowVelocity];
        ninjaCircle.opacity = ninjaCircleOpacity;
        overlayLayer.opacity = overlayLayerOpacity;
    } else {
        [[[CCDirector sharedDirector] scheduler] setTimeScale:1.0f];
        ninjaCircle.opacity = 0.0f;
        overlayLayer.opacity = 0.0f;
        radiusCircle = 0;
        
    }
    ninjaCircle.position = [_contentNode convertToWorldSpace:ninja.position];
}

-(void) reduceCircle
{
    if((radiusCircle%20 == 0 && radiusCircle!=0) || [ninja action] == IDDLE)
    {
        //parar tempo
        radiusCircle = 0;
        [self resetCircle];
        
    }
    else
    {
        ninjaCircle.scaleX -= 0.05f;
        ninjaCircle.scaleY -= 0.05f;
        
        radiusCircle++;
        
        enableSlowMotion = true;
    }
}

-(void) resetCircle
{
    //reset tamanho circulo volta ninja
    ninjaCircle.scaleX = 1.0f;
    ninjaCircle.scaleY = 1.0f;
    
    //parar slow motion
    enableSlowMotion = false;
    
    radiusCircle = 0;
    
    [self unschedule:_cmd];
}


//SAIR ECRA
-(void) outsideRoom
{
    if(ninja.position.x > [self contentSize].width || ninja.position.y > [self contentSize].height)
    {
        retryButton.visible = true;
        startAgainButton.visible = true;
        retryButton.enabled = true;
        startAgainButton.enabled = true;
        
        [[CCDirector sharedDirector] pause];
    }
}

//----------------------------------------------------------------------------------------------------
//---------------------------------------------PAUSE--------------------------------------------------
//----------------------------------------------------------------------------------------------------
-(void)pause_resume
{
    [[CCDirector sharedDirector] resume];
    overlayLayer.opacity = 0;
    pauseLayer.visible = false;
    pause.visible = true;
    
    pause_resume. visible = false;
    pause_menu. visible = false;
    pause_reset. visible = false;
    
    [self enableKnifeButton];
    [self enableGrapplingHookButton];
}

-(void)pause_reset
{
    [self selectReset];
}

-(void)pause_menu
{
    [self pause_resume];
    [self selectReset];
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void) pause
{
    [[CCDirector sharedDirector] pause];
    overlayLayer.opacity = 0.5f;
    pauseLayer.visible = true;
    pause.visible = false;
    
    pause_resume. visible = true;
    pause_menu. visible = true;
    pause_reset. visible = true;
    
    [self disableGrapplingButton];
    [self disableKnifeButton:false];
}


@end