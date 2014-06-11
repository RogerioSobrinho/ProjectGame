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
        
 
        
        //Criar fundo de tela
        self.fundo = [SKSpriteNode spriteNodeWithImageNamed:@"613354.png"];
        
        //Coloca -15 para a sprite ficar no fundo
        self.fundo.zPosition = -15;
        self.fundo.position = CGPointMake(self.size.width/3, self.size.height/3);
        
        //adicionar fundo
        [self addChild:self.fundo];
        
        
        
        //criar frames do dragao
        self.dragaoFrames = [self carregarSprites:@"essa.fw.png"withNumberOfSprites:8 withNumberOfRows:2 withNumberOfSpritesPerRow:4];
        
        [self.dragao setSize:CGSizeMake(50, 49)];
        
        self.dragao.xScale =-self.dragao.xScale;
        
        
        //Criar o Sprite do dragao
        self.dragao = [SKSpriteNode spriteNodeWithImageNamed:@"essa.fw.png"];

        
        //Posicionamento do dragao na tela(no jogo)
        self.dragao.position = CGPointMake(self.size.width / 3, self.size.height / 2);
        self.dragao.zRotation = 0;
        
        
        //Criacao da Animacao
        SKAction *dragaoAnimado = [SKAction animateWithTextures:self.dragaoFrames timePerFrame:0.05f];
        
        //Animacao
        [self.dragao runAction:[SKAction repeatActionForever:dragaoAnimado]];
        
        
        
        //Criar corpo fisico
        self.dragao.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.dragao.size.width/2];
        
        // Nao permite o corpo fisico movimentar a Sprite
        self.dragao.physicsBody.dynamic = NO;
        
        // Faz o corpo ser afetado pela gravidade
        self.dragao.physicsBody.affectedByGravity = YES;
        
        //Para o corpo nao girar
        self.dragao.physicsBody.allowsRotation = NO;
        self.dragao.physicsBody.density = 0.65f;
        
        //Elasticidade do corpo
        self.dragao.physicsBody.restitution = 1;
        
    
        //adicionar o dragao na tela
        [self addChild:self.dragao];
        
    }
    return self;
}


-(NSMutableArray*) carregarSprites:nome withNumberOfSprites:(int)numSprites withNumberOfRows:(int) numRows withNumberOfSpritesPerRow:(int) numSpritesPerRow{
    
    //Armazena frames das magens
    NSMutableArray *animacao = [NSMutableArray array];
    
    
    //Carrega a imagem principal
    SKTexture* textura = [SKTexture textureWithImageNamed: nome];
    
    //loop para passar todas linhas das sprites
    for(int j = numRows-1;j >= 0; j--) {
        
        for(int i = 0; i < numSpritesPerRow;i++)
        {
            //Criar textura/frame da imagem principal
            SKTexture *partes = [SKTexture textureWithRect:CGRectMake(i*(1.0f/numSpritesPerRow),  j*(1.0f/numRows), 1.0f/numSpritesPerRow, 1.0f/numRows) inTexture:textura];
            
            //Adiciona textura/frame  na matriz da animacao
            [animacao addObject:partes];
            
            //Verificar a quantidade de textura ja gravados
            if(animacao.count == numSprites)
                break;
        }
        
        if(animacao.count == numSprites)
            break;
    }
    
    return animacao;
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
