import Cocoa
import Carbon

private func khayalHotKeyHandler(_ next: EventHandlerCallRef?, _ event: EventRef?, _ data: UnsafeMutableRawPointer?) -> OSStatus {
    AppDelegate.openKhayal()
    return noErr
}

final class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechRecognizerDelegate {
    var hotKeyRef: EventHotKeyRef?
    var recognizer: NSSpeechRecognizer?
    var voiceOnce = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        installHotKey()
        if CommandLine.arguments.contains("--voice") {
            voiceOnce = true
            startVoice()
            NSApplication.shared.perform(#selector(NSApplication.terminate(_:)), with: nil, afterDelay: 25)
        }
    }

    func installHotKey() {
        var hotKeyID = EventHotKeyID(signature: OSType(0x4B48594C), id: 1)
        RegisterEventHotKey(UInt32(kVK_Space), UInt32(optionKey), hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        var spec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), khayalHotKeyHandler, 1, &spec, nil, nil)
    }

    static func openKhayal() {
        let url = URL(fileURLWithPath: NSHomeDirectory() + "/Applications/Khayal.app")
        NSWorkspace.shared.open(url)
    }

    func startVoice() {
        let rec = NSSpeechRecognizer()
        rec?.commands = [
            "Finder", "Chrome", "Safari", "Telegram",
            "günaydın", "gunaydin", "Good morning",
            "yan yana", "durum", "karanlık", "aydınlık"
        ]
        rec?.listensInForegroundOnly = false
        rec?.delegate = self
        rec?.startListening()
        recognizer = rec
        NSSound.beep()
    }

    func speechRecognizer(_ sender: NSSpeechRecognizer, didRecognizeCommand command: String) {
        let bin = NSHomeDirectory() + "/.cursor/skills/khayal-mac/scripts/khayal"
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.arguments = [bin, command]
        try? task.run()
        if voiceOnce {
            NSApp.terminate(nil)
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
