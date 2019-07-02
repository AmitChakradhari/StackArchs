import UIKit

class EditedAnsweredView: UIView {

    var editedAnsweredLabel = UILabel()
    var userImage = UIImageView()
    var userName = UILabel()
    var badges = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpView()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpView() {
        backgroundColor = .lightGray
        translatesAutoresizingMaskIntoConstraints = false
        //bounds = CGRect(x: 0, y: 0, width: 250, height: 90)
        editedAnsweredLabel.translatesAutoresizingMaskIntoConstraints = false
        editedAnsweredLabel.text = "answered Jul 3 '12 at 2:25 a 2:25"

        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        userImage.image = UIImage(named: "user")
        userImage.contentMode = .scaleAspectFill
        userImage.backgroundColor = .white
        userImage.setContentHuggingPriority(.required, for: .horizontal)
        userImage.layer.masksToBounds = true

        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.text = "User123"

        badges.translatesAutoresizingMaskIntoConstraints = false
        badges.text = "200 . 1 . 5 . 9"

        addSubview(editedAnsweredLabel)
        addSubview(userImage)
        addSubview(badges)
        addSubview(userName)

        NSLayoutConstraint.activate([
            editedAnsweredLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            editedAnsweredLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            editedAnsweredLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            editedAnsweredLabel.heightAnchor.constraint(equalToConstant: 15),

            userImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userImage.topAnchor.constraint(equalTo: editedAnsweredLabel.bottomAnchor, constant: 5),
            userImage.widthAnchor.constraint(equalToConstant: 48),
            userImage.heightAnchor.constraint(equalToConstant: 48),

            userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 5),
            userName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            userName.topAnchor.constraint(equalTo: editedAnsweredLabel.bottomAnchor, constant: 5),
            userName.heightAnchor.constraint(equalToConstant: 25),

            badges.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 5),
            badges.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            badges.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5),
            badges.heightAnchor.constraint(equalToConstant: 20),
            badges.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)

            ])
    }
}
