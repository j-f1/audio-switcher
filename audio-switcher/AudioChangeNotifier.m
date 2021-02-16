//
//  AudioChangeNotifier.m
//  Instant Audio Switcher
//
//  Created by Jed Fox on 1/16/21.
//

#import "AudioChangeNotifier.h"

static UInt count = 0;
OSStatus handle(AudioHardwarePropertyID property, void *ctx) {
  return ((__bridge AudioHardwarePropertyListener)ctx)(property);
}

OSStatus myAudioHardwareAddPropertyListener(AudioHardwarePropertyID         inPropertyID,
                                            AudioHardwarePropertyListener   inProc) {
  count++;
  return AudioHardwareAddPropertyListener(inPropertyID, handle, (__bridge void * _Nullable)(inProc));
}

OSStatus myAudioHardwareRemovePropertyListener(AudioHardwarePropertyID         inPropertyID,
                                               AudioHardwarePropertyListener   inProc) {
  count--;
  if (count == 0) {
    return AudioHardwareRemovePropertyListener(inPropertyID, handle);
  } else {
    return noErr;
  }
}
