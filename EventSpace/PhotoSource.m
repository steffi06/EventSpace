//
//  PhotoSource.m
//  FGallery
//
//  Created by Nick Lauer on 13-03-30.
//
//

#import "PhotoSource.h"
#import <Parse/Parse.h>

@interface PhotoSource ()
@end

@implementation PhotoSource

- (id)initWithPhotoUrls:(NSArray *)photoUrls {
    if (self = [super init]) {
        self.photoUrls = photoUrls;
    }

    return self;
}

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController*)gallery {
    return [self.photoUrls count];
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery
              sourceTypeForPhotoAtIndex:(NSUInteger)index {
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index; {
    return [self.photoUrls objectAtIndex:index];
}

@end
