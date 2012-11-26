//
//  SimpleAsyncImageView.m
//  iNfinite
//
//  Created by Baker, Phillip on 11/26/12.
//  Copyright (c) 2012 phillbaker. All rights reserved.
//

#import "SimpleAsyncImageView.h"

@implementation SimpleAsyncImageView {
    void (^_onSuccess)(UIImage * image);
}

@synthesize download = _download;
@synthesize connection = _connection;

//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void)startDownloadWithURL:(NSURL*)url onSuccess:(void (^)(UIImage *image))success {
    self.download = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request
                                                            delegate:self
                                                    startImmediately:YES];

    if(!conn) {
        NSLog(@"download - failed");
    }
    NSLog(@"starting downlaod: %@", conn);
    self.connection = conn;
    _onSuccess = success;
}

- (void)cancelDownload {
    [self.connection cancel];
    self.connection = nil;
    self.download = nil;
    NSLog(@"cancel download");
}

#pragma mark -
#pragma mark NSURLConnectionDelegate
#pragma mark -

//-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
     NSLog(@"received response: %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"appending download");
    [self.download appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Reset for a retry
    self.download = nil;
    self.connection = nil;
    NSLog(@"failed download");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Use the image and clear the temporary data
    NSLog(@"finisehd download");
    UIImage *image = [[UIImage alloc] initWithData:self.download];
    _onSuccess(image);
    
    // Use the image
//    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize) {
//        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
//        UIGraphicsBeginImageContext(itemSize);
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//        [image drawInRect:imageRect];
//        self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    else {
//        self.appRecord.appIcon = image;
//    }
    
    
    // Clean up
    self.download = nil;
    self.connection = nil;
    
    // call our delegate and tell it that our icon is ready for display
//    [delegate appImageDidLoad:self.indexPathInTableView];
}


@end
