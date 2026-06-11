#import <Foundation/Foundation.h>

static NSString * const UnityMessageReceivedNotificationName = @"UnityMessageReceivedNotification";
static NSString * const UnityMessagePayloadKey = @"message";

extern "C" {
    void SendMessageToIOS(const char *message) {
        if (message == NULL) {
            NSLog(@"[NativeCallProxy] Received null message from Unity");
            return;
        }

        NSString *messageString = [NSString stringWithUTF8String:message];

        NSLog(@"[NativeCallProxy] Message from Unity: %@", messageString);

        [[NSNotificationCenter defaultCenter] postNotificationName:UnityMessageReceivedNotificationName
                                                            object:nil
                                                          userInfo:@{
                                                              UnityMessagePayloadKey: messageString
                                                          }];
    }
}