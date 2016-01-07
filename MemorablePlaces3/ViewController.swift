//
//  ViewController.swift
//  MemorablePlaces3
//
//  Created by Julian Nicholls on 07/01/2016.
//  Copyright © 2016 Really Big Shoe. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    let locMgr      : CLLocationManager  = CLLocationManager()
    var locCount    : Int = 0

    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        locMgr.delegate = self
        locMgr.desiredAccuracy = kCLLocationAccuracyBest

        let uilpgr = UILongPressGestureRecognizer(target: self, action: "addLocation:")

        uilpgr.minimumPressDuration = 1.5

        map.addGestureRecognizer(uilpgr)
    }

    @IBAction func locatePressed(sender: AnyObject) {
        locCount = 0

        locMgr.requestWhenInUseAuthorization()
        locMgr.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let user : CLLocation = locations[0]

        let lat  = user.coordinate.latitude
        let long = user.coordinate.longitude

        let location : CLLocationCoordinate2D   = CLLocationCoordinate2DMake(lat, long)
        let span     : MKCoordinateSpan         = MKCoordinateSpanMake(0.01, 0.01)
        let region   : MKCoordinateRegion       = MKCoordinateRegionMake(location, span)

        self.map.setRegion(region, animated: true)

        // Only take two updates

        if ++locCount == 2 {
            locMgr.stopUpdatingLocation()
        }
    }

    func addLocation(gr: UILongPressGestureRecognizer) {
        let pTouch = gr.locationInView(self.map)

        let pMap : CLLocationCoordinate2D = map.convertPoint(pTouch, toCoordinateFromView: self.map)

        setLocationPin(pMap)
    }

    func setLocationPin(loc2d: CLLocationCoordinate2D) {
        let loc = CLLocation(latitude: loc2d.latitude, longitude: loc2d.longitude)
        let ann = MKPointAnnotation()

        ann.coordinate = loc2d

        CLGeocoder().reverseGeocodeLocation(loc) {
            (placemarks, error) -> Void in

            if error == nil {
                if let pm = placemarks![0] as CLPlacemark? {
                    let subT  = pm.subThoroughfare != nil ? pm.subThoroughfare! : ""
                    let mainT = pm.thoroughfare != nil ? "\(pm.thoroughfare!), " : ""
                    let local = pm.locality != nil ? "\(pm.locality!), " : ""
                    let admin = pm.administrativeArea!
                    let code  = pm.postalCode!

                    dispatch_async(dispatch_get_main_queue(), {
                        ann.title = "\(subT) \(mainT)\(local)\(admin) \(code)"
                        self.map.addAnnotation(ann)
                    })
                }
            }
            else {
                print(error?.localizedDescription)

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    ann.title = String(format: "%.3f, %.3f", arguments: [loc2d.latitude, loc2d.longitude])
                    self.map.addAnnotation(ann)
                })
            }
        }
    }





    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

