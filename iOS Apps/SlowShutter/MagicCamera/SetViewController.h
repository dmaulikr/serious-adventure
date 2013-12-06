//
//  SetViewController.h
//  SnapANote
//
//  Created by Thomas on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCSwitchClone.h"

//@class MagicCameraViewController;

@interface DataCell : UITableViewCell {
	UILabel*		title;
    RCSwitchClone*  switchEnable;
    id              delegate_;
	NSUInteger      index;
    BOOL            enable;
}

@property (nonatomic, retain) UILabel*      title;
@property (nonatomic) NSUInteger	index;
@property (nonatomic) BOOL          enable;

- (void) setDelegate:(id)delegate;
- (void)setInfo:(NSString*)str OPTION:(BOOL)option INDEX:(int)idx;
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier INDEX:(int)idx;
@end

@interface SegmentCell : UITableViewCell {
	UILabel*		title;
    UISegmentedControl* segmentCtrl;
    id              delegate_;
	NSUInteger      index;
}

@property (nonatomic, retain) UILabel*      title;
@property (nonatomic, retain) UISegmentedControl* segmentCtrl;
@property (nonatomic) NSUInteger	index;

- (void) setDelegate:(id)delegate;
- (void)setInfo:(NSString*)str INDEX:(int)idx;
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier INDEX:(int)idx;
@end

@interface SetViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> 
{
//    MagicCameraViewController* delegate;
    IBOutlet UIBarButtonItem*   btnSave;
    IBOutlet UIBarButtonItem*   btnCancel;
    IBOutlet UITableView*       tblSetting;

    BOOL                        fSetStoreImage;
    
    BOOL                        fExposureAdjust;
    BOOL                        fExposureLock;
    BOOL                        fScreenShutter;
    BOOL                        fAutoSave;
    int                         selftimer;
    int                         selftimerIndex;
    NSString*                   strSetRecipient;
	UITextField*                txtRecipient;
    BOOL                        ftableinit;
}

//@property(nonatomic,retain)MagicCameraViewController* delegate;
@property(nonatomic,retain)NSString* strSetRecipient;
@property(nonatomic)BOOL fExposureAdjust;
@property(nonatomic)BOOL fExposureLock;
@property(nonatomic)BOOL fScreenShutter;
@property(nonatomic)BOOL fAutoSave;
@property(nonatomic)int  selftimer;

- (IBAction) onSave;
- (IBAction) onCancel;
- (void) setOption:(int)index OPTION:(BOOL)option;
- (void) setEmailText:(NSString*)str;
- (void) animateTextField:(BOOL) up;
- (void) checkEmailAddres:(NSString*)ea;

@end
