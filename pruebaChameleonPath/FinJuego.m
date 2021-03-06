//
//  FinJuego.m
//  pruebaChameleonPath
//
//  Created by Dave on 11/11/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

/*
 FinJuego
 
 Esta 'scene' aparece al terminar el juego, y marca la puntuación, si se fue exitoso,
 o un mensaje de game over.
 
 También tiene la opción de regresar a la pantalla principal.
 
 */

#import "FinJuego.h"
#import "HelloWorldLayer.h"

@implementation FinJuego

/*
 Crea la capa donde se ejecutará la escena
 */

+(CCScene *) sceneWithEnd: (int) end t: (int)tiempo  e:(int) estrella{
    CCScene *scene = [CCScene node];
    
    FinJuego *layer = [[FinJuego alloc] initWithEnd:end t:tiempo e:estrella];
    
    [scene addChild: layer];
    
    return scene;
}


/*
 Crea la escena.
 Elementos:
 -CCSprite background: la imagen de fondo en png
 -CCSprite textEnd: Si se ganó, el mensaje de victoria. Si se perdió, el de gameover.
 -CCMenu menu2: El menu con la opción para regresar al menú principal
 */

-(id)initWithEnd:(int)end t: (int)tiempo  e:(int) estrella
{
    if( (self=[super init]) ) {
        self.isTouchEnabled = YES;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"Background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:-2];
        
        CCSprite *textEnd;
        CCLabelTTF *punt;
        
        int puntos = 0;
        puntos = 75000/tiempo;
        if(estrella)
            puntos +=200*estrella;
        
        if (end == 0) {
            textEnd = [CCSprite spriteWithFile:@"Win.png"];
            punt = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i puntos", puntos] fontName:@"verdana" fontSize:24];
        }
        else if (end == 1) {
            textEnd = [CCSprite spriteWithFile:@"GameOver.png"];
            punt= [CCLabelTTF labelWithString:@"" fontName:@"verdana" fontSize:15];
            puntos = 0;
        }
        
        textEnd.position =  ccp(winSize.width/2, winSize.height/2);
        punt.position =  ccp(winSize.width/2-20, (winSize.height/2)-35);
        
        [self addChild:textEnd z:2];
        [self addChild:punt z:2];
        
        CCLabelTTF *atras = [CCLabelTTF labelWithString:@"Tap para continuar" fontName:@"verdana" fontSize:15];
        CCMenuItemLabel *atras1 = [CCMenuItemLabel itemWithLabel:atras target:self selector:@selector(back)];
        
        CCMenu *menu2 = [CCMenu menuWithItems:atras1, nil];
        menu2.position = ccp((winSize.width/2),(winSize.height/6));
        
        [self addChild:menu2];
        
        /* Highscores */
        
        NSString *pathPlist;
        NSMutableArray *puntuaciones;
        NSMutableArray *temp;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"highscores.plist"];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSMutableArray *arreglo = [[NSMutableArray alloc] initWithContentsOfFile: filePath];
            [arreglo addObject:@(puntos)];
            
            //los ordena de mayor a menor
            NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
            [arreglo sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
            
            //Escribe a plist.
            [arreglo writeToFile: filePath atomically:YES];
        }
        //highscore ya existia
        else {
            pathPlist = [[NSBundle mainBundle] pathForResource:@"highscores base" ofType:@"plist"];
            puntuaciones = [[NSMutableArray alloc] initWithContentsOfFile:pathPlist];
            temp = [[NSMutableArray alloc] initWithArray:puntuaciones];
            
            [puntuaciones addObject:@(puntos)];

            NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
            [puntuaciones sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];

            [temp writeToFile: filePath atomically:YES];

        }


    }
    return self;
}

-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:0
                                                       swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCScene *Reiniciar = [HelloWorldLayer scene];
    
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:Reiniciar ]];
}

/*
El selector 'back' para regresar al menu principal 
*/

- (void)back {
	CCScene *MainMenuScene = [HelloWorldLayer scene];
    
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:MainMenuScene]];
}



@end
