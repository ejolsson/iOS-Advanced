//
//  HeroListViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//

import UIKit

let tokenHardCode = "eyJraWQiOiJwcml2YXRlIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJpZGVudGlmeSI6IkI4M0I1NjZCLUY2NEItNENGNi1CQzI1LUIwQTAxNkQzNkIzMiIsImVtYWlsIjoiZWpvbHNzb25AZ21haWwuY29tIiwiZXhwaXJhdGlvbiI6NjQwOTIyMTEyMDB9.fBTvAWVKbqaJoDAFvpLlO6YY5gjCPVwxJbXvCQMKiBw"

struct HeroCellItem {
    let image: UIImage
    let text: String
} // done

class HeroListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    static var herosModel: [HeroModel] = []
    static var herosToShow: [HeroModel] = []
    var heroModel: HeroModel!
    var places: [Place] = []
    var place: Place! // w/o !, error "no initializers"
    
//    var herosCD: [HeroCD] = []
//    var heroCD: HeroCD!
    
    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
    let loginInfo = LoginViewController() // use this to get user token
    let keychain = KeychainManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems() // load bar buttons
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Heros"
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")
        
        // Get Token
        let tokenFmUD = LocalDataLayer.shared.getTokenFmUserDefaults() // load token prior to api calls
//        let tokenFmKC = loginInfo.getToken(account: UserDefaults.standard.string(forKey: "email") ?? "")
        
        let tokenRaw: () = loginInfo.getTokenSimple(account: "tokenSimple")

        print("userToken: \(loginInfo.userToken)\n")
        let tokenBig: () = keychain.readDataBigToken(username: "token-manager")
//        let tokenString = String(decoding: tokenBig, as: UTF8.self)
        
        

//        NetworkLayer.shared.fetchHeros(token: tokenFmUD) { [weak self] allHeros, error in
//            guard let self = self else { return }
//
//            if let allHeros = allHeros {
//                self.herosModel = allHeros
////                print("Check out herosModel INSIDE api call: \(self.herosModel)\n")
//                LocalDataLayer.shared.saveHerosToUserDefaults(heros: allHeros)
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            } else {
//                print("Error fetching heros: ", error?.localizedDescription ?? "")
//            }
//        } // save to UserDefaults
        
//        print("herosToShow check: \(herosCD[0...4])\n")
        
        if HeroListViewController.herosToShow.isEmpty {
            NetworkLayer.shared.fetchHeros(token: tokenFmUD) { [weak self] herosModelContainer, error in // hero api call
                guard let self = self else { return }
                
                print("herosToShow is Empty\nherosToShow: \(HeroListViewController.herosToShow)\n")
                
                if let herosModelContainer = herosModelContainer {
                    
                    self.addLocationsToHeroModel(herosModelContainer) // location api call, append HeroModel
                    
                    print("herosModelContainer[6] = \(herosModelContainer[6])\n")
                    
                    HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation() // get core data, write to 'herosToShow'
                    
                    print("\nHeroListViewController > viewDidLoad HeroListViewController.herosToShow[6]:\n\(HeroListViewController.herosToShow[6])\n")
                    
                    HeroListViewController.herosModel = HeroListViewController.herosToShow // assign local instance to global variable to be read and used
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Error fetching heros: ", error?.localizedDescription ?? "")
                }
            }
        } else {
            print("HerosCD is NOT empty\n")
            let herosToShow = CoreDataManager.getCoreDataForPresentation()
        }

        
        
    } // End viewDidLoad
    
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HeroListViewController.herosModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        
        // updated to accept API data
        let hero = HeroListViewController.herosModel[indexPath.row]
        
        cell.iconImageView.setImage(url: hero.photo ) // need to write extension
        cell.titleLabel.text = hero.name
        cell.descriptionLabel.text = hero.description // connected label to TableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
                
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = HeroListViewController.herosModel[indexPath.row]
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
        
        loginInfo.deleteKeychainItem(service: "token mgmt", account: UserDefaults.standard.string(forKey: "email") ?? "")
        
        self.present(loginVC, animated: true) // modal pop up, works, not secure/effective
