//
//  AppCoordinator.swift
//  Marvel
//
//  Created by Emil Marashliev on 10/29/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject {

    lazy var rootViewController: UIViewController = {
        return self.navigationController
    }()

    private lazy var networkManager = NetworkManager()
    private let storyboard = UIStoryboard(name: "App", bundle: nil)

    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    private lazy var listViewController: ListViewController = {
        let identifier = String(describing: ListViewController.self)
        let viewController =
            self.storyboard.instantiateViewController(withIdentifier: identifier)
                as! ListViewController
        viewController.networkManager = self.networkManager
        viewController.delegate = self
        return viewController
    }()

    private lazy var detailViewController: DetailViewController = {
        let identifier = String(describing: DetailViewController.self)
        let viewController =
            self.storyboard.instantiateViewController(withIdentifier: identifier)
                as! DetailViewController
        viewController.networkManager = self.networkManager
        return viewController
    }()

    func start() {
        self.navigationController.viewControllers = [self.listViewController]
    }
}

// MARK: - ListViewControllerDelegate

extension AppCoordinator: ListViewControllerDelegate {
    func selectedComics(with inxedPath: IndexPath) {
        navigationController.pushViewController(detailViewController, animated: true)
        detailViewController.collectionView?.scrollToItem(at: inxedPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
    }
}
