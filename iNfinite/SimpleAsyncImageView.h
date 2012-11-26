//
//  SimpleAsyncImageView.h
//  iNfinite
//
//  Created by Baker, Phillip on 11/26/12.
//  Copyright (c) 2012 phillbaker. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class SimpleAsyncImageView;
//
//@protocol SimpleAsyncImageViewDelegate <NSObject>
//
//- (void)imageDidLoad;
//
//@end

@interface SimpleAsyncImageView : UIImageView <NSURLConnectionDelegate>

@property (nonatomic, retain) NSMutableData *download;
@property (nonatomic, retain) NSURLConnection *connection;

- (void)startDownloadWithURL:(NSURL*)url onSuccess:(void(^)(UIImage *image))success;
- (void)cancelDownload;

@end
