//
//  CommandSpot.m
//  CcCommandSpot
//
//  Created by Ian Fan on 16/03/13.
//
//

#import "CommandSpot.h"

#define COMMAND_BASE_LENGTH 100
#define COMMAND_CHOICE_LENGTH 80

#pragma mark - COMMAND_BASE_UNIT

@implementation CommandBaseUnit
@synthesize commandChoiceType=_commandChoiceType, choiceArray=_choiceArray, baseSprite=_baseSprite;

#pragma mark - CommandChoice

-(void)showCommandChoice {
  self.isSelected = YES;
  
  [self setupCommandChoiceWithPngName:@"command_archer.png" tag:CommandChoiceType_Archer degree:135];
  [self setupCommandChoiceWithPngName:@"command_spearman.png" tag:CommandChoiceType_Spearman degree:45];
  [self setupCommandChoiceWithPngName:@"command_footman.png" tag:CommandChoiceType_Footman degree:-45];
  [self setupCommandChoiceWithPngName:@"command_knight.png" tag:CommandChoiceType_Knight degree:-135];
}

-(void)setupCommandChoiceWithPngName:(NSString*)pngName tag:(CommandChoiceType)tag degree:(float)degree {
  CGPoint centerPoint = _baseSprite.position;
  float scale = 1.0;
  float duration = 0.1;
  float beginLength = 0.5*COMMAND_BASE_LENGTH;
  float finalLength = 0.5*(COMMAND_BASE_LENGTH + COMMAND_CHOICE_LENGTH);
  
  CCSprite *sprite = [CCSprite spriteWithFile:pngName];
  scale = (float)COMMAND_CHOICE_LENGTH/sprite.boundingBox.size.width;
  sprite.scale = scale;
  sprite.tag = tag;
  [_parentLayer addChild:sprite];
  [_choiceArray addObject:sprite];
  
  sprite.position = [self returnPointWithCenterPoint:centerPoint Length:beginLength degree:degree];
  CGPoint targetPoint = [self returnPointWithCenterPoint:centerPoint Length:finalLength degree:degree];
  [sprite runAction:[CCMoveTo actionWithDuration:duration position:targetPoint]];
}

-(CGPoint)returnPointWithCenterPoint:(CGPoint)centerPoint Length:(float)length degree:(float)degree {
  float radians = CC_DEGREES_TO_RADIANS(degree);
  CGPoint direction = ccpNormalize(ccp(cosf(radians), sinf(radians)));
  CGPoint point = ccpAdd(centerPoint, ccpMult(direction, length));
  
  return point;
}

-(void)hideCommandChoice {
  self.isSelected = NO;
  
  float duration = 0.1;
  CGPoint centerPoint = _baseSprite.position;
  float length = 0.5*COMMAND_BASE_LENGTH;
  
  for (CCSprite *sprite in _choiceArray) {
    CGPoint targetPoint = ccpAdd(sprite.position, ccpMult(ccpNormalize(ccpSub(centerPoint, sprite.position)), length));
    CCCallBlock *callBackBlock = [CCCallBlock actionWithBlock:^(void) {[sprite removeFromParentAndCleanup:YES];}];
    [sprite runAction:[CCSequence actions:[CCSpawn actions:[CCFadeOut actionWithDuration:duration],[CCMoveTo actionWithDuration:duration position:targetPoint], nil],callBackBlock, nil]];
  }
  
  [_choiceArray removeAllObjects];
}

#pragma mark - Info

-(BOOL)isTouchedChoiceWithPoint:(CGPoint)point {
  BOOL isTouchedAny = NO;
  float detectDisSQ = 0.5*0.5*COMMAND_CHOICE_LENGTH*COMMAND_CHOICE_LENGTH;
  
  for (CCSprite *sprite in _choiceArray) {
    if ((ccpDistanceSQ(sprite.position, point) <= detectDisSQ) == YES) {
      isTouchedAny = YES;
      break;
    }
  }
  
  return isTouchedAny;
}

