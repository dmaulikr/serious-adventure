//
//  AleartWaitWindow.h
//  MagicCamera
//
//  Created by star com on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AleartWaitView : UIView {
    UILabel *                   msg_label;
    UIActivityIndicatorView *   processing_indicator;
}

- (void)setMessage:(NSString *)megString;

@end

