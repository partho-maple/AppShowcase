//
//  AppShowcaseView.h
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
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import "CustomCell.h"

// Replace 'parthobiswas' with your developer name. make sure your
// developer name is typed like the above with no spaces or capital letters.
#define DEV_NAME @"parthobiswas"

@class CustomCell;
@interface AppShowcaseView : UITableViewController <UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate> {
    
    // TableView - show the logo, labels, etc...
    IBOutlet UITableView *app_table;
    
    // JSON parsing - data storage.
    NSMutableData *response_data;
    
    // App list data - name, icon,
    // dev name, ratings and ids.
    NSArray *app_names;
    NSArray *dev_names;
    NSArray *app_icons;
    NSArray *app_ids;
    NSArray *app_ratings;
    
    // How many apps need to be shown?
    // (Automatically processed).
    NSInteger result_count;
    
    // Pull to refresh indicator.
    IBOutlet UIRefreshControl *pull_indicator;
}

// Close view method.
-(void)close;

// Data load/reload method.
-(void)refresh;

// Indicator methods.
-(void)update_indicators:(BOOL)state;

// Alert methods.
-(void)display_alert:(NSString *)alert_title :(NSString *)message;

// App logos will be cached to memory.
@property (strong ,nonatomic) NSMutableDictionary *cached_images;

@end
