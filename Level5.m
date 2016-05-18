    //
//  Level5.m
//  NinjaMomentum
//
//  Created by andre on 18/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "Level5.h"
#import "Ninja.h"
#import "CCDirector_Private.h"
#import "CCPhysics+ObjectiveChipmunk.h"
//#import "LogUtils.h"

//auxiliares slowmotion
bool enableSlowMotion5 = false;
float slowVelocity5 = 0.3f;
float ninjaCircleOpacity5 = 0.15f;
float overlayLayerOpacity5 = 0.3f;

bool asRetryLocation5 = false;
int numberOfEnemies5 = 4;

//auxiliares mira
float angleXX5 = 0.f, angleYY5 = 0.f;
float scaleAim5 = 5.0f;

CGPoint retryLocation5;
bool isPaused5 = false;

//TRIES
int numberTries5 = 0;

//auxiliares grappling hook
bool drawGrapplingHook5 = false;
int minDistanceToUseGrappling5 = 250;
int touchedPlatform5;


@implementation Level5
{
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
    CCButton *bombButton;
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
    
    //graping hook
    //CCNode *_platformGH1;
    //CCNode *_platformGH2;
    //CCPhysicsJoint *joint;
    //CCDrawNode *myDrawNode;
}

// default config
- (void)didLoadFromCCB
{
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
    
    //corda
 //   myDrawNode = [CCDrawNode node];
 //   [self addChild: myDrawNode];
}

- (void) update:(CCTime)delta
{
    //camera
    [self camera:ninja];
    
    //slow motion
    [self setupSlowMotion];
    
    //reposicionar mira ninja
    [ninja positionAimAt:ccp(0, 0)];
    
    [self outsideRoom];
    
    /*
    if(ccpDistance(ninja.positionInPoints, _platformGH1.positionInPoints) < minDistanceToUseGrappling4 || ccpDistance(ninja.positionInPoints, _platformGH2.positionInPoints) <minDistanceToUseGrappling4 ){
        [self enableGrapplingHookButton];
    }
    else{
        [self disableGrapplingButton];
        
    }
    
    [myDrawNode clear];
    
    
     if (drawGrapplingHook2){
     if(touchedPlatform == 1){
     [myDrawNode drawSegmentFrom:[_contentNode convertToWorldSpace:ninja.positionInPoints] to:[_contentNode convertToWorldSpace:_platformGH1.positionInPoints] radius:2.0f color:[CCColor colorWithRed:0 green:0 blue:0]];
     }
     else if(touchedPlatform == 2){
     [myDrawNode drawSegmentFrom:[_contentNode convertToWorldSpace:ninja.positionInPoints] to:[_contentNode convertToWorldSpace:_platformGH2.positionInPoints] radius:2.0f color:[CCColor colorWithRed:0 green:0 blue:0]];
     }
     }
     */
}

//----------------------------------------------------------------------------------------------------
//-------------------------------------------------TOUCH----------------------------------------------
//----------------------------------------------------------------------------------------------------

// called on every touch in this scene

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    // NINJA
    if (CGRectContainsPoint([ninja boundingBox], touchLocation))
    {
        //acao default = salto
        if (([ninja action] == IDDLE && [ninja canJump]) || ([ninja action] == -1 && [ninja canJump])) {
            
            [ninja setAction:JUMP];
            
            
            
        }
        
        //activar mira
        if(([ninja action] != IDDLE && [ninja canJump]) || ([ninja canShoot])){
            [ninja enableAim:true];
            
            if(![ninja initialJump])
                [self schedule:@selector(reduceCircle) interval:0.05 repeat:20 delay:0];
        }
    }
    /*
    //vou ver se cliquei dentro GH
    else if(CGRectContainsPoint([_platformGH1 boundingBox],touchLocation))
    {
        if([ninja action] == GRAPPLING)
        {
            
            joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:ninja.physicsBody
                                                              bodyB:_platformGH1.physicsBody
                                                            anchorA:ninja.anchorPointInPoints
                                                            anchorB:_platformGH1.anchorPointInPoints];
            
            drawGrapplingHook5 = true;
            [self unschedule:@selector(reduceCircle)];
            [self resetCircle];
            touchedPlatform5 = 1;
        }
    }
    
    else if(CGRectContainsPoint([_platformGH2 boundingBox],touchLocation))
    {
        if([ninja action] == GRAPPLING)
        {
            
            joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:ninja.physicsBody
                                                              bodyB:_platformGH2.physicsBody
                                                            anchorA:ninja.anchorPointInPoints
                                                            anchorB:_platformGH2.anchorPointInPoints];
            
            drawGrapplingHook4 = true;
            [self unschedule:@selector(reduceCircle)];
            [self resetCircle];
            touchedPlatform4 = 2;
        }
    }
    else if([ninja action] == GRAPPLING)
    {
        drawGrapplingHook4 = false;
        [joint invalidate];
        joint = nil;
        [self enableGrapplingHookButton];
        [ninja setAction:IDDLE];
        //[self unschedule:@selector(reduceCircle)];
        //[self resetCircle];
    }
    */
    else
    {
        [ninja setAction:IDDLE];
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
        
        angleYY5 = clampf(touchLocation.y - (ninja.boundingBox.origin.y + ninja.boundingBox.size.height/2), -80, 80);
        angleXX5 = clampf(touchLocation.x - (ninja.boundingBox.origin.x + ninja.boundingBox.size.width/2), -10, 10);
        
        //actualizar angulo e escala mira
        [ninja updateAim:angleYY5 withScale:-angleXX5/scaleAim5];
    }
}

