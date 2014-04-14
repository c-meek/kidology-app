//
//  GestureTargetPracticeScene.h
//  KidologyApp
//
//  Created by Mike's MacBook on Apr/14/2014.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TargetPracticeScene.h"


//typedef enum {
//    TOUCHING,
//    NOT_TOUCHING
//} AnchorStatus;

//typedef enum {
//    SWIPE,
//    ROTATE,
//    ZOOM,
//    DRAG //Not implemented yet
//} GestureType;
//
//typedef enum {
//    UP,
//    DOWN,
//    LEFT,
//    RIGHT,
//    CLOCKWISE,
//    COUNTER_CLOCKWISE,
//    IN,
//    OUT
//} Direction;


@interface GestureTargetPracticeScene : SKScene <UIGestureRecognizerDelegate>
{
    UIRotationGestureRecognizer* rotationGR;
    UISwipeGestureRecognizer* swipeRightGesture;
    UISwipeGestureRecognizer* swipeLeftGesture;
    UISwipeGestureRecognizer* swipeUpGesture;
    UISwipeGestureRecognizer* swipeDownGesture;
}

@property (nonatomic) SKSpriteNode * target;
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
@property (nonatomic) AnchorStatus anchored;

@property (nonatomic) int numOfRotations;
@property (nonatomic) ActionType currentGesture;
@property (nonatomic) Direction gestureDirection;
@property (nonatomic) SKSpriteNode *rotateTarget;
@property (nonatomic) SKSpriteNode *arrow;
@property (nonatomic) SKAction *gestureMoveDone;

//....just global varibles to keep track of stuff for certain procedures...
@property (nonatomic) Boolean isGestureDone;
@property (nonatomic) int hasRotated;
@property (nonatomic) Boolean swipedOutside;
//.........................................................................

-(id)initWithSize:(CGSize)size numberOfTargets:(int)numberOfTargets;
@end
