package com.cordova.plugins.silentmode;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import android.content.Context;
import android.media.AudioManager;

public class SilentMode extends CordovaPlugin {
  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("isMuted")) {
        this.isMuted(callbackContext);
        return true;
    }
    return false;
  }

  private void isMuted(CallbackContext callbackContext) {
    Context context = this.cordova.getActivity().getApplicationContext();
    AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
    if (audioManager.getRingerMode() == AudioManager.RINGER_MODE_SILENT) {
      callbackContext.success();
    } else {
      callbackContext.error();
    }
  }
}
