import UIKit
import PromiseKit
class UserProfilePageViewController: UIViewController {

    var networkManager: NetworkManager!
    var user: User!
    var userId: Int
    init(userId: Int) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager = NetworkManager()
        networkManager.getUser(with: userId)
            .done { [weak self] user in
                self?.user = user
            }.done(on: .main) { [weak self] in
                if let imageUrl = URL(string: self?.user.items[0].profileImage ?? "") {
                        self?.imageView.image = try? UIImage(data: Data(contentsOf: imageUrl))
                        self?.reputationLabel.text = "Reputation - \(self?.user.items[0].reputation ?? 0)"
                        for view in self?.getBadges(badges: self?.user.items[0].badgeCounts) ?? [] {
                            self?.badgeStackView.addArrangedSubview(view)
                        }
                }
            }.catch { error in
                print("error: \(error.localizedDescription)")
        }

        addBackButton()
        view.backgroundColor = .purple
        view.addSubview(profileView)
        profileView.addSubview(imageView)
        profileView.addSubview(reputationLabel)
        profileView.addSubview(badgeStackView)
        addConstraints()

    }

    func getBadges(badges: BadgeCount?) -> [UIView] {
        var views: [UIView] = []
        guard let badge = badges else { return views }
        //\u{1F538}\(badgeCounts.gold)\u{1F539}\(badgeCounts.silver)\u{1F53A}\(badgeCounts.bronze)
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

    let profileView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

        return view
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let reputationLabel: UILabel = {
        let reputationLabel = UILabel(frame: CGRect.zero)
        reputationLabel.translatesAutoresizingMaskIntoConstraints = false
        reputationLabel.textAlignment = .center
        return reputationLabel
    }()

    let badgeStackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect.zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 10.0
        return stackView
    }()

    func addConstraints() {
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            profileView.heightAnchor.constraint(equalToConstant: 300),

            imageView.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.centerXAnchor.constraint(equalTo: profileView.centerXAnchor),

            reputationLabel.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20),
            reputationLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -20),
            reputationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            reputationLabel.heightAnchor.constraint(equalToConstant: 50),

            badgeStackView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 10),
            badgeStackView.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -10),
            badgeStackView.topAnchor.constraint(equalTo: reputationLabel.bottomAnchor, constant: 10),
            badgeStackView.heightAnchor.constraint(equalToConstant: 30),
            badgeStackView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -20)
            ])
    }

    func addBackButton() {
        let backButton = UIButton()
        backButton.setTitle("<-", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.frame = CGRect(x: 10, y: 20, width: 44, height: 44)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
    }

    @objc func backButtonPressed(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
