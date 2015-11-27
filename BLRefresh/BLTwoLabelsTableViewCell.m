//
//  BLTwoLabelsTableViewCell.m
//  BLRefresh
//
//  Created by wangqiang li on 11/27/15.
//  Copyright © 2015 personal. All rights reserved.
//

#import "BLTwoLabelsTableViewCell.h"

@interface BLTwoLabelsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@end

@implementation BLTwoLabelsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self randomFont];
}

- (void)prepareForReuse
{
   [self randomFont];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)randomFont
{
    NSArray *bigFonts = @[UIFontTextStyleHeadline, UIFontTextStyleBody, UIFontTextStyleSubheadline];
    NSArray *smallFonts = @[UIFontTextStyleCaption1, UIFontTextStyleCaption2, UIFontTextStyleFootnote];
    int bigFontStyleIndex = arc4random_uniform((u_int32_t)bigFonts.count);
    int smallFontStyleIndex = arc4random_uniform((u_int32_t)smallFonts.count);
    UIFont *bigFont = [UIFont preferredFontForTextStyle:[bigFonts objectAtIndex:bigFontStyleIndex]];
    UIFont *smallFont = [UIFont preferredFontForTextStyle:[smallFonts objectAtIndex:smallFontStyleIndex]];
    self.firstLabel.font = bigFont;
    self.secondLabel.font = smallFont;
}

- (CGFloat)myheight
{
    return self.bounds.size.height;
}

@end
