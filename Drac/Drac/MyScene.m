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
    
        self.physicsWorld.contactDelegate=self;
        
        
        // Criar fundo de tela
        SKSpriteNode *fundo = [SKSpriteNode spriteNodeWithImageNamed:@"613354.png"];
        
        //Coloca -15 para a sprite ficar no fundo
        fundo.zPosition = -15;
        fundo.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        //adicionar fundo
        [self addChild:fundo];
        
        //Configura a gravidade
        self.physicsWorld.gravity=CGVectorMake(0.0f, -0.5f);
        
        //Cria muros na scene
        //SKPhysicsBody *BordaTela = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        //Corpo fisico da cena
        //self.physicsBody=BordaTela;
        
        
        
        //Cria o chao
        CGRect chaoRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        SKNode *chao = [SKNode node];
        chao.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:chaoRect];
        [self addChild:chao];

        //Cria o chao
        CGRect tetoRect = CGRectMake(self.frame.origin.x, self.frame.size.height, self.frame.size.width, 1);
        SKNode *teto = [SKNode node];
        teto.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:tetoRect];
        [self addChild:teto];
        
        
        
        //02 Criar o Sprite do dragao
        self.dragao = [SKSpriteNode spriteNodeWithImageNamed:@"essa.fw.png"];

        //criar frames do dragao
        self.dragaoFrames = [self carregarSprites:@"essa.fw.png" withNumberOfSprites:8 withNumberOfRows:2 withNumberOfSpritesPerRow:4];
        
        [self.dragao setSize:CGSizeMake(50.0f, 49.0f)];
        
        //Posicionamento do dragao na tela(no jogo)
        self.dragao.position = CGPointMake(self.size.width / 5, self.size.height / 2);
        self.dragao.zRotation = 0;
        
        //Criacao da Animacao
        SKAction *dragaoAnimado = [SKAction animateWithTextures:self.dragaoFrames timePerFrame:0.08f];
        
        //Animacao
        [self.dragao runAction:[SKAction repeatActionForever:dragaoAnimado]];
        
        //Criar corpo fisico
        self.dragao.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.dragao.size.width/2];
        
        // Nao permite o corpo fisico movimentar a Sprite
        self.dragao.physicsBody.dynamic = NO;
        
        // Faz o corpo ser afetado pela gravidade
        self.dragao.physicsBody.affectedByGravity = NO;
        
        //Para o corpo nao girar
        self.dragao.physicsBody.allowsRotation = NO;
        self.dragao.physicsBody.density = 0.65f;
        
        //Elasticidade do corpo
        self.dragao.physicsBody.restitution = 0.0f;
        
        //friccao
        self.dragao.physicsBody.friction =0.0f;
        
        //adicionar o dragao na tela
        [self addChild:self.dragao];
        
        
        
        
        //Define CategoryBitMask
        self.dragao.physicsBody.categoryBitMask = dragaoCategory;
        self.flecha.physicsBody.categoryBitMask = flechaCategory;
        self.diamante.physicsBody.categoryBitMask = diamanteCategory;
    
        //Define Qual CategoryBitMask colide com qual
        self.dragao.physicsBody.contactTestBitMask = flechaCategory;
        self.dragao.physicsBody.contactTestBitMask = diamanteCategory;
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        
        //Faz o corpo do dragao ficar dinamico
        self.dragao.physicsBody.dynamic = YES;
        //Introduz gravidade
        self.dragao.physicsBody.affectedByGravity = YES;
        //Da impulso vertical para cima
        [self.dragao.physicsBody applyImpulse:CGVectorMake(0, 5)];

        
    }
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
