//
//  LogoLayer.h
//  Super Mouse World
//
//  Created by Lion User on 3/20/13.
//  Copyright (c) 2013 Thetis Games. All rights reserved.
//

#import "CCScene.h"
#import "GrowButton.h"
#import "CCLabelAtlas.h"

@interface StoreLayer : CCScene< UIAlertViewDelegate >{
    
    GrowButton *m_btnSelected;
    int     m_nSelected;
    
    UIAlertView *changePlayerAlert;
    
    CCLabelAtlas    *_lblCoinCount;
    
}

@property ( nonatomic, retain ) CCLabelAtlas    *lblCoinCount;

@end
