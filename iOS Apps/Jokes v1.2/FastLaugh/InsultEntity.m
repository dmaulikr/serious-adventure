//
//  InsultEntity.m
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 6/20/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import "InsultEntity.h"


@implementation InsultEntity

@dynamic insult;
@dynamic showCount;
@dynamic category;

- (void)incShowCount
{
    self.showCount = [NSNumber numberWithInt: [self.showCount intValue] + 1];
}

@end
