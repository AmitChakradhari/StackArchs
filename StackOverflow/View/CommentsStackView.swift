import UIKit

class CommentsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("override init(frame called")
        translatesAutoresizingMaskIntoConstraints = false
        axis = NSLayoutConstraint.Axis.vertical
        distribution  = UIStackView.Distribution.equalSpacing
        alignment = UIStackView.Alignment.center
        spacing   = 10.0

        moreCommentsStackView.addArrangedSubview(moreCommentsButton)
        addArrangedSubview(commentsStackView)
        addArrangedSubview(moreCommentsStackView)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let commentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 5.0
        return stackView
    }()

    let moreCommentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 10.0
        return stackView
    }()

    let moreCommentsButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .yellow
        btn.tag = 11
        btn.setTitle("show more comments", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(nil, action: #selector(moreCommentsButtonPressed), for: .touchUpInside)
        return btn
    }()

    @objc func moreCommentsButtonPressed(sender: UIButton) {
        switch sender.tag {
        case 11:
            sender.setTitle("hide comments", for: .normal)
            sender.tag = 12
            //showMoreComments(sender: sender)
            guard let tableView = sender.commentStackView.superview!.superview!.superview as? UITableView, let cell = sender.commentStackView.superview!.superview as? QuestionTableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case 12:
            sender.setTitle("show more comments", for: .normal)
            sender.tag = 11
            //hideComments(sender: sender)
            guard let tableView = sender.commentStackView.superview!.superview!.superview as? UITableView, let cell = sender.commentStackView.superview!.superview as? QuestionTableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }

//    func showMoreComments(sender: UIButton) {
//        guard !sender.comments.isEmpty else { return }
//        guard let sv = sender.commentStackView.subviews[0] as? UIStackView else { return }
//        print("showComments")
//        for ids in 3...(sender.comments.count - 1) {
//            sv.addArrangedSubview(sender.comments[ids].commentView())
//        }
//    }
//
//    func hideComments(sender: UIButton) {
//        guard !sender.comments.isEmpty else { return }
//        guard let sv = sender.commentStackView.subviews[0] as? UIStackView else { return }
//        print("hideComments")
//        let arr = Array(3...(sv.arrangedSubviews.count - 1))
//        let revArr = Array(arr.reversed())
//        for ids in revArr {
//            sv.arrangedSubviews[ids].removeFromSuperview()
//        }
//    }
}
