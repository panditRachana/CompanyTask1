//
//  ViewController.swift
//  CompanyTask1
//
//  Created by Rachana Pandit on 17/12/22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var collectionViewImages:UICollectionView!
    @IBOutlet weak var tableViewUserInfo:UITableView!
    var arrayUserInfo = [UserInfo]()
    var arrayProducts = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewXib()
        toFetchProducts()
        toFetchUserData()
    }
    
//MARK: Register tableView Xib
    func registerTableViewXib()
    {
        let nibName = UINib(nibName:"TableViewUserCell" , bundle: nil)
        tableViewUserInfo.register(nibName, forCellReuseIdentifier: "TableViewUserCell")
    }
    
//MARK: Fetching UserData From Api
    func toFetchUserData()
    {
       let urlString = "https://fakestoreapi.com/users"
        
       let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            let getJsonObj = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            
            for dictionary in getJsonObj
            {
                let eachAddressDictionary = dictionary as [String:Any]
                let id = eachAddressDictionary["id"] as! Int
                let email = eachAddressDictionary["email"] as! String
                let userName = eachAddressDictionary["username"] as! String
                let password = eachAddressDictionary["password"] as! String
                let phone = eachAddressDictionary["phone"] as! String
                let vParameter = eachAddressDictionary["__v"] as! Int
                
                let nameDict =  eachAddressDictionary["name"] as! [String:Any]
                print(nameDict)
                let firstName = nameDict["firstname"] as! String
                let lastName = nameDict["lastname"] as! String
                
                self.arrayUserInfo.append(UserInfo(addressDictionary: eachAddressDictionary,
                    id: id,
                    email: email,
                    userName: userName, password: password,
                    nameDictionary: nameDict,phone: phone,
                    vParameter: vParameter,
                    firstName: firstName, lastName: lastName))
                
            }
            DispatchQueue.main.async {
                self.tableViewUserInfo.reloadData()
            }
        }
        dataTask.resume()
    }
    
//MARK: Fetching Products Api
    func toFetchProducts()
    {
      let urlString = "https://fakestoreapi.com/products"
      let url = URL(string: urlString)
      var request = URLRequest(url: url!)
      request.httpMethod = "GET"
      let session = URLSession(configuration: .default)
        
        var dataTask = session.dataTask(with: request) { data, response, error in
            
            let getJsonObject = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            
            for dictionary in getJsonObject{
                
                let eachDictionary = dictionary as [String:Any]
                
                let productId = eachDictionary["id"] as! Int
                let productTitle = eachDictionary["title"] as! String
                let productPrice = eachDictionary["price"] as! Double
                let productDecrip = eachDictionary["description"] as! String
                let productCategory = eachDictionary["category"] as! String
                let productImg = eachDictionary["image"] as! String
                
                let productRating =  eachDictionary["rating"] as! [String:Any]
                let productRate = productRating["rate"] as! Double
                let productCount = productRating["count"] as! Int
                
                self.arrayProducts.append(Product(id: productId,
                                title: productTitle,
                                price: productPrice,
                                description: productDecrip,
                                category: productCategory,
                                image: productImg,
                                rating: productRating,
                                rate: productRate,
                                count: productCount))
            }
            DispatchQueue.main.async
            {
                self.collectionViewImages.reloadData()
         }
    }
       dataTask.resume()
  }
}



//MARK: CollectionViewDataSource & Delegate Method
extension ViewController : UICollectionViewDelegate
{
    
}

extension ViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrayProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let collectioViewCell = collectionViewImages.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
//        let imgUrl = NSURL(string: arrayProducts[indexPath.row].image)
//        collectioViewCell.imageProduct.sd_setImage(with:imgUrl as URL?)
        
        let imageResize = SDImageResizingTransformer(size: CGSize(width: 150, height: 150), scaleMode:.aspectFit)
        
        collectioViewCell.imageProduct.sd_setImage(with: NSURL(string: arrayProducts[indexPath.row].image)as URL?,  placeholderImage: nil, context: [.imageTransformer: imageResize])
        
        return collectioViewCell
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 150, height: 150)
    }
}

//MARK: TableViewDelegate Method
extension ViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
}

//MARK: TableViewDataSource Method
extension ViewController :UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayUserInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tblCell = tableViewUserInfo.dequeueReusableCell(withIdentifier: "TableViewUserCell", for: indexPath) as! TableViewUserCell
        tblCell.lblFirstName.text = arrayUserInfo[indexPath.row].firstName
        tblCell.lblLastName.text =  arrayUserInfo[indexPath.row].lastName
        return tblCell
    }
}
