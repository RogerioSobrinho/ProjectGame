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
        
        self.iniciarJogo = NO;
        
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
        
    
        
        //Cria o chao
        CGRect chaoRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
        SKNode *chao = [SKNode node];
        chao.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:chaoRect];
        chao.physicsBody.restitution = 0.0f;
        [self addChild:chao];

        //Cria o teto
        CGRect tetoRect = CGRectMake(self.frame.origin.x, self.frame.size.height, self.frame.size.width, 1);
        SKNode *teto = [SKNode node];
        teto.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:tetoRect];
        teto.physicsBody.restitution = 0.0f;
        [self addChild:teto];
        
        
        //Cria as Labels de Instrucao do lado esquerdo
        self.EsqLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        self.EsqLabel.fontSize = 10;
        self.EsqLabel.fontColor = [UIColor blackColor];
        self.EsqLabel.position = CGPointMake(self.size.width - 350, self.size.height - 210);
        self.EsqLabel.text = @"Toque deste lado da tela";
        [self addChild:self.EsqLabel];
        
        self.EsqLabel2 = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        self.EsqLabel2.fontSize = 10;
        self.EsqLabel2.fontColor = [UIColor blackColor];
        self.EsqLabel2.position = CGPointMake(self.size.width - 350, self.size.height - 230);
        self.EsqLabel2.text = @"para o Drac descer";
        [self addChild:self.EsqLabel2];

        
        
        //Cria as Labels de Instrucao do lado direito
        self.DirLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        self.DirLabel.fontSize = 10;
        self.DirLabel.fontColor = [UIColor blackColor];
        self.DirLabel.position = CGPointMake(self.size.width - 130, self.size.height - 210);
        self.DirLabel.text = @"Toque deste lado da tela";
        [self addChild:self.DirLabel];
        
        self.DirLabel2 = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        self.DirLabel2.fontSize = 10;
        self.DirLabel2.fontColor = [UIColor blackColor];
        self.DirLabel2.position = CGPointMake(self.size.width - 130, self.size.height - 230);
        self.DirLabel2.text = @"para o Drac subir";
        [self addChild:self.DirLabel2];

        //Cria a Label para o titulo
        self.tituloLabel = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
        self.tituloLabel.fontSize = 60;
        self.tituloLabel.fontColor = [UIColor blackColor];
        self.tituloLabel.position = CGPointMake(self.size.width/2, self.size.height -100);
        self.tituloLabel.text = @"Drac";
        [self addChild:self.tituloLabel];

        //Cria a musica do jogo
        NSURL *urlMusica = [[NSBundle mainBundle] URLForResource:@"DracTheme" withExtension:@"mp3"];
        self.musica = [[AVAudioPlayer alloc]initWithContentsOfURL:urlMusica error:nil];
        self.musica.numberOfLoops = -1;
        [self.musica prepareToPlay];
        [self.musica play];
        
    }
    return self;
}



//Atualizacao
-(void)update:(NSTimeInterval)currentTime{
    
    if (self.iniciarJogo == YES) {
        CFTimeInterval timeSinceLast = currentTime -self.ultimoUpdateTimeInterval;
        self.ultimoUpdateTimeInterval = currentTime;
        
        
        if(timeSinceLast > 1){
            timeSinceLast = 1.0 / 60.0;
            self.ultimoUpdateTimeInterval= currentTime;
        }
        [self updateWithTimeSinceLastUpdate:timeSinceLast];
    }
    
    self.dragao.position = CGPointMake(self.frame.size.width / 5, self.dragao.position.y);
}




