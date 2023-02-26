//
//  HeroListViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/27/22.
//

import UIKit

struct HeroCellItem {
    let image: UIImage
    let text: String
} // done

class HeroListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var herosModel: [HeroModel] = [] // Oscar
    var places: [Place] = []
    
    var herosCD: [HeroCD] = []
//    var heroApi: HeroModel!
    var heroCD: HeroCD!
    
    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
    let loginInfo = LoginViewController() // use this to get user token
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Heros"
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")
        
        let tokenFmUD = LocalDataLayer.shared.getTokenFmUserDefaults() // load token prior to api calls
        let tokenFmKC = loginInfo.getToken(account: UserDefaults.standard.string(forKey: "email") ?? "")
        
        // Oscar start
        NetworkLayer.shared.fetchHeros(token: tokenFmUD) { [weak self] allHeros, error in
            guard let self = self else { return }
            
            if let allHeros = allHeros {
                self.herosModel = allHeros
                
                LocalDataLayer.shared.saveHerosToUserDefaults(heros: allHeros)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error fetching heros: ", error?.localizedDescription ?? "")
            }
        } // Oscar end
        
//        if herosCD.isEmpty { // copied this chunk fm CoreDataEjemplo > EmployeesViewController > ViewDidLoad()
//            debugPrint("herosCD isEmpty")
//
//            NetworkLayer.shared.fetchHeros(token: tokenFmUD) { [weak self] herosFmApi, error in
//                guard let self = self else { return }
//
////                print("herosFmApi = \(String(describing: herosFmApi))\n") // works
//
////                LocalDataLayer.shared.saveHerosToUserDefaults(heros: herosFmApi ?? []) // old save way
//
//                let group1 = DispatchGroup()
////                let group2 = DispatchGroup()
//
//                // map api values into Core Data
//                if let herosForMapping = self.heroCD { // this block fails
//
//                    print("Hi\n")
//
//                    herosFmApi?.forEach { hero in
//                        group1.enter()
//                        print("Hero loop: \(String(describing: herosFmApi))")
//                        herosForMapping.id = hero.id
//                        herosForMapping.name = hero.name
//                        herosForMapping.desc = hero.description
//                        herosForMapping.photo = hero.photo
//                        herosForMapping.favorite = hero.favorite
//
//                        NetworkLayer.shared.fetchLocations(token: tokenFmUD, heroId: hero.id) { heroLocations, error in
//                            var heroWithLocation = hero
//
//                            if let firstLocation = heroLocations?.first {
//                                herosForMapping.latitude = Double(firstLocation.latitud) ?? 0.0
//                                herosForMapping.longitude = Double(firstLocation.longitud) ?? 0.0
//                            } else {
//                                heroWithLocation.latitude = 0.0
//                                heroWithLocation.longitude = 0.0
//                            }
//                            group1.leave()
//                        }
//
//                    }
//
//                    group1.notify(queue: .main) {
//                        print("Group 1 tasks done\n")
//                    }
//
//                    print("\(herosForMapping)\n")
////                    self.saveHerosToCoreData(heros: herosForMapping)
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                } else {
//                    print("Error fetching heros: ", error?.localizedDescription ?? "") // this error is firing...
//                }
//            }
//
//
//
//        } else {
//            debugPrint("heros is NOT empty")
//        }
        
        // Read fm HeroCD & map to HeroModel
        
        configureItems() // load bar buttons
        
        
    } // End viewDidLoad
    
    let moveToMain = { (heros: [HeroModel]) -> Void in
        debugPrint("Reciviendo toda la info")

        debugPrint("Número de héroes: \(heros.count)\n")

        heros.forEach { debugPrint("La localización para el item \($0.id) es: [\($0.latitude!),\($0.longitude!)]") }
    } // printer func

//    func saveHerosToUserDefaults(heros: [Hero]) {
//        if let encodedHeros = try? JSONEncoder().encode(heros) {
//            UserDefaults.standard.set(encodedHeros, forKey: Self.heros)
//        }
//    } // this is the magic save func for UserDefaults
    
