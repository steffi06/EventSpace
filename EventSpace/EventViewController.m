//
//  EventViewController.m
//  EventSpace
//
//  Created by Stephanie Shupe on 3/30/13.
//  Copyright (c) 2013 EventSpace, Inc. All rights reserved.
//

#import "EventViewController.h"
#import <Parse/Parse.h>
#import "PhotoSource.h"
#import "FGalleryViewController.h"

@interface EventViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventPasswordTextField;
@property (strong) PhotoSource *source;
- (IBAction)submitButton:(id)sender;

@end

@implementation EventViewController

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
    [self.eventNameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButton:(id)sender {
    if ([self.title isEqualToString:@"Create Event"]) {
        NSString *eventName = self.eventNameTextField.text;
        NSString *eventPassword = self.eventPasswordTextField.text;

        PFObject *event = [PFObject objectWithClassName:@"Event"];
        event[@"name"] = eventName;
        event[@"password"] = eventPassword;
        
        if (eventName.length > 0 && eventPassword > 0) {
            [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self signedInWithEventId:event.objectId];
                    
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
                                                                        message:@"An error occurred. Please try to create your event again if you have a network connection."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        }
        
    } else {
        PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
        [eventQuery whereKey:@"name" equalTo:self.eventNameTextField.text];
        [eventQuery whereKey:@"password" equalTo:self.eventPasswordTextField.text];
        [eventQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (object) {
                NSLog(@"object id: %@", object.objectId);
                [self signedInWithEventId:object.objectId];    
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uh Oh!"
                                                                    message:@"We couldn't find your event. Please try to join your event again if you have a network connection."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];

            }
        }];
    }
}

- (void)signedInWithEventId:(NSString *)eventId {
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"eventId" equalTo:eventId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *urls = [[NSMutableArray alloc] initWithCapacity:objects.count];
        for (PFObject *object in objects) {
            [urls addObject:[object objectForKey:@"url"]];
        }
        self.source = [[PhotoSource alloc] initWithPhotoUrls:urls eventId:eventId];
        FGalleryViewController *controller = [[FGalleryViewController alloc] initWithPhotoSource:self.source barItems:[[NSArray alloc] init]];
        controller.eventId = eventId;
        controller.beginsInThumbnailView = YES;
        self.source.controller = controller;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self.navigationController presentViewController:navController animated:YES completion:nil];
    }];
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.eventPasswordTextField becomeFirstResponder];
    } else {
        [self submitButton:nil];
    }
    return YES;
}

@end
