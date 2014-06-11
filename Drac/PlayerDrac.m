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

-(id)init{
    
    self = [super init];
    if(self){
        
        
        //Criar o Sprite do dragao
        self.dragao = [SKSpriteNode spriteNodeWithImageNamed:@"Dragao.png"];
        
        
        
        //Criar corpo fisico
        self.dragao.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.dragao.size.width / 2];
        
        // Nao permite o corpo fisico movimentar a Sprite
        self.dragao.physicsBody.dynamic = NO;
        
        // Faz o corpo ser afetado pela gravidade
        self.dragao.physicsBody.affectedByGravity = YES;
    
        
            }
    
    return self;
}


@end
