import UIKit
import RxSwift
import RxCocoa

class UserProfilePageViewController: UIViewController {

    var userProfilePageView: UserProfilePageView!
    var userId: Int
    var userProfilePageViewModel: UserProfilePageViewModel!
    var userObservable: Observable<[UserItem]>!
    weak var coordinator: MainCoordinator?

    let disposeBag = DisposeBag()

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

        userObservable = userProfilePageViewModel.getUser(userId: userId)

        userObservable.subscribe(onNext: { [weak self] userArray in
            if let user = userArray.first, let imageUrl = URL(string: user.profileImage ?? "") {
                self?.userProfilePageView.imageView.image = try? UIImage(data: Data(contentsOf: imageUrl))
                self?.userProfilePageView.reputationLabel.text = "Reputation - \(user.reputation ?? 0)"
                for view in self?.userProfilePageViewModel.getBadges(badges: user.badgeCounts) ?? [] {
                    self?.userProfilePageView.badgeStackView.addArrangedSubview(view)
                }
            }
        })
        .disposed(by: disposeBag)

    }

    @objc func backButtonPressed(sender: UIButton) {
        coordinator?.dismissViewController()
    }
}
