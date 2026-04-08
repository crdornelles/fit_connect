import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

    private let CHANNEL = "com.fitconnect.app/deeplink"
    private let EVENT_CHANNEL = "com.fitconnect.app/deeplink_stream"

    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?

    private var initialLink: String?
    private var lastProcessedLink: String?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController
        setupChannels(controller: controller)

        // Captura deep link inicial (cold start)
        if let url = launchOptions?[.url] as? URL {
            handleDeepLink(url: url, isInitial: true)
        } else if
            let userActivityDictionary = launchOptions?[.userActivityDictionary] as? [AnyHashable: Any] {
            for value in userActivityDictionary.values {
                if let userActivity = value as? NSUserActivity,
                   userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                   let url = userActivity.webpageURL {
                    handleDeepLink(url: url, isInitial: true)
                    break
                }
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func setupChannels(controller: FlutterViewController) {
        // MethodChannel: Flutter pede o deep link inicial
        methodChannel = FlutterMethodChannel(
            name: CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        methodChannel?.setMethodCallHandler { [weak self] call, result in
            if call.method == "getInitialLink" {
                result(self?.initialLink)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        // EventChannel: stream de deep links em tempo real enquanto o app está em execução
        eventChannel = FlutterEventChannel(
            name: EVENT_CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        eventChannel?.setStreamHandler(self)
    }

    // Custom URL Scheme
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        handleDeepLink(url: url, isInitial: false)
        return super.application(app, open: url, options: options)
    }

    // Universal Links
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else {
            return false
        }

        handleDeepLink(url: url, isInitial: false)
        return true
    }

    private func handleDeepLink(url: URL, isInitial: Bool) {
        let urlString = url.absoluteString

        // Evita processar o mesmo link duas vezes
        if urlString == lastProcessedLink { return }

        lastProcessedLink = urlString
        NSLog("Deep link: \(urlString)")

        if isInitial {
            initialLink = urlString
        } else {
            eventSink?(urlString)
        }
    }
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
