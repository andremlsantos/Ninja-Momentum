//
//  LevelLater.m
//  NinjaMomentum
//
//  Created by Gonçalo Delgado on 12/05/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "LevelLater.h"
#import "Ninja.h"
#import "CCDirector_Private.h"
#import "CCPhysics+ObjectiveChipmunk.h"


//auxiliares slowmotion
bool enableSlowMotionL = false;
float slowVelocityL = 0.3f;
float ninjaCircleOpacityL = 0.15f;
float overlayLayerOpacityL = 0.3f;

int numberOfEnemiesL = 5;

//auxiliares mira
float angleXXL = 0.f, angleYYL = 0.f;
float scaleAimL = 5.0f;


//auxiliares grappling hook
bool drawGrapplingHookL = false;
int minDistanceToUseGrapplingL = 250;
int touchedPlatform;

@implementation LevelTest
{
    //physic world
    CCPhysicsNode *_physicsNode;
    
    //fix camera
    CCNode *_contentNode;
    
    //ninja
    Ninja *ninja;
    CCNode * ninjaCircle;
    CCNodeColor * overlayLayer;
    
    //graping hook
    CCNode *_platformGH;
   // CCNode *_platformGH2;
   // CCNode *_platformGH3;
    CCPhysicsJoint *joint;
    CCDrawNode *myDrawNode;
    
    //botoes
    CCButton *knifeButton;
    CCButton *jumpButton;
    CCButton *resetButton;
    CCButton *grapplingHookButton;
    
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
    
    myDrawNode = [CCDrawNode node];
    
    [self addChild: myDrawNode];
    
}

- (void) update:(CCTime)delta
{
    //camera
    [self camera:ninja];
    
    //slow motion
    [self setupSlowMotion];
    
    //reposicionar mira ninja
    [ninja positionAimAt:ccp(0, 0)];
    
    
    if(ccpDistance(ninja.positionInPoints, _platformGH.positionInPoints) < minDistanceToUseGrapplingL
    //   || ccpDistance(ninja.positionInPoints, _platformGH2.positionInPoints) < minDistanceToUseGrapplingL
    //   || ccpDistance(ninja.positionInPoints, _platformGH3.positionInPoints) < minDistanceToUseGrapplingL
       )
    {
        [self enableGrapplingHookButton];
    }
    else{
        [self disableGrapplingButton];
        
    }
    
    [myDrawNode clear];
    /*
    if (drawGrapplingHookL){
        if(touchedPlatform == 1){
            [myDrawNode drawSegmentFrom:[_contentNode convertToWorldSpace:ninja.positionInPoints] to:[_contentNode convertToWorldSpace:_platformGH.positionInPoints] radius:2.0f color:[CCColor colorWithRed:0 green:0 blue:0]];
        }
        else if(touchedPlatform == 2){
            [myDrawNode drawSegmentFrom:[_contentNode convertToWorldSpace:ninja.positionInPoints] to:[_contentNode convertToWorldSpace:_platformGH2.positionInPoints] radius:2.0f color:[CCColor colorWithRed:0 green:0 blue:0]];
        }
        else if(touchedPlatform == 3){
            [myDrawNode drawSegmentFrom:[_contentNode convertToWorldSpace:ninja.positionInPoints] to:[_contentNode convertToWorldSpace:_platformGH3.positionInPoints] radius:2.0f color:[CCColor colorWithRed:0 green:0 blue:0]];
        }*/
        
        
    //}
    
    if([ninja action] == GRAPPLING)
    {
        [self disableGrapplingButton];
        [self disableKnifeButtonWithTimer:true];
    }
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
        if ([ninja action] == IDDLE && [ninja canJump]) {
            [ninja setAction:JUMP];
        }
        
        //activar mira
        if(([ninja action] != IDDLE && [ninja canJump]) || ([ninja canShoot])){
            //[ninja enableAim:true];
            
            if(![ninja initialJump])
                [self schedule:@selector(reduceCircle) interval:0.05 repeat:20 delay:0];
        }
    }
    
    
    //vou ver se cliquei dentro GH
    else if(CGRectContainsPoint([_platformGH boundingBox],touchLocation))
    {
        if([ninja action] == GRAPPLING)
        {
            
            joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:ninja.physicsBody
                                                              bodyB:_platformGH.physicsBody
                                                            anchorA:ninja.anchorPointInPoints
                                                            anchorB:_platformGH.anchorPointInPoints];
            
            drawGrapplingHookL = true;
            [self unschedule:@selector(reduceCircle)];
            [self resetCircle];
            touchedPlatform = 1;
        }
    }
    /*
    else if(CGRectContainsPoint([_platformGH2 boundingBox],touchLocation))
    {
        if([ninja action] == GRAPPLING)
        {
            
            joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:ninja.physicsBody
                                                              bodyB:_platformGH2.physicsBody
                                                            anchorA:ninja.anchorPointInPoints
                                                            anchorB:_platformGH2.anchorPointInPoints];
            
            drawGrapplingHookL = true;
            [self unschedule:@selector(reduceCircle)];
            [self resetCircle];
            touchedPlatform = 2;
        }
    }
    
    else if(CGRectContainsPoint([_platformGH3 boundingBox],touchLocation))
    {
        if([ninja action] == GRAPPLING)
        {
            
            joint = [CCPhysicsJoint connectedDistanceJointWithBodyA:ninja.physicsBody
                                                              bodyB:_platformGH3.physicsBody
                                                            anchorA:ninja.anchorPointInPoints
                                                            anchorB:_platformGH3.anchorPointInPoints];
            
            drawGrapplingHookL = true;
            [self unschedule:@selector(reduceCircle)];
            [self resetCircle];
            touchedPlatform = 3;
        }
    }
    */
    
    //cliquei FORA
    else if([ninja action] == GRAPPLING)
    {
        drawGrapplingHookL = false;
        [joint invalidate];
        joint = nil;
        [self enableGrapplingHookButton];
        [ninja setAction:IDDLE];
    }
    
    
    else
    {
        [ninja setAction:IDDLE];
    }
}

