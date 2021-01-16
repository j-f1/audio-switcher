//
//  AudioChangeNotifier.h
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/16/21.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/AudioHardware.h>

NS_ASSUME_NONNULL_BEGIN

typedef OSStatus (^AudioHardwarePropertyListener)(AudioHardwarePropertyID inPropertyID);

OSStatus myAudioHardwareAddPropertyListener(AudioHardwarePropertyID         inPropertyID,
                                            AudioHardwarePropertyListener   inProc);

OSStatus myAudioHardwareRemovePropertyListener(AudioHardwarePropertyID         inPropertyID,
                                               AudioHardwarePropertyListener   inProc);

NS_ASSUME_NONNULL_END
