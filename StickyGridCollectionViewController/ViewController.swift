//
//  ViewController.swift
//  StickyGridCollectionViewController
//
//  Created by djiang on 28/07/21.
//

import UIKit

class ViewController: UIViewController {
    private lazy var stickyLayout: StickyGridCollectionViewLayout = {
        let layout = StickyGridCollectionViewLayout()
        layout.stickyRowsCount = 1
        layout.stickyColumnsCount = 1
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: stickyLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = false
        collectionView.alwaysBounceVertical = false
        collectionView.bounces = false
        collectionView.isUserInteractionEnabled = true
        collectionView.backgroundColor = .blue
        collectionView.register(CollectionviewCell.self, forCellWithReuseIdentifier: CollectionviewCell.reuseIdentifer)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.backgroundColor = .red
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionviewCell.reuseIdentifer,
            for: indexPath) as? CollectionviewCell else { fatalError("Could not create new cell") }
        cell.title = "\(indexPath)"
        cell.backgroundColor = stickyLayout.isSticky(at: indexPath) ? .gray : .white

//        cell.onTap = { [weak self] _ in
//        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
}
