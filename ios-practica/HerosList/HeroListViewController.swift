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
} // done

class HeroListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    static var herosModel: [HeroModel] = []
    static var herosToShow: [HeroModel] = []
    var heroModel: HeroModel!
    var places: [Place] = []
    var place: Place! // w/o !, error "no initializers"
    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
    let loginInfo = LoginViewController() // use this to get user token
    let keychain = KeychainManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("L31 Start HLVC viewDidLoad...\n")
        configureItems() // load bar buttons
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Heros"
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")
        


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
        
        if Global.heroDataLocallyStored == false {
            // TODO: - Call API
            
            // TODO: - Save API data to CO
        }
        
        HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation()
        
//        HeroListViewController.herosToShow =  [
//                    HeroModel(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94", name: "Goku", photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300", description: "I am Goku!!!.", favorite: true, latitude: 39.326, longitude: -4.83),
//                    HeroModel(id: "D88BE50B-913D-4EA8-AC42-04D3AF1434E3", name: "Krilin", photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300", description: "This is Krilin...", favorite: false, latitude: 40.0, longitude: -5.0)
//                ]
        sleep(2) // allow getCoreDataForPresentation to process
        print("L66 herosToShow: \(HeroListViewController.herosToShow.count)\n")
        
        if HeroListViewController.herosToShow.isEmpty { // showing as empty all the time... WTF!
            
            
            print("if herosToShow.isEmpty == true\n")
            NetworkLayer.shared.fetchHeros(token: Global.tokenMaster) { [weak self] herosModelContainer, error in // hero api call
                guard let self = self else { return }
                
                if let herosModelContainer = herosModelContainer {
                    
                    self.addLocationsToHeroModel(herosModelContainer) // saveToCD nested
//                    for hero in heros
//                                group.notify
//                                    moveToMain (héros.forEach)
//                                        saveApiDataToCoreData
//                                        getCoreDataForPresentation
//                    sleep(2) // allow time for api calls
                    debugPrint("herosModelContainer count (Should be 18): \(herosModelContainer.count)")
//                    print("herosModelContainer[6] (lat/long should be NIL)= \(herosModelContainer.name) lat: \(String(describing: herosModelContainer.latitude)), long: \(String(describing: herosModelContainer.longitude))\n") // lat/long nil
                    
//                    HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation() // get core data, write to 'herosToShow' // ⚠️ not working, count = 0
                    
                    debugPrint("\nHeroListViewController > viewDidLoad HeroListViewController.herosToShow COUNT (Should be 18): \(HeroListViewController.herosToShow.count)\n")
                    print("\nL97 HLVC > vDL HLVC.herosToShow[6]:\n\(HeroListViewController.herosToShow)\n") // empty when above is commented out
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    print("Error fetching heros: ", error?.localizedDescription ?? "")
                }
//                HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation()
            }
        } else {
            print("herosToShow is NOT empty\n")
            HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation() // move just before if HeroListViewController.herosToShow.isEmpty
        }
        
        HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation()
        
//        sleep(5) // allow time for api calls
        print("L112 self.tableView.reloadData()...")
        self.tableView.reloadData() // hopefully refresh tableView...
        
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
        print("Core Data tasks complete, refereshing UI...")
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
            
            //self?.delegate.dismiss()
        }))
        
        self.present(alert, animated: true, completion: nil)
    } // imported fm CoreDataEjemplo
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HeroListViewController.herosToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        
        // updated to accept API data
            let hero = HeroListViewController.herosToShow[indexPath.row] // try changing to herosToShow
        
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
        let hero = HeroListViewController.herosToShow[indexPath.row]
//        let hero = HeroListViewController.herosModel[indexPath.row]
        let detailsView = DetailsViewController()
        detailsView.hero = hero
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
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
        
//        var window: UIWindow?
        let loginVC = LoginViewController()
        
//        UserDefaults.standard.set(false, forKey: "login status") // set login status
//        print("Login status: \(UserDefaults.standard.bool(forKey: "login status"))\n")
        
        KeychainManager.deleteBigToken()
        Global.loginStatus = false
        print("Global.loginStatus: \(Global.loginStatus)\n\n")
        
        self.present(loginVC, animated: true) // modal pop up, works, not secure/effective
//        window?.rootViewController = LoginViewController()
//        VcSelector.updateRootVC() // call vc selector
    }
    
    @IBAction func didTapTestButton() {
        
        self.tableView.reloadData()
//        KeychainManager.saveDataBigToken(token: Global.tokenMaster)
        KeychainManager.deleteBigToken()
//        KeychainManager.readBigToken()
//        HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation()
    }

    
    let addLocationsToHeroModel = {(heros: [HeroModel]) -> Void in // was updateFullItems
        print("\nStarting addLocationsToHeroModel...\n")
        var herosWithLocations: [HeroModel] = []
        
        let group = DispatchGroup() // https://developer.apple.com/documentation/dispatch/dispatchgroup
        
        for hero in heros { // loop through all heros found in api call
            group.enter() // INDICA QUE LA OPERACIÓN COMIENZA // Apple Docs: Explicitly indicates that a block has entered the group.
            
            NetworkLayer.shared.getLocalization(token: Global.tokenMaster, with: hero.id) { heroLocations, error in
                var fullHero = hero // instantiate hero, using the " hero loop index"
                // use if let due to case when lat/long nil
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

        } // end hero in heros
        
        group.notify(queue: .main) {
            print("Starting addLocationsToHeroModel > group.notify...\n")
            debugPrint("herosWithLocations count (Should be 18): \(herosWithLocations.count)")
//            print("herosWithLocations[6] = \(herosWithLocations[6])\n") // has lat/long!
            
            // write to herosModel or herosToPresent?
//            HeroListViewController.herosModel = herosWithLocations
            
            
            HeroListViewController.herosToShow = herosWithLocations
            debugPrint("L227: HeroListViewController.herosToShow.count (Should be 18): \(HeroListViewController.herosToShow.count)\n")
//            print("L227: HeroListViewController.herosToShow:\n \(HeroListViewController.herosToShow[6])\n")
            
    //            herosModel = fullItems
            // CUANDO TODAS LAS TAREAS DEL GRUPO TERMINEN, SE EJECUTA LA SIGUIENTE FUNCIÓN
            print("Step 3: addLocationsToHeroModel > group.notify - end\n")
            moveToMain(herosWithLocations) //... contains: saveApiDataToCoreData
            
        }
        print("Ending addLocationsToHeroModel\n") // back to HLVC L78
    } // end addLocationsToHeroModel

    
} // end class HeroListVC



let moveToMain = { (heros: [HeroModel]) -> Void in
    
    print("Starting moveToMain... heros.forEach... saveApiDatatoCoreData")
//    var herosCD: [HeroCD] // Not used // HeroCD Declared In Heros+CoreDataClass.swift
    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
    
    debugPrint("Hero count: \(heros.count)")
    
    print("Starting heros.forEach...")
    heros.forEach { debugPrint("Location for item \($0.id) is: [\($0.name),\($0.id),\($0.latitude!),\($0.longitude!)]\n") }
    
    CoreDataManager.saveApiDataToCoreData(heros) // write api data to core data, locations now added!
    
    // add reading core data here...
    HeroListViewController.herosToShow = CoreDataManager.getCoreDataForPresentation()
    
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

