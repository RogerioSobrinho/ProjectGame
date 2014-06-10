//
//  MyScene.m
//  SpriteKitTest
//
//  Created by LUIZ FERNANDO SILVA on 11/02/14.
//  Copyright (c) 2014 Luiz Fernando Silva. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        /* Setup your scene here */
        
        // Ajusta os parametros iniciais da cena
        fraseOffset = 0;
        canoTimer = 0;
        contouPonto = false;
        
        self.lastUpdateTimeInterval = 0;
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        self.perdeu = false;
        
        self.pontos = 0;
        
        self.flappyFrames = [self loadSpriteSheetFromImageWithName:@"doge.png" withNumberOfSprites:6 withNumberOfRows:2 withNumberOfSpritesPerRow:3];
        
        // Cria o fundo
        self.fundo = [SKSpriteNode spriteNodeWithImageNamed:@"fundoFase.png"];
        
        // Coloca -15 para o sprite ficar no fundo de tudo
        self.fundo.zPosition = -15;
        
        self.fundo.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        
        [self addChild:self.fundo];
        
        // Cria o sprite do flappy
        self.flappy = [SKSpriteNode spriteNodeWithImageNamed:@"Doge.png"];
        
        // Cria o SKAction da animação do flappy
        SKAction *flappyAnim = [SKAction animateWithTextures:self.flappyFrames timePerFrame:0.05f];
        // Anima o flappy!
        [self.flappy runAction:[SKAction repeatActionForever:flappyAnim]];
        
        [self.flappy setSize:CGSizeMake(50, 49)];
        
        self.flappy.xScale = -self.flappy.xScale;
        
        // Cria o corpo de física do flappy
        self.flappy.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.flappy.size.width / 2];
        // Trocando o valor da propriedade 'dynamic' para falso (NO) não permite o corpo de física movimentar o sprite
        self.flappy.physicsBody.dynamic = NO;
        // Trocando o valor da propriedade 'affectedByGravity' para falso desabilita os efeitos da gravidade do mundo em cima do corpo
        self.flappy.physicsBody.affectedByGravity = YES;
        // Coloca-se a categoria do corpo para o valor que criamos para que assim conseguiremos saber quais objetos estão colidindo mais em baixo
        self.flappy.physicsBody.categoryBitMask = flappyCategory;
        // Coloca-se a propriedade de teste de contato para que possamos dizer quais tipos de corpos o flappy vai colidir
        self.flappy.physicsBody.contactTestBitMask = canosCategory;
        // Liga-se o modo preciso para que as colisões não 'vazem' quando os corpos estão se movendo rapidamente
        self.flappy.physicsBody.usesPreciseCollisionDetection = YES;
        // Desliga a flag que habilita a rotação do node, assim o corpo não gira o node junto quando ele girar
        self.flappy.physicsBody.allowsRotation = NO;
        self.flappy.physicsBody.density = 0.65f;
        // A proprieadde restitution se refere a elasticidade do objeto, de 0 à 1
        self.flappy.physicsBody.restitution = 0;
        
        // Chama-se o addChild desta view para adicionar o flappy na tela. Sem chamar este método, o flappy não aparece!
        [self addChild:self.flappy];
        
        // Cria o contador de pontos
        self.pontuacao = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Regular"];
        self.pontuacao.position = CGPointMake(self.size.width / 2, self.size.height - 150);
        self.pontuacao.text = [NSString stringWithFormat:@"%i", self.pontos];
        self.pontuacao.fontSize = 50;
        self.pontuacao.fontColor = [UIColor blackColor];
        
        [self addChild:self.pontuacao];
        
        // Cria o chão
        self.chao = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:35 green:36 blue:5 alpha:1] size:CGSizeMake(self.size.width, 60)];
        
        self.chao.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.chao.frame];
        self.chao.physicsBody.categoryBitMask = chaoCategory;
        self.chao.physicsBody.contactTestBitMask = flappyCategory;
        self.chao.physicsBody.dynamic = NO;
        self.chao.physicsBody.restitution = 0;
        self.chao.position = CGPointMake(self.size.width / 2, 0);
        
        [self addChild:self.chao];
        
        // Liga a gravidade do mundo
        self.physicsWorld.gravity = CGVectorMake(0, -10);
        
        // Seta o delegate das colisões de física para esta classe (self), assim, quando um contato for detectado, o método didBeginContact dessa classe será chamado
        self.physicsWorld.contactDelegate = self;
        
        // Inicia o jogo
        [self iniciarJogo];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    for (UITouch *touch in touches)
    {
        if(!self.perdeu && self.flappy.position.y < self.size.height)
        {
            // Atualiza a flag de jogando para verdadeiro para dizer ao jogo para colocar os canos na tela
            self.jogando = true;
            
            // Habilita o modo dinamco do corpo, se não estiver habilitado ainda
            self.flappy.physicsBody.dynamic = YES;
            // Habilita a gravidade, se não estiver habilitado ainda
            self.flappy.physicsBody.affectedByGravity = YES;
            
            // Zera a velocidade do falppy
            self.flappy.physicsBody.velocity = CGVectorMake(0, 0);
            // Dá um impulso vertical para cima de 25 unidades
            [self.flappy.physicsBody applyImpulse:CGVectorMake(0, 25)];
            
            
            // Mostra uma frase aleatória na tela
            [self mostrarFrase];
            
            [self runAction:[SKAction playSoundFileNamed:@"baterAsas.wav" waitForCompletion:NO]];
        }
        
        // Re-inicia o jogo caso o player tenha perdido
        if(self.perdeu)
        {
            [self iniciarJogo];
        }
    }
}

