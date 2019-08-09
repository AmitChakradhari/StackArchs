import UIKit
import RxSwift
import RxCocoa

class AllQuestionsPage: UIViewController {

    var tableView: UITableView!
    let cellIdentifier = "allQuestionCell"
    var allQuestionPageViewModel: AllQuestionPageViewModel!
    var questionsObservable: Observable<[AllQuestionsItems]>!
    weak var coordinator: MainCoordinator?

    let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()

        allQuestionPageViewModel = AllQuestionPageViewModel()

        questionsObservable = allQuestionPageViewModel.getAllQuestions()

        questionsObservable
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: AllQuestionsTableViewCell.self)) { [weak self] (row, element, cell) in

            guard let strongSelf = self else { return }

            let cellData = strongSelf.allQuestionPageViewModel.questionCellItem(item: element)
            cell.questionTitle.text = cellData.questionTitle
            cell.questionTag.text = cellData.questionTag
            cell.createdDate.text = cellData.createdDate
            }
        .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(AllQuestionsItems.self)
            .subscribe(onNext: { [weak self] value in
                self?.modalTransitionStyle = .flipHorizontal
                self?.coordinator?.questionAnswer(qId: value.questionId)
            })
            .disposed(by: disposeBag)

        }

    func setUpTableView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        let allQuestionPageView =  AllQuestionPageView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight/2))
        tableView = allQuestionPageView.tableView
        tableView.register(AllQuestionsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)
    }

}
