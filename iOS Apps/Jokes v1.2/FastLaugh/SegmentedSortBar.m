//
//  SegmentedSortBar.m
//  BarcodeLibrary
//
//  Created by Konstantin Sokolinskyi on 4/5/12.
//  Copyright (c) 2012 Vision Smarts SPRL. All rights reserved.
//

#import "SegmentedSortBar.h"
#import "GUIHelper.h"
#import "DataModel.h"
#import "PurchaseEntity.h"

@interface SegmentedSortBar ()

@property (strong, nonatomic) UIButton *jokesSegmentButton;
@property (strong, nonatomic) UIButton *jokesSegmentButtonPressed;

@property (strong, nonatomic) UIButton *onelinersSegmentButton;
@property (strong, nonatomic) UIButton *onelinersSegmentButtonPressed;

@property (strong, nonatomic) UIButton *knockknockSegmentButton;
@property (strong, nonatomic) UIButton *knockknockSegmentButtonPressed;

@property (strong, nonatomic) UIButton *chucknorrisSegmentButton;
@property (strong, nonatomic) UIButton *chucknorrisSegmentButtonPressed;

@property (strong, nonatomic) UIImageView *chucknorrisPurchase;
@property (strong, nonatomic) UIImageView *onelinersPurchase;
@property (strong, nonatomic) UIImageView *knockknockPurchase;

- (UIButton*)genericButtonWithImage: (UIImage*)image title: (NSString*)title originX: (CGFloat)originX;
- (UIButton*)buttonWithImage: (UIImage*)image title: (NSString*)title originX: (CGFloat)originX  offset:(CGFloat)xShift;
- (UIButton*)selectedButtonWithImage: (UIImage*)image title: (NSString*)title originX: (CGFloat)originX  offset:(CGFloat)xShift;

- (int)selectedSegmentIndexForButton: (id)sender;
- (UIButton*)buttonForSegmentIndex: (NSInteger)index;
- (UIButton*)pressedButtonForSegmentIndex: (NSInteger)index;
- (void)invertFromPressedToNonPressedForIndex: (NSInteger)index;
- (void)invertFromNonPressedToPressedForIndex: (NSInteger)index;

- (void)btnPressed: (id)sender;


@end

@implementation SegmentedSortBar

@synthesize selectedSegmentIndex = __selectedSegmentIndex;
@synthesize delegate = __delegate;

@synthesize jokesSegmentButton = _nameSegmentButton;
@synthesize jokesSegmentButtonPressed = _nameSegmentButtonPressed;

@synthesize onelinersSegmentButton = _authorSegmentButton;
@synthesize onelinersSegmentButtonPressed = _authorSegmentButtonPressed;

@synthesize knockknockSegmentButton = _knockknockSegmentButton;
@synthesize knockknockSegmentButtonPressed = _knockknockSegmentButtonPressed;

@synthesize chucknorrisSegmentButton = _dateSegmentButton;
@synthesize chucknorrisSegmentButtonPressed = _dateSegmentButtonPressed;

@synthesize chucknorrisPurchase = _yomamaPurchase;
@synthesize onelinersPurchase = _shakespearePurchase;
@synthesize knockknockPurchase = _knockknockPurchase;

- (void)setSelectedSegmentIndex: (NSInteger)newIndex
{
    [self invertFromPressedToNonPressedForIndex: self.selectedSegmentIndex];
    __selectedSegmentIndex = newIndex;
    [self invertFromNonPressedToPressedForIndex: self.selectedSegmentIndex];
}


