//
//  AppShowcaseView.m
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

#import "AppShowcaseView.h"

@interface AppShowcaseView ()

@end

@implementation AppShowcaseView

/// VIEW DID LOAD ///

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Link the pull to refresh to the refresh method.
    [pull_indicator addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    // Set the pull to refresh indicator info text.
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Pull to Refresh" attributes:attributes];
    pull_indicator.attributedTitle = [[NSAttributedString alloc] initWithAttributedString:title];
    
    // Initilise the app logo image cache.
    self.cached_images = [[NSMutableDictionary alloc] init];
    
    // Create the 'Done' button.
    UIBarButtonItem *right_button = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    
    // Set the button colour.
    [right_button setTintColor:[UIColor whiteColor]];
    
    // Set the 'Done' button as the right
    // button on the navigation controller.
    self.navigationItem.rightBarButtonItem = right_button;
    
    // Set the table view indicator colour.
    [app_table setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    // Start loading the data.
    [self refresh];
}

/// CLOSE VIEW METHOD ///

-(void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// DATA LOAD/RELOAD METHOD ///

-(void)refresh {
    
    // Start loading indicators.
    [self update_indicators:YES];
    
    // Setup the JSON url and download the data on request.
    NSString *link = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&country=us&entity=software", DEV_NAME];
    NSURLRequest *the_request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    NSURLConnection *the_connection = [[NSURLConnection alloc] initWithRequest:the_request delegate:self];
    
    if (the_connection) {
        response_data = [[NSMutableData alloc] init];
    }
}

/// INDICATOR METHODS ///

-(void)update_indicators:(BOOL)state {
    
    // Start or stop the indicators depending
    // on the passed in loading state.
    
    if (state == YES) {
        
        // Start the loading indicators.
        [pull_indicator beginRefreshing];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    else if (state == NO) {
        
        // Stop the loading indicators.
        [pull_indicator endRefreshing];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

/// ALERT METHODS ///

-(void)display_alert:(NSString *)alert_title :(NSString *)message {
    
    // Display the info alert.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alert_title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the alert actions.
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    // Add the action and present the alert.
    [alert addAction:dismiss];
    [self presentViewController:alert animated:YES completion:nil];
}

/// CONNECTION DELEGATE METHODS ///

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // Stop loading indicators.
    [self update_indicators:NO];
    
    // Get the error message.
    NSString *error_msg = [NSString stringWithFormat:@"Failed: %@", [error description]];
    
    // Display the error alert.
    [self display_alert:@"Error" :error_msg];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [response_data setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [response_data appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // Parse the downloaded JSON data.
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response_data options:NSJSONReadingMutableLeaves error:&error];
    
    // Store how many apps need to be loaded.
    result_count = [[dict valueForKey:@"resultCount"] integerValue];

    // Store the app data - name, icon, etc...
    app_names = [[dict objectForKey:@"results"] valueForKey:@"trackName"];
    dev_names = [[dict objectForKey:@"results"] valueForKey:@"sellerName"];
    app_icons = [[dict objectForKey:@"results"] valueForKey:@"artworkUrl512"];
    app_ids = [[dict objectForKey:@"results"] valueForKey:@"trackId"];
    app_ratings = [[dict objectForKey:@"results"] valueForKey:@"averageUserRating"];
    
    // Stop loading indicators.
    [self update_indicators:NO];
    
    // Data is now saved locally so lets
    // load it into the app table view.
    [app_table reloadData];
}

/// UITABLEVIEW METHODS ///

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Start loading indicators.
    [self update_indicators:YES];
    
    // Get the selected cell App ID.
    NSString *app_id = [NSString stringWithFormat:@"%@", app_ids[indexPath.row]];
    
    // Setup the store view controller.
    SKStoreProductViewController *store_view = [[SKStoreProductViewController alloc] init];
    [store_view setDelegate:self];
    
    // Run the store view controller.
    [store_view loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : app_id} completionBlock:^(BOOL result, NSError *error) {
        
        // Check if an error has occured otherwise
        // display the store view controller.
        
        if (error) {
            
            // Hide the table view cell selection.
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            // Stop loading indicators.
            [self update_indicators:NO];
            
            // Display the error alert.
            [self display_alert:@"Error" :[NSString stringWithFormat:@"%@", error.description]];
        }
        
        else {
            
            // Display the store view controller.
            [self presentViewController:store_view animated:YES completion:^{
                
                // Hide the table view cell selection.
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                // Stop loading indicators.
                [self update_indicators:NO];
            }];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Delegate call back for cell at index path.
    static NSString *CellIdentifier = @"Cell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Set the intial image state
    // to display no picture.
    cell.logo_image.image = nil;
    
    // Set the labels - name, info, etc...
    cell.name_label.text = [NSString stringWithFormat:@"%@", app_names[indexPath.row]];
    cell.dev_label.text = [NSString stringWithFormat:@"%@", dev_names[indexPath.row]];
    
    // Set the rating stars to the correct number
    // and then show the stars.
    NSInteger rating;
    
    if (![app_ratings[indexPath.row] isKindOfClass:[NSNull class]]) {
        
        // Get the app rating number.
        rating = [app_ratings[indexPath.row] integerValue];
        
        // Show the appropriate number of star
        // images depending on the user rating.
        
        for (int loop = 0; loop <= rating; loop++) {
            
            switch (loop) {
                    
                case 1: cell.star_1.alpha = 1.0; break;
                case 2: cell.star_2.alpha = 1.0; break;
                case 3: cell.star_3.alpha = 1.0; break;
                case 4: cell.star_4.alpha = 1.0; break;
                case 5: cell.star_5.alpha = 1.0; break;
                    
                default: break;
            }
        }
    }
    
    // Set the app logo in the imageview. We will also be caching
    // the images in asynchronously so that there is no image
    // flickering issues and so the UITableView uns smoothly
    // while being scrolled.
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];
    
    if ([self.cached_images objectForKey:identifier] != nil) {
        cell.logo_image.image = [self.cached_images valueForKey:identifier];
    }
    
    else {
        
        // Download the app image in a background thread.
        dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
        dispatch_async(downloadQueue, ^{
            
            // Get the app icon image url.
            NSURL *image_url =[NSURL URLWithString:[NSString stringWithFormat:@"%@", app_icons[indexPath.row]]];
            
            // Download the image data.
            NSData *data = [NSData dataWithContentsOfURL:image_url];
            
            // Perform the UI updates on the main thread.
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Set the image in the image view.
                UIImage *image = [UIImage imageWithData:data];
                [cell.logo_image setImage:image];
                
                // Save the image to cache.
                [self.cached_images setValue:image forKey:identifier];
                cell.logo_image.image = [self.cached_images valueForKey:identifier];
                
                // Content has been loaded into the cell, so stop
                // the activity indicator from spinning.
                [cell.logo_active stopAnimating];
            });
        });
    }
    
    // Apply image boarder effects. It looks
    // much nicer with rounded corners. You can
    // also apply other effect too if you wish.
    [cell.logo_image.layer setCornerRadius:16.0];
    
    // Set the background colour.
    [cell setBackgroundColor:[UIColor clearColor]];
    
    // Set the cell selected background colour.
    UIView *background_view = [[UIView alloc] initWithFrame:cell.frame];
    background_view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
    cell.selectedBackgroundView = background_view;
    
    // Set the content restraints. Keep things in place
    // otherwise the image/labels dont seem to appear in
    // the correct position on the cell.
    cell.logo_image.clipsToBounds = YES;
    cell.name_label.clipsToBounds = YES;
    cell.dev_label.clipsToBounds = YES;
    cell.star_1.clipsToBounds = YES;
    cell.star_2.clipsToBounds = YES;
    cell.star_3.clipsToBounds = YES;
    cell.star_4.clipsToBounds = YES;
    cell.star_5.clipsToBounds = YES;
    cell.logo_active.clipsToBounds = YES;
    cell.contentView.clipsToBounds = NO;
    
    return cell;
}

-(CGFloat)tableView :(UITableView *)tableView heightForRowAtIndexPath :(NSIndexPath *)indexPath {
    return 116;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return result_count;
}

/// STORE VIEW METHODS ///

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// OTHER METHODS ///

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
