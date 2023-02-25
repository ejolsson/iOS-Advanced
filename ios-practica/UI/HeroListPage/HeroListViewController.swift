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
    
    var heros: [HeroCD] = [] // ⭐️ Changing fm [Hero] to [HeroCD]
    var context = AppDelegate.sharedAppDelegate.coreDataManager.managedContext
    var currentHero: HeroCD?
    
    var hero: HeroCD! // ⭐️ Changing fm Hero! to HeroCD!
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Heros"
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")
        
        // load token, fm UserDefaults storage, prior to api call
        let token = LocalDataLayer.shared.getTokenFmUserDefaults() // load token prior to api calls

        
        if heros.isEmpty { // copied this chunk fm CoreDataEjemplo > EmployeesViewController > ViewDidLoad()
            // 1.- llamar al api rest
            // 2.- guardar la info en coredata
            // getEmployeesFromApi { employee
            // mapeo del json a Employee
            // }
        }
        
        
        NetworkLayer.shared.fetchHeros(token: token) { [weak self] allHeros, error in
            guard let self = self else { return }
            
            if let allHeros = allHeros {
                self.heros = allHeros
                
//                LocalDataLayer.shared.saveHerosToUserDefaults(heros: allHeros) // old save way
                self.saveHerosToCoreData(heros: allHeros) // desired way, this had no impact. del app, reran w/ this commmented and heros showed just fine. ⚠️ Need to find out where/how tableview is getting painted... Update: I commented out this entire block and finally the hero data didn't show.
                //print("\(allHeros)\n")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error fetching heros: ", error?.localizedDescription ?? "")
            }
        }
        
        configureItems()
        
        // ----------- below imported fm wait example ----------------------
        
//        let updateFullItems = {(heros: [Hero]) -> Void in
//
//            var fullItems: [Hero] = []
//
//            let group = DispatchGroup() // https://developer.apple.com/documentation/dispatch/dispatchgroup
//
//        //    DispatchGroup() - Groups allow you to aggregate a set of tasks and synchronize behaviors on the group. You attach multiple work items to a group and schedule them for asynchronous execution on the same queue or different queues. When all work items finish executing, the group executes its completion handler. You can also wait synchronously for all tasks in the group to finish executing.
//
//            for hero in heros {
//                group.enter() // INDICA QUE LA OPERACIÓN COMIENZA // Apple Docs: Explicitly indicates that a block has entered the group.
//
//                NetworkLayer.shared.getLocalization(token: token, with: hero.id) { heroLocations, error in
//                    var fullHero = hero
//                    if let firstLocation = heroLocations.first {
//                        fullHero.latitude = Double(firstLocation.latitud)
//                        fullHero.longitude = Double(firstLocation.longitud)
//                    } else {
//                        fullHero.latitude = 0.0
//                        fullHero.longitude = 0.0
//                    }
//                    fullItems.append(fullHero)
//                    group.leave() // INDICA QUE LA OPERACIÓN TERMINA
//                }
//            }
//
//            group.notify(queue: .main) {
//
//                // CUANDO TODAS LAS TAREAS DEL GRUPO TERMINEN, SE EJECUTA LA SIGUIENTE FUNCIÓN
//                self.moveToMain(fullItems)
//
//            }
//        }

//        NetworkLayer.shared.getHeroes(token: token) { heros, error in
//
//            if error == nil {
//                updateFullItems(heros) // UNA VEZ TENGO LA LISTA DE HÉROES, COMIENZO LAS
//            }
//
//        }

        // ----------- above imported fm wait example ----------------------
        
//        saveHerosToCoreData(heros: heros) // moved inside 'fetchHeros' above
        
    } // End viewDidLoad
    
    let moveToMain = { (heros: [Hero]) -> Void in
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
    
    func saveHerosToCoreData(heros: [HeroCD]) { // my code, taking model matching api service. Switch fm Hero to HeroCD
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
        return heros.count
    } // should be complete
    
    // table cell UI creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        
        // updated to accept API data
        let hero = heros[indexPath.row]
        
        cell.iconImageView.setImage(url: hero.photo ?? "") // need to write extension
        cell.titleLabel.text = hero.name
        cell.descriptionLabel.text = hero.description // connected label to TableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
                
        return cell
    } // should be complete

    // table row height???
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    } // should be complete
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // enables detailsView viewing
        let hero = heros[indexPath.row]
        let detailsView = DetailsViewController()
        detailsView.hero = hero
        navigationController?.pushViewController(detailsView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // empty
    }
    
    private func configureItems() {
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(
            title: "Logout", image: UIImage(systemName: "person.circle"), target: self, action: #selector(didTapLogoutButton2)
        ),
            UIBarButtonItem(
            title: "test", image: UIImage(systemName: "play"), target: self, action: #selector(didTapTestButton)
            )
        ]
    }
    
    @objc func didTapLogoutButton() {
        print("didTapLogoutButton pressed\n")
        let vc = UIViewController() // LogoutViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapLogoutButton2() {
        print("didTapTestButton pressed\n")
        let vc = UIViewController() // LogoutViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    @IBAction func didTapTestButton() {
        
        // Test functions below
        print("didTapLogoutButton pressed\n")
        
        print("Context = \(context)\n")
        
        print("HerosListVC > heros: [Hero] = \(heros)\n")
        
        print("HerosListVC > hero: Hero! = \(String(describing: hero ?? nil))\n")
        
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
