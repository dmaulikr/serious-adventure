//
//  ShakingWindow.m
//  InsultShake
//
//  Created by Konstantin Sokolinskyi on 6/16/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import "ShakingWindow.h"

@implementation ShakingWindow

- ( void ) motionEnded: ( UIEventSubtype ) motion withEvent: ( UIEvent * ) event;
{
	debug( @"shaking gesture detected" );
	if ( motion == UIEventSubtypeMotionShake )
	{
        debug(@"Shaken");
        [[NSNotificationCenter defaultCenter] postNotificationName: @"DID_SHAKE_NOTIFICATION"
															object: self];
	}
}



@end
