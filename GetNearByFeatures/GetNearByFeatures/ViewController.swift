//
//  ViewController.swift
//  GetNearByFeatures
//
//  Created by Ganesh on 1/31/17.
//  Copyright © 2017 Ganesh. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var mybeacon:CLLocation = CLLocation()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        mybeacon = CLLocation(latitude: 17.729306950185151, longitude: 83.314586258062363)
        
        self.myfunc()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func myfunc()
    {
        
        let beaconPoints = self.getDataFrom(geoJSON:"Beacons")
        var beacons = [CLLocation]()
        
        for (_,inde) in beaconPoints.enumerated()
        {
            
            let geometry = (inde as! [String:AnyObject])["geometry"] as! [String:AnyObject]
            let coordinates = geometry["coordinates"] as! [NSNumber]
            
            beacons.append(CLLocation(latitude: coordinates[1] as! Double, longitude: coordinates[0] as! Double))
            
        }
        // print("you got beacons \(beacons)")
        
        let PoiPoints = self.getDataFrom(geoJSON:"POI")
        var pois = [CLLocation]()
        
        for (_,inde) in PoiPoints.enumerated()
        {
            let geometry = (inde as! [String:AnyObject])["geometry"] as! [String:AnyObject]
            let coordinates = geometry["coordinates"] as! [NSNumber]
            var thepoi = CLLocation(latitude: coordinates.last as! CLLocationDegrees, longitude: coordinates.first as! CLLocationDegrees)
            pois.append(thepoi)
            
        }
        // print("you got pois \(pois)")
        
        
        let Paths = self.getDataFrom(geoJSON:"Path")
        var path = [[CLLocation]]()
        
        for (_,inde) in Paths.enumerated()
        {
            let geometry = (inde as! [String:AnyObject])["geometry"] as! [String:AnyObject]
            let coordinates = geometry["coordinates"] as! [[NSNumber]]
            var locPath = [CLLocation]()
            for lines in coordinates{
                let lPath = CLLocation(latitude: lines.last as! CLLocationDegrees, longitude: lines.first as! CLLocationDegrees)
                locPath.append(lPath)
            }
            path.append(locPath)
        }
        
        //   print("you have paths \(path)")
        
        let Zones = self.getDataFrom(geoJSON:"Zones")
        var zones1 = [[CLLocation]]()
        
        for (_,inde) in Zones.enumerated()
        {
            
            let geometry = (inde as! [String:AnyObject])["geometry"] as! [String:AnyObject]
            let coordinates = (geometry["coordinates"] as! [[[NSNumber]]]).first! as [[NSNumber]]
            
            var locZone = [CLLocation]()
            for lines in coordinates{
                let lZone = CLLocation(latitude: lines.last as! CLLocationDegrees, longitude: lines.first as! CLLocationDegrees)
                locZone.append(lZone)
            }
            zones1.append(locZone)
            
            
        }
        
        
        //Send the available featuers to the getNearByFeatures function
        
        let foundFeatures = Utils.getNearByFeatures(PoIs: pois, Beacons: beacons, Paths: path, Zones: zones1, position: mybeacon, radius: 3.0)
        /*
        foundFeatures.0 is PoIs array of CLLocation
        foundFeatures.1 is beacons array of CLLocation
        foundFeatures.2 is Paths array of array of CLLocation
        foundFeatures.3 is Zones array of array of Zones
        */
        
        
        // For printing the Featuers
        
        
         
         print ("POIS")
         for pois in foundFeatures.0
         {
            
            print ("[ \(pois.coordinate.longitude), \(pois.coordinate.latitude)],")
            
         }
        
        print ("Beacons")
        for beacons in foundFeatures.1
        {
            
            print ("[ \(beacons.coordinate.longitude), \(beacons.coordinate.latitude)],")
            
        }
        
         print ("Paths")
         for pat in foundFeatures.2
         {
         print ("[[")
         
                 for pathend in pat
                 {
                        print ("[ \(pathend.coordinate.longitude), \(pathend.coordinate.latitude)],")
                 }
         
         print ("]],")
         }
        
         print ("Zones")
         for zone in foundFeatures.3
         {
                print ("[[")
         
                 for zonecorner in zone
                 {
                        print ("[ \(zonecorner.coordinate.longitude), \(zonecorner.coordinate.latitude)],")
                 }
         
         print ("]],")
         }
 
    }
    
    func getDataFrom(geoJSON:String)->NSArray {
        
        let bundle = Bundle(for: type(of: self))
        if let theURL = bundle.url(forResource: geoJSON, withExtension: "geojson") {
            do {
                let data = try Data(contentsOf: theURL)
                if let parsedData = try? JSONSerialization.jsonObject(with: data) as! [String:Any] {
                    return parsedData["features"] as! NSArray
                }
            } catch {
                print(error)
            }
        }
        return NSArray()
    }

}

