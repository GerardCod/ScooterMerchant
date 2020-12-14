package com.devopsti.scooter.merchant;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.media.AudioAttributes;
import android.net.Uri;
import android.os.Build;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

// Nota, esta linea la agregue
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
  @Override
  public void onCreate() {
    super.onCreate();
    System.out.println("Notification sent");
    FlutterFirebaseMessagingService.setPluginRegistrant(this);
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      NotificationChannel channel = new NotificationChannel("messages", "messages", NotificationManager.IMPORTANCE_HIGH);
      channel.setSound(null, null);
      NotificationManager manager = getSystemService(NotificationManager.class);
      manager.createNotificationChannel(channel);
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      NotificationChannel channel2 = new NotificationChannel("alarms", "Alarms", NotificationManager.IMPORTANCE_HIGH);
      // channel2.setSound(null, null);

      Uri uri = Uri.parse("android.resource://" + this.getPackageName() + "/" + R.raw.ringtone);

      AudioAttributes att = new AudioAttributes.Builder()
              .setUsage(AudioAttributes.USAGE_NOTIFICATION)
              .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
              .build();
      channel2.setSound(uri, att);
      channel2.enableVibration(true);
      channel2.enableLights(true);

      NotificationManager manager = getSystemService(NotificationManager.class);
      manager.createNotificationChannel(channel2);
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      NotificationChannel channel3 = new NotificationChannel("claxon", "claxon", NotificationManager.IMPORTANCE_HIGH);
      Uri uri = Uri.parse("android.resource://" + this.getPackageName() + "/" + R.raw.carhorn);

      AudioAttributes att = new AudioAttributes.Builder()
              .setUsage(AudioAttributes.USAGE_NOTIFICATION)
              .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
              .build();
      channel3.setSound(uri, att);
      channel3.enableVibration(true);
      channel3.enableLights(true);

      NotificationManager manager = getSystemService(NotificationManager.class);
      manager.createNotificationChannel(channel3);
    }
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    // GeneratedPluginRegistrant.registerWith(registry);
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
  }
}