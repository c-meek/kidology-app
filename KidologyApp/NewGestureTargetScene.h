//
//  NewGestureTargetScene.h
//  KidologyApp
//
//  Created by ngo, tien dong on 4/15/14.
//  Copyright (c) 2014 OSU. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TargetPracticeScene.h"

typedef enum {
    SWIPE, // not implemented yet
    ROTATE,
    ZOOM,
    DRAG
} ActionType;

typedef enum {
    CLOCKWISE,
    COUNTER_CLOCKWISE,
    IN,
    OUT
} Direction;

@interface NewGestureTargetScene: SKScene <UIGestureRecognizerDelegate>
{
    UIRotationGestureRecognizer* rotationGR;
    UIPanGestureRecognizer* panGR;
    UIPinchGestureRecognizer* pinchGR;
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
@property (nonatomic) float targetSize;
@property (nonatomic) NSString *affectedHand;
@property (nonatomic) BOOL enableSound;
@property (nonatomic) float time;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) AnchorStatus anchored;

//.... Specific gesture stuff hrere...
@property (nonatomic) ActionType currentGesture;
@property (nonatomic) Direction gestureDirection;
@property (nonatomic) SKSpriteNode *rotateTarget;

//This is the object that moves in DRAG (or pan)
@property (nonatomic) SKSpriteNode *updatedTarget;

//This is the actual target that the object (above) is drag to
@property (nonatomic) SKSpriteNode *dragTarget;

@property (nonatomic) SKSpriteNode *zoomTarget;
@property (nonatomic) SKSpriteNode *outline;
@property (nonatomic) SKLabelNode *tapScreenLabel;
@property (nonatomic) SKAction *gestureMoveDone;
@property (nonatomic) CGPoint *lastupdated;

// global varibles to keep track of stuff for certain procedures
@property (nonatomic) int counter;
@property (nonatomic) int hasStartedInCenter;;
@property (nonatomic) Boolean isGestureDone;
@property (nonatomic) int hasRotated;
@property (nonatomic) Boolean swipedOutside;
//.........................................................................

-(id)initWithSize:(CGSize)size;
@end
