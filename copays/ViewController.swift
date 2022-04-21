//
//  ViewController.swift
//  copays
//
//  Created by Christianto Vinsen on 04/04/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //empty view
    @IBOutlet weak var emptyIlustration: UIImageView!
    @IBOutlet weak var emptyTripLabel: UILabel!

    //on going trip list
    @IBOutlet weak var onGoingTableView: UITableView!
    @IBOutlet weak var onGoingLabel: UILabel!
    
    //done trip list
    @IBOutlet weak var doneTripLabel: UILabel!
    @IBOutlet weak var doneTripTableView: UITableView!
    
    
    var trips = [Trip]()
    var doneTrips = [Trip]()

    var emptyTrip: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyTrip ? hideTripList() : showTripList()
//        doneTrips.append(Trip(name: "Japan - March 2023", date: "10/07/2023", totalExpenses: 10000000, totalMembers: 5))
//        doneTrips.append(Trip(name: "California - April 2024", date: "10/09/2024", totalExpenses: 50000000, totalMembers: 3))
//        doneTrips.append(Trip(name: "Seoul - Mei 2022", date: "10/11/2022", totalExpenses: 40000000, totalMembers: 6))
    }
    
    func showTripList(){
        initTrip()
        //hide empty
        emptyIlustration.isHidden = true
        emptyTripLabel.isHidden = true
        
        //show trip list
        onGoingTableView.isHidden = false
        onGoingLabel.isHidden = false
        doneTripLabel.isHidden = false
        doneTripTableView.isHidden = false
        
        onGoingTableView.dataSource = self
        onGoingTableView.delegate = self
        doneTripTableView.dataSource = self
        doneTripTableView.delegate = self
    }
    func hideTripList(){
        //hide triplist
        onGoingTableView.isHidden = true
        onGoingLabel.isHidden = true
        doneTripLabel.isHidden = true
        doneTripTableView.isHidden = true
        
        //show empty view
        emptyIlustration.isHidden = false
        emptyTripLabel.isHidden = false
        emptyIlustration.image = UIImage(named: "World-amico")

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147
    }
    func initTrip(){
        //dummy
//        trips.append(Trip(name: "Jakarta - Juli 2023", date: "10/07/2023", totalExpenses: 10000000, totalMembers: 5))
//        trips.append(Trip(name: "Jakarta - September 2024", date: "10/09/2024", totalExpenses: 50000000, totalMembers: 3))
//        trips.append(Trip(name: "Bandung - November 2022", date: "10/11/2022", totalExpenses: 40000000, totalMembers: 6))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell") as! MyTripTableViewCell
        if tableView == self.onGoingTableView {
            cell.tripName.text = trips[indexPath.row].name
            cell.tripDate.text = trips[indexPath.row].date
            cell.totalExpense.text = String("Rp.  \(trips[indexPath.row].totalExpenses)")
            cell.totalMember.text = String(  "\(trips[indexPath.row].totalMembers)")

            print("OnGOing init")
        }
        else if tableView == self.doneTripTableView{
            cell.tripName.text = doneTrips[indexPath.row].name
            cell.tripDate.text = doneTrips[indexPath.row].date
            cell.totalExpense.text = String("Rp.  \(doneTrips[indexPath.row].totalExpenses)")
            cell.totalMember.text = String(  "\(doneTrips[indexPath.row].totalMembers)")

            print("DONE init")
        }
        
        
        return cell
    }

    func deleteTrip(index: Int) {
        print("Delete Trip index \(index)")
    }

    func editTrip() {
        print("Edit Trip")
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Edit action
        let edit = UIContextualAction(style: .normal, title: "Edit Trip"){
            [weak self] (action, view, completionHandler)in
            guard let self = self else{
                return
            }
            self.editTrip()
            completionHandler(true)
        }
        edit.backgroundColor = .systemGreen
        edit.image = UIImage(systemName: "pencil")
        
        
        // Trash action
        let delete = UIContextualAction(style: .destructive, title: "Delete Trip"){
            [weak self] (action, view, completionHandler) in
            guard let self = self else{
                return
            }
//            self.trips.remove(at: indexPath.row)
            if tableView == self.onGoingTableView {
                self.trips.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("OnGOing")
            }
            else if tableView == self.doneTripTableView{
                self.doneTrips.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("DONE")
            }
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.reloadData()
//            print(indexPath.row)
//            print(tableView.)
            completionHandler(true)
        }
        delete.backgroundColor = .systemRed
        delete.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])

        return configuration
    }
   
}

