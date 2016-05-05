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
    jumpForce = 2200;
    verticalJumpForce = 300;
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
        
        if(angleX  < 0)
        {
            launchDirection = ccp(1, angleY/-90);
            force = ccpMult(launchDirection, -angleX * jumpForce);
        }
        else
        {
            launchDirection = ccp(1, angleY/90);
            force = ccpMult(launchDirection, -angleX * jumpForce);
        }
        
        [self.physicsBody applyForce:force];
        [self performSelector:@selector(startJumpAnimation) withObject:nil afterDelay:0.0f];
    }
}

/*
- (void) jumpInWater:(float)angleX withAngleY:(float)angleY withPower:(float)power
{
    if([self canJump])
    {
        //set force and direction
        CGPoint launchDirection = ccp(0.5, angleY/-90);
        CGPoint force = ccpMult(launchDirection, -angleX * waterJumpForce);
        [self.physicsBody applyForce:force];
    }
}
 */

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
        [currentNode setColor:[CCColor colorWithRed:0 green:200 blue:0]];
    }
}

- (void) positionAimAt:(CGPoint) point
{
    aim.position = ccpAdd(self.position, point);
}

- (void) updateAim:(float)rotation withScale:(float)scale
{
    if(scale > 0)
        aim.rotation = rotation;
    else
        aim.rotation = -rotation;
    
    aim.scaleX = scale/2;
    
    float redComponent = scale;
    float greenComponent = 1/scale;
    
    for (CCNode* currentNode in aim.children)
    {
        [currentNode setColor:[CCColor colorWithRed:redComponent green:greenComponent blue:0]];
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
    //se for SALTO
    if([self action] == JUMP)
        [self jump:angleX withAngleY:angleY];
        
    //se for FACA
    else if([self action] == KNIFE)
        [self shootKnife:physicsWorld withAngleX:angleX withAngleY:angleY];
    
    //se for BOMBA
    else if([self action] == BOMB)
        [self shootBomb:physicsWorld withAngleX:angleX withAngleY:angleY];
    
    /*
    //se aterrar na WATER
    else if([self action] == WATER)
        [self pushNinjaInWater:physicsWorld];
    
    //se quero saltar agua
    else if ([self action] == JUMPONWATER){
        [self jumpInWater: angleX withAngleY:angleY withPower: self.physicsBody.velocity.x];
    }
     */

}

/*
//recebe mundo fisico
- (void) pushNinjaInWater:(CCPhysicsNode *)physicsWorld
{
    [self.physicsBody applyImpulse:ccp(20, 0)];
}
 */


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
    
    //set force and direction
    CGPoint launchDirection = ccp(1, angleY/-90);
    CGPoint force = ccpMult(launchDirection, -angleX * knifeForce);
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
