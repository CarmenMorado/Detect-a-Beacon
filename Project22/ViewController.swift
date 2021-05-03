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
    var locationManager: CLLocationManager?
    var circle: UIView!
    var firstBeaconDetected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        view.backgroundColor = .lightGray
        
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
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
          //  locationManager?.startMonitoring(for: beaconRegion)
          //  locationManager?.startRangingBeacons(in: beaconRegion)
        //}
        
       // if self.firstBeacon  UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!  {
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
       //}
        
        //locationManager?.startMonitoring(for: beaconRegion)
       // locationManager?.startRangingBeacons(in: beaconRegion)
        
       // let uuid2 = UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!
       // let beaconRegion2 = CLBeaconRegion(proximityUUID: uuid2, major: 65504, minor: 65505, identifier: "MyBeacon2")
       // if beaconRegion2.uuid == UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")! {
          // locationManager?.startMonitoring(for: beaconRegion2)
         //  locationManager?.startRangingBeacons(in: beaconRegion2)
       //}
        
        //startScanning()
       // locationManager?.startMonitoring(for: beaconRegion2)
       // locationManager?.startRangingBeacons(in: beaconRegion2)

        //let uuid3 = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        //let beaconRegion3 = CLBeaconRegion(proximityUUID: uuid3, major: 123, minor: 456, identifier: "MyBeacon3")

        
        //locationManager?.startMonitoring(for: beaconRegion)
       // locationManager?.startRangingBeacons(in: beaconRegion)
        
        //locationManager?.startMonitoring(for: beaconRegion2)
        //locationManager?.startRangingBeacons(in: beaconRegion2)
        
        //locationManager?.startMonitoring(for: beaconRegion3)
        //locationManager?.startRangingBeacons(in: beaconRegion3)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
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
                self.animateCircle(scale: 0.001)
            }
        }
    }
    
   // func updateMessage(region: CLBeaconRegion) {
     //   UIView.animate(withDuration: 0.8) {
       //     switch region {
         //   case .init(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, identifier: "MyBeacon"):
           //     self.beaconReading.text = "The beacon with the UUID of 5A4BCFCE-174E-4BAC-A814-092E77F6B7E5 has been detected!"
            //case .init(uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!, identifier: "MyBeacon2"):
                
            //default:
              //  self.beaconReading.text = "UNKNOWN"
            //}
        //}
    //}
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if firstBeaconDetected == false {
                let alert = UIAlertController(title: "Beacon Detected!", message: "Your first beacon has been detected!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                firstBeaconDetected = true
                self.present(alert, animated: true)
            }
            
            update(distance: beacon.proximity)
        }
        
        else {
            update(distance: .unknown)
        }
    }
    
    func animateCircle(scale: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
            animations: {
            self.circle.transform = CGAffineTransform(scaleX: scale, y: scale)
            })
    }

}

