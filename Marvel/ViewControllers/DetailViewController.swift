//
//  DetailViewController.swift
//  Marvel
//
//  Created by Emil Marashliev on 11/2/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import UIKit
import Nuke

class DetailViewController: UICollectionViewController {

    var networkManager: NetworkManager!
    private var comiscsObserverKey: String?

    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView?.collectionViewLayout.delegate
        collectionView?.prefetchDataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        comiscsObserverKey = ComicsManager.addObserver { [unowned self] in
            self.collectionView?.reloadData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let comiscsObserverKey = self.comiscsObserverKey {
            ComicsManager.removeObserver(with: comiscsObserverKey)
        }
    }


    //MARK: - Collection view data source

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {

        return ComicsManager.comicses.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let identifier = String(describing: ComicsCollectionViewCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath)
            as! ComicsCollectionViewCell
        let comics = ComicsManager.comicses[indexPath.row]
        cell.coverImage.image = #imageLiteral(resourceName: "Placeholder1")
        if let thumbnail = comics.thumbnail, let url = URL(string: thumbnail) {
            Nuke.loadImage(with: url, into: cell.coverImage)
        }
        cell.titleLabel.text = comics.title
        cell.descriptionLabel.text = comics.comicsDescription ?? "No description available"
        var charactersText = ""
        if let characters = comics.characters {
            charactersText = characters.flatMap({$0.name}).joined(separator: ", ")
        }
        if charactersText.isEmpty {
            cell.charactersLabel.text = "No characters."
        } else {
             cell.charactersLabel.text = charactersText
        }

        return cell
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension DetailViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        ComicsManager.fetchComicsesIfNeeded(for: indexPaths, with: networkManager)
        ComicsManager.startImagePreheating(indexPaths)
    }

    func collectionView(_: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        ComicsManager.stopImagePreheating(indexPaths)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 288, height: 457)
    }
}
