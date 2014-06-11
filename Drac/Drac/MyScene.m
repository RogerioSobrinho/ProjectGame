//
//  MyScene.m
//  Drac
//
//  Created by ROGERIO ALVES SOBRINHO on 10/06/14.
//  Copyright (c) 2014 ROGERIO ALVES SOBRINHO. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        

        //Criar o Sprite do dragao
        self.dragao = [SKSpriteNode spriteNodeWithImageNamed:@"Dragao.png"];
        
        //Criar corpo fisico
        self.dragao.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.dragao.size.width / 2];
        
        // Nao permite o corpo fisico movimentar a Sprite
        self.dragao.physicsBody.dynamic = NO;
        
        // Faz o corpo ser afetado pela gravidade
        self.dragao.physicsBody.affectedByGravity = YES;
        
        //Para o corpo nao girar
        self.dragao.physicsBody.allowsRotation = NO;
        self.dragao.physicsBody.density = 0.65f;
        
   
        [self addChild:self.dragao];
        
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