// Reinicia o jogo
- (void)iniciarJogo
{
    // Ajusta as flags
    self.perdeu = false;
    self.jogando = false;
    
    // Ajusta os parametros da cena
    canoTimer = 200;
    contouPonto = false;
    
    // Anima o flappy!
    SKAction *flappyAnim = [SKAction animateWithTextures:self.flappyFrames timePerFrame:0.05f];
    [self.flappy runAction:[SKAction repeatActionForever:flappyAnim]];
    
    // Zera os pontos
    self.pontos = -2;
    self.pontuacao.text = [NSString stringWithFormat:@"%i", MAX(0, self.pontos)];
    
    // Re-posiciona o flappy no meio da tela
    self.flappy.position = CGPointMake(self.size.width / 3, self.size.height / 2);
    self.flappy.zRotation = 0;
    // Liga as colisões
    self.flappy.physicsBody.collisionBitMask = 0xFFFFFFFF;
    // Fixa o flappy no ar desligando a gravidade e zerando a sua velocidade
    self.flappy.physicsBody.velocity = CGVectorMake(0, 0);
    self.flappy.physicsBody.affectedByGravity = NO;
    
    // Remove todos os canos
    for (SKNode *node in self.children)
    {
        if(node.name != nil && [node.name compare:@"Canos"] == NSOrderedSame)
        {
            [node removeFromParent];
        }
    }
}

// Faz com que o jogador perca. O método desabilita o flappy e o joga no chão
- (void)perder
{
    [self runAction:[SKAction playSoundFileNamed:@"Bateu.mp3" waitForCompletion:NO]];
    // Desabilita as ações de andar de todos os canos
    for (SKNode *node in self.children)
    {
        if(node.name != nil && [node.name compare:@"Canos"] == NSOrderedSame)
        {
            [node removeAllActions];
        }
    }
    
    [self.flappy removeAllActions];
    self.flappy.physicsBody.collisionBitMask = chaoCategory;
    self.perdeu = true;
}

// Soma um ponto e toca um sonzinho
- (void)somarPonto
{
    self.pontos++;
    self.pontuacao.text = [NSString stringWithFormat:@"%i", MAX(0, self.pontos)];
}

