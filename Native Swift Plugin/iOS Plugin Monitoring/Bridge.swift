import Foundation

@_cdecl("getValue")
public func getValue() ->  UnsafePointer<CChar>? {
    let string = UsageMonitor.helloWorld().utf8CString
    return string.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> UnsafePointer<CChar>? in
        // Cast the base address of the UnsafeRawBufferPointer to UnsafePointer<CChar>
        return pointer.baseAddress?.assumingMemoryBound(to: CChar.self)
    }
}

@_cdecl("setValue")
public func setValue(value: Double) {
    print(value)
}
