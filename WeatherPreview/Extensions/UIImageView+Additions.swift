//
//  UIImageView+Additions.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import UIKit

extension UIImageView {
    func loadImage(path: String) {
        guard let url = URL(string: path) else {
            image = nil
            return
        }
        
        let session = URLSession.shared
        session.downloadTask(with: url) { [weak self] (destinationUrl, response, error) in
            if let err = error {
                print("Failed to download image with path \(path). Occured error is \(err.localizedDescription)")
                self?.setImage(nil)
                return
            }
            
            guard let dataUrl = destinationUrl else {
                print("Destination url is missing")
                self?.setImage(nil)
                return
            }
            
            guard let data = try? Data(contentsOf: dataUrl) else {
                print("Data is missing")
                self?.setImage(nil)
                return
            }
            let image = UIImage(data: data)
            self?.setImage(image)
        }.resume()
    }
    
    private func setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.image = image
        }
    }
}

