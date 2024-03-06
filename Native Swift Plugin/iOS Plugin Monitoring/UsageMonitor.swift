import Foundation

class RAMUsageMonitor {
    // Singleton instance
    // I'm using the singleton pattern here since it makes sense to have a single instance running
    public static let instance = RAMUsageMonitor()
    
    private init() {}
    
    private var timer: DispatchSourceTimer?
    private var memorySamples: [Double] = []
    
    // The following function will start a monitoring loop task with a 1 second delay
    // It will store all the samples in the 'memorySamples' variable until it's stopped
    func StartMonitoring() {
        // Clear previous samples
        memorySamples.removeAll()
        
        // Schedule a timer to run the task at every second
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        
        // Every second, the timer will run a task to fetch the RAM usage of the current process
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            let memoryUsage = Double(GetMemoryUsageOfAppMB())
            // Store the current usage in the array
            self.memorySamples.append(memoryUsage)
        }
        
        // Start the timer
        timer?.resume()
    }
    
    // When this function is called, it will stop the timer and return a string as a result
    // The string will be formatted and contain the average of all the values collected
    func StopMonitoring() -> String {
        // Stop the timer
        timer?.cancel()
        timer = nil
        
        // Calculate the average of memory samples
        guard !memorySamples.isEmpty else {
            return "No memory samples collected."
        }
        let totalMemory = memorySamples.reduce(0, +)
        let averageMemory = totalMemory / Double(memorySamples.count)
        
        // Return the average RAM usage
        return "Average RAM usage \(averageMemory) MB"
    }

    func GetMemoryUsageOfAppMB() -> UInt64 {
        
        // Source: https://stackoverflow.com/a/64640842

        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }
        
        return used
    }
}
