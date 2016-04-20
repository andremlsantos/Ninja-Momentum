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

//auxiliares slowmotion
bool enableSlowMotion=false;

//auxiliares mira
float angleXX = 0.f, angleYY = 0.f;
float multForce = 200.0f;
float scaleAim = 5.0f;

//auxiliares slow motiom
float slowVelocity = 0.0f;
float ninjaCircleOpacity = 0.15f;
float overlayLayerOpacity = 0.3f;

@implementation Level1
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
}

- (void) update:(CCTime)delta
{
    //camera
    [self camera:ninja];
    
    //estado buttoes
    [self updateButtons];
    
    //slow motion
    [self setupSlowMotion];
}


/*
 TOUCH
 */
// called on every touch in this scene
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    //localizacao touch
    CGPoint touchLocation = [touch locationInNode:_contentNode];
        
    // vou ver se cliquei dentro ninja
    if (CGRectContainsPoint([ninja boundingBox], touchLocation))
    {
        //acao default = salto
        if ([ninja action] == IDDLE && [ninja canJump]) {
            [ninja setAction:JUMP];
        }
        
        //activar mira
        if([ninja action] != IDDLE && [ninja canJump]){
            [ninja positionAimAt:ccp(10, 0)];
            enableSlowMotion = true;
        }
        
        //activar mira
        if([ninja action] > 0)
        {
            [ninja positionAimAt:ccp(0, 0)];
            enableSlowMotion = true;
        }
        
    }
    else {
    	[ninja resetAim];
        [ninja setAction:IDDLE];
    }
}

//update touch and rotation
- (void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    //localizacao toque
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    angleYY = clampf(touchLocation.y - (ninja.boundingBox.origin.y + ninja.boundingBox.size.height/2), -40, 40);
    angleXX = clampf(touchLocation.x - (ninja.boundingBox.origin.x + ninja.boundingBox.size.width/2), -10, 10);
    
    [ninja updateAim:angleYY withScale:-angleXX/scaleAim];
}

- (void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    //desactivar slowmotion
    if([ninja action]>=0)
        enableSlowMotion = false;
    
    //fazer acao ninja
    [ninja action:_physicsNode withAngleX:angleXX withAngleY:angleYY];
    
    //apagar mira
    [ninja resetAim];
    
    //desactivar salto
    if([ninja action] == JUMP && [ninja canJump])
        [ninja setCanJump:false];
}

/*
 NINJA
 */
- (void) initNinja
{
    //init aim
    [ninja initAim:_physicsNode];
}

/*
 CAMERA
 */
- (void) camera:(CCNode*) ninja
{
    self.position = ccp(0, 0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:ninja worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
}

/*
 BUTTONS
 */
-(void) selectKnife
{
    [ninja setAction:KNIFE];
}

-(void) selectBomb
{
    [ninja setAction:BOMB];
}

-(void) selectReset
{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Levels/Level1"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

// ENABLE/DISABLE buttons
-(void) updateButtons
{
    
    if([ninja canJump])
    {
        knifeButton.background.opacity = 0.2;
        knifeButton.label.opacity = 0.2;
        knifeButton.userInteractionEnabled = NO;
        
        bombButton.background.opacity = 0.2;
        bombButton.label.opacity = 0.2;
        bombButton.userInteractionEnabled = NO;
        
        jumpButton.background.opacity = 0.2;
        jumpButton.label.opacity = 0.2;
        jumpButton.userInteractionEnabled=NO;
    }
    else {
        knifeButton.background.opacity = 0.8;
        knifeButton.label.opacity = 0.8;
        knifeButton.userInteractionEnabled = YES;
        
        bombButton.background.opacity = 0.8;
        bombButton.label.opacity = 0.8;
        bombButton.userInteractionEnabled = YES;
        
        jumpButton.background.opacity = 0.8;
        jumpButton.label.opacity = 0.8;
        jumpButton.userInteractionEnabled = YES;
    }
}


/*
 COLISIONS
 */
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair knife:(CCNode *)nodeA enemy:(CCNode *)nodeB
{
    [[_physicsNode space] addPostStepBlock:^{
        [self killEnemy:nodeB];
    } key:nodeB];
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA ground:(CCNode *)nodeB
{
    ninja.physicsBody.velocity= ccp(0, 0);
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA enemy:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    
    // if energy is large enough, remove the seal
    if (energy > 5000.f) {
        [[_physicsNode space] addPostStepBlock:^{
            [self killEnemy:nodeB];
        } key:nodeB];
        
        //ninja pode saltar
        [ninja setCanJump:true];
        [ninja verticalJump:0 withforceY:300];
    }
    [self killEnemy:nodeB];
}

//matar inimigo
- (void)killEnemy:(CCNode *)enemy {
    //remover pai
    [enemy removeFromParent];
}


/*
 SLOW MOTION
 */
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
    }
    ninjaCircle.position = [_contentNode convertToWorldSpace:ninja.position];
}

@end
