//
//  ImageDownloadService.swift
//  Square
//
//  Created by MacDev1 on 2/8/23.
//

import UIKit
import CryptoKit

class ImageDownloadSerive: ObservableObject {
    @Published var image: UIImage = UIImage()
    
    func loadImage(urlString: String, completion:() -> ()) {
        guard let url = URL(string: urlString) else{return}
        
        let fileName = "\(SHA256.hash(data: Data(urlString.utf8)).compactMap({String(format: "%02x", $0)}).joined()).jpg"
        let catchFilePath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        let fileManager = FileManager.default
        let fileExist = fileManager.fileExists(atPath: catchFilePath.path)
        if fileExist == true{
            DispatchQueue.main.async {
                if let fileImage = UIImage(contentsOfFile: catchFilePath.path){
                    self.image = fileImage
                    return
                }
            }
        }else{
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {return}
                do{
                    try data.write(to: catchFilePath)
                } catch{
                    print(catchFilePath)
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.image = UIImage(data: data) ?? UIImage()
                }
                
            }
            task.resume()
        }
    }
    
}
