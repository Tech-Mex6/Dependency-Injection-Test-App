//
//  GIFCell.swift
//  Dependency Injection App
//
//  Created by meekam okeke on 2/18/22.
//

import UIKit

class GIFCell: UITableViewCell {
    var cellData: DataModel?
    var GIFImageView  = UIImageView()
    var GIFTitleLabel = DITitleLabel(textAlignment: .natural, fontSize: 16)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(GIFImageView)
        addSubview(GIFTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.GIFImageView.image = nil
    }
     
    func downloadGIF() {
        guard let imageURL = cellData?.images.fixedHeightSmall.url else { return }
        NetworkManager.shared.downloadImage(from: imageURL) { [weak self] image in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.GIFImageView.image = image
            }
        }
    }
    
    func configureImageView() {
        GIFImageView.layer.cornerRadius = 10
        GIFImageView.clipsToBounds      = true
    }
    
    func setImageViewConstraints() {
        let padding: CGFloat = 10
        GIFImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            GIFImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            GIFImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            GIFImageView.heightAnchor.constraint(equalToConstant: 100),
            GIFImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setTitleLabelConstraints() {
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            GIFTitleLabel.centerYAnchor.constraint(equalTo: GIFImageView.centerYAnchor),
            GIFTitleLabel.leadingAnchor.constraint(equalTo: GIFImageView.trailingAnchor, constant: padding),
            GIFTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            GIFTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding)
        ])
    }
    
}
