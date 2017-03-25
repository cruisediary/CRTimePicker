//
//  CRTimePickerViewController.swift
//  CRTimePicker
//
//  Created by Cruz on 25/03/2017.
//  Copyright © 2017 cruz. All rights reserved.
//

import UIKit

protocol CRTimePickerDelegate: class {
    func timeDidSelect(hour: Int, minute: Int)
}

class CRTimePickerViewController: UIViewController {
    
    weak var delegate: CRTimePickerDelegate?

    @IBOutlet weak var hourContainerView: UIView!
    @IBOutlet weak var hourView: UIView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var hourTableView: UITableView!
    
    @IBOutlet weak var minuteContainerView: UIView!
    @IBOutlet weak var minuteView: UIView!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var minuteTableView: UITableView!
    
    var hour: Int = 0
    var minute: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gesture)))
        hourContainerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gesture)))
        
        minuteContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gesture)))
        minuteContainerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gesture)))
        // Do any additional setup after loading the view.
    }
    
    func gesture(gesture: UIGestureRecognizer) {
        guard let view = gesture.view else { return }
        switch view {
        case hourContainerView:
            var point = gesture.location(in: hourContainerView)
            point.x = hourView.center.x
            point.y = min(max(point.y, 30), view.frame.size.height - 30)
            
            if let indexPath = hourTableView.indexPathForRow(at: point) {
                hour = indexPath.row + 1
                hourLabel.text = String(format: "%02lu", hour)
            }
            
            UIView.animate(withDuration: 0.1) {
                self.hourView.center = point
            }
        case minuteContainerView:
            var point = gesture.location(in: minuteContainerView)
            point.x = minuteView.center.x
            point.y = min(max(point.y, 30), view.frame.size.height - 30)
            
            if let indexPath = hourTableView.indexPathForRow(at: point) {
                minute = indexPath.row * 5
                minuteLabel.text = String(format: "%02lu", minute)
            }
            
            UIView.animate(withDuration: 0.1) {
                self.minuteView.center = point
            }
        default: break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CRTimePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case hourTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CRHourCell", for: indexPath) as! CRHourCell
            cell.hourLabel.text = String(format: "%02lu", indexPath.row + 1)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CRMinuteCell", for: indexPath) as! CRMinuteCell
            cell.minuteLabel.text = String(format: "%02lu", indexPath.row * 5)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
}

extension CRTimePickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 12
    }
}
