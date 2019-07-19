import UIKit

class DateUtilities {

    class func getDate(_ date: Int) -> String {

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM d, yyyy"

        let customDate = Date(timeIntervalSince1970: TimeInterval(date))

        return formatter.string(from: customDate)
    }

}
