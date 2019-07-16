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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        view.backgroundColor = .white
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
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let questionAnswerPageView = QuestioAnswerPageView(tableViewFrame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        tableView = questionAnswerPageView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: questionCellIdentifier)
        tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: answerCellIdentifier)
        view.addSubview(tableView)

        backButton = questionAnswerPageView.backButton
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
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
                //cell.comments = item.comments ?? 0
                cell.questionTitle.text = item.title
                cell.questionDetail.text = item.bodyMarkdown

                // answered is asked
                cell.answeredView.editedAnsweredLabel.text = "asked \(Utility.getDate(item.creationDate))"
                cell.answeredView.userName.text = item.owner.displayName
                cell.answeredView.userImage.image = try? UIImage(data: Data(contentsOf: URL(string: item.owner.profileImage ?? "")!))

                let badgeCounts = item.owner.badgeCounts ?? BadgeCount(bronze: 0, silver: 0, gold: 0)

                cell.answeredView.badges.text = "\( item.owner.reputation ?? 0)\u{1F538}\(badgeCounts.gold)\u{1F539}\(badgeCounts.silver)\u{1F53A}\(badgeCounts.bronze)"

                if let lastEditor = item.lastEditor {
                    cell.editedView.isHidden = false
                    cell.editedView.editedAnsweredLabel.text = "edited \(Utility.getDate(item.lastActivityDate))"
                    cell.editedView.userName.text = lastEditor.displayName
                    cell.editedView.userImage.image = try? UIImage(data: Data(contentsOf: URL(string: lastEditor.profileImage ?? "")!))

                    let badgeCounts = lastEditor.badgeCounts ?? BadgeCount(bronze: 0, silver: 0, gold: 0)

                    cell.editedView.badges.text = "\( lastEditor.reputation ?? 0)\u{1F538}\(badgeCounts.gold)\u{1F539}\(badgeCounts.silver)\u{1F53A}\(badgeCounts.bronze)"
                } else {
                    cell.editedView.isHidden = true
                }
                let count = item.comments?.count
                guard let commentsCount = count, let comments = item.comments else { return cell }
                guard commentsCount > 0 else { return cell }
                guard let sv = cell.commentsStackView.subviews[0] as? UIStackView else { return cell }
//                if commentsCount > 3 {
//                    for ids in 0...2 {
//
//                        sv.addArrangedSubview(item.comments[ids].commentView())
//                    }
//                } else {
//                    for ids in 0...commentsCount-1 {
//                        sv.addArrangedSubview(item.comments[ids].commentView())
//                    }
//                }
                for ids in 0...commentsCount-1 {
                    let userId: Int = comments[ids].owner?.userId ?? 0
                    sv.addArrangedSubview(comments[ids].commentView(userId: userId, clickListener: getClickListener(userID: userId)))
                }
                //cell.commentsStackView.moreCommentsButton.isHidden = false
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
            cell.answeredView.editedAnsweredLabel.text = "answered \(Utility.getDate(item.creationDate))"
            cell.answeredView.userName.text = item.owner.displayName ?? ""
            if let imageUrl = URL(string: item.owner.profileImage ?? "") {
                cell.answeredView.userImage.image = try? UIImage(data: Data(contentsOf: imageUrl))
            }
            let badgeCounts = item.owner.badgeCounts ?? BadgeCount(bronze: 0, silver: 0, gold: 0)
            cell.answeredView.badges.text = "\(item.owner.reputation ?? 0)\u{1F538}\(badgeCounts.gold)\u{1F539}\(badgeCounts.silver)\u{1F53A}\(badgeCounts.bronze)"

            if let lastEditor = item.lastEditor {
                cell.editedView.isHidden = false
                cell.editedView.editedAnsweredLabel.text = "edited \(Utility.getDate(item.lastEditDate ?? 0))"
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