//update touch and rotation
- (void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if ([ninja action] == JUMP || [ninja action] == KNIFE){
        
        [ninja enableAim:true];
        
        //localizacao toque
        CGPoint touchLocation = [touch locationInNode:_contentNode];
        
        angleYYL = clampf(touchLocation.y - (ninja.boundingBox.origin.y + ninja.boundingBox.size.height/2), -80, 80);
        angleXXL = clampf(touchLocation.x - (ninja.boundingBox.origin.x + ninja.boundingBox.size.width/2), -10, 10);
        
        //actualizar angulo e escala mira
        [ninja updateAim:angleYYL withScale:-angleXXL/scaleAimL];
    }
}

- (void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    //DESACTIVAR BUTOES / TEMPO
    if([ninja action] == KNIFE)
        [self disableKnifeButton:YES];
    
    else if([ninja action] == GRAPPLING)
        [self disableGrapplingButton];
    
    //fazer acao ninja
    [ninja action:_physicsNode withAngleX:angleXXL withAngleY:angleYYL];
    
    //apagar mira
    [ninja enableAim:false];
    
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
/*
 GH
 */
-(void) selectGrapplingHook
{
    //if([ninja action] == JUMP)
    [ninja setAction:GRAPPLING];
    
    if([ninja action] == KNIFE)
    {
        [self unschedule:@selector(reduceCircle)];
        [self resetCircle];
    }
    
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

/*
 KNIFE
 */
-(void) selectKnife
{
    //fazer reset ao slow motion, caso tenho selecionado outra arma
    
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

- (void) disableKnifeButtonWithTimer:(BOOL)isTimer
{
    //disale button
    knifeButton.background.opacity = 0.2;
    knifeButton.label.opacity = 0.2;
    knifeButton.userInteractionEnabled = NO;
    
    if (isTimer) {
        //setup timer
        [self schedule:@selector(enableKnifeButton) interval:0.01];
    }
}

-(void) selectReset
{
    
    if(joint != nil){
        [joint invalidate];
        joint = nil;
    }
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/LevelTest"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    //reset variaveis
    enableSlowMotionL=false;
    angleXXL = 0.f, angleYYL = 0.f;
    scaleAimL = 5.0f;
    slowVelocityL = 0.3f;
    ninjaCircleOpacityL = 0.15f;
    overlayLayerOpacityL = 0.3f;
    numberOfEnemiesL = 5;
    drawGrapplingHookL = false;
    //enteredWater = false;
    //collidedWithWaterEnd = false;
}
-(void) nextLevel
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/Level3"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    //reset variaveis
    enableSlowMotionL=false;
    angleXXL = 0.f, angleYYL = 0.f;
    scaleAimL = 5.0f;
    slowVelocityL = 0.3f;
    ninjaCircleOpacityL = 0.15f;
    overlayLayerOpacityL = 0.3f;
    numberOfEnemiesL = 5;
    drawGrapplingHookL = false;
}

- (void) enableAllButtons:(BOOL)isEnable
{
    if(isEnable)
    {
        //disale button
        [self enableGrapplingHookButton];
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
    //matar inimigo
    [[_physicsNode space] addPostStepBlock:^{
        [self killNode:nodeB];
    } key:nodeB];
    
    numberOfEnemiesL--;
    if (numberOfEnemiesL == 0){
        [self nextLevel];
    }
}

//MORRER
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA ground:(CCNode *)nodeB
{
    
    if(joint != nil){
        [joint invalidate];
        joint = nil;
        drawGrapplingHookL = false;
    }
    
    
    [self selectReset];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA enemy:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    
    // if energy is large enough, remove the seal
    if (energy > 5000.f) {
        [[_physicsNode space] addPostStepBlock:^{
            [self killNode:nodeB];
        } key:nodeB];
        
        //ninja pode saltar
        [ninja setCanJump:true];
        [ninja verticalJump];
        
        [self schedule:@selector(reduceCircle) interval:0.05 repeat:20 delay:0];
        
    }
    [self killNode:nodeB];
    
    numberOfEnemiesL--;
    if (numberOfEnemiesL == 0){
        [self nextLevel];
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
    if(enableSlowMotionL)
    {
        [[[CCDirector sharedDirector] scheduler] setTimeScale:slowVelocityL];
        ninjaCircle.opacity = ninjaCircleOpacityL;
        overlayLayer.opacity = overlayLayerOpacityL;
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
    
    if((i%20 == 0 && i!=0) || [ninja action] == IDDLE)
    {
        //parar tempo
        i = 0;
        [self resetCircle];
        
    }
    else
    {
        ninjaCircle.scaleX -= 0.05f;
        ninjaCircle.scaleY -= 0.05f;
        
        i++;
        
        enableSlowMotionL = true;
    }
}

-(void) resetCircle
{
    //reset tamanho circulo volta ninja
    ninjaCircle.scaleX = 1.0f;
    ninjaCircle.scaleY = 1.0f;
    
    //parar slow motion
    enableSlowMotionL = false;
    
    [self unschedule:_cmd];
}

@end
