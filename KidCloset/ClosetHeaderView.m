//
//  ClosetHeaderView.m
//  KidCloset
//
//  Created by Patrick Ryan on 3/23/16.
//  Copyright © 2016 pjr. All rights reserved.
//

#import "ClosetHeaderView.h"
@implementation ClosetHeaderView


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
            _nameLabel.textColor = [UIColor flatWhiteColor];
        /*[_nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3]];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.numberOfLines = 1;*/
        
       /* _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/4, 40,frame.size.width/2,frame.size.height/3)];
        _sizeLabel.textAlignment = NSTextAlignmentCenter;*/
        _sizeLabel.textColor = [UIColor flatWhiteColor];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
            _nameLabel.textColor = [UIColor flatWhiteColor];
        /*[_nameLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle3]];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.numberOfLines = 1;*/
        
       /* _sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/4, 40,frame.size.width/2,frame.size.height/3)];
        _sizeLabel.textAlignment = NSTextAlignmentCenter;*/
        _sizeLabel.textColor = [UIColor flatWhiteColor];
        
    }
    return self;
}

-(void)loadArrows{
        //[_arrowRightView setBackgroundColor: [UIColor whiteColor]];
        //_arrowLeftView = [[Arrow alloc]initWithFrame:CGRectMake(0,  10, self.frame.size.height/4, 20) left:YES];
        
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
