//
//  LogoLayer.h
//  Super Mouse World
//
//  Created by Lion User on 3/20/13.
//  Copyright (c) 2013 Thetis Games. All rights reserved.
//

#import "CCScene.h"
#import "GrowButton.h"

@interface CoinShopLayer : CCScene{
 
    GrowButton*     m_btnCoin;
    int             m_nSelected;
    CCLabelAtlas    *_lblCoinCount;
}

@property ( nonatomic, retain ) CCLabelAtlas    *lblCoinCount;

@property ( nonatomic, retain )  GrowButton*     m_btnCoin;

@end
