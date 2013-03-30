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
@property (strong) NSString *eventId;
@end

@implementation PhotoSource

- (id)initWithPhotoUrls:(NSArray *)photoUrls eventId:(NSString *)eventId {
    if (self = [super init]) {
        self.photoUrls = photoUrls;
        self.eventId = eventId;
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

- (void)reloadImages {
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"eventId" equalTo:self.eventId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *urls = [[NSMutableArray alloc] initWithCapacity:objects.count];
        for (PFObject *object in objects) {
            [urls addObject:[object objectForKey:@"url"]];
        }

        if (urls.count > self.photoUrls.count) {
            self.photoUrls = urls;
            [self.controller reloadGallery];
        }
    }];
}

@end
