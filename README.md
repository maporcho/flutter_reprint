
# flutter_reprint    
 A plugin that allows you to use [Reprint](https://github.com/ajalt/reprint) in Flutter apps.    
    
## Installing    
 To use this plugin, follow the steps below:    
    
1. add `flutter_reprint` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).    
    
2. add `Reprint` as a dependency in your ```your_flutter_app_main_dir/android/app/build.gradle``` file:    
    
``` 
dependencies {    
    (...) 
    implementation 'com.github.ajalt.reprint:core:3.3.2@aar'
} 
``` 

3. Add ```Reprint.initialize(this)``` to your application class ```onCreate``` method:    
    
```kotlin 
class YourApplication : FlutterApplication() {    
    
 override fun onCreate() {   
     super.onCreate()  
     Reprint.initialize(this) }    
 } 
 ```    
 If you do not have an application class, you'll need to create one. Don't forget to add it to your AndroidManifest.xml file:    
    
```xml 
<manifest xmlns:android="http://schemas.android.com/apk/res/android"    
 package="br.com.marcoporcho.my_app">    
   
 <application android:name=".application.YourApplication"   
 (...)  
 > 
```    
 4. Add the USE_FINGEPRINT permission to your ```AndroidManifest.xml``` file:    
    
```xml 
<manifest xmlns:android="http://schemas.android.com/apk/res/android"    
 package="br.com.marcoporcho.my_app">    
<uses-permission android:name="android.permission.USE_FINGERPRINT" /> 
```    
    
## Getting Started    
 You can check out the `example` directory for a sample app using `flutter_reprint`.    
    
For the impatient:    
    
**Check if the device has fingerprint hardware**    
 ```dart 
 bool fingerprintReaderAvailable = await FlutterReprint.canCheckFingerprint;
 ```    
 
**Authenticate**    
 ```dart 
 FlutterReprint.authenticateWithBiometrics().then((authResult) { 
	if(authResult.success) {
		 print('SUCCESS');
	} else {
	 print('FAIL');
	}
});
```
**Stop authentication**
 ```dart 
 FlutterReprint.stopAuthentication().then((cancelOK) { 
	if(cancelOK) {
		 print('SUCCESS');
	} else {
	 print('FAIL');
	}
});
 ```    

