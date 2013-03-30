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

- (id)initWithPhotoUrls:(NSArray *)photoUrls;

@end
