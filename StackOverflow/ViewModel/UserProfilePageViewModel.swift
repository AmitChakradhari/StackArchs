import UIKit
import PromiseKit

class UserProfilePageViewModel {

    var user: User!

    func getUser(userId: Int, completion: @escaping (User) -> Void) {
        let networkManager = NetworkManager()
        networkManager.getUser(with: userId)
            .done { [weak self] user in
                self?.user = user
                completion(user)
            } .catch { error in
                print("error: \(error.localizedDescription)")
        }
    }

    func getBadges(badges: BadgeCount?) -> [UIView] {
        var views: [UIView] = []
        guard let badge = badges else { return views }
        if badge.gold > 0 {
            let label = UILabel(frame: CGRect.zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\u{1F538} \(badge.gold)"
            label.backgroundColor = .yellow
            views.append(label)
        }
        if badge.silver > 0 {
            let label = UILabel(frame: CGRect.zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\u{1F539} \(badge.silver)"
            label.backgroundColor = .gray
            views.append(label)
        }
        if badge.bronze > 0 {
            let label = UILabel(frame: CGRect.zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\u{1F53A} \(badge.bronze)"
            label.backgroundColor = .brown
            views.append(label)
        }
        return views
    }

}
