//
//  PlayerDrac.m
//  Drac
//
//  Created by LUCAS SOTIN PLACHI ANDELOCI on 10/06/14.
//  Copyright (c) 2014 ROGERIO ALVES SOBRINHO. All rights reserved.
//

#import "PlayerDrac.h"
#import <SpriteKit/SpriteKit.h>


@implementation PlayerDrac

//Criar o Sprite do dragao
dragao = [SKSpriteNode spriteNodeWithImageNamed:@"Dragao.png"];

//Criar corpo fisico
dragao.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.dragaoDrac.size.width / 2];

// Nao permite o corpo fisico movimentar a Sprite
dragao.physicsBody.dynamic = NO;

// Faz o corpo ser afetado pela gravidade
dragao.physicsBody.affectedByGravity = YES;



@end
