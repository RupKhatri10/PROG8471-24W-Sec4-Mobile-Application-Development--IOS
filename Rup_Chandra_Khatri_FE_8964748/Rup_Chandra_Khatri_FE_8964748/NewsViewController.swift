//
//  NewsViewController.swift
//  Rup_Chandra_Khatri_FE_8964748
//
//  Created by user237233 on 4/13/24.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
        
    private var newsService = NewsService()
    private var newsArray = [NewsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchNews(country: "Nepal")
        

        // Do any additional setup after loading the view.
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the NewsTableViewCell class
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "newsCell")
    }
//    private func configureTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        // Register the NewsTableViewCell nib file
//        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "newsCell")
//    }
    
    
    @IBAction func changeNewsButtonTapped(_ sender: Any) {
        showCountryInputAlert()
    }
    
    private func showCountryInputAlert() {
           let alertController = UIAlertController(title: "Select Your Country", message: "to see that country's news", preferredStyle: .alert)
           
           alertController.addTextField { textField in
               textField.placeholder = "Country (eg: Nepal)"
           }
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           
           let goAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
               if let countryCode = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !countryCode.isEmpty {
                   self?.fetchNews(country: countryCode)
               } else {
                   self?.displayErrorAlert(message: "Please enter a valid country.")
               }
           }
           alertController.addAction(goAction)
           
           present(alertController, animated: true, completion: nil)
       }
       
       private func fetchNews(country: String) {
           newsService.delegate = self
           newsService.fetchNews(country: country)
           print()
       }
       
       private func displayErrorAlert(message: String) {
           let errorAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           errorAlertController.addAction(okAction)
           present(errorAlertController, animated: true, completion: nil)
       }
   }

   // MARK: - Extensions

   extension NewsViewController: NewsServiceDelegate {
       func didUpdateNews(_ newsService: NewsService, news: [NewsModel]) {
           DispatchQueue.main.async {
               self.newsArray = news
               self.tableView.reloadData()
           }
       }
       
       func didFailWithError(error: Error) {
           print("Failed to fetch news:", error)
           displayErrorAlert(message: "Failed to fetch news. Please try again later.")
       }       

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return newsArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell
           let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
           
           print(cell);
           
           let news = newsArray[indexPath.row]
//           print(news);
           cell.newsTitle?.text = news.title ?? "Title not available"
           cell.newsDescription?.text = news.description ?? "Description not found"
           cell.newsSource?.text = news.sourceName ?? "Source not found"
           cell.newsAuthor?.text = news.author ?? "Author not found"
           
           return cell
       }
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 100
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
