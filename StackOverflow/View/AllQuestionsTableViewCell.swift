import UIKit

class AllQuestionsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(questionTitle)
        contentView.addSubview(questionTag)
        contentView.addSubview(createdDate)
        translatesAutoresizingMaskIntoConstraints = false
        addConstraintsAmongSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        print("aDecoder")
        fatalError("init(coder:) has not been implemented")
    }

    let questionTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()

    let questionTag: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()

    let createdDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

    func addConstraintsAmongSubviews() {

        NSLayoutConstraint.activate([
            questionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            questionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            questionTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),

            questionTag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            questionTag.trailingAnchor.constraint(equalTo: createdDate.leadingAnchor, constant: -10),
            questionTag.topAnchor.constraint(equalTo: questionTitle.bottomAnchor, constant: 10),
            questionTag.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            createdDate.leadingAnchor.constraint(equalTo: questionTag.trailingAnchor, constant: 10),
            createdDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            createdDate.topAnchor.constraint(equalTo: questionTitle.bottomAnchor, constant: 10),
            createdDate.widthAnchor.constraint(equalToConstant: 80)
            ])
    }

}
