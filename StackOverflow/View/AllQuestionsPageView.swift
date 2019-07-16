import UIKit
class AllQuestionPageView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.frame = frame
        addSubview(tableView)
    }
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
