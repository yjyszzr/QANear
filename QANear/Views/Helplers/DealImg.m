//
//  DealImg.m
//  QANear
//
//  Created by zzr on 2021/11/18.
//

#import <Foundation/Foundation.h>
#import "DealImg.h"
#import "QiniuSDK.h"



@implementation MyClass
+ (NSString*)sampleCategoryMethod:(NSString*)stoken picName:(NSString*) picName uploaddata:(NSData*)uploaddata  {
        __block NSString *hashkey = nil;
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.useHttps = NO;// 是否使用https
            builder.zone = [QNFixedZone zone1];// 指定华北区域

        }];
        
        QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
        QNUploadOption *option = [[QNUploadOption alloc] initWithProgressHandler:^(NSString *key, float percent) {
            NSLog(@"progress %f", percent);
        }];
        
       // NSData *data = [uploaddata dataUsingEncoding:NSUTF8StringEncoding];
        NSString *token = stoken;
        [upManager putData:uploaddata key:picName token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"%@", info);
            NSLog(@"%@", resp);
            hashkey = [ resp objectForKey:@"status" ];
            NSLog(@"%@", hashkey);
        } option:option];
        
        return @"success";

    }

//+  s1 {
//    [SaveQuestionCommand ""  imgArr: ""  uploaddata: selectedImages picName: ""]
//   }
@end


