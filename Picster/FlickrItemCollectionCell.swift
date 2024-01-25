//
//  FlickrItemCollectionCell.swift
//  Picster
//
//  Created by mac 2019 on 1/25/24.
//

import UIKit


class FlickrItemCollectionCell: UICollectionViewCell{
    static let reuseIdentifier = "FlickrItemCollectionCell"
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    
    public func configure(with url: URL) {
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, _, _ in
            
            guard let data else{
                return
            }
            do{
                let image = UIImage(data: data)
                DispatchQueue.main.async{
                    self?.imageView.image = image
                }
            }
        }.resume()
    }
}
