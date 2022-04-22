//
//  AddMemberViewController.swift
//  copays
//
//  Created by Christianto Vinsen on 07/04/22.
//

import UIKit

class AddMemberViewController: UIViewController {
    
    var members : [Member] = []
    var chosenMembersIndex : [Int] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Split With"
        
        let rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveMember)
        )
        rightBarButtonItem.tintColor = #colorLiteral(red: 0.05490196078, green: 0.662745098, blue: 0.3450980392, alpha: 1)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        leftBarButtonItem.tintColor = .red
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    @objc func saveMember() {
        // Notify chosenMembersIndex value to AddTransactionViewController
        let notifMessage = ["chosenMembersIndex": chosenMembersIndex]
        NotificationCenter.default.post(name: Notification.Name("ListenerForChosenMemberIndex"), object: notifMessage)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonPressed(_ sender: UIBarItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddMemberViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
        
        cell.layer.cornerRadius = 10
        
        cell.setup(member: members[indexPath.row], active: chosenMembersIndex.contains(indexPath.row))
        
        return cell
    }
}

extension AddMemberViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if chosenMembersIndex.contains(indexPath.row) {
            chosenMembersIndex.remove(at: chosenMembersIndex.firstIndex(of: indexPath.row)!)
        } else {
            chosenMembersIndex.append(indexPath.row)
        }
        
        collectionView.reloadData()
    }
}
