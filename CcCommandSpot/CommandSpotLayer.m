//
//  CommandSpotLayer.m
//  CcCommandSpot
//
//  Created by Ian Fan on 16/03/13.
//
//

#import "CommandSpotLayer.h"

@implementation CommandSpotLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	CommandSpotLayer *layer = [CommandSpotLayer node];
	[scene addChild: layer];
	
	return scene;
}

#pragma mark -
#pragma mark Touch Event

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_commandSpot ccTouchesBegan:touches withEvent:event];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [_commandSpot ccTouchesMoved:touches withEvent:event];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[_commandSpot ccTouchesEnded:touches withEvent:event];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
  [self ccTouchEnded:touch withEvent:event];
}

-(void)setupCommandSpot {
  CGSize winSize = [CCDirector sharedDirector].winSize;
  
  _commandSpot = [[CommandSpot alloc]init];
  [_commandSpot setupCommandSpotWithParentLayer:self];
  
  {
  CommandBaseUnit *unit = [[[CommandBaseUnit alloc]init]autorelease];
  [unit setupCommandBaseWithParentLayer:self pos:ccp(winSize.width/4, winSize.height/2) baseChioceType:CommandChoiceType_Base];
  [_commandSpot addCommandBaseUnit:unit];
  }
  
  {
  CommandBaseUnit *unit = [[[CommandBaseUnit alloc]init]autorelease];
  [unit setupCommandBaseWithParentLayer:self pos:ccp(winSize.width*3/4, winSize.height/2) baseChioceType:CommandChoiceType_Base];
  [_commandSpot addCommandBaseUnit:unit];
  }
}

#pragma mark - Init

-(id)init {
  if ((self = [super init])) {
    
    [self setupCommandSpot];
    
    self.isTouchEnabled = YES;
  }
  
  return self;
}

- (void) dealloc {
  [_commandSpot release];
  
	[super dealloc];
}

@end
