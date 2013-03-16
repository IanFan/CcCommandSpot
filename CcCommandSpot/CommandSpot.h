
//
//  CommandSpot.h
//  CcCommandSpot
//
//  Created by Ian Fan on 16/03/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
  CommandChoiceType_Base,
  CommandChoiceType_Spearman,
  CommandChoiceType_Footman,
  CommandChoiceType_Knight,
  CommandChoiceType_Archer,
} CommandChoiceType;

@interface CommandBaseUnit : NSObject
{
  CCLayer *_parentLayer;
}

@property CGPoint position;
@property CGRect frame;
@property BOOL isSelected;
@property (nonatomic,assign) NSMutableArray *choiceSpriteArray;
@property (nonatomic,assign) CCSprite *baseSprite;
@property (nonatomic,assign) CCSprite *tickSprite;

-(void)setupCommandBaseWithParentLayer:(CCLayer*)parentL pos:(CGPoint)pos baseChioceType:(CommandChoiceType)baseChoiceType;

//setup standard choice
-(void)setupStandardChoiceWithIsSpearman:(BOOL)isSpearman isFootman:(BOOL)isFootman isKnight:(BOOL)isKnight isArcher:(BOOL)isArcher;

//-(void)setupStandardFormationWithIsLeftObliq

//setup customized choice
-(void)addChoiceWithChoiceType:(CommandChoiceType)chioceType choicePos:(int)choicePos;

@end

@interface CommandSpot : NSObject
{
  CCLayer *_parentLayer;
}

@end
