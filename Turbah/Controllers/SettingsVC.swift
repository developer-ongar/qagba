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
    
    var didEnterMainView: (()->Void)?
    
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
            case distance
            case contact
            case ourApps
            case terms
            case share
        }
    }
    
    let sectionArray = [
        section(name: .general, cells: [
            cell(name: .distance),
            cell(name: .northType)
        ]),
        section(name: .contact, cells: [
            cell(name: .contact),
            cell(name: .contact)
        ]),
        section(name: .bottom, cells: [
            cell(name: .terms),
            cell(name: .ourApps),
            cell(name: .share)
        ])
    ]
    
    let contactInfo = [("contactemail", "developer.ongar@protonmail.com"), ("contactinstagram", "Developer")]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.cellID)
        tableView.register(SegmentedCell.self, forCellReuseIdentifier: SegmentedCell.id)
        tableView.register(ContactCell.self, forCellReuseIdentifier: ContactCell.id)
        tableView.register(DistanceCell.self, forCellReuseIdentifier: DistanceCell.id)
    }
    
    @objc func donePressed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didEnterMainView?()
    }
    
    
    // MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sectionArray[indexPath.section].cells[indexPath.row].name {
        case .northType:
            let cell = tableView.dequeueReusableCell(withIdentifier: SegmentedCell.id, for: indexPath) as! SegmentedCell
            cell.selectionStyle = .none
            cell.segmentedControl.addTarget(self, action: #selector(northTypeChanged(_:)), for: .valueChanged)
            return cell
        case .distance:
            let cell = tableView.dequeueReusableCell(withIdentifier: DistanceCell.id, for: indexPath) as! DistanceCell
            cell.selectionStyle = .none
            return cell
        case .contact:
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.id, for: indexPath) as! ContactCell
            cell.iconImageView.image = UIImage(named: contactInfo[indexPath.row].0)
            cell.infoLabel.text = contactInfo[indexPath.row].1
            return cell
        case .ourApps:
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cellID, for: indexPath)
            cell.textLabel?.text = "OurApps".localized
            cell.textLabel?.font = .systemFont(ofSize: UIFont.labelFontSize)
            return cell
        case .terms:
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cellID, for: indexPath)
            cell.textLabel?.text = "TermsPrivacy".localized
            cell.textLabel?.font = .systemFont(ofSize: UIFont.labelFontSize)
            return cell
        case .share:
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.cellID, for: indexPath)
            cell.textLabel?.text = "Share".localized
            cell.textLabel?.font = .systemFont(ofSize: UIFont.labelFontSize)
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
        case .contact: return "Contact".localized
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == (tableView.numberOfSections - 1) {
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
                    let alert = UIAlertController(title: "UnableSendTitle".localized, message: "UnableSendMessage".localized, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                } else {
                    let composeVC = MFMailComposeViewController()
                    composeVC.mailComposeDelegate = self
                    composeVC.setToRecipients(["mmqazwini@yahoo.com"])
                    composeVC.setSubject("EmailTitle".localized)
                    composeVC.setMessageBody("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nSent From Qagba", isHTML: false)
                    present(composeVC, animated: true, completion: nil)
                }
            } else {
                let instagramUrl = URL(string: "instagram://user?username=ongar.jr")
                if UIApplication.shared.canOpenURL(instagramUrl!) {
                    UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
                } else {
                    if let url = URL(string: "http://instagram.com/ongar.jr") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        case .ourApps:
            guard let url = URL(string: developerURL) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .terms:
            guard let url = URL(string: "https://developer-ongar.github.io/Qagba-app-privacy/index.html") else { return }
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
        save.trueNorth = sender.selectedSegmentIndex == 0
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
