import UIKit
import PromiseKit

extension JSONDecoder {
    func convertFromSnakeCase() -> JSONDecoder {
        self.keyDecodingStrategy = .convertFromSnakeCase
        return self
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
