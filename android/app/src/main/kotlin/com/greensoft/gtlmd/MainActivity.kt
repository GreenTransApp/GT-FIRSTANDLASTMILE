package com.greensoft.gtlmd

import android.os.Build
import android.os.Bundle
import android.view.WindowInsetsController
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import android.view.WindowInsets
import android.view.View
import android.os.Build.VERSION_CODES
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "scan_channel"
    private lateinit var scanReceiver: BroadcastReceiver

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // Disable edge-to-edge
            window.setDecorFitsSystemWindows(true)
        } else {
            // For older versions
            @Suppress("DEPRECATION")
            window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE
        }

         val engine = flutterEngine ?: return
        val methodChannel = MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)

        // Register the BroadcastReceiver
        scanReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val barcode = intent?.getStringExtra("barcode_string") ?: return
                methodChannel.invokeMethod("onBarcodeScanned", barcode)
            }
        }

        val filter = IntentFilter()
        filter.addAction("android.intent.ACTION_DECODE_DATA") // Use the intent action from ScanSettings
        registerReceiver(scanReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
    }

        override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(scanReceiver)
    }
}