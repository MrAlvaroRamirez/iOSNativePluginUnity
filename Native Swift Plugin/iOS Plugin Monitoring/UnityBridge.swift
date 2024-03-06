import Foundation

// This file contains the exported methods to be called from Unity

@_cdecl("StartMonitoring")
public func StartMonitoring() {
    RAMUsageMonitor.instance.StartMonitoring();
}

@_cdecl("StopMonitoring")
public func StopMonitoring() -> UnsafePointer<CChar>? {
    // Since we cannot pass a Swift string directly to Unity, we need to
    //  convert it to a C-style string (a CChar pointer) first.
    let string = RAMUsageMonitor.instance.StopMonitoring().utf8CString
    return string.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> UnsafePointer<CChar>? in
        return pointer.baseAddress?.assumingMemoryBound(to: CChar.self)
    }
}
