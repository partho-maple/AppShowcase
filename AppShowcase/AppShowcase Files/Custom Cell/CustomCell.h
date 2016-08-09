//
//  CustomCell.h
//  AppShowcase
//
//  Created by Partho Biswas on 16/08/2014.
//  Copyright (c) 2014 Partho Biswas. All rights reserved.
//

/*************************************************************
 * IMPORTANT NOTE:                                           *
 * This application has been designed for iOS 8 and higher,  *
 * some of the functionality of this application will NOT    *
 * work with lower versions of iOS.                          *
 *                                                           *
 * If you need any help, please send me an email:            *
 *                                                           *
 * partho.maple@gmail.com                                    *
 *************************************************************/

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell {
    
}

// Name/dev labels.
@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UILabel *dev_label;

// App logo image.
@property (strong, nonatomic) IBOutlet UIImageView *logo_image;

// Rating stars.
@property (strong, nonatomic) IBOutlet UIImageView *star_1;
@property (strong, nonatomic) IBOutlet UIImageView *star_2;
@property (strong, nonatomic) IBOutlet UIImageView *star_3;
@property (strong, nonatomic) IBOutlet UIImageView *star_4;
@property (strong, nonatomic) IBOutlet UIImageView *star_5;

// Image activity indictor.
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *logo_active;

@end