//        window?.rootViewController = LoginViewController()
//        VcSelector.updateRootVC() // call vc selector
    }
    
    @IBAction func didTapTestButton() {
        
        // Test functions below
//        print("didTapLogoutButton pressed\n")
//        print("Context = \(context)\n")
//        print("HerosListVC > herosModel: [HeroModel] = \(herosModel)\n")
//        print("HerosListVC > hero: Hero! = \(String(describing: heroCD ?? nil))\n")
//        print("Token fm UserDefaults = \(String(describing: UserDefaults.standard.string(forKey: "token")))\n")
//        print("Email fm UserDefaults = \(String(describing: UserDefaults.standard.string(forKey: "email")))\n")
//        print("Password fm UserDefaults = \(String(describing: UserDefaults.standard.string(forKey: "password")))\n")
        //KeyChainManager.readData(LoginViewController.userEmail)
        
        let token = LocalDataLayer.shared.getTokenFmUserDefaults()
        let email = "ejolsson@gmail.com"

        loginInfo.deleteKeychainItem(service: "token mgmt", account: email) //pass
        loginInfo.deleteKeychainItem(service: "password mgmt", account: email) // fail
        loginInfo.deleteKeychainItem(service: "password mgmt", account: "ejolsson@gmail.com") //fail
        loginInfo.deleteKeychainItem(service: "password mgmt", account: "tokenSimple") // pass
        loginInfo.deleteKeychainItem(service: "", account: "tokenSimple") // fail
    }

    
    let addLocationsToHeroModel = {(heroes: [HeroModel]) -> Void in // was updateFullItems
        print("Step 2: let addLocationsToHeroModel\n")
        var herosWithLocations: [HeroModel] = []
        
        let group = DispatchGroup() // https://developer.apple.com/documentation/dispatch/dispatchgroup
        
        for hero in heroes { // loop through all heros found in api call
            group.enter() // INDICA QUE LA OPERACIÓN COMIENZA // Apple Docs: Explicitly indicates that a block has entered the group.
            
            NetworkLayer.shared.getLocalization(token: tokenHardCode, with: hero.id) { heroLocations, error in
                var fullHero = hero // instantiate hero, using the " hero loop index"
                // use if let due to case when lat/long nil
                if let firstLocation = heroLocations.first { // only grab first hero location
                    fullHero.latitude = Double(firstLocation.latitud)
                    fullHero.longitude = Double(firstLocation.longitud)
                } else { // error case... put position in 0,0
                    fullHero.latitude = 0.0
                    fullHero.longitude = 0.0
                }
                herosWithLocations.append(fullHero)
                group.leave() // INDICA QUE LA OPERACIÓN TERMINA
            }
        } // end hero in heros
        
        group.notify(queue: .main) {
    //        print("fullItems = \(fullItems)\n")
    //            herosModel = fullItems
            // CUANDO TODAS LAS TAREAS DEL GRUPO TERMINEN, SE EJECUTA LA SIGUIENTE FUNCIÓN
            print("Step 3: let addLocationsToHeroModel > group.notify\n")
            moveToMain(herosWithLocations)
            
        }
    } // end addLocationsToHeroModel

    
} // end class HeroListVC



let moveToMain = { (heros: [HeroModel]) -> Void in
    
    print("Step 4\n")
    var herosCD: [HeroCD] // HeroCD Declared In Heros+CoreDataClass.swift
    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
    
    debugPrint("Receiving all the info")
    debugPrint("Hero count: \(heros.count)\n")
    
    heros.forEach { debugPrint("Location for item \($0.id) is: [\($0.name),\($0.id),\($0.latitude!),\($0.longitude!)]") }
    
    CoreDataManager.saveApiDataToCoreData(heros) // write api data to core data, locations now added!
    
    
} // end moveToMain

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
    
    
} // end extension UIImageView

extension UIBarButtonItem {
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}

