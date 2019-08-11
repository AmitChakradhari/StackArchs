import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

enum CellModel {
    case question(QuestionItems)
    case answer(AnswerItems)
}

struct SectionOfCustomData {
    var header: String
    var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
    init(original: SectionOfCustomData, items: [CellModel]) {
        self = original
        self.items = items
    }

    typealias Item = CellModel
}


class QuestionAnswerPageVC: UIViewController, UITableViewDelegate {

    var networkManager: NetworkManager!
    var tableView: UITableView!
    var backButton: UIButton!
    var questionId: Int!
    let questionCellIdentifier = "questionCell"
    let answerCellIdentifier = "answerCell"
    var questionData: [QuestionItems]!
    var questionAnswerPageViewModel: QuestionAnswerPageViewModel!
    var questionObserver: Observable<[QuestionItems]>!
    var answersObserver: Observable<[AnswerItems]>!
    var questionCellViewModel: QuestionCellViewModel!
    weak var coordinator: MainCoordinator?

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
            configureCell: { dataSource, tableView, indexPath, item in

                switch item {
                case .question(let question):
                    print(question.body)
                    return self.makeQuestionCell(from: question, tableView: self.tableView)
                case .answer(let answer):
                    print(answer.body)
                    return self.makeAnswerCell(from: answer, tableView: self.tableView)
                }
        })

        questionAnswerPageViewModel = QuestionAnswerPageViewModel()

        questionObserver = questionAnswerPageViewModel.getQuestionAnswer1(with: questionId).0

        answersObserver = questionAnswerPageViewModel.getQuestionAnswer1(with: questionId).1

        var observ: [SectionOfCustomData] = []

        questionObserver.subscribe(onNext: { [weak self] questionItem in

            let questionCellArray = questionItem.map {
                CellModel.question($0)
            }
            observ.append(SectionOfCustomData(header: "question", items: questionCellArray))
            self?.questionCellViewModel = QuestionCellViewModel(questionData: questionItem)

        })
        .disposed(by: disposeBag)

        answersObserver.subscribe(onNext: { answerItem in

            let answerCellArray = answerItem.map {
                CellModel.answer($0)
            }
            observ.append(SectionOfCustomData(header: "answer", items: answerCellArray))
            Observable.of(observ)
                .bind(to: self.tableView.rx.items(dataSource: dataSource))
                .disposed(by: self.disposeBag)

        })
        .disposed(by: disposeBag)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupView() {

        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        let questionAnswerPageView = QuestionAnswerPageView(frame: CGRect(x: 0, y: barHeight/2, width: displayWidth, height: displayHeight - barHeight/2))

        tableView = questionAnswerPageView.tableView
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: questionCellIdentifier)
        tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: answerCellIdentifier)

        view.addSubview(questionAnswerPageView)
        view.backgroundColor = .white
    }

    @objc func backButtonPressed(sender: UIButton) {
        coordinator?.dismissViewController()
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

    private func makeQuestionCell(from model: QuestionItems, tableView: UITableView) -> QuestionTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: questionCellIdentifier) as! QuestionTableViewCell

        if cell.contentView.bounds.width >= 450 {
            cell.editors.axis = .horizontal
        } else {
            cell.editors.axis = .vertical
        }

        let item = model

            cell.questionTitle.text = questionCellViewModel.questionTitle
            cell.questionDetail.text = questionCellViewModel.questionDetail
            cell.answeredView.editedAnsweredLabel.text = questionCellViewModel.answeredViewEditedAnsweredLabel
            cell.answeredView.userName.text = questionCellViewModel.answeredViewUserName
            cell.answeredView.userImage.image = try? UIImage(data: Data(contentsOf: URL(string: questionCellViewModel.answeredViewImageUrlString) ?? URL(fileURLWithPath: "")))
            cell.answeredView.badges.text = questionCellViewModel.answeredViewBadgesText

            if item.lastEditor != nil {
                cell.editedView.isHidden = false
                cell.editedView.editedAnsweredLabel.text = questionCellViewModel.answeredViewEditedAnsweredLabel
                cell.editedView.userName.text = questionCellViewModel.editedViewUserName
                cell.editedView.userImage.image = try? UIImage(data: Data(contentsOf: URL(string: questionCellViewModel.editedViewImageUrlString) ?? URL(fileURLWithPath: "")))
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
                let commentView = comments[ids].commentView()
                commentView.rx.tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { [weak self] gesture in
                        self?.coordinator?.showProfilePage(userId: userId)
                    })
                    .disposed(by: disposeBag)
                sv.addArrangedSubview(commentView)
            }
            cell.commentsStackView.moreCommentsButton.isHidden = true
            //cell.commentsStackView.moreCommentsButton.isHidden = commentsCount < 4 ? true : false
            cell.commentsStackView.moreCommentsButton.commentStackView = cell.commentsStackView
            cell.commentsStackView.moreCommentsButton.comments = comments

        return cell
    }

    private func makeAnswerCell(from model: AnswerItems, tableView: UITableView) -> AnswerTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: answerCellIdentifier) as! AnswerTableViewCell

        if cell.contentView.bounds.width >= 450 {
            cell.editors.axis = .horizontal
        } else {
            cell.editors.axis = .vertical
        }
        let item = model
        let answerCellData = AnswerCellViewModel(answerData: item)

        cell.answerDetail.text = answerCellData.answerDetail

        cell.answeredView.editedAnsweredLabel.text = answerCellData.answeredViewEditedAnsweredLabel
        cell.answeredView.userName.text = answerCellData.answeredViewUserName
        cell.answeredView.userImage.image = try? UIImage(data: Data(contentsOf: URL(string: answerCellData.answeredViewImageUrlString) ?? URL(fileURLWithPath: "")))
        cell.answeredView.badges.text = answerCellData.answeredViewBadgesText

        if item.lastEditor != nil {
            cell.editedView.isHidden = false
            cell.editedView.editedAnsweredLabel.text = answerCellData.editedViewEditedAnsweredLabel
            cell.editedView.userName.text = answerCellData.editedViewUserName
            cell.editedView.userImage.image = try? UIImage(data: Data(contentsOf: URL(string: answerCellData.editedViewImageUrlString) ?? URL(fileURLWithPath: "")))
            cell.editedView.badges.text = answerCellData.editedViewBadgesText
        } else {
            cell.editedView.isHidden = true
        }
        guard let comments = item.comments else { return cell }
        guard comments.count > 0 else { return cell }
        guard let sv = cell.commentsStackView.subviews[0] as? UIStackView else { return cell }
        for ids in 0...comments.count-1 {
            let userId: Int = comments[ids].owner?.userId ?? 0
            let commentView = comments[ids].commentView()
            commentView.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] gesture in
                    self?.coordinator?.showProfilePage(userId: userId)
                })
                .disposed(by: disposeBag)
            sv.addArrangedSubview(commentView)
        }
        cell.commentsStackView.moreCommentsButton.isHidden = true
        //cell.commentsStackView.moreCommentsButton.isHidden = commentsCount < 4 ? true : false
        cell.commentsStackView.moreCommentsButton.commentStackView = cell.commentsStackView
        cell.commentsStackView.moreCommentsButton.comments = comments
        return cell
    }

}

extension Comment {

    func commentView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.green
        let comment = UILabel()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.numberOfLines = 0
        let str = "\(self.bodyMarkdown)-\(self.owner?.displayName ?? "Anonymous")"
        comment.text = str
        comment.isUserInteractionEnabled = true

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
}
