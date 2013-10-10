//
//  SegmentedSortBar.h
//  BarcodeLibrary
//
//  Created by Konstantin Sokolinskyi on 4/5/12.
//  Copyright (c) 2012 Vision Smarts SPRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseEntity.h"
@class SegmentedSortBar;


@protocol SegmentedSortBarDelegate <NSObject>

- (void)didChangeSelectedIndex: (SegmentedSortBar*)sender;
//- (void)didPurchasePack: (PurchaseEntity*)sender;


@end


@interface SegmentedSortBar : UIView

@property (assign, nonatomic) NSInteger selectedSegmentIndex;
@property (strong, nonatomic) id<SegmentedSortBarDelegate> delegate;

- (NSString*) titleForSegmentAtIndex: (NSInteger)index;
- (void) updatePurchased: (PurchaseEntity* ) pack withCompletion: (void(^)(BOOL finished))block;

@end
