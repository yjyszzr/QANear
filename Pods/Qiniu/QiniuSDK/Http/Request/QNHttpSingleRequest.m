//
//  QNHttpRequest+SingleRequestRetry.m
//  QiniuSDK
//
//  Created by yangsen on 2020/4/29.
//  Copyright © 2020 Qiniu. All rights reserved.
//

#import "QNDefine.h"
#import "QNAsyncRun.h"
#import "QNVersion.h"
#import "QNUtils.h"
#import "QNLogUtil.h"
#import "QNHttpSingleRequest.h"
#import "QNConfiguration.h"
#import "QNUploadOption.h"
#import "QNUpToken.h"
#import "QNResponseInfo.h"
#import "QNNetworkStatusManager.h"
#import "QNRequestClient.h"
#import "QNUploadRequestState.h"

#import "QNConnectChecker.h"
#import "QNDnsPrefetch.h"

#import "QNReportItem.h"

#import "QNUploadSystemClient.h"
#import "NSURLRequest+QNRequest.h"



@interface QNHttpSingleRequest()

@property(nonatomic, assign)int currentRetryTime;
@property(nonatomic, strong)QNConfiguration *config;
@property(nonatomic, strong)QNUploadOption *uploadOption;
@property(nonatomic, strong)QNUpToken *token;
@property(nonatomic, strong)QNUploadRequestInfo *requestInfo;
@property(nonatomic, strong)QNUploadRequestState *requestState;

@property(nonatomic, strong)NSMutableArray <QNUploadSingleRequestMetrics *> *requestMetricsList;

@property(nonatomic, strong)id <QNRequestClient> client;

@end
@implementation QNHttpSingleRequest

- (instancetype)initWithConfig:(QNConfiguration *)config
                  uploadOption:(QNUploadOption *)uploadOption
                         token:(QNUpToken *)token
                   requestInfo:(QNUploadRequestInfo *)requestInfo
                  requestState:(QNUploadRequestState *)requestState{
    if (self = [super init]) {
        _config = config;
        _uploadOption = uploadOption;
        _token = token;
        _requestInfo = requestInfo;
        _requestState = requestState;
        _currentRetryTime = 0;
    }
    return self;
}

