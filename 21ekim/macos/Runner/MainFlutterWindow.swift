import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var windowChannel: FlutterMethodChannel?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let channel = FlutterMethodChannel(
      name: "focus_and_grow/window",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    self.windowChannel = channel

    channel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else {
        result(nil)
        return
      }

      switch call.method {
      case "enterFullScreen":
        if !self.styleMask.contains(.fullScreen) {
          self.toggleFullScreen(nil)
        }
        result(true)
      case "exitFullScreen":
        if self.styleMask.contains(.fullScreen) {
          self.toggleFullScreen(nil)
        }
        result(true)
      case "isFullScreen":
        result(self.styleMask.contains(.fullScreen))
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleWindowShrink),
      name: NSWindow.willExitFullScreenNotification,
      object: self
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleWindowShrink),
      name: NSWindow.didMiniaturizeNotification,
      object: self
    )

    super.awakeFromNib()
  }

  @objc private func handleWindowShrink() {
    windowChannel?.invokeMethod("onWindowShrink", nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}

