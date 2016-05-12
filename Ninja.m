//
//  Ninja.m
//  NinjaMomentum
//
//  Created by andre on 25/03/16.
//  Copyright © 2016 Apportable. All rights reserved.
//
#import "Ninja.h"
#import "Knife.h"
#import "Bomb.h"
#import "Aim.h"

@implementation Ninja
{
    Aim *aim;
}

//arma usada
@synthesize action = _action;

//pode saltar
@synthesize canJump = _canJump;

//bloquear armas no inicio
@synthesize initialJump = _initialJump;

//FORCES
@synthesize jumpForce;
@synthesize verticalJumpForce;
@synthesize waterJumpForce;
@synthesize knifeForce;
@synthesize waterForce;

float oldScale = 0.0f;

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"ninja";
    
    //posso saltar inicialmente
    [self setCanJump:true];
    
    //sem acao inicial
    [self setAction:IDDLE];
    
    //block weapons
    [self setInitialJump:true];
    
    
    //RESET FORCES
    jumpForce = 1500;
    verticalJumpForce = 200;
    waterForce = 50;
    waterJumpForce = 3000;
    knifeForce = 200;
    
  
}

/*
 JUMP
 */
- (void) jump:(float)angleX withAngleY:(float)angleY
{
    if([self canJump])
    {
        //set force and direction
        CGPoint launchDirection;
        CGPoint force;
        

        if(angleY < 0){
            launchDirection = ccp(cosf(GLKMathDegreesToRadians(-angleY)),sinf(GLKMathDegreesToRadians(-angleY)));
        }
        else{
            launchDirection = ccp(cosf(GLKMathDegreesToRadians(angleY)),sinf(GLKMathDegreesToRadians(angleY)));
        }
        
        if(angleX > 0)
            launchDirection.x = -launchDirection.x;
        
        if (angleY > 0)
            launchDirection.y = -launchDirection.y;
        
        force = ccpMult(launchDirection, fabsf(angleX) * jumpForce);
        [self.physicsBody applyForce:force];
        [self performSelector:@selector(startJumpAnimation) withObject:nil afterDelay:0.0f];
    }
}


- (void) verticalJump
{
    if([self canJump])
    {
        //cancelar velocidade actual
        self.physicsBody.velocity = ccp(0, 0);
        
        //adicionar impulso
        [self.physicsBody applyImpulse:ccp(0, verticalJumpForce)];
    }
}

/*
 AIM
 */
- (void) initAim:(CCPhysicsNode *)physicsWorld
{
    aim = (Aim*)[CCBReader load:@"Aim"];
    aim.position = ccpMult(self.position, 3);
    
    [physicsWorld addChild:aim];
    aim.visible = false;
    aim.scaleX = 0.1;
    for (CCNode* currentNode in aim.children)
    {
        [currentNode setColor:[CCColor colorWithRed:0.0 green:0.9 blue:0.0]];
    }
}

- (void) positionAimAt:(CGPoint) point
{
    aim.position = ccpAdd(self.position, point);
}

- (void) updateAim:(float)rotation withScale:(float)scale
{
    aim.scaleX = scale/2;
    
    if(scale > 0)
        aim.rotation = rotation;
    else{
        aim.rotation = -rotation;
        scale = scale * -1.0f;//color correction
    }
    for (CCNode* currentNode in aim.children)
    {
        [currentNode setColor:[CCColor colorWithRed:scale green:0.5/scale blue:0]];
    }
}

- (void) enableAim:(BOOL) value
{
    aim.visible = value;
    aim.rotation = 0;
}

//- (void) resetAim
//{
    //aim.visible = false;
    //aim.rotation = 0;
//}

/* 
 ACOES NINJA
 */
//recebe mundo fisico + força + angulo
- (void) action:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY
{
    CCLOG(@"ACTION !!! %d", [self action]);
    //se for SALTO
    if([self action] == JUMP)
        [self jump:angleX withAngleY:angleY];
        
    //se for FACA
    else if([self action] == KNIFE)
        [self shootKnife:physicsWorld withAngleX:angleX withAngleY:angleY];
    
    //se for BOMBA
    else if([self action] == BOMB)
        [self shootBomb:physicsWorld withAngleX:angleX withAngleY:angleY];

}

//recebe mundo fisico + força + angulo
- (void) shootKnife:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY
{
    //init knife
    Knife *knife = (Knife*)[CCBReader load:@"Weapons/Knife"];
    
    if(angleX>0)
    {
        knife.position = ccpAdd(self.position, ccp(-20, 5));
    } else {
        knife.position = ccpAdd(self.position, ccp(20, 5));
    }
    
    //add to physic world
    [physicsWorld addChild:knife];
    CGPoint launchDirection;
    
    if(angleY < 0){
        launchDirection = ccp(cosf(GLKMathDegreesToRadians(-angleY)),sinf(GLKMathDegreesToRadians(-angleY)));
    }
    else{
        launchDirection = ccp(cosf(GLKMathDegreesToRadians(angleY)),sinf(GLKMathDegreesToRadians(angleY)));
    }
    
    if(angleX > 0)
        launchDirection.x = -launchDirection.x;
    
    if (angleY > 0)
        launchDirection.y = -launchDirection.y;
    
    CGPoint force = ccpMult(launchDirection, fabsf(angleX) * knifeForce);
    [knife.physicsBody applyForce:force];
    
    [self setAction:IDDLE];
}

//recebe mundo fisico + força + angulo
- (void) shootBomb:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY
{
    //init bomb
    Bomb *bomb = (Bomb*)[CCBReader load:@"Weapons/Bomb"];
    
    if(angleX>0)
    {
        bomb.position = ccpAdd(self.position, ccp(-20, 5));
    } else {
        bomb.position = ccpAdd(self.position, ccp(20, 5));
    }
    
    //add to physic world
    [physicsWorld addChild:bomb];
    
    //set force and direction
    CGPoint launchDirection = ccp(1, angleY/-90);
    CGPoint force = ccpMult(launchDirection, -angleX * knifeForce);
    [bomb.physicsBody applyForce:force];
    
    [self setAction:IDDLE];
}

- (bool) canShoot
{
    if([self action]==KNIFE || [self action]==BOMB)
    {
        return true;
    }
    return false;
}
- (void)startJumpAnimation{
    CCAnimationManager* animationManager = self.animationManager;
    
    [animationManager runAnimationsForSequenceNamed:@"Jump"];
}
- (void)idleAnimation{
    CCAnimationManager* animationManager = self.animationManager;
    
    [animationManager runAnimationsForSequenceNamed:@"Idle"];
}
@end
