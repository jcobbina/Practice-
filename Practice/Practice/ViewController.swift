//
//  ViewController.swift
//  Practice
//
//  Created by Umar Maikano on 05/02/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var flagImageView: UIImageView!
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRequest()
    }
    
    func render() {
        DispatchQueue.main.async {
            if let population = self.city?.population {
                self.populationLabel.text = String(population)
            }
            if let cityname = self.city?.city {
                self.flagImageView.image = UIImage(named: cityname)
                self.cityLabel.text = cityname
            }
        }
    }
    
    func getRequest() {
        guard let url = URL(string: "http://localhost:8080/city.json") else {
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            // esnure error is nil
            guard error == nil else { return }
            
            // ensure response is HTTP
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            // ensure status code 200 success code
            guard response.statusCode == 200 else { return }
            
            // ensure data is not nil
            guard let data = data else { return }
            
            do {
                let city = try JSONDecoder.init().decode(City.self, from: data)
                self.city = city
                self.render()
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        task.resume()
    }
}

struct City: Decodable {
    let city: String
    let population: Int
    let capital: Bool
    let eu: Bool?
}
