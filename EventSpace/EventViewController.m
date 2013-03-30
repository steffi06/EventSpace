//
//  EventViewController.m
//  EventSpace
//
//  Created by Stephanie Shupe on 3/30/13.
//  Copyright (c) 2013 EventSpace, Inc. All rights reserved.
//

#import "EventViewController.h"
#import <Parse/Parse.h>

@interface EventViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *eventPasswordTextField;
@property (strong) NSString *eventID;
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
                    // TO DO:
                    // go to collection view of images
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
                self.eventID = object.objectId;
                // TO DO:
                // send object.objectId to new view controller
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController
                                   animated:YES
                                 completion:nil];
                
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.eventPasswordTextField becomeFirstResponder];
    } else {
        [self submitButton:nil];
    }
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *data = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithData:data];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *photo = [PFObject objectWithClassName:@"Photo"];
            photo[@"eventId"] = self.eventID;
            photo[@"url"] = imageFile.url;
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Success!");
                }
                if (error) {
                    NSLog(@"error: %@",error);
                }
            }];
        }
    }];
}

@end
