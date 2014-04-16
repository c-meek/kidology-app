//
//  NewGestureTargetScence.h
//  KidologyApp
//
//  Created by ngo, tien dong on 4/15/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>

typedef enum {
    SWIPE,
    ROTATE,
    ZOOM,
    DRAG //Not implemented yet
} ActionType;

typedef enum {
    UP,
    DOWN,
    LEFT,
    RIGHT,
    CLOCKWISE,
    COUNTER_CLOCKWISE,
    IN,
    OUT
} Direction;

@interface NewGestureTargetScence: SKScene <UIGestureRecognizerDelegate>
{
    UIRotationGestureRecognizer* rotationGR;
    UIPanGestureRecognizer* panGR;
}

@property (nonatomic) SKSpriteNode *target;
@property (nonatomic) SKSpriteNode *anchor;
@property (nonatomic) SKSpriteNode *pressedAnchor;
@property (nonatomic) SKSpriteNode *quitButton;
@property (nonatomic) SKSpriteNode *quitButtonPressed;
@property (nonatomic) int totalTouches;
@property (nonatomic) int correctTouches;
@property (nonatomic) int totalTargets;
@property (nonatomic) int delayBetweenTargets;
@property (nonatomic) NSString *affectedHand;
@property (nonatomic) float time;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
//@property (nonatomic) AnchorStatus anchored;

@property (nonatomic) int counter;
@property (nonatomic) int numOfRotations;
@property (nonatomic) ActionType currentGesture;
@property (nonatomic) Direction gestureDirection;
@property (nonatomic) SKSpriteNode *rotateTarget;
@property (nonatomic) SKSpriteNode *updatedTarget;
@property (nonatomic) SKSpriteNode *arrow;
@property (nonatomic) SKAction *gestureMoveDone;
@property (nonatomic) CGPoint *lastupdated;

//....just global varibles to keep track of stuff for certain procedures...
@property (nonatomic) Boolean isGestureDone;
@property (nonatomic) int hasRotated;
@property (nonatomic) Boolean swipedOutside;
//.........................................................................

-(id)initWithSize:(CGSize)size;
@end
