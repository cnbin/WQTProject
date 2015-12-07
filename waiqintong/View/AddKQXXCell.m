//
//  SaveUserLocationCell.m
//  waiqintong
//
//  Created by Apple on 11/14/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "AddKQXXCell.h"

@implementation AddKQXXCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.latitudeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 40, 15)];
        self.latitudeTextLabel.text = @"纬度";
        self.latitudeTextLabel.font =  [UIFont fontWithName:@"Helvetica" size:10];
        
        self.longitudeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, 40, 15)];
        self.longitudeTextLabel.text = @"经度";
        self.longitudeTextLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        
        self.timeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 30, 15)];
        self.timeTextLabel.text = @"时间";
        self.timeTextLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        
        [self.contentView addSubview:self.latitudeTextLabel];
        [self.contentView addSubview:self.longitudeTextLabel];
        [self.contentView addSubview:self.timeTextLabel];
        
        self.latitudeLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 5, 200, 15)];
        self.latitudeLabel.font =  [UIFont fontWithName:@"Helvetica" size:10];
        
        self.longitudeLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 25, 200, 15)];
        self.longitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 45, 200, 15)];
        self.timeLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        
        UIImage *imageSelected = [UIImage imageNamed:@"buttonSelected"];
        self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(280 ,15, 30, 30)];
       
        [self.doneButton setImage:imageSelected forState:UIControlStateSelected];
        [self.doneButton setImage:imageSelected forState:UIControlStateHighlighted];

        [self.contentView addSubview:self.latitudeLabel];
        [self.contentView addSubview:self.longitudeLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.doneButton];
    }
    
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
