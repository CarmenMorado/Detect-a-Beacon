//
//  ViewController.swift
//  Project22
//
//  Created by Carmen Morado on 4/28/21.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var locationManager: CLLocationManager?
    var circle: UIView!
    var firstBeaconDetected = false
    var currentBeaconUuid: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        view.backgroundColor = .lightGray
        nameLabel.text = "Unknown"
        
        circle = UIView()
        circle.frame.size = CGSize(width: 256, height: 256)
        circle.layer.cornerRadius = 128
        circle.backgroundColor = .darkGray
        circle.center = view.center
        view.addSubview(circle)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        addBeaconRegion(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "Apple AirLocate")
        addBeaconRegion(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6", major: 123, minor: 456, identifier: "Radius Networks")
        addBeaconRegion(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491", major: 123, minor: 456, identifier: "TwoCanoes")
       }
    
    func addBeaconRegion(uuidString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
        let uuid = UUID(uuidString: uuidString)!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity, name: String) {
        UIView.animate(withDuration: 0.8) {
            self.nameLabel.text = "\(name)"
            
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                self.animateCircle(scale: 0.25)

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                self.animateCircle(scale: 0.5)

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                self.animateCircle(scale: 1.0)

            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.nameLabel.text = "Unknown"
                self.animateCircle(scale: 0.001)
            }
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if firstBeaconDetected == false {
                let alert = UIAlertController(title: "Beacon Detected!", message: "Your first beacon has been detected!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                firstBeaconDetected = true
                self.present(alert, animated: true)
            }
            
            if currentBeaconUuid == nil { currentBeaconUuid = region.proximityUUID }
            guard currentBeaconUuid == region.proximityUUID else { return }

            update(distance: beacon.proximity, name: region.identifier)
        }
        
        else {
            guard currentBeaconUuid == region.proximityUUID else { return }
            currentBeaconUuid = nil
            update(distance: .unknown, name: "Unknown")
        }
    }
    
    func animateCircle(scale: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
            animations: {
            self.circle.transform = CGAffineTransform(scaleX: scale, y: scale)
            })
    }

}

