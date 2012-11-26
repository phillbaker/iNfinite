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

- (void)startDownloadWithURL:(NSURL*)url onSuccess:(void (^)(UIImage *image))success {
    self.download = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:10.0];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request
                                                            delegate:self
                                                    startImmediately:NO];

    [conn scheduleInRunLoop:[NSRunLoop currentRunLoop]
                    forMode:NSRunLoopCommonModes];
    [conn start];

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
    
    // Clean up
    self.download = nil;
    self.connection = nil;
}


@end
