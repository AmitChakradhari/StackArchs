import UIKit
import PromiseKit
class UserProfilePageViewController: UIViewController {

    var networkManager: NetworkManager!
    var userProfilePageView: UserProfilePageView!
    var user: User!
    var userId: Int
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager()
        userProfilePageView = UserProfilePageView(frame: view.frame)
        view.addSubview(userProfilePageView)
        networkManager.getUser(with: userId)
            .done { [weak self] user in
                self?.user = user
            }.done(on: .main) { [weak self] in
                if let imageUrl = URL(string: self?.user.items[0].profileImage ?? "") {
                    self?.userProfilePageView.imageView.image = try? UIImage(data: Data(contentsOf: imageUrl))
                    self?.userProfilePageView.reputationLabel.text = "Reputation - \(self?.user.items[0].reputation ?? 0)"
                        for view in self?.getBadges(badges: self?.user.items[0].badgeCounts) ?? [] {
                            self?.userProfilePageView.badgeStackView.addArrangedSubview(view)
                        }
                }
            }.catch { error in
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

    @objc func backButtonPressed(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
