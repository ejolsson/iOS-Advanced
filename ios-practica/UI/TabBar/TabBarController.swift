//
//  TabBarController.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabs()
    }
    
    private func setupTabs() {
        let navigationController1 = UINavigationController(rootViewController: HeroListViewController())
        let tabImage1 = UIImage(systemName: "text.justify")!
        navigationController1.tabBarItem = UITabBarItem(title: "Hero List", image: tabImage1, tag: 0)
        
        let navigationController2 = UINavigationController(rootViewController: MapViewController())
        let tabImage2 = UIImage(systemName: "map")!
        navigationController2.tabBarItem = UITabBarItem(title: "Map", image: tabImage2, tag: 1)
        
        viewControllers = [navigationController1, navigationController2]
    }

}