- (void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    //DESACTIVAR BUTOES / TEMPO
    if([ninja action] == KNIFE)
        [self disableKnifeButton:YES];
    
    else if([ninja action] == BOMB)
        [self disableBombButton:YES];
    
    else if([ninja action] == GRAPPLING)
    {
        //CCLOG(@"disable GH");
        
        [self disableGrapplingButton];
        
        //CCLOG(@"desactivar circulo");
        
        [self unschedule:@selector(reduceCircle)];
        [self resetCircle];
    }
    
    [self unschedule:@selector(reduceCircle)];
    [self resetCircle];
    
    //fazer acao ninja
    [ninja action:_physicsNode withAngleX:angleXX5 withAngleY:angleYY5];
    
    //apagar mira
    [ninja enableAim:false];
    
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
    
    if([ninja action] == BOMB || [ninja action] == KNIFE)
    {
        //[self unschedule:@selector(reduceCircle)];
        //[self resetCircle];
    }
    
    if(!enableSlowMotion5)
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
    retryButton.visible = false;
    startAgainButton.visible = false;
    startAgainButton.enabled = false;
    retryButton.enabled = false;
    
    if(asRetryLocation5)
    {
        ninja.positionInPoints = retryLocation5;
        [ninja setCanJump:true];
        [ninja verticalJump];
    }
    else{
        [self selectReset];
    }
    
    
    numberTries5++;
    //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", numberTries] forKey:@"triesLevel1"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    CCLOG(@"tries %d", numberTries5);
    
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
    if([ninja action] == BOMB)
    {
        [self unschedule:@selector(reduceCircle)];
        [self resetCircle];
    }
    
    [ninja setAction:KNIFE];
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

/*
 BOMB
 */
-(void) selectBomb
{
    //fazer reset ao slow motion, caso tenho selecionado outra arma
    if([ninja action] == KNIFE)
    {
        [self unschedule:@selector(reduceCircle)];
        [self resetCircle];
    }
    
    [ninja setAction:BOMB];
    [self schedule:@selector(reduceCircle) interval:0.05 repeat:20 delay:0];
}

- (void) enableBombButton
{
    //parar tempo
    [self unschedule:_cmd];
    
    //activar
    bombButton.background.opacity = 0.8;
    bombButton.label.opacity = 0.8;
    bombButton.userInteractionEnabled = YES;
}

- (void) disableBombButton:(BOOL)isTimer
{
    //disale button
    bombButton.background.opacity = 0.2;
    bombButton.label.opacity = 0.2;
    bombButton.userInteractionEnabled = NO;
    
    if (isTimer ) {
        //setup timer
        [self schedule:@selector(enableBombButton) interval:1.0];
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
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/Level5"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    //reset variaveis
    enableSlowMotion5=false;
    angleXX5 = 0.f, angleYY5 = 0.f;
    scaleAim5= 5.0f;
    slowVelocity5 = 0.3f;
    ninjaCircleOpacity5 = 0.15f;
    overlayLayerOpacity5 = 0.3f;
    numberOfEnemies5 = 4;
    asRetryLocation5 = false;
    //drawGrapplingHook = false;
    //enteredWater = false;
    //collidedWithWaterEnd = false;
    
    numberTries5=0;
    
    //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", numberTries] forKey:@"triesLevel1"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    overlayLayer2.opacity = 0.0f;
    textMomentum.opacity = 0.0f;
    
    CCLOG(@"tries %d", numberTries5);
}
-(void) nextLevel
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/Level6"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    //reset variaveis
    enableSlowMotion5=false;
    angleXX5 = 0.f, angleYY5 = 0.f;
    scaleAim5 = 5.0f;
    slowVelocity5 = 0.3f;
    ninjaCircleOpacity5 = 0.15f;
    overlayLayerOpacity5 = 0.3f;
    numberOfEnemies5 = 4;
    asRetryLocation5 = false;
    
    [[CCDirector sharedDirector] resume];
}

- (void) enableAllButtons:(BOOL)isEnable
{
    if(isEnable)
    {
        //disale button
        [self enableBombButton];
        //[self enableGrapplingHookButton];
        [self enableKnifeButton];
    }
    else
    {
        [self disableKnifeButton:false];
        [self disableBombButton:false];
        [self disableGrapplingButton];
    }
}

//----------------------------------------------------------------------------------------------------
//-------------------------------------------------COLISIONS------------------------------------------
//----------------------------------------------------------------------------------------------------
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair knife:(CCNode *)nodeA enemy:(CCNode *)nodeB
{
    //matar inimigo
    [[_physicsNode space] addPostStepBlock:^{
        [self killNode:nodeB];
    } key:nodeB];
    
    numberOfEnemies5--;
    if (numberOfEnemies5 == 0){
        //[self nextLevel];
        
        layerEnd.opacity = 1.0f;
        textEnd.opacity = 1.0f;
        resetButton.visible = true;
        nextButton.visible = true;
        
        [[CCDirector sharedDirector] pause];
    }
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair bomb:(CCNode *)nodeA enemy:(CCNode *)nodeB
{
    //matar inimigo
    [[_physicsNode space] addPostStepBlock:^{
        [self killNode:nodeB];
        [self killNode:nodeA];
    } key:nodeB];
}

//MORRER
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA ground:(CCNode *)nodeB
{
    
    retryButton.visible = true;
    startAgainButton.visible = true;
    retryButton.enabled = true;
    startAgainButton.enabled = true;
    
    textMomentum.opacity = 1.0f;
    overlayLayer2.opacity = 0.9f;
    
    [[CCDirector sharedDirector] pause];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA enemy:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    
    CCLOG(@"energia %lf", energy);
    
    if (energy > 5000.0f) {
        retryLocation5 = nodeB.positionInPoints;
        CGPoint mult = ccp(1,1.5);
        retryLocation5 = ccpCompMult(retryLocation5, mult);
        asRetryLocation5 = true;
        
        [self killNode:nodeB];// matar inimigo
        
        //ninja pode saltar
        [ninja setCanJump:true];
        [ninja verticalJump];
        
        numberOfEnemies5--;
        if (numberOfEnemies5 == 0)
        {
            //salvar tries
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", numberTries5] forKey:@"triesLevel5"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //acabei nivel
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"endedLevel5"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //desbloquei proximo
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"unblockedLevel6"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            CCLOG(@"tries %d", numberTries5);
            
            //[self nextLevel];
            
            layerEnd.opacity = 1.0f;
            textEnd.opacity = 1.0f;
            resetButton.visible = true;
            nextButton.visible = true;
            
            [[CCDirector sharedDirector] pause];
            
            if(numberTries5 == 0)
            {
                star1.opacity = 1.0f;
                star2.opacity = 1.0f;
                star3.opacity = 1.0f;
            }
            else if(numberTries5 >= 1 && numberTries5 <=4)
            {
                star1.opacity = 1.0f;
                star2.opacity = 1.0f;
                star3.opacity = 0.0f;
            }
            else if(numberTries5 >= 5)
            {
                star1.opacity = 1.0f;
                star2.opacity = 0.0f;
                star3.opacity = 0.0f;
            }
        }
        
        // CCLOG(@"açao ninja %d", [ninja action]);
        [ninja setAction:-1];
        
        [self schedule:@selector(reduceCircle) interval:0.05 repeat:20 delay:0];
    }
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
    if(enableSlowMotion5)
    {
        [[[CCDirector sharedDirector] scheduler] setTimeScale:slowVelocity5];
        ninjaCircle.opacity = ninjaCircleOpacity5;
        overlayLayer.opacity = overlayLayerOpacity5;
    } else {
        [[[CCDirector sharedDirector] scheduler] setTimeScale:1.0f];
        ninjaCircle.opacity = 0.0f;
        overlayLayer.opacity = 0.0f;
        
    }
    ninjaCircle.position = [_contentNode convertToWorldSpace:ninja.position];
}

-(void) reduceCircle
{
    static int i=0;
    
    // CCLOG(@"dentro %d", i);
    
    
    
    if((i%20 == 0 && i!=0)
       || [ninja action] == IDDLE
       )
    {
        // CCLOG(@"reset circle");
        
        //parar tempo
        i = 0;
        [self resetCircle];
        
    }
    else
    {
        ninjaCircle.scaleX -= 0.05f;
        ninjaCircle.scaleY -= 0.05f;
        
        i++;
        
        enableSlowMotion5 = true;
    }
}

-(void) resetCircle
{
    //reset tamanho circulo volta ninja
    ninjaCircle.scaleX = 1.0f;
    ninjaCircle.scaleY = 1.0f;
    
    //parar slow motion
    enableSlowMotion5 = false;
    
    [self unschedule:_cmd];
}


//SAIR ECRA
-(void) outsideRoom
{
    if(ninja.position.x > [self contentSize].width || ninja.position.y > [self contentSize].height)
    {
        //CCLOG(@"ninja fora bounds");
        
        retryButton.visible = true;
        startAgainButton.visible = true;
        retryButton.enabled = true;
        startAgainButton.enabled = true;
        
        [[CCDirector sharedDirector] pause];
    }
}

@end
