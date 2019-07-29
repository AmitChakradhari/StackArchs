import UIKit
import PromiseKit
class UserProfilePageViewController: UIViewController {

    var userProfilePageView: UserProfilePageView!
    var userId: Int
    var userProfilePageViewModel: UserProfilePageViewModel!
    weak var coordinator: MainCoordinator?

    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        userProfilePageView = UserProfilePageView(frame: view.frame)
        view.addSubview(userProfilePageView)

        userProfilePageViewModel = UserProfilePageViewModel()

        userProfilePageViewModel.getUser(userId: userId) { [weak self] user in
            if let imageUrl = URL(string: user.items[0].profileImage ?? "") {
                self?.userProfilePageView.imageView.image = try? UIImage(data: Data(contentsOf: imageUrl))
                self?.userProfilePageView.reputationLabel.text = "Reputation - \(user.items[0].reputation ?? 0)"
                for view in self?.userProfilePageViewModel.getBadges(badges: user.items[0].badgeCounts) ?? [] {
                    self?.userProfilePageView.badgeStackView.addArrangedSubview(view)
                }
            }
        }

    }

    @objc func backButtonPressed(sender: UIButton) {
        coordinator?.dismissViewController()
    }
}