- (void)request:(NSURLRequest *)request
         server:(id <QNUploadServer>)server
    shouldRetry:(BOOL(^)(QNResponseInfo *responseInfo, NSDictionary *response))shouldRetry
       progress:(void(^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
       complete:(QNSingleRequestCompleteHandler)complete{
    
    _currentRetryTime = 0;
    _requestMetricsList = [NSMutableArray array];
    [self retryRequest:request server:server shouldRetry:shouldRetry progress:progress complete:complete];
}

- (void)retryRequest:(NSURLRequest *)request
              server:(id <QNUploadServer>)server
         shouldRetry:(BOOL(^)(QNResponseInfo *responseInfo, NSDictionary *response))shouldRetry
            progress:(void(^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
            complete:(QNSingleRequestCompleteHandler)complete{
    
    if (kQNIsHttp3(server.httpVersion)) {
        self.client = [[QNUploadSystemClient alloc] init];
    } else {
        self.client = [[QNUploadSystemClient alloc] init];
    }
    
    kQNWeakSelf;
    BOOL (^checkCancelHandler)(void) = ^{
        kQNStrongSelf;
        
        BOOL isCancelled = self.requestState.isUserCancel;
        if (!isCancelled && self.uploadOption.cancellationSignal) {
            isCancelled = self.uploadOption.cancellationSignal();
        }
        return isCancelled;
    };

    QNLogInfo(@"key:%@ retry:%d url:%@", self.requestInfo.key, self.currentRetryTime, request.URL);
    
    [self.client request:request connectionProxy:self.config.proxy progress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        kQNStrongSelf;
        
        if (progress) {
            progress(totalBytesWritten, totalBytesExpectedToWrite);
        }
        
        if (checkCancelHandler()) {
            self.requestState.isUserCancel = YES;
            [self.client cancel];
        }
    } complete:^(NSURLResponse *response, QNUploadSingleRequestMetrics *metrics, NSData * responseData, NSError * error) {
        kQNStrongSelf;
        
        if (metrics) {
            [self.requestMetricsList addObject:metrics];
        }
        
        QNResponseInfo *responseInfo = nil;
        if (checkCancelHandler()) {
            responseInfo = [QNResponseInfo cancelResponse];
            [self complete:responseInfo server:server response:nil requestMetrics:metrics complete:complete];
            return;
        }
        
        NSDictionary *responseDic = nil;
        if (responseData) {
            responseDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                          options:NSJSONReadingMutableLeaves
                                                            error:nil];
        }
        
        responseInfo = [[QNResponseInfo alloc] initWithResponseInfoHost:request.qn_domain
                                                               response:(NSHTTPURLResponse *)response
                                                                   body:responseData
                                                                  error:error];
        if ([self shouldCheckConnect:responseInfo]) {
            QNUploadSingleRequestMetrics *connectCheckMetrics = [QNConnectChecker check];
            metrics.connectCheckMetrics = connectCheckMetrics;
            if (![QNConnectChecker isConnected:connectCheckMetrics]) {
                NSString *message = [NSString stringWithFormat:@"check origin statusCode:%d error:%@", responseInfo.statusCode, responseInfo.error];
                responseInfo = [QNResponseInfo errorResponseInfo:NSURLErrorNotConnectedToInternet errorDesc:message];
            }
        }
        
        QNLogInfo(@"key:%@ response:%@", self.requestInfo.key, responseInfo);
        if (shouldRetry(responseInfo, responseDic)
            && self.currentRetryTime < self.config.retryMax
            && responseInfo.couldHostRetry) {
            self.currentRetryTime += 1;
            QNAsyncRunAfter(self.config.retryInterval, kQNBackgroundQueue, ^{
                [self retryRequest:request server:server shouldRetry:shouldRetry progress:progress complete:complete];
            });
        } else {
            [self complete:responseInfo server:server response:responseDic requestMetrics:metrics complete:complete];
        }
    }];
    
}

- (BOOL)shouldCheckConnect:(QNResponseInfo *)responseInfo {
    if (!kQNGlobalConfiguration.connectCheckEnable) {
        return NO;
    }
    
    return responseInfo.statusCode == kQNNetworkError ||
    responseInfo.statusCode == -1001 /* NSURLErrorTimedOut */ ||
    responseInfo.statusCode == -1003 /* NSURLErrorCannotFindHost */ ||
    responseInfo.statusCode == -1004 /* NSURLErrorCannotConnectToHost */ ||
    responseInfo.statusCode == -1005 /* NSURLErrorNetworkConnectionLost */ ||
    responseInfo.statusCode == -1006 /* NSURLErrorDNSLookupFailed */ ||
    responseInfo.statusCode == -1009 /* NSURLErrorNotConnectedToInternet */;
}

- (void)complete:(QNResponseInfo *)responseInfo
            server:(id<QNUploadServer>)server
          response:(NSDictionary *)response
    requestMetrics:(QNUploadSingleRequestMetrics *)requestMetrics
          complete:(QNSingleRequestCompleteHandler)complete {
    [self updateHostNetworkStatus:responseInfo server:server requestMetrics:requestMetrics];
    [self reportRequest:responseInfo server:server requestMetrics:requestMetrics];
    if (complete) {
        complete(responseInfo, [self.requestMetricsList copy], response);
    }
}

//MARK:-- 统计网络状态
- (void)updateHostNetworkStatus:(QNResponseInfo *)responseInfo
                         server:(id <QNUploadServer>)server
                 requestMetrics:(QNUploadSingleRequestMetrics *)requestMetrics{
    long long bytes = requestMetrics.bytesSend.longLongValue;
    if (requestMetrics.startDate && requestMetrics.endDate && bytes >= 1024 * 1024) {
        double duration = [requestMetrics.endDate timeIntervalSinceDate:requestMetrics.startDate] * 1000;
        NSNumber *speed = [QNUtils calculateSpeed:bytes totalTime:duration];
        if (speed) {
            NSString *type = [QNNetworkStatusManager getNetworkStatusType:server.host ip:server.ip];
            [kQNNetworkStatusManager updateNetworkStatus:type speed:(int)(speed.longValue / 1000)];
        }
    }
}

//MARK:-- 统计quality日志
- (void)reportRequest:(QNResponseInfo *)info
               server:(id <QNUploadServer>)server
       requestMetrics:(QNUploadSingleRequestMetrics *)requestMetrics {
    
    if (! [self.requestInfo shouldReportRequestLog]) {
        return;
    }
    
    QNUploadSingleRequestMetrics *requestMetricsP = requestMetrics ?: [QNUploadSingleRequestMetrics emptyMetrics];
    
    NSInteger currentTimestamp = [QNUtils currentTimestamp];
    QNReportItem *item = [QNReportItem item];
    [item setReportValue:QNReportLogTypeRequest forKey:QNReportRequestKeyLogType];
    [item setReportValue:@(currentTimestamp/1000) forKey:QNReportRequestKeyUpTime];
    [item setReportValue:info.requestReportStatusCode forKey:QNReportRequestKeyStatusCode];
    [item setReportValue:info.reqId forKey:QNReportRequestKeyRequestId];
    [item setReportValue:requestMetricsP.request.qn_domain forKey:QNReportRequestKeyHost];
    [item setReportValue:requestMetricsP.remoteAddress forKey:QNReportRequestKeyRemoteIp];
    [item setReportValue:requestMetricsP.remotePort forKey:QNReportRequestKeyPort];
    [item setReportValue:self.requestInfo.bucket forKey:QNReportRequestKeyTargetBucket];
    [item setReportValue:self.requestInfo.key forKey:QNReportRequestKeyTargetKey];
    [item setReportValue:requestMetricsP.totalElapsedTime forKey:QNReportRequestKeyTotalElapsedTime];
    [item setReportValue:requestMetricsP.totalDnsTime forKey:QNReportRequestKeyDnsElapsedTime];
    [item setReportValue:requestMetricsP.totalConnectTime forKey:QNReportRequestKeyConnectElapsedTime];
    [item setReportValue:requestMetricsP.totalSecureConnectTime forKey:QNReportRequestKeyTLSConnectElapsedTime];
    [item setReportValue:requestMetricsP.totalRequestTime forKey:QNReportRequestKeyRequestElapsedTime];
    [item setReportValue:requestMetricsP.totalWaitTime forKey:QNReportRequestKeyWaitElapsedTime];
    [item setReportValue:requestMetricsP.totalWaitTime forKey:QNReportRequestKeyResponseElapsedTime];
    [item setReportValue:requestMetricsP.totalResponseTime forKey:QNReportRequestKeyResponseElapsedTime];
    [item setReportValue:self.requestInfo.fileOffset forKey:QNReportRequestKeyFileOffset];
    [item setReportValue:requestMetricsP.bytesSend forKey:QNReportRequestKeyBytesSent];
    [item setReportValue:requestMetricsP.totalBytes forKey:QNReportRequestKeyBytesTotal];
    [item setReportValue:@([QNUtils getCurrentProcessID]) forKey:QNReportRequestKeyPid];
    [item setReportValue:@([QNUtils getCurrentThreadID]) forKey:QNReportRequestKeyTid];
    [item setReportValue:self.requestInfo.targetRegionId forKey:QNReportRequestKeyTargetRegionId];
    [item setReportValue:self.requestInfo.currentRegionId forKey:QNReportRequestKeyCurrentRegionId];
    [item setReportValue:info.requestReportErrorType forKey:QNReportRequestKeyErrorType];
    NSString *errorDesc = info.requestReportErrorType ? info.message : nil;
    [item setReportValue:errorDesc forKey:QNReportRequestKeyErrorDescription];
    [item setReportValue:self.requestInfo.requestType forKey:QNReportRequestKeyUpType];
    [item setReportValue:[QNUtils systemName] forKey:QNReportRequestKeyOsName];
    [item setReportValue:[QNUtils systemVersion] forKey:QNReportRequestKeyOsVersion];
    [item setReportValue:[QNUtils sdkLanguage] forKey:QNReportRequestKeySDKName];
    [item setReportValue:[QNUtils sdkVersion] forKey:QNReportRequestKeySDKVersion];
    [item setReportValue:@([QNUtils currentTimestamp]) forKey:QNReportRequestKeyClientTime];
    [item setReportValue:[QNUtils getCurrentNetworkType] forKey:QNReportRequestKeyNetworkType];
    [item setReportValue:[QNUtils getCurrentSignalStrength] forKey:QNReportRequestKeySignalStrength];
    
    [item setReportValue:server.source forKey:QNReportRequestKeyPrefetchedDnsSource];
    if (server.ipPrefetchedTime) {
        NSInteger prefetchTime = currentTimestamp/1000 - [server.ipPrefetchedTime integerValue];
        [item setReportValue:@(prefetchTime) forKey:QNReportRequestKeyPrefetchedBefore];
    }
    [item setReportValue:kQNDnsPrefetch.lastPrefetchedErrorMessage forKey:QNReportRequestKeyPrefetchedErrorMessage];
    
    [item setReportValue:requestMetricsP.httpVersion forKey:QNReportRequestKeyHttpVersion];

    if (!kQNGlobalConfiguration.connectCheckEnable) {
        [item setReportValue:@"disable" forKey:QNReportRequestKeyNetworkMeasuring];
    } else if (requestMetricsP.connectCheckMetrics) {
        QNUploadSingleRequestMetrics *metrics = requestMetricsP.connectCheckMetrics;
        NSString *connectCheckDuration = [NSString stringWithFormat:@"%.2lf", [metrics.totalElapsedTime doubleValue]];
        NSString *connectCheckStatusCode = @"";
        if (metrics.response) {
            connectCheckStatusCode = [NSString stringWithFormat:@"%ld", (long)((NSHTTPURLResponse *)metrics.response).statusCode];
        } else if (metrics.error) {
            connectCheckStatusCode = [NSString stringWithFormat:@"%ld", (long)metrics.error.code];
        }
        NSString *networkMeasuring = [NSString stringWithFormat:@"duration:%@ status_code:%@",connectCheckDuration, connectCheckStatusCode];
        [item setReportValue:networkMeasuring forKey:QNReportRequestKeyNetworkMeasuring];
    }
    
    // 成功统计速度
    if (info.isOK) {
        [item setReportValue:requestMetricsP.perceptiveSpeed forKey:QNReportRequestKeyPerceptiveSpeed];
    }
    
    [kQNReporter reportItem:item token:self.token.token];
}

@end