//Metodo de toque na tela
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        //adicionar o dragao na tela
        if(self.iniciarJogo == NO)
        {
            //Remove as labels
            [self.EsqLabel removeFromParent];
            [self.EsqLabel2 removeFromParent];
            [self.DirLabel removeFromParent];
            [self.DirLabel2 removeFromParent];
            [self.tituloLabel removeFromParent];
            
            //adiciona o dragao, a vida e os pontos na tela
            [self CriarDragao];
            [self criarCoracao];
            [self criarPontuacaoTela];
        }
        
        self.iniciarJogo = YES;
        
        //Faz o corpo do dragao ficar dinamico
        self.dragao.physicsBody.dynamic = YES;
        self.dragao.physicsBody.allowsRotation = NO;
        //Introduz gravidade
        self.dragao.physicsBody.affectedByGravity = YES;
        
        
        if ([touch locationInView:self.view].x > self.frame.size.width/2) {
            //Da impulso vertical para cima
            [self.dragao.physicsBody applyImpulse:CGVectorMake(0, 7)];
        }
        else
        {
            //Da impulso vertical para baixo
            [self.dragao.physicsBody applyImpulse:CGVectorMake(0, -7)];
        }
    }
}


//Metodo que cria o dragao
-(void)CriarDragao
{
    
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
    

    //Define CategoryBitMask
    self.dragao.physicsBody.categoryBitMask = dragaoCategory;
    
    //Define Qual CategoryBitMask colide com qual
    self.dragao.physicsBody.contactTestBitMask = flechaCategory;
    self.dragao.physicsBody.contactTestBitMask = diamanteCategory;
    [self addChild:self.dragao];
    
    
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


//Cria os coracoes de vida na tela
-(void)criarCoracao
{
    
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

}

//Cria a pontuacao na tela de jogo
-(void)criarPontuacaoTela
{
    //Faz a pontuacao e mostra na tela
    self.pontos = 0;
    self.pontuacao = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Regular"];
    self.pontuacao.position = CGPointMake(self.size.width -30, self.size.height - 35);
    self.pontuacao.text = @"0";
    self.pontuacao.fontSize = 20;
    self.pontuacao.fontColor = [UIColor blackColor];
    [self addChild:self.pontuacao];
}

//Cria as flechas na tela
-(void)criarFlechas
{
    
    self.flecha = [[SKSpriteNode alloc]initWithImageNamed:@"flecha.png"];
    
    //Determina o tamanho
    [self.flecha setSize:CGSizeMake(30.0f, 10.0f)];
    
    //Dinamica da flecha
    self.flecha.physicsBody.dynamic = NO;
    self.flecha.physicsBody.restitution = 0.0;
    
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
    int velocidade = [self calculaORandom:1.0 : 4.0];
    
    //Criar acao
    SKAction *moverFlecha = [SKAction moveTo:CGPointMake(-self.flecha.size.width/2, posicaoFlecha) duration:velocidade];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [self.flecha runAction:[SKAction sequence:@[moverFlecha,actionMoveDone]]];
    
    
}


//Cria as pedras na tela
-(void)criarPedra
{
    
    self.pedra = [[SKSpriteNode alloc]initWithImageNamed:@"Pedra.png"];
    
    //Determina o tamanho
    [self.pedra setSize:CGSizeMake(20.0f, 20.0f)];
    
    //Dinamica da flecha
    self.pedra.physicsBody.dynamic = NO;
    self.pedra.physicsBody.restitution = 0.0;
    
    //Determina o spawn da flecha;
    int posicaoPedra = [self calculaORandom:self.pedra.size.height/2 :self.frame.size.height - self.pedra.size.height /2];
    
    //Criar corpo fisico
    self.pedra.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.pedra.size.width/2, self.pedra.size.height/2)];
    
    //Valor do bitmask da pedra
    self.pedra.physicsBody.categoryBitMask = pedraCategory;
    self.pedra.physicsBody.collisionBitMask = dragaoCategory;
    self.pedra.physicsBody.contactTestBitMask = dragaoCategory;
    self.pedra.physicsBody.usesPreciseCollisionDetection = YES;
    
    //Criar a pedra antes da tela
    self.pedra.position = CGPointMake(self.frame.size.width + self.pedra.size.width/2, posicaoPedra);
    
    [self addChild:self.pedra];
    
    
    //Determina a velocidade da pedra
    int velocidade = [self calculaORandom:1.0 :3.0];
    
    //Criar acao
    SKAction *moverPedra = [SKAction moveTo:CGPointMake(-self.pedra.size.width/2, posicaoPedra) duration:velocidade];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [self.pedra runAction:[SKAction sequence:@[moverPedra,actionMoveDone]]];
    
    
}



