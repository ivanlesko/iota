//
//  CreditsScene.m
//  iota
//
//  Created by Ivan Lesko on 3/28/14.
//  Copyright (c) 2014 Ivan Lesko. All rights reserved.
//

#import "CreditsScene.h"

#import "Peg.h"
#import "Ball.h"

#define PEG_COLUMNS 15
#define PEG_ROWS    5

@implementation CreditsScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKButton *credits = [[SKButton alloc] initWithImageNamed:@"creditsScreen"];
        credits.position  = CGPointMake(size.width / 2.0, size.height / 2.0);
        [self addChild:credits];
        [credits setTouchUpTarget:self action:@selector(presentMainMenu)];
        
        self.physicsWorld.gravity = CGVectorMake(.02, -19.0);
        self.physicsWorld.contactDelegate = self;
        
        [self setupPegs];
        
        SKAction *dropBalls = [SKAction sequence: @[
                                                    [SKAction performSelector:@selector(dropBallsFromTop) onTarget:self],
                                                    [SKAction waitForDuration:.25 withRange:1]
                                                    ]];
        [self runAction: [SKAction repeatActionForever:dropBalls]];
        
        [self createLetterBoxes];
    }
    
    return self;
}

- (void)dropBallsFromTop {
    int lowerBound = 1;
    int upperBound = 6;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    Ball *ball        = [Ball newBall];
    ball.position     = CGPointMake(skRand(0, self.size.width), self.size.height);
    ball.currentColor = rndValue;
    [self addChild:ball];
}

- (void)setupPegs {
    CGPoint origin = CGPointMake(35, 121);
    
    int columns = PEG_COLUMNS;
    int rows    = PEG_ROWS;
    
    for (int j = 0; j < rows; j++) {
        for (int i = 0; i < columns; i ++) {
            if ((j % 2 == 1) && (i == columns - 1)) {
                // Don't make a peg if we are in an even row and last column.
            } else {
                Peg *peg = [Peg newPeg];
                if (j % 2 == 0) {
                    peg.position = CGPointMake(origin.x + (i * 50), origin.y + (j * 50));
                } else {
                    peg.position = CGPointMake(origin.x + (i * 50) + 25, origin.y + (j * 50));
                }
                [self addChild:peg];
            }
        }
    }
}

- (SKSpriteNode *)boxAtPosition:(CGPoint)position withSize:(CGSize)size {
    SKSpriteNode *box = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
    box.position = CGPointMake(position.x + size.width / 2.0, position.y + size.height / 2.0);
    box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box.size];
    box.physicsBody.affectedByGravity = NO;
    box.physicsBody.dynamic = NO;
    box.physicsBody.friction = 0.0f;
    
    return box;
}

- (SKSpriteNode *)circleAtPosition:(CGPoint)position withSize:(CGSize)size {
    SKSpriteNode *circle = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
    circle.position = CGPointMake(position.x + size.width / 2.0, position.y + size.height / 3.0);
    circle.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:circle.size.width / 2.0];
    circle.physicsBody.affectedByGravity = NO;
    circle.physicsBody.dynamic = NO;
    circle.physicsBody.friction = 0.0;
    
    return circle;
}

- (void)createLetterBoxes {
    [self addChild:[self boxAtPosition:CGPointMake(307, 556) withSize:CGSizeMake(157, 312)]];
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0 || node.position.x < 0 || node.position.x > self.frame.size.width)
            [node removeFromParent];
    }];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    firstBody = contact.bodyA;
    secondBody = contact.bodyB;
    
    if ([firstBody.node isKindOfClass:[Peg class]]) {
        Peg *peg = (Peg *)firstBody.node;
        
        Ball *ball = (Ball *)secondBody.node;
        if (peg.colorCount != ball.currentColor) {
            peg.colorCount = ball.currentColor;
        }
    }
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)presentMainMenu {
    [self.view presentScene:self.mainMenu transition:[SKTransition fadeToBlackOneSecondDuration]];
}

@end









