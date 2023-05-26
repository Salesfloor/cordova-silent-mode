## Cordova Silent Mode

This plugin allow to verify, through phonegap, if the current device is in silent mode

## Usage

```js
SilentMode.isMuted(
	function() { //Callback
		console.log('mute enabled'); 
	}, function() {  //Callback
		console.log('mute disabled'); 
	});
```