//
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    // Lógica de quando o jogador estiver jogando
    if(self.jogando)
    {
        if(!self.perdeu)
        {
            // Lógica para criar os canos
            canoTimer -= timeSinceLast * 60;
            
            if(canoTimer <= 90 && !contouPonto)
            {
                [self somarPonto];
                contouPonto = true;
                if (self.pontos > 0)
                {
                    [self runAction:[SKAction playSoundFileNamed:@"beep.wav" waitForCompletion:NO]];
                }
            }
            
            if(canoTimer <= 0)
            {
                contouPonto = false;
                canoTimer = 100;
                [self criarCanos];
            }
        }
        
        self.flappy.zRotation = (self.flappy.physicsBody.velocity.dy) / 600;
    }
}

// Chamado antes de cada quadro ser renderizado
- (void)update:(CFTimeInterval)currentTime
{
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1)
    { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

// Cria um par de canos na tela
- (void)criarCanos
{
    float tamanhoHorizontal = 50;
    float separacao = 150;
    float y = (-self.size.height + separacao + 100) / 2 + rand() % (int)(-self.size.height + separacao + 50);
    
    // Cria um nó para acomodar o par de canos
    SKNode *canos = [[SKNode alloc] init];
    
    canos.name = @"Canos";
    canos.position = CGPointMake(self.size.width + tamanhoHorizontal / 2, y);
    
    // Cria um par de canos
    /*SKSpriteNode *canoSuperior = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:35 green:36 blue:5 alpha:1] size:CGSizeMake(tamanhoHorizontal, self.size.height)];*/
    
    SKTexture *texturaCano = [SKTexture textureWithImageNamed:@"canoDogeOficial.png"];
    
    SKSpriteNode *canoSuperior = [SKSpriteNode spriteNodeWithTexture:texturaCano size:CGSizeMake(tamanhoHorizontal, self.size.height)];
    
    canoSuperior.zRotation = M_PI;
    
    // Posiciona o cano superior
    canoSuperior.position = CGPointMake(0, self.size.height + separacao / 2);
    // Adiciona o SKPhysicsBody no cano superior para que o flappy colida com ele
    canoSuperior.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:canoSuperior.size];
    canoSuperior.physicsBody.dynamic = NO; // Desliga a propriedade dynamic para que o corpo não altere a posição do cano
    canoSuperior.physicsBody.categoryBitMask = canosCategory;
    canoSuperior.physicsBody.contactTestBitMask = flappyCategory;
    canoSuperior.physicsBody.restitution = 0;
    
    SKSpriteNode *canoInferior = [SKSpriteNode spriteNodeWithTexture:texturaCano size:CGSizeMake(tamanhoHorizontal, self.size.height)];
    
    // Posiciona o cano inferior
    canoInferior.position = CGPointMake(0, self.size.height - canoInferior.size.height - separacao / 2);
    canoInferior.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:canoSuperior.size];
    canoInferior.physicsBody.dynamic = NO; // Desliga a propriedade dynamic para que o corpo não altere a posição do cano
    canoInferior.physicsBody.categoryBitMask = canosCategory;
    canoInferior.physicsBody.contactTestBitMask = flappyCategory;
    canoInferior.physicsBody.restitution = 0;
    
    // Adiciona os dois canos dentro do SKNode que irá conte-los
    [canos addChild:canoSuperior];
    [canos addChild:canoInferior];
    
    // Duração das transisões dos canos na tela
    float duracao = 3;
    
    // Cria as ações para aplicar aos canos
    SKAction *acaoMover = [SKAction moveTo:CGPointMake(-20, canos.position.y) duration:duracao];
    SKAction *acaoRemover = [SKAction removeFromParent];
    
    // Usando o [SKAction sequence:], é possível fazer com que uma seqencia de actions seja feita uma depois da outra
    [canos runAction:[SKAction sequence:@[acaoMover, acaoRemover]]];
    
    canos.zPosition = -5;
    
    // Adiciona os canos na cena
    [self addChild:canos];
}

