
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
  CommandChoiceType_None,
  CommandChoiceType_Base,
  CommandChoiceType_Spearman,
  CommandChoiceType_Footman,
  CommandChoiceType_Knight,
  CommandChoiceType_Archer,
} CommandChoiceType;

#pragma mark - COMMAND_BASE_UNIT
@protocol CommandBaseUnitDelegate;

@interface CommandBaseUnit : NSObject
{
  CCLayer *_parentLayer;
}

@property BOOL isSelected;
@property CommandChoiceType commandChoiceType;
@property CGPoint position;
@property CGRect frame;

@property (nonatomic,assign) NSMutableArray *choiceArray;
@property (nonatomic,assign) CCSprite *baseSprite;
@property (nonatomic,assign) CCSprite *tickSprite;

-(void)setupCommandBaseWithParentLayer:(CCLayer*)parentL pos:(CGPoint)pos baseChioceType:(CommandChoiceType)baseChoiceType;

//Control
-(void)showCommandChoice;
-(void)hideCommandChoice;

//Info
-(BOOL)isTouchedChoiceWithPoint:(CGPoint)point;

@end

#pragma mark - COMMAND_SPOT

@interface CommandSpot : NSObject
{
  CCLayer *_parentLayer;
}

@property (nonatomic,retain) NSMutableArray *baseUnitArray;
@property (nonatomic,assign) CommandBaseUnit *touchedUnit;

-(void)setupCommandSpotWithParentLayer:(CCLayer*)parentL;
-(void)addCommandBaseUnit:(CommandBaseUnit*)baseUnit;

//TouchEvent
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
