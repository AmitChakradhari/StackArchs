import UIKit
import PromiseKit
class QuestionAnswerPageVC: UIViewController {

    var networkManager: NetworkManager!
    var tableView: UITableView!
    var backButton: UIButton!
    var questionId: Int!
    let questionCellIdentifier = "questionCell"
    let answerCellIdentifier = "answerCell"
    var questionData: Question!
    var answersData: Answers!
    var questionAnswerPageViewModel: QuestionAnswerPageViewModel!
    lazy var questionCellViewModel = QuestionCellViewModel(questionData: questionData)

    override func viewDidLoad() {
        super.viewDidLoad()


        questionAnswerPageViewModel = QuestionAnswerPageViewModel(vc: self)
        setupView()
        networkManager = NetworkManager()
        networkManager.getQuestion(with: questionId)
            .then { [weak self] qData -> Promise<Answers> in
                guard let strongSelf = self else {
                    return UIViewController.brokenPromise()
                }
                strongSelf.questionData = qData
                return strongSelf.networkManager.getAnswersOfQuestion(with: strongSelf.questionId)
            }.done { [weak self] ansData in
                self?.answersData = ansData
            }.ensure { [weak self] in
                self?.tableView.reloadData()
            }.catch { error in
                print("error: \(error.localizedDescription)")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupView() {
        let questionAnswerPageView = questionAnswerPageViewModel.questionAnswerPageView!
        tableView = questionAnswerPageViewModel.tableView
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(questionAnswerPageView)
        view.backgroundColor = .white
    }

    @objc func backButtonPressed(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func moreCommentsButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 11:
            sender.setTitle("hide comments", for: .normal)
            sender.tag = 12
            //showMoreComments(sender: sender)
            guard let cell = sender.commentStackView.superview!.superview as? QuestionTableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case 12:
            sender.setTitle("show more comments", for: .normal)
            sender.tag = 11
            //hideComments(sender: sender)
            guard let cell = sender.commentStackView.superview!.superview as? QuestionTableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

extension QuestionAnswerPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard answersData != nil else {
            return 1
        }
        return answersData.items.count // +1 causes app to crash
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: questionCellIdentifier, for: indexPath) as! QuestionTableViewCell
            // swiftlint:enable force_cast
            guard questionData != nil else {
                return cell
            }
            if cell.contentView.bounds.width >= 450 {
                cell.editors.axis = .horizontal
            } else {
                cell.editors.axis = .vertical
            }

            if let item = questionData.items.first {
                cell.questionTitle.text = questionCellViewModel.questionTitle
                cell.questionDetail.text = questionCellViewModel.questionDetail
                cell.answeredView.editedAnsweredLabel.text = questionCellViewModel.answeredViewEditedAnsweredLabel
                cell.answeredView.userName.text = questionCellViewModel.answeredViewUserName
                cell.answeredView.userImage.image = try? UIImage(data: Data(contentsOf: URL(string: questionCellViewModel.answeredViewImageUrlString)!))
                cell.answeredView.badges.text = questionCellViewModel.answeredViewBadgesText

                if item.lastEditor != nil {
                    cell.editedView.isHidden = false
                    cell.editedView.editedAnsweredLabel.text = questionCellViewModel.answeredViewEditedAnsweredLabel
                    cell.editedView.userName.text = questionCellViewModel.editedViewUserName
                    cell.editedView.userImage.image = try? UIImage(data: Data(contentsOf: URL(string: questionCellViewModel.editedViewImageUrlString)!))
                    cell.editedView.badges.text = questionCellViewModel.editedViewBadgesText
                } else {
                    cell.editedView.isHidden = true
                }
                let count = item.comments?.count
                guard let commentsCount = count, let comments = item.comments else { return cell }
                guard commentsCount > 0 else { return cell }
                guard let sv = cell.commentsStackView.subviews[0] as? UIStackView else { return cell }

                for ids in 0...commentsCount-1 {
                    let userId: Int = comments[ids].owner?.userId ?? 0
                    sv.addArrangedSubview(comments[ids].commentView(userId: userId, clickListener: getClickListener(userID: userId)))
                }
                cell.commentsStackView.moreCommentsButton.isHidden = true
                //cell.commentsStackView.moreCommentsButton.isHidden = commentsCount < 4 ? true : false
                cell.commentsStackView.moreCommentsButton.commentStackView = cell.commentsStackView
                cell.commentsStackView.moreCommentsButton.comments = comments
            }
            return cell
        } else {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: answerCellIdentifier, for: indexPath) as! AnswerTableViewCell
            // swiftlint:enable force_cast
            guard answersData != nil && indexPath.row > 0 else {
                return cell
            }

            if cell.contentView.bounds.width >= 450 {
                cell.editors.axis = .horizontal
            } else {
                cell.editors.axis = .vertical
            }
            let item = answersData.items[indexPath.row]
            cell.answerDetail.text = item.bodyMarkdown
            if !indexPath.row.isMultiple(of: 2) {
                cell.contentView.backgroundColor = .lightGray
            }
            cell.answeredView.editedAnsweredLabel.text = "answered \(DateUtilities.getDate(item.creationDate))"
            cell.answeredView.userName.text = item.owner.displayName ?? ""
            if let imageUrl = URL(string: item.owner.profileImage ?? "") {
                cell.answeredView.userImage.image = try? UIImage(data: Data(contentsOf: imageUrl))
            }
            let badgeCounts = item.owner.badgeCounts ?? BadgeCount(bronze: 0, silver: 0, gold: 0)
            cell.answeredView.badges.text = "\(item.owner.reputation ?? 0)\u{1F538}\(badgeCounts.gold)\u{1F539}\(badgeCounts.silver)\u{1F53A}\(badgeCounts.bronze)"

            if let lastEditor = item.lastEditor {
                cell.editedView.isHidden = false
                cell.editedView.editedAnsweredLabel.text = "edited \(DateUtilities.getDate(item.lastEditDate ?? 0))"
                cell.editedView.userName.text = lastEditor.displayName
                cell.editedView.userImage.image = try? UIImage(data: Data(contentsOf: URL(string: lastEditor.profileImage ?? "")!))

                let badgeCounts = lastEditor.badgeCounts ?? BadgeCount(bronze: 0, silver: 0, gold: 0)
                cell.editedView.badges.text = "\( lastEditor.reputation ?? 0)\u{1F538}\(badgeCounts.gold)\u{1F539}\(badgeCounts.silver)\u{1F53A}\(badgeCounts.bronze)"
            } else {
                cell.editedView.isHidden = true
            }
            guard let comments = item.comments else { return cell }
            guard comments.count > 0 else { return cell }
            guard let sv = cell.commentsStackView.subviews[0] as? UIStackView else { return cell }
            for ids in 0...comments.count-1 {
                let userId: Int = comments[ids].owner?.userId ?? 0
                sv.addArrangedSubview(comments[ids].commentView(userId: userId, clickListener: getClickListener(userID: userId)))
            }
            cell.commentsStackView.moreCommentsButton.isHidden = true
            //cell.commentsStackView.moreCommentsButton.isHidden = commentsCount < 4 ? true : false
            cell.commentsStackView.moreCommentsButton.commentStackView = cell.commentsStackView
            cell.commentsStackView.moreCommentsButton.comments = comments
            return cell
        }
    }

    func getClickListener(userID: Int) -> ((Int) -> Void) {
        return ({ [weak self] userId in
            let userProfilePage = UserProfilePageViewController(userId: userId)
            userProfilePage.modalPresentationStyle = .popover
            self?.modalTransitionStyle = .flipHorizontal
            self?.showDetailViewController(userProfilePage, sender: self)
        })
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
