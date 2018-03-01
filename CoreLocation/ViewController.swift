import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var hAccuracy: UILabel!
    @IBOutlet weak var vAccuracy: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var course: UILabel!
    
    var locationManager = CLLocationManager()
    var location: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
            case .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .authorizedWhenInUse, .restricted, .denied:
                let alertController = UIAlertController(title: "Background location access disabled", message: "In order to update your location for this app, please open settings and enable location sharing.", preferredStyle: .alert)
            
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
            
                let openAction = UIAlertAction(title: "Open Settings", style: .default) {(action) in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                alertController.addAction(openAction)
            
                present(alertController, animated: true, completion: nil)
        }
            
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        
        print("\(String(describing: location))")
        
        latitude.text = String(format: "%.4f", location!.coordinate.latitude)
        longitude.text = String(format: "%.4f", location!.coordinate.longitude)
        altitude.text = String(format: "%.4f", location!.altitude)
        hAccuracy.text = String(format: "%.4f", location!.horizontalAccuracy)
        vAccuracy.text = String(format: "%.4f", location!.verticalAccuracy)
        timestamp.text = "\(location!.timestamp)"
        speed.text = String(format: "%.4f", location!.speed)
        course.text = String(format: "%.4f", location!.course)
        
        //If you want to stop updating location:
        //locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorAlert = UIAlertController(title: "Error", message: "Failed to get your location", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(OKAction)
        present(errorAlert, animated: true)
    }
}

