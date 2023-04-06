//
//  HeroListViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//

import UIKit

struct HeroCellItem {
    let image: UIImage
    let text: String
}

class HeroListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    static var herosModel: [HeroModel] = []
    static var herosToShow: [HeroModel] = []
//    let heroViewModel = HeroViewModel()
    var heroModel: HeroModel!
    var places: [Place] = []
    var place: Place! // w/o !, error "no initializers"
    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
    let loginInfo = LoginViewController() // use this to get user token
    let keychain = KeychainManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configureItems() // load bar buttons
        configureItems2() // load bar buttons
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Heros"
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")
        
        print("\nInitial check for heroes in CD...")
        HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation()
        print("Core Data inventory check of herosToShow: \(HeroListViewController.herosToShow.count)\n")
        
        if HeroListViewController.herosToShow.isEmpty {
            
            print("herosToShow.isEmpty == true... make api calls\n")
            
            NetworkLayer.shared.fetchHeros(token: Global.tokenMaster) { [weak self] herosModelContainer, error in
                guard let self = self else { return }

                if let herosModelContainer = herosModelContainer {

                    self.addLocationsToHeroModel(herosModelContainer) // saveToCD nested
//                        for hero in heros
//                            group.notify
//                                moveToMain (héros.forEach)
//                                    saveApiDataToCoreData
//                                    getCoreDataForPresentation // has notif.post..

                    DispatchQueue.main.async {
                    }
                } else {
                    print("Error fetching heros: ", error?.localizedDescription ?? "")
                }
            }
        } else {
            print("herosToShow is NOT empty\n")
        }
        
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
        print("Core Data tasks complete, self.tableView.reloadData()...")
        self.tableView.reloadData()
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Warning!", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in // ⚠️ was [weak self] Variable 'self' was written to, but never read
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            @unknown default:
                debugPrint("unknown")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HeroListViewController.herosToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        
        // updated to accept API data
            let hero = HeroListViewController.herosToShow[indexPath.row]
        
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
        let hero = HeroListViewController.herosToShow[indexPath.row]
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
    } // logout & test buttons
    
    private func configureItems2() {
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(
            title: "Logout", image: UIImage(named: ""), target: self, action: #selector(didTapLogoutButton) // person.cirle, ipad.and.arrow.forward, images: marker-blue, exit,
        ),
                                                    UIBarButtonItem(
                                                        title: "aux", image: UIImage(systemName: "play"), target: self, action: #selector(didTapAuxButton)
                                                    )
        ]
    } // logout & test buttons
    
    @IBAction func didTapAuxButton() {
        
        print("\nAux button pressed\n")
        NotificationCenter.default.post(name: Notification.Name("data.is.loaded.into.CD"), object: nil) // This notification works to refersh the UI!!
//        self.tableView.reloadData()
//        KeychainManager.deleteToken()
//        CoreDataManager.deleteCoreData() 
    }
    
    @IBAction func didTapLogoutButton() {
        
//        var window: UIWindow?
        let loginVC = LoginViewController()
        
        KeychainManager.deleteToken()
        Global.loginStatus = false
        print("Global.loginStatus: \(Global.loginStatus)\n\n")
        
        // Delete heros in CD
        CoreDataManager.deleteCoreData()
        
        self.present(loginVC, animated: true) // modal pop up, works, not secure/effective
//        window?.rootViewController = LoginViewController()
//        VcSelector.updateRootVC() // call vc selector
    }

/// move to HeroViewModel
    let addLocationsToHeroModel = {(heros: [HeroModel]) -> Void in
        print("\nStarting addLocationsToHeroModel...\n")
        var herosWithLocations: [HeroModel] = []

        let group = DispatchGroup() // https://developer.apple.com/documentation/dispatch/dispatchgroup

        for hero in heros {
            group.enter() // Apple Docs: Explicitly indicates that a block has entered the group.

            NetworkLayer.shared.getLocalization(token: Global.tokenMaster, with: hero.id) { heroLocations, error in
                var fullHero = hero

                if let firstLocation = heroLocations.first { // only grab first hero location
                    fullHero.latitude = Double(firstLocation.latitud)
                    fullHero.longitude = Double(firstLocation.longitud)
                } else {
                    fullHero.latitude = 0.0
                    fullHero.longitude = 0.0
                }
                herosWithLocations.append(fullHero)
                group.leave() // indicates the operation will termianate
            }
        }

        group.notify(queue: .main) {
            debugPrint("herosWithLocations count (Should be 18): \(herosWithLocations.count)")

            debugPrint("L227: HeroListViewController.herosToShow.count (Should be 18): \(HeroListViewController.herosToShow.count)\n")

            moveToMain2(herosWithLocations) //... contains: saveApiDataToCoreData
        }
    } // end addLocationsToHeroModel

} // end class HeroListVC

/// move to HeroViewModel
//let moveToMain = { (heros: [HeroModel]) -> Void in
//
//    print("Starting moveToMain... heros.forEach... saveApiDatatoCoreData")
//    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
//
//    debugPrint("Hero count: \(heros.count)")
//
//    CoreDataManager.saveApiDataToCoreData(heros) // write api data to core data
//
//    HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation()
//    
//} // move to HeroViewModel

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

