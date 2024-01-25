//
//  UserPreferenceViewController.swift
//  Picster
//
//  Created by mac 2019 on 1/19/24.
//

import UIKit

protocol UserPreferenceDelegate: AnyObject{
    func onDismiss()
}


class UserPreferenceViewController: UIViewController {

    weak var dismissDelegate: UserPreferenceDelegate!
    
    private var topics = [
        "Nature", "Food", "Astro", "Abstract", "Tech", "Macro", "Animals", "Flower", "Sunset", "Travel"
    ]
    private var selectedTopics: Set<String> = []
    
    private var labelPreferredTopicMessage: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.text = "Select your preferred topics"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var buttonSave: UIButton = {
        var button = UIButton(configuration: .borderedProminent())
        button.setTitle("Save", for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var topicsContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        buttonSave.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        UserPreferenceManager.getUserPreferredTopics().forEach{
            selectedTopics.insert($0)
        }
        
        view.addSubview(labelPreferredTopicMessage)
        view.addSubview(topicsContainerView)
        view.addSubview(buttonSave)
        populateTopicCells()
    }
    
    
    private func populateTopicCells(){
        
        let cells = (selectedTopics + topics).map{
            let cell = TopicCellButton(topic: $0)
            cell.setTopicSelection(selectedTopics.contains($0))
            cell.addTarget(self, action: #selector(topicCellGotTapped), for: .touchUpInside)
            return cell
        }
        
        cells.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            topicsContainerView.addSubview($0)
        }
        
        var rows = [[TopicCellButton]]()
        var selectionIndex = 0
        let width: CGFloat = 250
        while selectionIndex < cells.count{
            let selectedCells = getCellsWithinTotalWidth(from: cells, width: width, startIndex: selectionIndex)
            selectionIndex += selectedCells.count
            
            rows.append(selectedCells)
        }
        
        let hStacks = rows.map { row in
            let hStack = UIStackView(arrangedSubviews: row)
            hStack.translatesAutoresizingMaskIntoConstraints = false
            topicsContainerView.addSubview(hStack)
            return hStack
        }
        

        var top = topicsContainerView.topAnchor
        let leading = topicsContainerView.leadingAnchor
        let trailing = topicsContainerView.trailingAnchor
        let bottom = topicsContainerView.bottomAnchor
        
        hStacks.forEach { hStack in
            
            hStack.topAnchor.constraint(equalTo: top, constant: 8).isActive = true
            hStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
            hStack.centerXAnchor.constraint(equalTo: topicsContainerView.centerXAnchor).isActive = true
            
            let leadC = hStack.leadingAnchor.constraint(greaterThanOrEqualTo: leading, constant: 8)
            leadC.priority = .defaultLow
            leadC.isActive = true
            
            let trailC = hStack.trailingAnchor.constraint(greaterThanOrEqualTo: trailing, constant: -8)
            trailC.priority = .defaultLow
            trailC.isActive = true
            
            let bottomC = hStack.bottomAnchor.constraint(equalTo: bottom)
            bottomC.priority = .defaultLow
            bottomC.isActive = true
            
            hStack.spacing = 8
            top = hStack.bottomAnchor
        }
        
        func getCellsWithinTotalWidth(from cells: [TopicCellButton], width: CGFloat, startIndex: Int = 0, takeAtLeastOne: Bool = true) -> [TopicCellButton]{
            var selectedCells = [TopicCellButton]()
            var index = startIndex
            var remainingWidth = width
            
            if takeAtLeastOne && index < cells.count{
                selectedCells.append(cells[index])
                remainingWidth -= cells[index].width
                index += 1
            }
            
            while index < cells.count{
                
                remainingWidth -= cells[index].width
                
                if remainingWidth > 0{
                    selectedCells.append(cells[index])
                }
                else{
                    break
                }
                index += 1
            }
            
            return selectedCells
        }
    }
    
    
    @objc private func topicCellGotTapped(_ sender: TopicCellButton){
        let title = sender.titleLabel!.text!
        if selectedTopics.contains(title){
            selectedTopics.remove(title)
        }
        else{
            selectedTopics.insert(title)
        }
        sender.setTopicSelection(selectedTopics.contains(title))
        buttonSave.isEnabled = true
    }
    
    
    override func viewDidLayoutSubviews() {
        let padding: CGFloat = 20
        
        let labelPreferredTopicConstraints = [
            labelPreferredTopicMessage.topAnchor.constraint(equalTo: view.topAnchor, constant: padding*2),
            labelPreferredTopicMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            labelPreferredTopicMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            labelPreferredTopicMessage.heightAnchor.constraint(equalToConstant: 35)
        ]
        NSLayoutConstraint.activate(labelPreferredTopicConstraints)
        
        let buttonSaveConstraints = [
            buttonSave.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            buttonSave.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonSave.widthAnchor.constraint(equalToConstant: 180),
            buttonSave.heightAnchor.constraint(equalToConstant: 70)
        ]
        NSLayoutConstraint.activate(buttonSaveConstraints)
        
        let topicsContainerViewConstraints = [
            topicsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topicsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            topicsContainerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 300),
            topicsContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ]
        NSLayoutConstraint.activate(topicsContainerViewConstraints)
        
    }
    
    
    @objc private func saveButtonTapped(){
        UserPreferenceManager.setUserPreferredTopics(topics: selectedTopics.sorted())
        dismiss(animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissDelegate?.onDismiss()
    }
    
}


class TopicCellButton: UIButton{
    
    var width: CGFloat{
        intrinsicContentSize.width
    }
    
    init(topic: String) {
        super.init(frame: .zero)
        self.setTitle(topic, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTopicSelection(_ selected: Bool){
        configuration = selected ? .borderedProminent() : .bordered()
    }
    
}
