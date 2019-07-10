import UIKit

class AnswerTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(answerDetail)
        contentView.addSubview(editors)
        editors.addArrangedSubview(editedView)
        editors.addArrangedSubview(answeredView)
        contentView.addSubview(commentsStackView)
        translatesAutoresizingMaskIntoConstraints = false
        addConstraintsAmongSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let answerDetail: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()

    let editedView = EditedAnsweredView(frame: CGRect(x: 0, y: 0, width: 220, height: 90))
    let answeredView = EditedAnsweredView(frame: CGRect(x: 0, y: 0, width: 220, height: 90))
    var commentsStackView = CommentsStackView(frame: CGRect.zero)

    let editors: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 10.0

        return stackView
    }()

    func addConstraintsAmongSubviews() {
        NSLayoutConstraint.activate([

            answerDetail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            answerDetail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            answerDetail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            //answerDetail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            editors.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            editors.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            editors.topAnchor.constraint(equalTo: answerDetail.bottomAnchor, constant: 10),
            //editors.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            commentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            commentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            commentsStackView.topAnchor.constraint(equalTo: editors.bottomAnchor, constant: 10),
            commentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
    }
}
