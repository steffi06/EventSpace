//
//  PhotoSource.h
//  FGallery
//
//  Created by Nick Lauer on 13-03-30.
//
//

#import <Foundation/Foundation.h>
#import "FGalleryViewController.h"

@interface PhotoSource : NSObject <FGalleryViewControllerDelegate>

@property (weak) FGalleryViewController *controller;
@property (strong) NSArray *photoUrls;

- (id)initWithPhotoUrls:(NSArray *)photoUrls eventId:(NSString *)eventId;

@end
