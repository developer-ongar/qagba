//
//  SettingsVC.swift
//  Turbah
//
//  Created by MMQ on 7/16/20.
//  Copyright © 2020 MMQ. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class SettingsVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    struct section {
        var name: sectionNames
        var cells: [cell]
        
        enum sectionNames {
            case general
            case contact
            case bottom
        }
    }
    
    struct cell {
        var name: cellNames
        
        enum cellNames {
            case northType
            case contact
            case terms
            case share
            case red
        }
    }
    
    let sectionArray = [
        section(name: .general, cells: [
            cell(name: .northType),
            cell(name: .red),
            cell(name: .red),
            cell(name: .red)
        ]),
        section(name: .contact, cells: [
            cell(name: .contact),
            cell(name: .contact)
        ]),
        section(name: .bottom, cells: [
            cell(name: .terms),
            cell(name: .share)
        ])
    ]
    
    let contactInfo = [(UIImage(named: "contactemail"), "mmqazwini@yahoo.com"), (UIImage(named: "contactinstagram"), "@mmqazwini")]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        
        tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.cellID)
        tableView.register(SegmentedCell.self, forCellReuseIdentifier: SegmentedCell.id)
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.id)
        //tableView.sectionHeaderHeight = 70
    }
    
    @objc func donePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section].cells[indexPath.row].name {
        case .northType:
            let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedCell.id, for: indexPath) as! SegmentedCell
            cell.selectionStyle = .none
            cell.segmentedControl.addTarget(self, action: #selector(northTypeChanged(_:)), for: .valueChanged)
            return cell
        case .contact:
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.id, for: indexPath) as! ContactCell
            cell.iconImageView.image = contactInfo[indexPath.row].0
            cell.infoLabel.text = contactInfo[indexPath.row].1
            return cell
        case .terms:
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cellID, for: indexPath)
            cell.textLabel?.text = "Terms and Privacy Policy"
            return cell
        case .share:
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cellID, for: indexPath)
            cell.textLabel?.text = "Share"
            return cell
        case .red:
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cellID, for: indexPath)
            cell.textLabel?.text = "y\(indexPath.row)lo"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray[section].cells.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sectionArray[section].name {
        case .general, .bottom: return nil
        case .contact: return "Contact"
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == tableView.numberOfSections - 1 {
            return SettingsFooterView()
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (tableView.numberOfSections - 1) {
            return 75
        }
        return 20
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sectionArray[indexPath.section].cells[indexPath.row].name {
        case .contact:
            if indexPath.row == 0 {
                if !MFMailComposeViewController.canSendMail() {
                    let alert = UIAlertController(title: "Unable to send message", message: "Unable to send message. Please check your internet connection and try again.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                } else {
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    composeVC.setToRecipients(["mmqazwini@yahoo.com"])
                    composeVC.setSubject("Turbah AR Qibla")
                    composeVC.setMessageBody("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nSent From Turbah", isHTML: false)
                    present(composeVC, animated: true, completion: nil)
                }
            } else {
                let instagramUrl = URL(string: "instagram://user?username=mmqazwini")
                if UIApplication.shared.canOpenURL(instagramUrl!) {
                    UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://instagram.com/mmqazwini") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        case .terms:
            guard let url = URL(string: "http://alqazwini.org/turbah/privacyandterms.html") else { return }
            let safariView = SFSafariViewController(url: url)
            present(safariView, animated: true)
        case .share:
            let activityVC = UIActivityViewController(activityItems: [appURL, "Turbah - تـربـة"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            present(activityVC, animated: true)
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @objc private func northTypeChanged(_ sender: UISegmentedControl) {
        save.northType = (sender.selectedSegmentIndex == 0) ? .trueNorth : .magneticNorth
    }

}
