import UIKit
class UserProfilePageView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
        addSubview(profileView)
        profileView.addSubview(imageView)
        profileView.addSubview(reputationLabel)
        profileView.addSubview(badgeStackView)
        addSubview(backButton)
        bringSubviewToFront(backButton)
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    let backButton: UIButton = {
        let backButton = UIButton()
        backButton.setTitle("<-", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.frame = CGRect(x: 10, y: 20, width: 44, height: 44)
        backButton.addTarget(self, action: #selector(UserProfilePageViewController.backButtonPressed), for: .touchUpInside)
        return backButton
    }()

    func addConstraints() {
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            profileView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            profileView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
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
            badgeStackView.bottomAnchor.constraint(equalTo: profileView.bottomAnchor, constant: -20),

            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: bottomAnchor, constant: 20)
            ])
    }
}
