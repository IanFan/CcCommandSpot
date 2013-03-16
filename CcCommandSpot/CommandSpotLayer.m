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

#pragma mark - Init

-(id)init {
  if ((self = [super init])) {
    
    self.isTouchEnabled = YES;
  }
  
  return self;
}

- (void) dealloc {
  
	[super dealloc];
}

@end
