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
        
        [[Pontos pontos] setPontuacao:0];
    
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
        
    
        //comeca com 3 de vida
        self.vida = 3;
        //Criar coracoes de vida na tela
        self.coracao1 = [SKSpriteNode spriteNodeWithImageNamed:@"Vida.png"];
        self.coracao1.position = CGPointMake(self.size.width -450, self.size.height - 30);
        [self.coracao1 setSize:CGSizeMake(15.0f, 15.0f)];
        [self addChild:self.coracao1];
        
        self.coracao2 = [SKSpriteNode spriteNodeWithImageNamed:@"Vida.png"];
        self.coracao2.position = CGPointMake(self.size.width -432, self.size.height - 30);
        [self.coracao2 setSize:CGSizeMake(15.0f, 15.0f)];
        [self addChild:self.coracao2];
        
        self.coracao3 = [SKSpriteNode spriteNodeWithImageNamed:@"Vida.png"];
        self.coracao3.position = CGPointMake(self.size.width -414, self.size.height - 30);
        [self.coracao3 setSize:CGSizeMake(15.0f, 15.0f)];
        [self addChild:self.coracao3];

        
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
        
        
        //Faz a pontuacao e mostra na tela
        self.pontos = 0;
        self.pontuacao = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Regular"];
        self.pontuacao.position = CGPointMake(self.size.width -30, self.size.height - 35);
        self.pontuacao.text = @"0";
        self.pontuacao.fontSize = 20;
        self.pontuacao.fontColor = [UIColor blackColor];
        
        [self addChild:self.pontuacao];

        
        
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
        self.dragao.physicsBody.allowsRotation = YES;
        self.dragao.physicsBody.density = 0.65f;
        
        //Elasticidade do corpo
        self.dragao.physicsBody.restitution = 0.0f;
        
        //friccao
        self.dragao.physicsBody.friction =0.0f;
        
        //
        self.dragao.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.dragao.size];
        
        
        //adicionar o dragao na tela
        [self addChild:self.dragao];
        
        
        
        //Define CategoryBitMask
        self.dragao.physicsBody.categoryBitMask = dragaoCategory;
    
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
        self.dragao.physicsBody.allowsRotation = NO;
        //Introduz gravidade
        self.dragao.physicsBody.affectedByGravity = YES;
        
        
        if ([touch locationInView:self.view].x > self.frame.size.width/2) {
            //Da impulso vertical para cima
            [self.dragao.physicsBody applyImpulse:CGVectorMake(0, 15)];
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
    
    self.flecha = [[SKSpriteNode alloc]initWithImageNamed:@"flecha.png"];
    
    //Determina o tamanho
    [self.flecha setSize:CGSizeMake(40.0f, 15.0f)];
    
    //Dinamica da flecha
    self.flecha.physicsBody.dynamic = NO;
    
    
   //Determina o spawn da flecha;
    int posicaoFlecha = [self calculaORandom:self.flecha.size.height/2 :self.frame.size.height - self.flecha.size.height /2];
    
    //Criar corpo fisico
    self.flecha.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.flecha.size.width/2, self.flecha.size.height/2)];
    
    //Valor do bitmask da flecha
    self.flecha.physicsBody.categoryBitMask = flechaCategory;
    self.flecha.physicsBody.collisionBitMask = dragaoCategory;
    self.flecha.physicsBody.contactTestBitMask = dragaoCategory;
    self.flecha.physicsBody.usesPreciseCollisionDetection = YES;
    
    //Criar a flecha antes da tela
    self.flecha.position = CGPointMake(self.frame.size.width + self.flecha.size.width/2, posicaoFlecha);
    [self addChild:self.flecha];
    
    
    //Determina a velocidade da flecha
    int velocidade = [self calculaORandom:1.0 :4.0];
    
    //Criar acao
    SKAction *moverFlecha = [SKAction moveTo:CGPointMake(-self.flecha.size.width/2, posicaoFlecha) duration:velocidade];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [self.flecha runAction:[SKAction sequence:@[moverFlecha,actionMoveDone]]];
    
    
}


//Criar os diamantes
-(void)criarDiamantes
{
    //cria o node diamante
    self.diamante = [[SKSpriteNode alloc]initWithImageNamed:@"Diamante.png"];
    
    //determina o diamante
    [self.diamante setSize:CGSizeMake(20.0f, 20.0f)];
    
    
    //Criar corpo fisico
    self.diamante.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.diamante.size];

    
    //Colisao diamante
     self.diamante.physicsBody.categoryBitMask = diamanteCategory;
    self.diamante.physicsBody.collisionBitMask = dragaoCategory;
    self.diamante.physicsBody.contactTestBitMask = dragaoCategory;
    self.diamante.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    //Determina Spawn do diamante
     int posicaoDiamante = [self calculaORandom:self.diamante.size.height/2 :self.frame.size.height - self.diamante.size.height /2];
    
    //Criar o diamante antes da tela
    self.diamante.position = CGPointMake(self.frame.size.width + self.diamante.size.width/2, posicaoDiamante);
    [self addChild:self.diamante];
    
    
    //Determina a velocidade da do diamante
    int velocidade = [self calculaORandom:2.0 :5.0];
    
    //Criar acao
    SKAction *moverDiamante = [SKAction moveTo:CGPointMake(-self.diamante.size.width/2, posicaoDiamante) duration:velocidade];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [self.diamante runAction:[SKAction sequence:@[moverDiamante,actionMoveDone]]];
    
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

//Metodo que soma pontos
-(void)SomarPontos
{
    self.pontos++;
    
    [[Pontos pontos] setPontuacao:[[Pontos pontos] pontuacao] + 15];
    self.pontuacao.text = [NSString stringWithFormat:@"%i", MAX(0, [[Pontos pontos]pontuacao])];
}

//Metodo de Perder
-(void)Perdeu
{
    self.vida--;
    if(self.vida <= 0)
    {
        [self.dragao removeAllActions];
        NSLog(@"Perdeu!!!");
        //Cria a cena de game over
        GameOverScene *gameOver=[[GameOverScene alloc]initWithSize:self.frame.size jogadorPerdeu:YES];
        
        //Pede para a MyScene acessar a view e apresentar o Game Over
        [self.view presentScene:gameOver];
    }
}

//Metodo de contato
-(void)didBeginContact:(SKPhysicsContact *)contato
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if(contato.bodyA.categoryBitMask < contato.bodyB.categoryBitMask)
    {
        firstBody = contato.bodyA;
        secondBody = contato.bodyB;
    }
    else
    {
        firstBody = contato.bodyB;
        secondBody = contato.bodyA;
    }
    
    if(firstBody.categoryBitMask == dragaoCategory && secondBody.categoryBitMask == flechaCategory)
    {
        [secondBody.node removeFromParent];
        if(self.vida == 3)
        {
        [self.coracao3 removeFromParent];
        }
        if(self.vida == 2)
        {
            [self.coracao2 removeFromParent];
        }
        
         NSLog(@"FlechaHit");
        [self Perdeu];

    }
    
    if(firstBody.categoryBitMask == dragaoCategory && secondBody.categoryBitMask == diamanteCategory)
    {
        [secondBody.node removeFromParent];
        NSLog(@"DiamanteHit");
        [self SomarPontos];
    
    }

    
    
}


//metodo de iniciar jogo
-(void)iniciarJogo
{
    
}



@end
