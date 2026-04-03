package com.fitconnect.app

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val TAG = "FitConnect"
    private val CHANNEL = "com.fitconnect.app/deeplink"
    private val EVENT_CHANNEL = "com.fitconnect.app/deeplink_stream"

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

    private var initialLink: String? = null
    private var lastProcessedLink: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate - checking for deep link")
        handleIntent(intent, isInitial = true)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel: Flutter pede o deep link inicial
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialLink" -> result.success(initialLink)
                else -> result.notImplemented()
            }
        }

        // EventChannel: stream de deep links em tempo real
        eventChannel = EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            EVENT_CHANNEL
        )
        eventChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }
            override fun onCancel(args: Any?) {
                eventSink = null
            }
        })
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d(TAG, "onNewIntent - app was already open")
        handleIntent(intent, isInitial = false)
    }

    private fun handleIntent(intent: Intent?, isInitial: Boolean) {
        val data: Uri? = intent?.data

        if (intent?.action == Intent.ACTION_VIEW && data != null) {
            val deepLinkUrl = data.toString()

            // Evita processar o mesmo link duas vezes
            if (deepLinkUrl == lastProcessedLink) return

            lastProcessedLink = deepLinkUrl
            Log.i(TAG, "Deep link: $deepLinkUrl")

            if (isInitial) {
                // App estava fechado - guarda para o Flutter buscar
                initialLink = deepLinkUrl
            } else {
                // App estava aberto - envia via stream
                eventSink?.success(deepLinkUrl)
            }
        }
    }
}
