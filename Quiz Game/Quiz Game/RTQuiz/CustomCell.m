//
//  CustomCell.m
//  RTQuiz
//
//  Created by Forthright Entertainment in 2013.
//  Copyright (c) 2013 Forthright Entertainment. All rights reserved.
//


#import "CustomCell.h"

@implementation CustomCell
@synthesize nameLabel;
@synthesize scoreLabel;
-(void)setFonts{
    [nameLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:24]];
    [scoreLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:24]];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setFonts];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
