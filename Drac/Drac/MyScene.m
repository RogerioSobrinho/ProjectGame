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
        
        //Configura a gravidade
        self.physicsWorld.gravity=CGVectorMake(0.0f, -0.5f);

        
        
        // Criar fundo de tela
        SKSpriteNode *fundo = [SKSpriteNode spriteNodeWithImageNamed:@"613354.png"];
        
        //Coloca -15 para a sprite ficar no fundo
        fundo.zPosition = -15;
        fundo.position = CGPointMake(self.size.width/2, self.size.height/2);
        
        //adicionar fundo
        [self addChild:fundo];
        
    
        
        //Cria o chao
        CGRect chaoRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        SKNode *chao = [SKNode node];
        chao.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:chaoRect];
        [self addChild:chao];

        //Cria o teto
        CGRect tetoRect = CGRectMake(self.frame.origin.x, self.frame.size.height, self.frame.size.width, 1);
        SKNode *teto = [SKNode node];
        teto.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:tetoRect];
        [self addChild:teto];
        
        
        
        //02 Criar o Sprite do dragao
        self.dragao = [SKSpriteNode spriteNodeWithImageNamed:@"DracMod2PS.png"];

        //criar frames do dragao
        self.dragaoFrames = [self carregarSprites:@"DracMod2PS.png" withNumberOfSprites:8 withNumberOfRows:2 withNumberOfSpritesPerRow:4];
        
        [self.dragao setSize:CGSizeMake(70.0f, 70.0f)];
        
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

//Atualizacao
-(void)update:(NSTimeInterval)currentTime{
    CFTimeInterval timeSinceLast = currentTime -self.ultimoUpdateTimeInterval;
    self.ultimoUpdateTimeInterval = currentTime;
    if(timeSinceLast > 1){
        timeSinceLast = 1.0 / 60.0;
        self.ultimoUpdateTimeInterval= currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}



//Metodo de toque na tela
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    for (UITouch *touch in touches)
    {
        
        //Faz o corpo do dragao ficar dinamico
        self.dragao.physicsBody.dynamic = YES;
        //Introduz gravidade
        self.dragao.physicsBody.affectedByGravity = YES;
        
        
        if ([touch locationInView:self.view].x > self.frame.size.width/2) {
            //Da impulso vertical para cima
            [self.dragao.physicsBody applyImpulse:CGVectorMake(0, 7)];
        }
        else
        {
            //Da impulso vertical para baixo
            [self.dragao.physicsBody applyImpulse:CGVectorMake(0, -5)];
        }
    }
}


//Metodo de carregar animacao do Dragao
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


//Cria as flechas na tela
-(void)criarFlechas
{
    
    SKSpriteNode *flecha = [[SKSpriteNode alloc]initWithImageNamed:@"images.png"];
    
    //Determina o tamanho
    [flecha setSize:CGSizeMake(40.0f, 15.0f)];
    
    
   //Determina o spawn da flecha;
    int posicaoFlecha = [self calculaORandom:flecha.size.height/2 :self.frame.size.height - flecha.size.height /2];
    
    //Criar a flecha antes da tela
    flecha.position = CGPointMake(self.frame.size.width + flecha.size.width/2, posicaoFlecha);
    [self addChild:flecha];
    
    
    //Determina a velocidade da flecha
    int velocidade = [self calculaORandom:1.0 :4.0];
    
    //Criar acao
    SKAction *moverFlecha = [SKAction moveTo:CGPointMake(-flecha.size.width/2, posicaoFlecha) duration:velocidade];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [flecha runAction:[SKAction sequence:@[moverFlecha,actionMoveDone]]];
    
}


//Criar os diamantes
-(void)criarDiamantes
{
    //cria o node diamante
    SKSpriteNode *diamante = [[SKSpriteNode alloc]initWithImageNamed:@"Diamante.png"];
    
    //determina o diamante
    [diamante setSize:CGSizeMake(20.0f, 20.0f)];
    
    
    //Determina Spawn do diamante
     int posicaoDiamante = [self calculaORandom:diamante.size.height/2 :self.frame.size.height - diamante.size.height /2];
    
    //Criar o diamante antes da tela
    diamante.position = CGPointMake(self.frame.size.width + diamante.size.width/2, posicaoDiamante);
    [self addChild:diamante];
    
    
    //Determina a velocidade da do diamante
    int velocidade = [self calculaORandom:2.0 :5.0];
    
    //Criar acao
    SKAction *moverDiamante = [SKAction moveTo:CGPointMake(-diamante.size.width/2, posicaoDiamante) duration:velocidade];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [diamante runAction:[SKAction sequence:@[moverDiamante,actionMoveDone]]];
    
}


 // Metodo de calcular Random
-(int)calculaORandom:(int)min :(int)max{
    int minY = min;
    int maxY =max;
    int rangeY = maxY - minY;
    int atualY = (arc4random()% rangeY) + minY;
    
    return atualY;
}

-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    int tempDeRespawn = 1;
    int tempoRespawnDiamante = 3;

    self.ultimoSpawnTimeInterval += timeSinceLast;
    if(self.ultimoSpawnTimeInterval > tempDeRespawn)
    {
        self.ultimoSpawnTimeInterval = 0;
        [self criarFlechas];
    }
    
    self.ultimoSpawnDiamante += timeSinceLast;
    if(self.ultimoSpawnDiamante > tempoRespawnDiamante)
    {
        self.ultimoSpawnDiamante = 0;
        [self criarDiamantes];
    }

}

//metodo de iniciar jogo
-(void)iniciarJogo
{
    
}



@end
