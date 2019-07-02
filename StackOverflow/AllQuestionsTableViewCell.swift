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

//            questionTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: frame.size.width, height: 20, enableInsets: false)
//            questionTag.anchor(top: questionTitle.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width, height: 20, enableInsets: false)
//            createdDate.anchor(top: questionTag.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width, height: 20, enableInsets: false)
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
// https://medium.com/@kemalekren/swift-create-custom-tableview-cell-with-programmatically-in-ios-835d3880513d
  //  questionTitle.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
//    productNameLabel.anchor(top: topAnchor, left: productImage.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
//    productDescriptionLabel.anchor(top: productNameLabel.bottomAnchor, left: productImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)

extension UIView {

    func anchor (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat, enableInsets: Bool) {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)

        if #available(iOS 11, *), enableInsets {
            let insets = self.safeAreaInsets
            topInset = insets.top
            bottomInset = insets.bottom

            print("Top: \(topInset)")
            print("bottom: \(bottomInset)")
        }

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop+topInset).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom-bottomInset).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

    }
}