- (id)initWithFrame:(CGRect)frame
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        frame = CGRectMake(0, 0, 480, 66);
    }else{
        frame = CGRectMake(0, 0, 320, 44);
    }
    
    
    self = [super initWithFrame: frame];
    if (self) {
        // NORMAL
        self.jokesSegmentButton = [self buttonWithImage: [UIImage imageNamed: @"3ItemsSGLeft.png"] title: NSLocalizedString(@"Jokes", @"") originX: 0 offset: 20.0];
        
                
        self.onelinersSegmentButton = [self buttonWithImage: [UIImage imageNamed: @"3ItemsSGMiddleLeft.png"]
                                                   title: NSLocalizedString(@"One-liners", @"")
                                                 originX: [GUIHelper getRightXForView: self.jokesSegmentButton]
                                                  offset: 0.0];

        self.knockknockSegmentButton = [self buttonWithImage: [UIImage imageNamed: @"3ItemsSGMiddle.png"]
                                                      title: NSLocalizedString(@"Knock Knock", @"")
                                                    originX: [GUIHelper getRightXForView: self.onelinersSegmentButton]
                                                     offset: 0.0];

        self.chucknorrisSegmentButton = [self buttonWithImage: [UIImage imageNamed: @"3ItemsSGRight.png"]
                                                 title: NSLocalizedString(@"Tough Guy", @"")
                                               originX: [GUIHelper getRightXForView: self.knockknockSegmentButton]
                                                offset: 0.0];
        
        [self addSubview: self.jokesSegmentButton];
        [self addSubview: self.onelinersSegmentButton];
        [self addSubview: self.knockknockSegmentButton];
        [self addSubview: self.chucknorrisSegmentButton];
        
        // SELECTED
        self.jokesSegmentButtonPressed = [self selectedButtonWithImage: [UIImage imageNamed: @"3ItemsSGLeftPressed.png"] title: NSLocalizedString(@"Jokes", @"") originX: 0  offset: 10.0];
        self.onelinersSegmentButtonPressed = [self selectedButtonWithImage: [UIImage imageNamed: @"3ItemsSGMiddleLeftPressed.png"] title: NSLocalizedString(@"One-liners", @"") originX: [GUIHelper getRightXForView: self.jokesSegmentButton] offset: 0.0];
        self.knockknockSegmentButtonPressed = [self selectedButtonWithImage: [UIImage imageNamed: @"3ItemsSGMiddlePressed.png"] title: NSLocalizedString(@"Knock Knock", @"") originX: [GUIHelper getRightXForView: self.onelinersSegmentButtonPressed] offset: 0.0];
        
        self.chucknorrisSegmentButtonPressed = [self selectedButtonWithImage: [UIImage imageNamed: @"3ItemsSGRightPressed.png"] title: NSLocalizedString(@"Tough Guy", @"") originX: [GUIHelper getRightXForView: self.knockknockSegmentButtonPressed]  offset: 0.0];
    
        __selectedSegmentIndex = 1;
 
        debug(@"PACKNAME %@", [[DataModel sharedInstance] packWithIdentifier:@"com.brightnewt.fastlaughjokes.yomama_pack"].name);
        UIImage *lockedImage;
        if (![[[DataModel sharedInstance] packWithIdentifier:@"com.brightnewt.fastlaughjokes.chuck_norris"].isBought boolValue]){
            lockedImage = [UIImage imageNamed: @"cn_locked.png"];
            self.chucknorrisPurchase = [[UIImageView alloc] initWithImage: lockedImage];
           [self.chucknorrisSegmentButton addSubview: self.chucknorrisPurchase];
            //iPad
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
                self.chucknorrisPurchase.frame = CGRectMake(0, 0, 1.5*lockedImage.size.width, 1.5*lockedImage.size.height);
            }else{
               self.chucknorrisPurchase.frame = CGRectMake(0, 0, lockedImage.size.width, lockedImage.size.height);
            }
            
            
        }
        if (![[[DataModel sharedInstance] packWithIdentifier:@"com.brightnewt.fastlaughjokes.one_liners"].isBought boolValue]){
            lockedImage = [UIImage imageNamed: @"ol_locked.png"];
            self.onelinersPurchase = [[UIImageView alloc] initWithImage: lockedImage];
            [self.onelinersSegmentButton addSubview: self.onelinersPurchase];
            
            //iPad
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
                self.onelinersPurchase.frame = CGRectMake(0, 0, 1.5*lockedImage.size.width, 1.5*lockedImage.size.height);
            }else{
                self.onelinersPurchase.frame = CGRectMake(0, 0, lockedImage.size.width, lockedImage.size.height);
            }

        }
        if (![[[DataModel sharedInstance] packWithIdentifier:@"com.brightnewt.fastlaughjokes.knock_knock"].isBought boolValue]){
            lockedImage = [UIImage imageNamed: @"kk_locked.png"];
            self.knockknockPurchase = [[UIImageView alloc] initWithImage: lockedImage];
            [self.knockknockSegmentButton addSubview: self.knockknockPurchase];
            //iPad
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
                self.knockknockPurchase.frame = CGRectMake(0, 0, 1.5*lockedImage.size.width, 1.5*lockedImage.size.height);
            }else{
                self.knockknockPurchase.frame = CGRectMake(0, 0, lockedImage.size.width, lockedImage.size.height);
            }

        }

    }
    
    return self;
}



