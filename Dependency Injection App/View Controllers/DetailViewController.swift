//
//  DetailViewController.swift
//  Dependency Injection App
//
//  Created by meekam okeke on 2/22/22.
//

import UIKit

class DetailViewController: UIViewController {
    var ID: String = ""
    let networkService: NetworkManager
    var GIF: DataModel!
    
    var imageView = UIImageView()
    var imageTitleLabel = DITitleLabel(textAlignment: .center, fontSize: 18)
    var imageSourceLabel = DISecondaryTitleLabel(textAlignment: .center, fontSize: 16)
    var imageRatingLabel = DISecondaryTitleLabel(textAlignment: .center, fontSize: 16)
    
    /// initializer to inject dependencies
    init(ID: String, networkService: NetworkManager) {
        self.ID = ID
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GIF Details"
        configureImageView()
        layoutUI()
        setImageViewConstraints()
        setTitleLabelConstraints()
        setSourceLabelConstraints()
        setRatingLabelConstraints()
        fetchGIFByID()
    }
    
    func configureImageView() {
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
    
    func layoutUI() {
        view.addSubview(imageView)
        view.addSubview(imageTitleLabel)
        view.addSubview(imageSourceLabel)
        view.addSubview(imageRatingLabel)
        view.backgroundColor = .systemBackground
    }
    
    func setImageViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setTitleLabelConstraints() {
        imageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            imageTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            imageTitleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imageTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    func setSourceLabelConstraints() {
        imageSourceLabel.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            imageSourceLabel.topAnchor.constraint(equalTo: imageTitleLabel.bottomAnchor, constant: 10),
            imageSourceLabel.centerXAnchor.constraint(equalTo: imageTitleLabel.centerXAnchor),
            imageSourceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageSourceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    func setRatingLabelConstraints() {
        imageRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            imageRatingLabel.topAnchor.constraint(equalTo: imageSourceLabel.bottomAnchor, constant: 10),
            imageRatingLabel.centerXAnchor.constraint(equalTo: imageSourceLabel.centerXAnchor),
            imageRatingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageRatingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        
    }
    
    func fetchGIFByID() {
        networkService.fetchDataByID(ID: ID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let dataByID):
                self.GIF = dataByID.data
                self.downloadGIF()
                DispatchQueue.main.async {
                    self.imageTitleLabel.text = "Title: \(self.GIF.title)"
                    self.imageSourceLabel.text = "Source: \(self.GIF.sourceTld)"
                    self.imageRatingLabel.text = "Rating: \(self.GIF.rating)"
                }
            case.failure(.invalidData):
                print("Invalid data.")
            case .failure(.invalidResponse):
                print("Invalid response.")
            case.failure(.unableToComplete):
                print("Unable to complete.")
            }
        }
    }
    
    func downloadGIF() {
        guard let imageURL = self.GIF?.images.downsized.url else { return }
        networkService.downloadImage(from: imageURL) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
