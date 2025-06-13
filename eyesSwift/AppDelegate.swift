import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var toggleTitleBarMenuItem1: NSMenuItem!
    @IBOutlet weak var toggleTitleBarMenuItem2: NSMenuItem!
    @IBOutlet weak var alwaysOnTopMenuItem: NSMenuItem!
    
    private var showTitleBar: Bool {
        get { UserDefaults.standard.bool(forKey: "showTitleBar") }
        set {
            UserDefaults.standard.set(newValue, forKey: "showTitleBar")
            updateTitleBar()
            updateMenuItems()
        }
    }
    
    private var alwaysOnTop: Bool {
        get { UserDefaults.standard.bool(forKey: "alwaysOnTop") }
        set {
            UserDefaults.standard.set(newValue, forKey: "alwaysOnTop")
            updateWindowLevel()
        }
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        loadDefaultValues()
        window.isOpaque = false
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = true
        
        showTitleBar = UserDefaults.standard.bool(forKey: "showTitleBar")
        alwaysOnTop = UserDefaults.standard.bool(forKey: "alwaysOnTop")
        
        updateTitleBar()
        updateMenuItems()
        updateWindowLevel()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let eventMask1: NSEvent.EventTypeMask = [.mouseMoved, .leftMouseDragged, .rightMouseDragged, .otherMouseDragged, .leftMouseDown, .rightMouseDown, .otherMouseDown]
        let eventMask2: NSEvent.EventTypeMask = [.mouseMoved, .leftMouseDown, .rightMouseDown, .otherMouseDown]
        
        NSEvent.addGlobalMonitorForEvents(matching: eventMask1) { [weak self] _ in
            self?.window.contentView?.display()
        }
        
        NSEvent.addLocalMonitorForEvents(matching: eventMask2) { [weak self] event in
            self?.window.contentView?.display()
            return event
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func toggleTitleBar(_ sender: Any) {
        showTitleBar.toggle()
    }
    
    @IBAction func toggleAlwaysOnTop(_ sender: Any) {
        alwaysOnTop.toggle()
    }
    
    private func updateTitleBar() {
        if showTitleBar {
            window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
            window.makeKeyAndOrderFront(nil)
        } else {
            window.styleMask = [.borderless]
        }
    }
    
    private func updateMenuItems() {
        if let appName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
            window.title = appName
        }
        let title = showTitleBar ? NSLocalizedString("Hide Title Bar", comment: "") : NSLocalizedString("Show Title Bar", comment: "")
        toggleTitleBarMenuItem1.title = title
        toggleTitleBarMenuItem2.title = title
    }
    
    private func updateWindowLevel() {
        alwaysOnTopMenuItem.state = alwaysOnTop ? .on : .off
        window.level = alwaysOnTop ? .floating : .normal
    }
    
    private func loadDefaultValues() {
        if let defaultsPath = Bundle.main.path(forResource: "Defaults", ofType: "plist"),
           let defaultsDict = NSDictionary(contentsOfFile: defaultsPath) as? [String: Any] {
            UserDefaults.standard.register(defaults: defaultsDict)
        }
    }
}
