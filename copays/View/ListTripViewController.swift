//
//  ListTripViewController.swift
//  copays
//
//  Created by Ryan Vieri Kwa on 06/04/22.
//

import UIKit

class ListTripViewController: UIViewController {
    
    
    @IBOutlet weak var tripListTableView: UITableView!
    
    @IBOutlet weak var emptyTripIllustration: UIImageView!
    @IBOutlet weak var emptyTripLabel: UILabel!
    
    var tripList = [Trip]()
    var emptyTrip: Bool = false
    var rowIndex: IndexPath = []
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Helper.isShowingOnboardingPage() {
            let storyboard = UIStoryboard(name: "OnboardingScreen", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        
        getTripList()
        title = "My Trip"
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableViewData), name: Notification.Name("refreshTableViewData"), object: nil)
        navigationItem.largeTitleDisplayMode =  .always
        updateTripListView()
    }
    override func viewWillAppear(_ animated: Bool) {
        getTripList()
    }
    func updateTripListView(){
        tripList.isEmpty ? hideTripList() : showTripList()
    }
    
    @objc func refreshTableViewData (notification: NSNotification){
        print("LOG: notification")
        getTripList()
        updateTripListView()
    }

    func getTripList(){
        if let tripListData = defaults.data(forKey: "TripList"){
            do{
                //array of trip
                let trip = try decoder.decode([Trip].self, from: tripListData)
                //assign
                tripList = trip
                tripListTableView.reloadData()
                print("TRIPPPPPP \(tripList.count)")
            }
            catch{
                print("ERROR")
            }
        }
    }
    
    func removeAllTripList(){
        let temp = [Trip]()
        if let encodedTripList = try? encoder.encode(temp){
            defaults.set(encodedTripList, forKey: "TripList")
        }
    }
    
    func setImageTrip(imageView tripImage: UIImageView, iconName: String){
        tripImage.tintColor = .white
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .black, scale: .medium)
        tripImage.image = UIImage(systemName: iconName, withConfiguration: symbolConfiguration)
        tripImage.backgroundColor = #colorLiteral(red: 0.054, green: 0.6627, blue: 0.345, alpha: 1)
        tripImage.layer.cornerRadius = tripImage.bounds.width / 2
        tripImage.clipsToBounds = true
    }
 
    
    func editTrip(table: UITableView, index: IndexPath) -> UIContextualAction{
        let edit = UIContextualAction(style: .normal, title: "Edit Trip"){
            [weak self] (action, view, completionHandler)in
            guard let self = self else{
                return
            }
            //do edit
            
            self.rowIndex = index
            self.performSegue(withIdentifier: "edit", sender: self)
            completionHandler(true)
        }
        edit.backgroundColor = .systemGreen
        edit.image = UIImage(systemName: "pencil")
        
        return edit
    }
    
    //utk segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "edit"){
            let tripModalView = segue.destination as! TripController
            tripModalView.indexTrip = rowIndex.row
            tripModalView.isEditTrip = true
            tripModalView.editName = tripList[rowIndex.row].name
            tripModalView.editDate = tripList[rowIndex.row].date
            tripModalView.names.append(contentsOf: tripList[rowIndex.row].members)
            tripModalView.isDone = tripList[rowIndex.row].isDone
        }
    }
    
    
    func deleteTrip(table tableView: UITableView, index indexPath: IndexPath) -> UIContextualAction{
        let delete = UIContextualAction(style: .destructive, title: "Delete Trip"){
            [weak self] (action, view, completionHandler) in
            guard let selfController = self else{
                return
            }
            //alert
            let deleteConfirmation = UIAlertController( title: "Delete Trip?", message: "This action will permanently remove this trip from your list", preferredStyle: .alert)
            //delete confirm
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive){
                [weak self] action in
                //delete trip
                selfController.tripList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                //set to user default
                if let encodedUser = try? self!.encoder.encode(selfController.tripList) {
                    self!.defaults.set(encodedUser, forKey: "TripList")
                }

                selfController.updateTripListView()

                completionHandler(true)
                
                print("After delete \(selfController.tripList.count)")

            }
            //cancel
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            //add action to alert
            deleteConfirmation.addAction(deleteAction)
            deleteConfirmation.addAction(cancelAction)
            
            //show alert
            selfController.present(deleteConfirmation, animated: true)
        }
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash")
        return delete
    }

    func showTripList(){
        //show trip list
        getTripList()
        tripListTableView.dataSource = self
        tripListTableView.delegate = self
        tripListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tripListTableView.isHidden = false
        //hide empty
        emptyTripIllustration.alpha = 0
        emptyTripLabel.alpha = 0
                

    }
    func hideTripList(){
        //hide triplist
        tripListTableView.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.showHideTransitionViews, animations: {
            self.emptyTripIllustration.image = #imageLiteral(resourceName: "Flying around the world-amico")
            self.emptyTripIllustration.alpha = 1.0
            self.emptyTripLabel.alpha = 1.0
             }, completion: { (Bool) -> Void in }
        )
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

extension ListTripViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripList.count
    }
    
    // Go to expense list screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ExpenseList") as? ELViewController {
            vc.indexTrip = indexPath.row
            vc.tripName = tripList[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell") as! MyTripTableViewCell
        if let tripName = tripList[indexPath.row].name,
           let tripDate = tripList[indexPath.row].date,
           let tripTotalExpense = tripList[indexPath.row].totalExpenses,
           let tripTotalMember = tripList[indexPath.row].totalMembers,
           let tripStatus = tripList[indexPath.row].isDone {
            cell.tripName.text = tripName
            cell.tripDate.text = tripDate
            let nf = NumberFormatter()
            nf.numberStyle = NumberFormatter.Style.decimal
            nf.maximumFractionDigits = 2
            cell.totalExpense.text = String("Rp. \(nf.string(from: tripTotalExpense as NSNumber)!)")
            cell.totalExpense.textColor = tripStatus == true ? #colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            cell.totalMember.text = String("\(tripTotalMember)")
            cell.cardView.backgroundColor = tripStatus == true ? #colorLiteral(red: 0.901, green: 0.901, blue: 0.901, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            tripStatus == true ? setImageTrip(imageView: cell.tripImage, iconName: "airplane.arrival") : setImageTrip(imageView: cell.tripImage, iconName: "airplane.departure")
        }
        return cell
    }
    //swipe kanan
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editTrip(table: tableView, index: indexPath)
        let deleteAction = deleteTrip(table: tableView, index: indexPath)
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, edit])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
