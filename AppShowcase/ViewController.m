//
//  ViewController.m
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

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/// BUTTONS ///

-(IBAction)open_gallery {
    
    UIStoryboard *gallery = [UIStoryboard storyboardWithName:@"AppShowcase" bundle:nil];
    AppShowcaseView *view = [gallery instantiateInitialViewController];
    [self presentViewController:view animated:YES completion:nil];
}

/// VIEW DID LOAD ///

-(void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

/// OTHER METHODS ///

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
