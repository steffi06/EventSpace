//
//  WelcomeViewController.m
//  EventSpace
//
//  Created by Stephanie Shupe on 3/30/13.
//  Copyright (c) 2013 EventSpace, Inc. All rights reserved.
//

#import "WelcomeViewController.h"
#import "EventViewController.h"
#import <Parse/Parse.h>

@interface WelcomeViewController ()
- (IBAction)joinEvent:(id)sender;
- (IBAction)createEvent:(id)sender;
@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)joinEvent:(id)sender {
    EventViewController *joinEventViewController = [[EventViewController alloc] init];
    joinEventViewController.title = @"Join Event";
    [self.navigationController pushViewController:joinEventViewController animated:YES];
}

- (IBAction)createEvent:(id)sender {
    EventViewController *createEventViewController = [[EventViewController alloc] init];
    createEventViewController.title = @"Create Event";
    [self.navigationController pushViewController:createEventViewController animated:YES];
}
@end
