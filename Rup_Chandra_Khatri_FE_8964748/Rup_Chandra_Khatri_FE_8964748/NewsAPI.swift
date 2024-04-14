//
//  NewsAPI.swift
//  Rup_Chandra_Khatri_FE_8964748
//
//  Created by user237233 on 4/13/24.
//
import Foundation

struct NewsData: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let source: Source
    let author: String? // Make author optional
    let title: String
    let description: String? // Make description optional
}

struct Source: Codable {
    let id: String?
    let name: String
}


struct NewsModel {
    let sourceName: String?
    let author: String?
    let title: String?
    let description: String?
}

protocol NewsServiceDelegate {
    func didUpdateNews(_ newsService: NewsService, news: [NewsModel])
    func didFailWithError(error: Error)
}

struct NewsService {
    let newsAPIKey = "d90a6b7aefc2459ebcb340e8d89bf816"
    let newsURL = "https://newsapi.org/v2/top-headlines"
    
    var delegate: NewsServiceDelegate?
    
    func fetchNews(country: String) {
        let urlString = "\(newsURL)?country=\(country)&apiKey=\(newsAPIKey)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let news = self.parseJSON(safeData) {
                        self.delegate?.didUpdateNews(self, news: news)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ newsData: Data) -> [NewsModel]? {
        print("Inside parseJSON News")
        let decoder = JSONDecoder()
        do {
            print("Attempting to decode JSON data...")
            let decodedDataObj = try decoder.decode(NewsData.self, from: newsData)
            print("JSON data decoded successfully")

            var newsArray: [NewsModel] = []
            for article in decodedDataObj.articles {
                // Check if the author and description fields are not null before accessing them
                let sourceName = article.source.name
                let author = article.author ?? "Unknown" // Provide a default value if author is null
                let description = article.description ?? "No description available" // Provide a default value if description is null
                let title = article.title
                
                print("Data ====> \(sourceName) = \(author) = \(description) = \(title)")
                
                let news = NewsModel(sourceName: sourceName, author: author, title: title, description: description)
                newsArray.append(news)
            }
            
            return newsArray
        } catch {
            print("An error occurred during JSON decoding: \(error)")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }


}