//    private func saveInCoreDataWith(array: [[String: AnyObject]]) { // Tutorial code adapted
//        //_ = array.map{self.createPhotoEntityFrom(dictionary: $0)}
//        do {
//            try CoreDataManager.sharedInstance.persistentContainerF.viewContext.save()
//        } catch let error {
//            print(error)
//        }
//    }
    
    func saveHerosToCoreData(heros: HeroModel) {
//        if let encodedHeros = try? JSONEncoder().encode(heros) { // 'encodedHeros not used as written...
        
        let heros = HeroCD(context: context)
            do {
                try context.save()
//                try CoreDataManager.saveContext(<#T##self: CoreDataManager##CoreDataManager#>)
            } catch let error {
                debugPrint(error)
                showError()
            }
        //}
    }
    
    
    private func showError() {
        let alert = UIAlertController(title: "Warning!", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
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
            
            //self?.delegate.dismiss()
        }))
        
        self.present(alert, animated: true, completion: nil)
    } // imported fm CoreDataEjemplo
    
    // table rows creation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return herosModel.count
    } // should be complete
    
    // table cell UI creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        
        // updated to accept API data
        let hero = herosModel[indexPath.row]
        
        cell.iconImageView.setImage(url: hero.photo ?? "") // need to write extension
        cell.titleLabel.text = hero.name
        cell.descriptionLabel.text = hero.description // connected label to TableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
                
        return cell
    } // should be complete

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = herosModel[indexPath.row]
        let detailsView = DetailsViewController()
        detailsView.hero = hero
        navigationController?.pushViewController(detailsView, animated: true)
    } // enables detailsView viewing
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // empty
    }
        
    private func configureItems() {
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(
            title: "Logout", image: UIImage(named: ""), target: self, action: #selector(didTapLogoutButton2) // person.cirle, ipad.and.arrow.forward, images: marker-blue, exit,
        ),
            UIBarButtonItem(
            title: "test", image: UIImage(systemName: "play"), target: self, action: #selector(didTapTestButton)
            )
        ]
    } // logout & test buttons
    
    @IBAction func didTapLogoutButton2() {
        
        var window: UIWindow?
        let loginVC = LoginViewController()
        
        UserDefaults.standard.set(false, forKey: "login status") // set login status
        print("Login status: \(UserDefaults.standard.bool(forKey: "login status"))\n")
        
        loginInfo.deleteTokens(service: "token mgmt", account: UserDefaults.standard.string(forKey: "email") ?? "")
        
        self.present(loginVC, animated: true) // modal pop up, works, not secure/effective
//        window?.rootViewController = LoginViewController()
//        VcSelector.updateRootVC() // call vc selector
    }
    
    @IBAction func didTapTestButton() {
        
        // Test functions below
        print("didTapLogoutButton pressed\n")
        
        print("Context = \(context)\n")
        
        print("HerosListVC > herosModel: [HeroModel] = \(herosModel)\n")
        
//        print("HerosListVC > hero: Hero! = \(String(describing: heroCD ?? nil))\n")
        
        print("Token fm UserDefaults = \(String(describing: UserDefaults.standard.string(forKey: "token")))\n")
        print("Email fm UserDefaults = \(String(describing: UserDefaults.standard.string(forKey: "email")))\n")
        print("Password fm UserDefaults = \(String(describing: UserDefaults.standard.string(forKey: "password")))\n")
        //KeyChainManager.readData(LoginViewController.userEmail)
        
        let token = LocalDataLayer.shared.getTokenFmUserDefaults()

        // Using 1st implementation attempt
//        NetworkLayer
//            .shared
//            .fetchLocations(token: token, heroId: hero.id) { [weak self] allPlaces, error in
//                guard let self = self else { return }
//
//                if let allPlaces = allPlaces {
//
//                    self.places = allPlaces
//
//                    print("Places count: ", allPlaces.count)
//
//                    if !self.places.isEmpty {
//                        DispatchQueue.main.async {
//                            //self.didTapTestButton.alpha = 1
//                            debugPrint("places is empty")
//                        }
//                    }
//                } else {
//                    print("Error fetching places: ", error?.localizedDescription ?? "")
//                }
//            }
        
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
