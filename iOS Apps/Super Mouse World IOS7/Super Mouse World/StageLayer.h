//
//  LogoLayer.h
//  Mighty Possum World
//
//  Created by Lion User on 3/20/13.
//  Copyright (c) 2013 Thetis Games. All rights reserved.
//

#import "CCScene.h"
#import "GrowButton.h"

@interface StageLayer : CCScene{

    GrowButton  *m_btnStage;
    int     m_nSelected;
    
    CCLabelAtlas    *_lblCoinCount;
}

@property ( nonatomic, retain ) CCLabelAtlas    *lblCoinCount;

@end
