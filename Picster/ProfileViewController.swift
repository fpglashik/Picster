//
//  ProfileViewController.swift
//  Picster
//
//  Created by mac 2019 on 1/17/24.
//

import UIKit
import CoreML


class ProfileViewController: UIViewController{
    
    private var searchField: UITextField = {
        let txt = UITextField(frame: .zero)
        txt.placeholder = "Search Image"
        txt.borderStyle = .roundedRect
        txt.backgroundColor = .systemGray
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    private var searchImageButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.setTitle("Find an Image", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var imageContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemTeal
        return container
    }()
    
    
    private var stylizerVC: ImageStylizeViewController = ImageStylizeViewController()
    
    
    
    private var imageView: UIImageView = {
        let imgVw = UIImageView(frame: .zero)
        imgVw.image = UIImage(resource: .face)
        imgVw.translatesAutoresizingMaskIntoConstraints = false
        imgVw.contentMode = .scaleAspectFit
        return imgVw
    }()
    
    private var modelPicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var applyEffectButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.setTitle("Apply Effect", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [modelPicker, applyEffectButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var targetImage: UIImage!
    
    static var title = "Profile"
    override func viewDidLoad() {
        view.backgroundColor = .systemMint
        
        configureViews()
    }
    
    private func configureViews(){
        
        searchImageButton.addTarget(self, action: #selector(loadRandomImageButtonPressed), for: .touchUpInside)
        applyEffectButton.addTarget(self, action: #selector(applyEffectButtonPressed), for: .touchUpInside)
        
        modelPicker.delegate = self
        modelPicker.dataSource = self
        
        targetImage = imageView.image
        
        view.addSubview(searchField)
        view.addSubview(searchImageButton)
        view.addSubview(imageView)
        view.addSubview(bottomStack)
        view.addSubview(imageContainerView)
        
        imageContainerView.addSubview(stylizerVC.view)
        stylizerVC.view.frame = view.bounds
    }
    
    
    
    struct RandomImageResponse: Decodable{
        var urls: RandomImageUrl
    }
    struct RandomImageUrl: Decodable{
        var regular: String
    }
    
    @objc private func loadRandomImageButtonPressed(){
        searchField.resignFirstResponder()
        
        searchImageButton.isEnabled = false
        
        Task{
            do{
                var urlString = "https://api.unsplash.com/photos/random?client_id=jIjFwrB43aE19Dri_tfMJsB8l3N8EHzubG3t_sos-VM"
                urlString += searchField.text!.isEmpty ? "" : "&query=\(searchField.text!)"
                
                print(urlString)
                let data = try await NetworkManager.fetchData(from: urlString)
                let response = try JSONDecoder().decode(RandomImageResponse.self, from: data)
                let imageData = try await NetworkManager.fetchData(from: response.urls.regular)
                
                let loadedImage = UIImage(data: imageData)
                self.imageView.image = loadedImage
                self.targetImage = loadedImage
                self.searchImageButton.isEnabled = true
            }
            catch{
                searchImageButton.isEnabled = true
            }
        }
        
    }
    
    @objc private func applyEffectButtonPressed(){
        guard let image = targetImage else{
            return
        }
        applyEffectButton.isEnabled = false
        Task{
            do{
                try await AiEffect.allCases[modelPicker.selectedRow(inComponent: 0)].applyEffect(on: image) { outputImage in
                    
                    DispatchQueue.main.async {
                        self.imageView.image = outputImage
                        self.applyEffectButton.isEnabled = true
                        
                        if let outputImage{
                            self.stylizerVC.stylize(with: outputImage)
                        }
                    }
                }
            }
            catch{
                applyEffectButton.isEnabled = true
            }
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        let padding: CGFloat = 50
        let spacing: CGFloat = 10
        
        searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        let widthAnchorConstraint = searchField.widthAnchor.constraint(lessThanOrEqualToConstant: 500)
        widthAnchorConstraint.priority  = .defaultLow
        widthAnchorConstraint.isActive = true
        searchField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        searchImageButton.topAnchor.constraint(equalTo: searchField.topAnchor).isActive = true
        searchImageButton.bottomAnchor.constraint(equalTo: searchField.bottomAnchor).isActive = true
        searchImageButton.leadingAnchor.constraint(equalTo: searchField.trailingAnchor, constant: spacing).isActive = true
        searchImageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
        
        imageView.topAnchor.constraint(equalTo: searchImageButton.bottomAnchor, constant: padding).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomStack.topAnchor, constant: -spacing).isActive = true
        
        bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding).isActive = true
        bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        imageContainerView.topAnchor.constraint(equalTo: searchImageButton.bottomAnchor, constant: padding).isActive = true
        imageContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        imageContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
        imageContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing).isActive = true
        
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        AiEffect.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = AiEffect.allCases[row].rawValue
        label.textColor = .black
        return label
    }
}


enum AiEffect: String, CaseIterable{
    case Anime
    case Cartoon
    case FacialCartoon
    case WhiteBoxCartoon
    case Original
    
    func applyEffect(on image: UIImage, completion: @escaping ((UIImage?) -> Void)) async throws{
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            switch self {
                case .Anime:
                    completion(try? makeCartoonUsing_AnimeGanPaprika(of: image))
                case .Cartoon:
                    completion(try? makeCartoonUsing_Photo2Cartoon(of: image))
                case .FacialCartoon:
                    completion(try? makeCartoonUsing_FacialCartoonization(of: image))
                case .WhiteBoxCartoon:
                    completion(try? makeCartoonUsing_WhiteboxCartoonization(of: image))
                case .Original:
                    completion(image)
            }
        }
    }
    
    private func makeCartoonUsing_Photo2Cartoon(of image: UIImage) throws -> UIImage? {
        let model = try Photo2Cartoon(configuration: MLModelConfiguration())
        let inputPixelBuffer = Photo2CartoonInput(input: image.resize(size: .init(width: 256, height: 256))!.getCVPixelBuffer()!)
        let output = try model.prediction(input: inputPixelBuffer)
        
        return UIImage(pixelBuffer: output.activation_out)?.resize(size: image.size)
    }
    
    
    private func makeCartoonUsing_FacialCartoonization(of image: UIImage) throws -> UIImage? {
        let model = try FacialCartoonization(configuration: MLModelConfiguration())
        let pixelBuffer = image.resize(size: .init(width: 256, height: 256))!.getCVPixelBuffer()!
        let input = FacialCartoonizationInput(inputs: pixelBuffer)
        let output = try model.prediction(input: input)
        
        return UIImage(pixelBuffer: output.activation_out)?.resize(size: image.size)
    }
    
    
    private func makeCartoonUsing_WhiteboxCartoonization(of image: UIImage) throws -> UIImage? {
        let model = try WhiteboxCartoonization(configuration: MLModelConfiguration())
        let pixelBuffer = image.resize(size: .init(width: 1536, height: 1536))!.getCVPixelBuffer()!
        let input = WhiteboxCartoonizationInput(Placeholder: pixelBuffer)
        let output = try model.prediction(input: input)
        
        return UIImage(pixelBuffer: output.activation_out)?.resize(size: image.size)
    }
    
    
    private func makeCartoonUsing_AnimeGanPaprika(of image: UIImage) throws -> UIImage? {
        let model = try AnimeGanPaprika(configuration: MLModelConfiguration())
        let pixelBuffer = image.resize(size: .init(width: 256, height: 256))!.getCVPixelBuffer()!
        let input = AnimeGanPaprikaInput(test__0: pixelBuffer)
        let output = try model.prediction(input: input)
        
        return UIImage(pixelBuffer: output.image)?.resize(size: image.size)
    }
    
    
}


class ImageStylizeViewController: UIViewController{
    
    private var targetImage: UIImage!
    
    private var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(resource: .face)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [modelPicker, applyEffectButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var modelPicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var applyEffectButton: UIButton = {
        let button = UIButton(configuration: .borderedProminent())
        button.setTitle("Apply Effect", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    func stylize(with image: UIImage){
        targetImage = image
        imageView.image = image
    }
    
    override func viewDidLoad() {
        applyEffectButton.addTarget(self, action: #selector(applyEffectButtonPressed), for: .touchUpInside)
        
        modelPicker.delegate = self
        modelPicker.dataSource = self
        
        targetImage = imageView.image
        
        view.addSubview(imageView)
        view.addSubview(bottomStack)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        let padding: CGFloat = 50
        let spacing: CGFloat = 10
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomStack.topAnchor, constant: -spacing).isActive = true
        
        bottomStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        bottomStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomStack.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
    @objc private func applyEffectButtonPressed(){
        guard let image = targetImage else{
            return
        }
        applyEffectButton.isEnabled = false
        Task{
            do{
                try await AiEffect.allCases[modelPicker.selectedRow(inComponent: 0)].applyEffect(on: image) { outputImage in
                    
                    DispatchQueue.main.async {
                        self.imageView.image = outputImage
                        self.applyEffectButton.isEnabled = true
                    }
                }
            }
            catch{
                applyEffectButton.isEnabled = true
            }
        }
    }
    
}

extension ImageStylizeViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        AiEffect.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = AiEffect.allCases[row].rawValue
        label.textColor = .black
        return label
    }
}
