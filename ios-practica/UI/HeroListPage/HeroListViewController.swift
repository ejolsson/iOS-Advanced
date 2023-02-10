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
    
    var heros: [Hero] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Heros"
        
        let xib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "customTableCell")
        
        let token = LocalDataLayer.shared.getToken()
        
        NetworkLayer.shared.fetchHeros(token: token) { [weak self] allHeros, error in
            guard let self = self else { return }
            
            if let allHeros = allHeros {
                self.heros = allHeros
                
                LocalDataLayer.shared.save(heros: allHeros)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Error fetching heros: ", error?.localizedDescription ?? "")
            }
        }
    }
    
    // table rows creation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heros.count
    } // should be complete
    
    // table cell creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTableCell", for: indexPath) as! TableViewCell
        
        // updated to accept API data
        let hero = heros[indexPath.row]
        
        cell.iconImageView.setImage(url: hero.photo) // need to write extension
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
