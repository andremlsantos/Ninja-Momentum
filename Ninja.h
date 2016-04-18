//
//  Ninja.h
//  NinjaMomentum
//
//  Created by andre on 25/03/16.
//  Copyright © 2016 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Ninja : CCSprite

/*
 ACAO -1 - nada
 ACAO 0 - salto
 ACAO 1 - faca
 ACAO 2 - bomba
 */
@property int action;

@property bool canJump;


//ACOES
- (void) action:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY;
//acao 0
- (void) jump:(float)angleX withAngleY:(float)angleY;
//acao 1
- (void) shootKnife:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY;
//acao 2
- (void) shootBomb:(CCPhysicsNode *)physicsWorld withAngleX:(float)angleX withAngleY:(float)angleY;


/* 
 MIRA
 */
- (void) initAim:(CCPhysicsNode *)physicsWorld;
- (void) positionAimAt:(CGPoint) point;
- (void) updateAim:(float)rotation withScale:(float)scale;
- (void) resetAim;


@end