- (UIButton*)genericButtonWithImage: (UIImage*)image title: (NSString*)title originX: (CGFloat)originX
{
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        button.frame = CGRectMake(originX, 0, 1.5*image.size.width, 1.5*image.size.height);
    }
    else{
        button.frame = CGRectMake(originX, 0, image.size.width, image.size.height);
    }
    
    [button setBackgroundImage: image forState: UIControlStateNormal];
    [button setBackgroundImage: image forState: UIControlStateHighlighted];
    
    [button setTitle: title forState: UIControlStateNormal];
    return button;
}


- (UIButton*)buttonWithImage: (UIImage*)image title: (NSString*)title originX: (CGFloat)originX offset:(CGFloat)xShift
{
    UIButton *button = [self genericButtonWithImage: image title: nil originX: originX];
    [button addTarget: self action: @selector(btnPressed:) forControlEvents: UIControlEventTouchUpInside];
    UILabel *titleLabel;
    CGFloat fontSize = 12;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(xShift, 0 , button.frame.size.width - xShift, button.frame.size.height)];
        fontSize += 6;
        
    }
    else{
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(xShift, 0 , button.frame.size.width - xShift, button.frame.size.height)];
    }
    
    titleLabel.font = [UIFont fontWithName:@"Eras Bold ITC" size: fontSize];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.shadowColor = [GUIHelper defaultShadowColor];
    titleLabel.shadowOffset = [GUIHelper defaultShadowOffset];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [button addSubview: titleLabel];
    
    
    return button;
}


- (UIButton*)selectedButtonWithImage: (UIImage*)image title: (NSString*)title originX: (CGFloat)originX offset:(CGFloat)xShift
{
    UIButton *button = [self genericButtonWithImage: image title: nil originX: originX];
    UILabel *titleLabel;
    CGFloat fontSize = 12;
 
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(xShift, 0 , button.frame.size.width - xShift, button.frame.size.height)];
        fontSize += 6;
    }
    else{
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(xShift, 0 , button.frame.size.width - xShift, button.frame.size.height)];
    }
    
    titleLabel.font = [UIFont fontWithName:@"Eras Bold ITC" size: fontSize];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.shadowColor = [GUIHelper defaultShadowColor];
    titleLabel.shadowOffset = [GUIHelper defaultShadowOffset];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [button addSubview: titleLabel];
    
    return button;
}

- (NSString*) titleForSegmentAtIndex: (NSInteger)index
{
    switch ( index ) {
        case 0:
            return NSLocalizedString(@"Jokes", @"");
            break;
        case 1:
            return NSLocalizedString(@"OneLiners", @"");
            break;
        case 2:
            return NSLocalizedString(@"KnockKnock", @"");
            break;
        case 3:
            return NSLocalizedString(@"ToughGuy", @"");
            break;
            
        default:
            error(@"unknown index: %d", index);
            return nil;
    }
}


- (int)selectedSegmentIndexForButton: (id)sender
{
    if ( self.jokesSegmentButton == sender ) {
        return 0;
    }
    else if ( self.onelinersSegmentButton == sender ) {
        return 1;
    }
    else if ( self.knockknockSegmentButton == sender ) {
        return 2;
    }
    else if ( self.chucknorrisSegmentButton == sender ) {
        return 3;
    }
    else {
        error(@"unknown sender: %@", sender);
        return -1;
    }
}


- (UIButton*)buttonForSegmentIndex: (NSInteger)index
{
    
    switch ( index ) {
        case 0:
            return self.jokesSegmentButton;
            break;
        case 1:
            return  self.onelinersSegmentButton;
            break;
        case 2:
            return self.knockknockSegmentButton;
            break;
        case 3:
            return self.chucknorrisSegmentButton;
            break;
        default:
            error(@"unknown index: %d", index);
            return nil;
    }
}


