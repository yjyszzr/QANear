//
//  QNUploadServer.m
//  AppTest
//
//  Created by yangsen on 2020/4/23.
//  Copyright © 2020 com.qiniu. All rights reserved.
//

#import "QNUploadServer.h"

@interface QNUploadServer()

@property(nonatomic,  copy)NSString *ip;
@property(nonatomic,  copy)NSString *host;
@property(nonatomic,  copy)NSString *source;
@property(nonatomic,strong)NSNumber *ipPrefetchedTime;

@end
@implementation QNUploadServer
@synthesize httpVersion;

+ (instancetype)server:(NSString *)host
                    ip:(NSString *)ip
                source:(NSString *)source
      ipPrefetchedTime:(NSNumber *)ipPrefetchedTime{
    QNUploadServer *server = [[QNUploadServer alloc] init];
    server.ip = ip;
    server.host = host;
    server.source = source ?: @"none";
    server.httpVersion = kQNHttpVersion2;
    server.ipPrefetchedTime = ipPrefetchedTime;
    return server;
}

- (NSString *)serverId {
    return [self.host copy];
}

@end
