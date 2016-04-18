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

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"ninja";
    
    //posso saltar inicialmente
    [self setCanJump:true];
    
    //sem acao inicial
    [self setAction:-1];
}

/*
 JUMP
 */
- (void) jump:(float)angleX withAngleY:(float)angleY
{
    if([self canJump])
    {
        //set force and direction
        CGPoint launchDirection = ccp(1, angleY/-90);
        CGPoint force = ccpMult(launchDirection, -angleX * 2100);
        [self.physicsBody applyForce:force];
        
        //[self setAction:-1];
    }
}


/*
 AIM
 */
- (void) initAim:(CCPhysicsNode *)physicsWorld
{
    aim = (Aim*)[CCBReader load:@"Aim"];
    aim.position = ccpAdd(self.position, ccp(10, 0));
    
    [physicsWorld addChild:aim];
    aim.visible = false;
}

- (void) positionAimAt:(CGPoint) point
{
    aim.visible = true;
    aim.position = ccpAdd(self.position, point);
}

- (void) updateAim:(float)rotation withScale:(float)scale
{
    aim.rotation = rotation;
    aim.scaleX = scale;
}

- (void) resetAim
{
    aim.visible = false;
    aim.rotation = 0;
}

/* 
 ACOES NINJA
 */
//recebe mundo fisico + força + angulo
- (void) action:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY
{
    //se for SALTO
    if([self action] == 0)
        [self jump:angleX withAngleY:angleY];
        
    //se for FACA
    else if([self action] == 1)
        [self shootKnife:physicsWorld withAngleX:angleX withAngleY:angleY];
    
    //se for BOMBA
    else if([self action] == 2)
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
    
    //set force and direction
    CGPoint launchDirection = ccp(1, angleY/-90);
    CGPoint force = ccpMult(launchDirection, -angleX * 200);
    [knife.physicsBody applyForce:force];
    
    [self setAction:-1];
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
    CGPoint force = ccpMult(launchDirection, -angleX * 200);
    [bomb.physicsBody applyForce:force];
    
    [self setAction:-1];
}

@end