-(void)triggerCommandChioceWithPoint:(CGPoint)point {
  float detectDisSQ = 0.5*0.5*COMMAND_CHOICE_LENGTH*COMMAND_CHOICE_LENGTH;
  
  for (CCSprite *sprite in _choiceArray) {
    if ((ccpDistanceSQ(sprite.position, point) <= detectDisSQ) == YES) {
      [self triggerWithCommandChoiceType:sprite.tag];
      float scale = sprite.scale;
      [sprite runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.05 scale:scale*1.1], [CCScaleTo actionWithDuration:0.05 scale:scale], nil]];
      break;
    }
  }
}

-(void)triggerWithCommandChoiceType:(CommandChoiceType)choiceType {
  NSLog(@"triggerType = %d",choiceType);
}

#pragma mark - Setup

-(void)setupCommandBaseWithParentLayer:(CCLayer *)parentL pos:(CGPoint)pos baseChioceType:(CommandChoiceType)baseChoiceType {
  _parentLayer = parentL;
  _position = pos;
  _commandChoiceType = baseChoiceType;
  
  NSString *basePngName = @"command_flag.png";
  self.baseSprite = [CCSprite spriteWithFile:basePngName];
  _baseSprite.position = pos;
  [_parentLayer addChild:_baseSprite];
  
  float scale = (float)COMMAND_BASE_LENGTH/_baseSprite.boundingBox.size.width;
  _baseSprite.scale = scale;
}

#pragma mark - Init

-(id)init {
  if ((self = [super init])) {
    self.choiceArray = [[NSMutableArray alloc]init];
  }
  return self;
}

-(void)dealloc {
  for (CCSprite *sprite in _choiceArray) [sprite removeFromParentAndCleanup:YES];
  [_choiceArray release], self.choiceArray = nil;
  [_baseSprite removeFromParentAndCleanup:YES];
  [super dealloc];
}

@end

#pragma mark - COMMAND_SPOT

@implementation CommandSpot
@synthesize baseUnitArray=_baseUnitArray;

#pragma mark - TouchEvent

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for(UITouch *touch in touches){
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector]convertToGL:point];
    [self beginLocation:point];
  }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  for(UITouch *touch in touches){
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector]convertToGL:point];
    [self updateLocation:point];
  }
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for(UITouch *touch in touches){
    CGPoint point = [touch locationInView:[touch view]];
    point = [[CCDirector sharedDirector]convertToGL:point];
    [self endLocation:point];
  }
}

-(void)beginLocation:(CGPoint)point {
  float detectDisSQ = 0.5*0.5*COMMAND_BASE_LENGTH*COMMAND_BASE_LENGTH;
  for (CommandBaseUnit *unit in _baseUnitArray) {
    BOOL isTouchedInside = (ccpDistanceSQ(unit.baseSprite.position, point) <= detectDisSQ)? YES:NO;
    
    if (unit.isSelected == NO) {
      if (isTouchedInside == YES) [unit showCommandChoice];
    } else {
      if ([unit isTouchedChoiceWithPoint:point] == YES) [unit triggerCommandChioceWithPoint:point];
      else [unit hideCommandChoice];
    }
  }
}

-(void)updateLocation:(CGPoint)point {
  
}

-(void)endLocation:(CGPoint)point {
}

#pragma mark - Setup

-(void)setupCommandSpotWithParentLayer:(CCLayer *)parentL {
  _parentLayer = parentL;
}

-(void)addCommandBaseUnit:(CommandBaseUnit *)baseUnit {
  [_baseUnitArray addObject:baseUnit];
}

#pragma mark - Init

-(id)init {
  if ((self = [super init])) {
    self.baseUnitArray = [[NSMutableArray alloc]init];
  }
  return self;
}

-(void)dealloc {
  [_baseUnitArray release], self.baseUnitArray=nil;
  [super dealloc];
}

@end
