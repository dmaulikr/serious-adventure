//
//  InsultEntity.h
//  FastLaugh
//
//  Created by Konstantin Sokolinskyi on 6/20/12.
//  Copyright (c) 2012 BrightNewt Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InsultEntity : NSManagedObject

@property (nonatomic, retain) NSString *insult;
@property (nonatomic, retain) NSNumber *showCount;
@property (nonatomic, retain) NSManagedObject *category;

- (void)incShowCount;

@end