// Cria um label com uma frase aleatório na tela
- (void)mostrarFrase
{
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Regular"];
    
    NSArray *cores = @[[UIColor blueColor], [UIColor orangeColor], [UIColor redColor], [UIColor yellowColor]];
    [label setFontColor:[cores objectAtIndex:rand() % cores.count]];
    
    NSArray *frases = @[@"wow", @"such heit", @"much fly", @"plz higer"];
    label.text = [frases objectAtIndex:fraseOffset];
    
    fraseOffset = (fraseOffset + (1 + rand() % (frases.count - 1))) % frases.count;
    
    SKAction *fade = [SKAction fadeAlphaTo:0 duration:0.5f];
    SKAction *del = [SKAction removeFromParent];
    
    [label runAction:[SKAction sequence:@[fade, del]]];
    
    [self addChild:label];
    
    label.position = CGPointMake(label.frame.size.width / 2 + rand() % (int)(self.size.width - label.frame.size.width), rand() % (int)(self.size.height - label.frame.size.height - self.chao.size.height));
}

-(NSMutableArray*)loadSpriteSheetFromImageWithName:(NSString*)name withNumberOfSprites:(int)numSprites withNumberOfRows:(int)numRows withNumberOfSpritesPerRow:(int)numSpritesPerRow {
    // Matriz para armazenar os frames da animação
    NSMutableArray* animationSheet = [NSMutableArray array];
    
    // Carrega a imagem principal(Sprite Sheet/Sprite Stripe)
    SKTexture* mainTexture = [SKTexture textureWithImageNamed:name];
    
    // Loops para passar em todas as linhas de sprites
    for(int j = numRows-1; j >= 0; j--) {
        // Loop para passar em todas as sprites da linha
        for(int i = 0; i < numSpritesPerRow; i++) {
            // Cria uma textura/frame da imagem principal(Sprite Sheet/Sprite Stripe)
            // Obs.: As posições e tamanhos dos parametros do CGRectMake devem ser de 0~1(0%~100%)
            // O tamanho inserido não influência no tamanho do Node apenas o tamanho da Textura em si, mas o tamanho excedido é cortado
            SKTexture* part = [SKTexture textureWithRect:CGRectMake(i*(1.0f/numSpritesPerRow), j*(1.0f/numRows), 1.0f/numSpritesPerRow, 1.0f/numRows) inTexture:mainTexture];
            
            // Adiciona a textura/frame na matriz dos frames da animação
            [animationSheet addObject:part];
            
            // Verifica a quantidade de texturas/frames já gravados, para evitar que os loops excedam o tamanho da imagem principal(Sprite Sheet/Sprite Stripe) e cause posteriores erros e defeitos
            if(animationSheet.count == numSprites)
                break;
        }
        
        // Verifica a quantidade de texturas/frames já gravados, para evitar que os loops excedam o tamanho da imagem principal(Sprite Sheet/Sprite Stripe) e cause posteriores erros
        if(animationSheet.count == numSprites)
            break;
    }
    
    // Retorna a matriz com as texturas de cada frames da animação
    return animationSheet;
}

// Método chamado toda vez que uma colisão for encontrada
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if(self.perdeu)
        return;
    
    // Organiza os corpos de acordo com o valor da categoria. Isto é feito para facilitar a comparação mais em baixo
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // Compara as máscaras de categoria com os valores que nós usamos para os objetos do jogo
    if ((firstBody.categoryBitMask & flappyCategory) != 0)
    {
        if((secondBody.categoryBitMask & canosCategory) != 0)
        {
            self.flappy.physicsBody.velocity = CGVectorMake(0, 0);
            
            [self perder];
        }
        else if((secondBody.categoryBitMask & chaoCategory) != 0)
        {
            self.flappy.physicsBody.velocity = CGVectorMake(0, 0);
            self.flappy.physicsBody.affectedByGravity = NO;
            
            if(!self.perdeu)
            {
                [self perder];
            }
        }
    }
}

@end
