//
//  MainMenu.h
//  Super Mouse World
//
//  Created by Luiz Menezes on 29/10/12.
//  Copyright (c) 2012 Thetis Games. All rights reserved.
//

#import "CCScene.h"
#import "GrowIconButton.h"

@interface MainMenu : CCScene
{
    
    GrowIconButton *_btnSound;
	GrowIconButton *_btnEffect;

}

@property(nonatomic, retain) GrowIconButton *btnSound;
@property(nonatomic, retain) GrowIconButton *btnEffect;


+(CCScene *) scene;
@end
