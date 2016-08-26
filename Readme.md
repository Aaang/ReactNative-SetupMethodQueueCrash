# SetupMethodQueueCrash

## About
This GitHub project provides the abstract project structure of my React Native application in order to fix the top crash (apparently) for iOS applications using React Native, filed issue [#9334](https://github.com/facebook/react-native/issues/9334). The crash happens quite often and it's not clear what causes the crash, except that we see that the native modules' `methodQueue` is nil at some point. Unfortunately the crash logs don't give that much information and the issue is not reproducible (yet).

## Project
As said, this is only an abstract representation of the project structure, mainly on how the React Native part is included into the existing app.

#### Main files

* AppDelegate
  * ReactNativeManagerDelegate - delegating calls from ReactNativeManager
  * ReactNativeManager - public API providing React Native Modules (views)
    * SomeNativeModule - React Native "native module" as direct interface between RN and iOS
    * SomeNativeModuleDelegate - delegating events from React Native Module, e.g. "TestApp"

#### Auxiliary files
* ReactNativeModuleStyling - some styling information for the React Native Module
* ReactNativeModuleConfiguration - some configuration information for the React native Module

#### Not included in this project
* the heavily used [CocoaPods](https://cocoapods.org/about) setup
* I'm actually referencing React Native native files from a static lib instead of the node modules folder
* a proper UI, including native view controllers and React components

## Crash Log

````
Crashed Thread:  16

Thread 0:
0   libsystem_kernel.dylib               0x00000001819d0fd8 mach_msg_trap + 8
1   CoreFoundation                       0x0000000181e08c60 __CFRunLoopServiceMachPort + 192
2   CoreFoundation                       0x0000000181e06964 __CFRunLoopRun + 1028
3   CoreFoundation                       0x0000000181d30c50 CFRunLoopRunSpecific + 380
4   GraphicsServices                     0x0000000183618088 GSEventRunModal + 176
5   UIKit                                0x0000000187012088 UIApplicationMain + 200
6   TestApp                              0x00000001000e26d0 main (AppDelegate.swift:13)
7   ???                                  0x00000001818ce8b8 0x0 + 0

Thread 1: irrelevant

Thread 2:
0   libsystem_kernel.dylib               0x00000001819d0fd8 mach_msg_trap + 8
1   CoreFoundation                       0x0000000181e08c60 __CFRunLoopServiceMachPort + 192
2   CoreFoundation                       0x0000000181e06964 __CFRunLoopRun + 1028
3   CoreFoundation                       0x0000000181d30c50 CFRunLoopRunSpecific + 380
4   CFNetwork                            0x00000001824b1bcc +[NSURLConnection(Loader) _resourceLoadLoop:] + 408
5   Foundation                           0x0000000182827e4c __NSThread__start__ + 996
6   libsystem_pthread.dylib              0x0000000181ab7b28 _pthread_body + 152
7   libsystem_pthread.dylib              0x0000000181ab7a8c _pthread_start + 152
8   libsystem_pthread.dylib              0x0000000181ab5028 thread_start + 0

Thread 3-6: irrelevant

Thread 7:
0   libsystem_kernel.dylib               0x00000001819d0fd8 mach_msg_trap + 8
1   CoreFoundation                       0x0000000181e08c60 __CFRunLoopServiceMachPort + 192
2   CoreFoundation                       0x0000000181e06964 __CFRunLoopRun + 1028
3   CoreFoundation                       0x0000000181d30c50 CFRunLoopRunSpecific + 380
4   WebCore                              0x0000000185d16108 RunWebThread(void*) + 452
5   libsystem_pthread.dylib              0x0000000181ab7b28 _pthread_body + 152
6   libsystem_pthread.dylib              0x0000000181ab7a8c _pthread_start + 152
7   libsystem_pthread.dylib              0x0000000181ab5028 thread_start + 0

Thread 8:
0   libsystem_kernel.dylib               0x00000001819ebf24 __psynch_cvwait + 8
1   libc++.1.dylib                       0x000000018144342c std::__1::condition_variable::wait(std::__1::unique_lock<std::__1::mutex>&) + 52
2   JavaScriptCore                       0x00000001857fcf8c JSC::GCThread::waitForNextPhase() + 140
3   JavaScriptCore                       0x00000001857fd024 JSC::GCThread::gcThreadMain() + 80
4   JavaScriptCore                       0x00000001854d2944 WTF::threadEntryPoint(void*) + 208
5   JavaScriptCore                       0x00000001854d2854 WTF::wtfThreadEntryPoint(void*) + 20
6   libsystem_pthread.dylib              0x0000000181ab7b28 _pthread_body + 152
7   libsystem_pthread.dylib              0x0000000181ab7a8c _pthread_start + 152
8   libsystem_pthread.dylib              0x0000000181ab5028 thread_start + 0

Thread 9:
0   libsystem_kernel.dylib               0x00000001819d0fd8 mach_msg_trap + 8
1   CoreFoundation                       0x0000000181e08c60 __CFRunLoopServiceMachPort + 192
2   CoreFoundation                       0x0000000181e06964 __CFRunLoopRun + 1028
3   CoreFoundation                       0x0000000181d30c50 CFRunLoopRunSpecific + 380
4   WebCore                              0x0000000185d43950 WebCore::runLoaderThread(void*) + 268
5   JavaScriptCore                       0x00000001854d2944 WTF::threadEntryPoint(void*) + 208
6   JavaScriptCore                       0x00000001854d2854 WTF::wtfThreadEntryPoint(void*) + 20
7   libsystem_pthread.dylib              0x0000000181ab7b28 _pthread_body + 152
8   libsystem_pthread.dylib              0x0000000181ab7a8c _pthread_start + 152
9   libsystem_pthread.dylib              0x0000000181ab5028 thread_start + 0

Thread 10-15: irrelevant

Thread 16 Crashed:
0   libdispatch.dylib                    0x000000018189e534 _os_object_retain + 72
1   libobjc.A.dylib                      0x00000001814d0128 objc_storeStrong + 40
2   libobjc.A.dylib                      0x00000001814b6908 object_setIvar + 272
3   Foundation                           0x000000018275f6e4 -[NSObject(NSKeyValueCoding) setValue:forKey:] + 264
4   TestApp                              0x000000010071c908 -[RCTModuleData setUpMethodQueue] (RCTModuleData.m:186)
5   TestApp                              0x000000010071c3f8 -[RCTModuleData setUpInstanceAndBridge] (RCTModuleData.m:120)
6   TestApp                              0x000000010071ca6c -[RCTModuleData instance] (RCTModuleData.m:222)
7   TestApp                              0x00000001007162b4 -[RCTBatchedBridge moduleForName:] (RCTBatchedBridge.m:216)
8   TestApp                              0x000000010072c660 -[RCTBridge moduleForClass:] (RCTBridge.m:199)
9   TestApp                              0x00000001006c6254 __100-[RCTImageLoader loadImageOrDataWithURLRequest:size:scale:resizeMode:progressBlock:completionBlock:]_block_invoke.142 (RCTImageLoader.m:415)
10  libdispatch.dylib                    0x000000018189d4bc _dispatch_call_block_and_release + 20
11  libdispatch.dylib                    0x000000018189d47c _dispatch_client_callout + 12
12  libdispatch.dylib                    0x00000001818a94c0 _dispatch_queue_drain + 860
13  libdispatch.dylib                    0x00000001818a0f80 _dispatch_queue_invoke + 460
14  libdispatch.dylib                    0x000000018189d47c _dispatch_client_callout + 12
15  libdispatch.dylib                    0x00000001818ab914 _dispatch_root_queue_drain + 2136
16  libdispatch.dylib                    0x00000001818ab0b0 _dispatch_worker_thread3 + 108
17  libsystem_pthread.dylib              0x0000000181ab5470 _pthread_wqthread + 1088
18  libsystem_pthread.dylib              0x0000000181ab5020 start_wqthread + 0

Thread 17-24: irrelevant

Thread 25:
0   JavaScriptCore                       0x00000001859492a8 llint_entry + 5368
1   JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
2   JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
3   JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
4   JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
5   JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
6   JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
7   JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
8   JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
9   JavaScriptCore                       0x000000018594da04 llint_entry + 23632
10  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
11  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
12  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
13  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
14  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
15  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
16  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
17  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
18  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
19  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
20  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
21  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
22  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
23  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
24  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
25  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
26  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
27  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
28  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
29  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
30  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
31  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
32  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
33  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
34  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
35  JavaScriptCore                       0x0000000185947b98 vmEntryToJavaScript + 308
36  JavaScriptCore                       0x00000001858736bc JSC::JITCode::execute(JSC::VM*, JSC::ProtoCallFrame*) + 176
37  JavaScriptCore                       0x000000018551226c JSC::Interpreter::executeCall(JSC::ExecState*, JSC::JSObject*, JSC::CallType, JSC::CallData const&, JSC::JSValue, JSC::ArgList const&) + 396
38  JavaScriptCore                       0x00000001855c4378 JSC::boundFunctionCall(JSC::ExecState*) + 508
39  JavaScriptCore                       0x000000018594df80 llint_entry + 25036
40  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
41  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
42  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
43  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
44  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
45  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
46  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
47  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
48  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
49  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
50  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
51  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
52  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
53  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
54  JavaScriptCore                       0x000000018594dbd4 llint_entry + 24096
55  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
56  JavaScriptCore                       0x000000018594da04 llint_entry + 23632
57  JavaScriptCore                       0x000000018594d9a0 llint_entry + 23532
58  JavaScriptCore                       0x0000000185947b98 vmEntryToJavaScript + 308
59  JavaScriptCore                       0x00000001858736bc JSC::JITCode::execute(JSC::VM*, JSC::ProtoCallFrame*) + 176
60  JavaScriptCore                       0x000000018551226c JSC::Interpreter::executeCall(JSC::ExecState*, JSC::JSObject*, JSC::CallType, JSC::CallData const&, JSC::JSValue, JSC::ArgList const&) + 396
61  JavaScriptCore                       0x00000001855c4378 JSC::boundFunctionCall(JSC::ExecState*) + 508
62  JavaScriptCore                       0x0000000185947d20 vmEntryToNative + 316
63  JavaScriptCore                       0x00000001855122b0 JSC::Interpreter::executeCall(JSC::ExecState*, JSC::JSObject*, JSC::CallType, JSC::CallData const&, JSC::JSValue, JSC::ArgList const&) + 464
64  JavaScriptCore                       0x000000018551201c JSObjectCallAsFunction + 516
65  TestApp                              0x000000010071385c __52-[RCTJSCExecutor _executeJSCall:arguments:callback:]_block_invoke (RCTJSCExecutor.mm:567)
66  TestApp                              0x0000000100713ef4 -[RCTJSCExecutor executeBlockOnJavaScriptQueue:] (RCTJSCExecutor.mm:696)
67  TestApp                              0x0000000100713318 -[RCTJSCExecutor _executeJSCall:arguments:callback:] (RCTJSCExecutor.mm:567)
68  TestApp                              0x00000001007131c0 -[RCTJSCExecutor invokeCallbackID:arguments:callback:] (RCTJSCExecutor.mm:558)
69  TestApp                              0x000000010071954c -[RCTBatchedBridge _actuallyInvokeCallback:arguments:] (RCTBatchedBridge.m:814)
70  TestApp                              0x0000000100718be4 __41-[RCTBatchedBridge enqueueCallback:args:]_block_invoke (RCTBatchedBridge.m:735)
71  TestApp                              0x0000000100713ef4 -[RCTJSCExecutor executeBlockOnJavaScriptQueue:] (RCTJSCExecutor.mm:696)
72  Foundation                           0x000000018282802c __NSThreadPerformPerform + 336
73  CoreFoundation                       0x0000000181e0909c __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 20
74  CoreFoundation                       0x0000000181e08b30 __CFRunLoopDoSources0 + 536
75  CoreFoundation                       0x0000000181e06830 __CFRunLoopRun + 720
76  CoreFoundation                       0x0000000181d30c50 CFRunLoopRunSpecific + 380
77  TestApp                              0x0000000100711d70 +[RCTJSCExecutor runRunLoopThread] (RCTJSCExecutor.mm:259)
78  Foundation                           0x0000000182827e4c __NSThread__start__ + 996
79  libsystem_pthread.dylib              0x0000000181ab7b28 _pthread_body + 152
80  libsystem_pthread.dylib              0x0000000181ab7a8c _pthread_start + 152
81  libsystem_pthread.dylib              0x0000000181ab5028 thread_start + 0

Thread 26:
0   libsystem_kernel.dylib               0x00000001819ebf24 __psynch_cvwait + 8
1   libc++.1.dylib                       0x000000018144342c std::__1::condition_variable::wait(std::__1::unique_lock<std::__1::mutex>&) + 52
2   JavaScriptCore                       0x00000001857fcf8c JSC::GCThread::waitForNextPhase() + 140
3   JavaScriptCore                       0x00000001857fd024 JSC::GCThread::gcThreadMain() + 80
4   JavaScriptCore                       0x00000001854d2944 WTF::threadEntryPoint(void*) + 208
5   JavaScriptCore                       0x00000001854d2854 WTF::wtfThreadEntryPoint(void*) + 20
6   libsystem_pthread.dylib              0x0000000181ab7b28 _pthread_body + 152
7   libsystem_pthread.dylib              0x0000000181ab7a8c _pthread_start + 152
8   libsystem_pthread.dylib              0x0000000181ab5028 thread_start + 0

Thread 27:
0   libsystem_kernel.dylib               0x00000001819ec41c __semwait_signal + 8
1   libc++.1.dylib                       0x00000001814813b4 std::__1::this_thread::sleep_for(std::__1::chrono::duration<long long, std::__1::ratio<1l, 1000000000l> > const&) + 80
2   JavaScriptCore                       0x0000000185a4a698 bmalloc::Heap::scavenge(std::__1::unique_lock<bmalloc::StaticMutex>&, std::__1::chrono::duration<long long, std::__1::ratio<1l, 1000l> >) + 184
3   JavaScriptCore                       0x0000000185a4a348 bmalloc::Heap::concurrentScavenge() + 80
4   JavaScriptCore                       0x0000000185a4cae0 bmalloc::AsyncTask<bmalloc::Heap, void (bmalloc::Heap::*)()>::entryPoint() + 96
5   JavaScriptCore                       0x0000000185a4ca70 bmalloc::AsyncTask<bmalloc::Heap, void (bmalloc::Heap::*)()>::pthreadEntryPoint(void*) + 8
6   libsystem_pthread.dylib              0x0000000181ab7b28 _pthread_body + 152
7   libsystem_pthread.dylib              0x0000000181ab7a8c _pthread_start + 152
8   libsystem_pthread.dylib              0x0000000181ab5028 thread_start + 0
````
