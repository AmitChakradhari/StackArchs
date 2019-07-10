import UIKit
import PromiseKit

extension JSONDecoder {
    func convertFromSnakeCase() -> JSONDecoder {
        self.keyDecodingStrategy = .convertFromSnakeCase
        return self
    }
}

extension Comment {
    func commentView(userId: Int, clickListener: @escaping ((Int) -> Void)) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.green
        let comment = CommentLabel()
        comment.clickListener = clickListener
        comment.userID = userId
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.numberOfLines = 0
        let str = "\(self.bodyMarkdown)-\(self.owner?.displayName ?? "Anonymous")"
        comment.text = str
        comment.isUserInteractionEnabled = true

        comment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClick(sender:))))

        view.addSubview(comment)
        NSLayoutConstraint.activate([
            comment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            comment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            comment.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            comment.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            comment.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            comment.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])

        return view
    }
    @objc func handleClick(sender: UITapGestureRecognizer) {
        if let view = (sender.view as? CommentLabel), let userId = view.userID, let listener = view.clickListener {
            listener(userId)
        }
    }
    class CommentLabel: UILabel {
        var clickListener: ((Int) -> Void)?
        var userID: Int?
    }
}

extension UIButton {
    private struct CommentProperties {
        static var commentStackView: CommentsStackView = CommentsStackView(frame: CGRect.zero)
        static var comments: [Comment] = []
    }

    var commentStackView: CommentsStackView {
        get {
            return CommentProperties.commentStackView
        }
        set(newValue) {
            CommentProperties.commentStackView = newValue
        }
    }

    var comments: [Comment] {
        get {
            return CommentProperties.comments
        }
        set(newValue) {
            CommentProperties.comments = newValue
        }
    }
}

extension UILabel {
    private struct UserLink {
        static var link: String = ""
    }
    var userLink: String {
        get {
            return UserLink.link
        }
        set(newValue) {
            UserLink.link = newValue
        }
    }
}

extension UIViewController {
    static func brokenPromise<T>(method: String = #function) -> Promise<T> {
        return Promise<T>() { seal in
            let err = NSError(
                domain: "WeatherOrNot",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "'\(method)' not yet implemented."])
            seal.reject(err)
        }
    }
}
