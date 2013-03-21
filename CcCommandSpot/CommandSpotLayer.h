//
//  CommandSpotLayer.h
//  CcCommandSpot
//
//  Created by Ian Fan on 16/03/13.
//
//

#import "cocos2d.h"
#import "CommandSpot.h"

@interface CommandSpotLayer : CCLayer
{
  CommandSpot *_commandSpot;
}

+(CCScene *) scene;

@end