//Criar os diamantes
-(void)criarDiamantes
{
    //cria o node diamante
    self.diamante = [[SKSpriteNode alloc]initWithImageNamed:@"Diamante.png"];
    
    //determina o diamante
    [self.diamante setSize:CGSizeMake(15.0f, 15.0f)];
    
    
    //Criar corpo fisico
    self.diamante.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.diamante.size];
    self.diamante.physicsBody.restitution = 0.0;

    
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

//Criar o diamante2 (amarelo)
-(void)criarDiamantes2
{
    //cria o node diamante
    self.diamante2 = [[SKSpriteNode alloc]initWithImageNamed:@"diamante2.png"];
    
    //determina o diamante
    [self.diamante2 setSize:CGSizeMake(15.0f, 15.0f)];
    
    
    //Criar corpo fisico
    self.diamante2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.diamante.size];
    self.diamante2.physicsBody.restitution = 0.0;
    
    //Colisao diamante
    self.diamante2.physicsBody.categoryBitMask = diamante2Category;
    self.diamante2.physicsBody.collisionBitMask = dragaoCategory;
    self.diamante2.physicsBody.contactTestBitMask = dragaoCategory;
    self.diamante2.physicsBody.usesPreciseCollisionDetection = YES;
    
    
    //Determina Spawn do diamante
    int posicaoDiamante = [self calculaORandom:self.diamante2.size.height/2 :self.frame.size.height - self.diamante2.size.height /2];
    
    //Criar o diamante antes da tela
    self.diamante2.position = CGPointMake(self.frame.size.width + self.diamante2.size.width/2, posicaoDiamante);
    [self addChild:self.diamante2];
    
    
    //Determina a velocidade da do diamante
    int velocidade = [self calculaORandom:2.0 :5.0];
    
    //Criar acao
    SKAction *moverDiamante = [SKAction moveTo:CGPointMake(-self.diamante2.size.width/2, posicaoDiamante) duration:velocidade];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [self.diamante2 runAction:[SKAction sequence:@[moverDiamante,actionMoveDone]]];
    
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
    int tempoRespawnPedra = 5;

    self.ultimoSpawnTimeInterval += timeSinceLast;
    if(self.ultimoSpawnTimeInterval > tempDeRespawn)
    {
        self.ultimoSpawnTimeInterval = 0;
        [self criarFlechas];
    }
    
    self.ultimoSpawnDiamante += timeSinceLast;
    if(self.ultimoSpawnDiamante > tempDeRespawn)
    {
        self.ultimoSpawnDiamante = 0;
        [self criarDiamantes];
    }
    
    self.ultimoSpawnD2 += timeSinceLast;
    if(self.ultimoSpawnD2 > tempoRespawnDiamante)
    {
        self.ultimoSpawnD2 = 0;
        [self criarDiamantes2];
    }
    
    self.ultimoSpawnPedra += timeSinceLast;
    if (self.ultimoSpawnPedra > tempoRespawnPedra) {
        self.ultimoSpawnPedra = 0;
        [self criarPedra];
    }


}

//Metodo que soma pontos
-(void)SomarPontosComTipo:(int)tipo
{
    self.pontos++;
    
    if (tipo == 0) {
        [[Pontos pontos] setPontuacao:[[Pontos pontos] pontuacao] + 15];
    }else if (tipo == 1){
        [[Pontos pontos] setPontuacao:[[Pontos pontos] pontuacao] + 30];
    }
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
    
    // se a flecha atingir o dragao
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
        [self SomarPontosComTipo:0];
    }
    if(firstBody.categoryBitMask == dragaoCategory && secondBody.categoryBitMask == diamante2Category)
    {
        [secondBody.node removeFromParent];
        [self SomarPontosComTipo:1];
    }
    
    // se a pedra atingir o drac
    if(firstBody.categoryBitMask == dragaoCategory && secondBody.categoryBitMask == pedraCategory)
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

}
@end