- (UIButton*)pressedButtonForSegmentIndex: (NSInteger)index
{
    switch ( index ) {
        case 0:
            return self.jokesSegmentButtonPressed;
            break;
        case 1:
            return self.onelinersSegmentButtonPressed;
            break;
        case 2:
            return self.knockknockSegmentButtonPressed;
            break;
        case 3:
            return self.chucknorrisSegmentButtonPressed;
            break;
        default:
            error(@"unknown index: %d", index);
            return nil;
    }
}


- (void)invertFromPressedToNonPressedForIndex: (NSInteger)index
{
    UIButton *pressedButton = [self pressedButtonForSegmentIndex: index];
    UIButton *button = [self buttonForSegmentIndex: index];
    
    debug(@"pressedButton: %@ for index: %d", pressedButton);
    
    [pressedButton removeFromSuperview];
    [self addSubview: button];
}


- (void)invertFromNonPressedToPressedForIndex: (NSInteger)index
{
    UIButton *pressedButton = [self pressedButtonForSegmentIndex: index];
    UIButton *button = [self buttonForSegmentIndex: index];
    
    [button removeFromSuperview];
    [self addSubview: pressedButton];
}


- (void)btnPressed: (id)sender
{
    
   
    if (sender == self.chucknorrisSegmentButton){
        PurchaseEntity *pack = [[DataModel sharedInstance] packWithIdentifier:@"com.brightnewt.fastlaughjokes.chuck_norris"];
    
        if (![pack.isBought boolValue]){
            [[DataModel sharedInstance] purchasePack:pack];
            return;
        }
    }
    else if (sender == self.onelinersSegmentButton){
        PurchaseEntity *pack = [[DataModel sharedInstance] packWithIdentifier:@"com.brightnewt.fastlaughjokes.one_liners"];
        if (![pack.isBought boolValue]){
            [[DataModel sharedInstance] purchasePack:pack];
            return;
        }   
    }
    else if (sender == self.knockknockSegmentButton){
        PurchaseEntity *pack = [[DataModel sharedInstance] packWithIdentifier:@"com.brightnewt.fastlaughjokes.knock_knock"];
        if (![pack.isBought boolValue]){
            [[DataModel sharedInstance] purchasePack:pack];
            return;
        }
    }

        [self invertFromPressedToNonPressedForIndex: self.selectedSegmentIndex];
        __selectedSegmentIndex = [self selectedSegmentIndexForButton: sender];

        [self invertFromNonPressedToPressedForIndex: self.selectedSegmentIndex];
        
        [self.delegate didChangeSelectedIndex: sender];
  
    
}


- (void) updatePurchased: (PurchaseEntity* ) pack withCompletion: (void(^)(BOOL finished))block
{
    debug(@" pack %@ ", pack.name);
    if ([pack.iap_id isEqualToString: @"com.brightnewt.fastlaughjokes.chuck_norris"]){
        [self.chucknorrisPurchase removeFromSuperview];
        [self invertFromPressedToNonPressedForIndex: self.selectedSegmentIndex];
        __selectedSegmentIndex = 3;
        [self invertFromNonPressedToPressedForIndex: self.selectedSegmentIndex];
        [self.delegate didChangeSelectedIndex: self];
        
    }
    if ([pack.iap_id isEqualToString: @"com.brightnewt.fastlaughjokes.one_liners" ]){
        [self.onelinersPurchase removeFromSuperview];
         [self invertFromNonPressedToPressedForIndex: self.selectedSegmentIndex];
        [self invertFromPressedToNonPressedForIndex: self.selectedSegmentIndex];
        __selectedSegmentIndex = 1;
        [self invertFromNonPressedToPressedForIndex: self.selectedSegmentIndex];
        [self.delegate didChangeSelectedIndex: self];
        
    }
    if ([pack.iap_id isEqualToString: @"com.brightnewt.fastlaughjokes.knock_knock" ]){
        [self.knockknockPurchase removeFromSuperview];
        [self invertFromNonPressedToPressedForIndex: self.selectedSegmentIndex];
        [self invertFromPressedToNonPressedForIndex: self.selectedSegmentIndex];
        __selectedSegmentIndex = 2;
        [self invertFromNonPressedToPressedForIndex: self.selectedSegmentIndex];
        [self.delegate didChangeSelectedIndex: self];
        
    }

}

@end
