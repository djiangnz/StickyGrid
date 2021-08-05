//
//  CollectionViewCell.swift
//  CollectionviewCell
//
//  Created by djiang on 28/07/21.
//

import UIKit

class CollectionviewCell: UICollectionViewCell {
    static let reuseIdentifer = "sticky cell"

    var onTap: (CollectionviewCell) -> Void = { _ in }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.preferredFont(forTextStyle: .headline)
        view.adjustsFontForContentSizeCategory = true
        view.isUserInteractionEnabled = true
        view.textColor = .purple
        view.textAlignment = .center
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowRadius = 3.0
//        view.layer.shadowOpacity = 1.0
//        view.layer.shadowOffset = CGSize(width: 4, height: 4)
//        view.layer.masksToBounds = false
        return view
    }()

    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        return gesture
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionviewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
    }

    func configure() {
        contentView.addSubview(titleLabel)
        titleLabel.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

extension CollectionviewCell {
    @objc private func onTap(_ sender: UITapGestureRecognizer) {
        onTap(self)
    }
}
