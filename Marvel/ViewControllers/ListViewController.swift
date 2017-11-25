//
//  ListViewController.swift
//  Marvel
//
//  Created by Emil Marashliev on 10/31/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import UIKit
import Nuke
import StatefulViewController

protocol ListViewControllerDelegate: class {
    func selectedComics(with inxedPath: IndexPath)
}

class ListViewController: UITableViewController {

    var networkManager: NetworkManager!
    weak var delegate: ListViewControllerDelegate!

    @IBOutlet var loadingPlaceholderView: LoadingPlaceholderView!
    @IBOutlet var emptyPlaceholderView: EmptyPlaceholderView!

    private let preheater = Preheater()
    private var comiscsObserverKey: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.prefetchDataSource = self
        emptyPlaceholderView.setupView()
        emptyView = emptyPlaceholderView
        loadingView = loadingPlaceholderView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        comiscsObserverKey = ComicsManager.addObserver { [unowned self] in
            self.tableView.reloadData()
        }
        setupInitialViewState()
        refresh()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let comiscsObserverKey = self.comiscsObserverKey {
            ComicsManager.removeObserver(with: comiscsObserverKey)
        }
    }

    private func refresh() {
        guard lastState != .loading else { return }

        startLoading()

        networkManager.getComics { [unowned self] comicses, success in
            if !comicses.isEmpty, success {
                self.tableView.separatorStyle = .singleLine
                ComicsManager.comicses  = comicses
            }
            self.endLoading(animated: true)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComicsManager.comicses.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let identifier = String(describing: ComicsTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            as! ComicsTableViewCell
        let comics = ComicsManager.comicses[indexPath.row]
        cell.coverImage.image = #imageLiteral(resourceName: "Placeholder1")
        if let thumbnail = comics.thumbnail, let url = URL(string: thumbnail) {
            Nuke.loadImage(with: url, into: cell.coverImage)
        }
        return cell

    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(220)
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selectedComics(with: indexPath)
    }
}

// MARK: - StatefulViewController

extension ListViewController: StatefulViewController {
    func hasContent() -> Bool {
        return !ComicsManager.comicses.isEmpty
    }
}

// MARK: - UITableViewDataSourcePrefetching

extension ListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        ComicsManager.fetchComicsesIfNeeded(for: indexPaths, with: networkManager)
        ComicsManager.startImagePreheating(indexPaths)
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        ComicsManager.stopImagePreheating(indexPaths)
    }
}
