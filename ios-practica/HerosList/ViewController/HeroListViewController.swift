//
//  HeroListViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//

import UIKit

class HeroListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let heroViewModel = HeroViewModel()
//    static var herosToShow: [HeroModel] = []
    var place: Place! // needed for location api call & parsing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Heroes"
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")

        heroViewModel.checkForExistingHeroes()
        
        addNotfication()

    } // End viewDidLoad
    
    func addNotfication() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshHeroList(_:)), name: NSNotification.Name("data.is.loaded.into.CD"), object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name("data.is.loaded.into.CD"),
                                                  object: nil)
    }
    
    @objc
    func refreshHeroList(_ notification: Notification) {
        print("Core Data tasks complete, self.tableView.reloadData()...\n")
        self.tableView.reloadData()
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Warning!", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in // [weak self] action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                print("unknown")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HeroViewModel.heroesShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        let hero = HeroViewModel.heroesShow[indexPath.row]
        
        cell.iconImageView.setImage(url: hero.photo )
        cell.titleLabel.text = hero.name
        cell.descriptionLabel.text = hero.description
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
                
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let hero = HeroViewModel.heroesShow[indexPath.row]
        let detailsView = DetailsViewController()
        detailsView.hero = hero
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // empty
    }
        
    private func configureItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout", image: UIImage(named: ""), target: self, action: #selector(didTapLogoutButton)
        )
    }
    
    private func configureItems2() {
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(
            title: "Logout", image: UIImage(named: ""), target: self, action: #selector(didTapLogoutButton)
        ),
                                                    UIBarButtonItem(
                                                        title: "aux", image: UIImage(systemName: "play"), target: self, action: #selector(didTapAuxButton)
                                                    )
        ]
    } // logout & test buttons
    
    @IBAction func didTapAuxButton() {
        
        print("\nAux button pressed\n")
        NotificationCenter.default.post(name: Notification.Name("data.is.loaded.into.CD"), object: nil)
    }
    
    @IBAction func didTapLogoutButton() {
        
        let loginVC = LoginViewController()
        
        KeychainManager.deleteTokenFmKC()
        Global.loginStatus = false
        print("Global.loginStatus: \(Global.loginStatus)\n\n")
        
        CoreDataManager.deleteCoreData()
        
        loginVC.isModalInPresentation = true // prevent swipe away
        self.present(loginVC, animated: true)
    }

}


extension UIImageView {
    
    private func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
    func setImage(url: String) {
        guard let url = URL(string: url) else { return }
        
        downloadImage(url: url) { [weak self] image in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

extension UIBarButtonItem {
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}

struct HeroCellItem {
    let image: UIImage
    let text: String
}
