#import <Foundation/Foundation.h>

extern "C" {
    void SendMessageToIOS(const char *message) {
        if (message == NULL) {
            NSLog(@"[NativeCallProxy] Received null message from Unity");
            return;
        }

        NSString *messageString = [NSString stringWithUTF8String:message];
        NSLog(@"[NativeCallProxy] Message from Unity: %@", messageString);
    }
}