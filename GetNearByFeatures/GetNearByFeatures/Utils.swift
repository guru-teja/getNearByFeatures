//
//  Utils.swift
//  GetNearByFeatures
//
//  Created by Ganesh on 1/31/17.
//  Copyright © 2017 Ganesh. All rights reserved.
//

import Foundation
import CoreLocation

public class Utils
{
    
   
    static public func MetersToDecimalDegrees(meters:Double, latitude:Double) -> Double
    {
        return meters / (111.32 * 1000 * cos(latitude * (M_PI / 180)));
    }
    
    static public func DecimalDegreesToMeters(decimalDegrees:Double, latitude:Double) -> Double
    {
        return decimalDegrees * (111.32 * 1000 * cos(latitude * (M_PI / 180)));
    }
    
    
    static public func isPointIntersectingCircle(CircleCenter:CLLocation,PointLocation:CLLocation,Radius:Double) -> CLLocation
    {
        
        var Xc, Yc, Xp, Yp:Double
        var r = Radius as Double
        
        var NullLocation = CLLocation()
        
        Xc = CircleCenter.coordinate.latitude
        Yc = CircleCenter.coordinate.longitude
        Xp = PointLocation.coordinate.latitude
        Yp = PointLocation.coordinate.longitude
        
        let distance = sqrt( (pow(Double(Xp-Xc),2)) + (pow(Double(Yp-Yc),2)) )
        var distance_m = DecimalDegreesToMeters(decimalDegrees: distance, latitude: Xc)
        
        
            if(distance_m < r)
            {
                return PointLocation
            }
                
            else if (distance_m > r)
            {
                return NullLocation
            }
            else if (distance_m == r)
            {
                return PointLocation
            }
        
        return NullLocation
        
    }
    
    
    static public func isSegmentIntersectingCircle(StartingPoint:CLLocation, EndingPoint:CLLocation, BeaconLocation:CLLocation, radius:Double) -> [CLLocation]
    {
        var Ax, Bx, Ay,By,Dx,Dy,LAB,t,Cx,Cy,Ex,Ey,R,LEC,Fx,Fy,Gx,Gy,dt,ddt:Double
        var dAC,dBC:Double
        var dACm, dBCm:Double
        var LABm:Double
        
        
        Ax = StartingPoint.coordinate.longitude
        Ay = StartingPoint.coordinate.latitude
        
        Bx = EndingPoint.coordinate.longitude
        By = EndingPoint.coordinate.latitude
        
        Cx = BeaconLocation.coordinate.longitude
        Cy = BeaconLocation.coordinate.latitude
        
        R = MetersToDecimalDegrees(meters: radius, latitude: Cy)
        
        
        // compute the euclidean distance between A and B
        LAB = sqrt( (pow(Double(Bx-Ax),2)) + (pow(Double(By-Ay),2)) )
        LABm = DecimalDegreesToMeters(decimalDegrees: LAB, latitude: Cy)
        
        
        //Compute the Euclidean distance between A and C
        dAC = sqrt( (pow(Double(Cx-Ax),2)) + (pow(Double(Cy-Ay),2)) )
        dACm = DecimalDegreesToMeters(decimalDegrees: dAC, latitude: Cy)
        
        //Compute the Euclidean distance between B and C
        dBC = sqrt( (pow(Double(Cx-Bx),2)) + (pow(Double(Cy-By),2)) )
        dBCm = DecimalDegreesToMeters(decimalDegrees: dBC, latitude: Cy)
        
        if (LAB == 0 ) {
            //  print("Distance between A and B is Null")
            return [];
        }
        
        // compute the direction vector D from A to B
        Dx = (Bx-Ax)/LAB
        Dy = (By-Ay)/LAB
        
        // Now the line equation is x = Dx*t + Ax, y = Dy*t + Ay with 0 <= t <= 1.
        
        // compute the value t of the closest point to the circle center (Cx, Cy)
        t = Dx*(Cx-Ax) + Dy*(Cy-Ay)
        
        // This is the projection of C on the line from A to B.
        
        // compute the coordinates of the point E on line and closest to C
        Ex = t*Dx+Ax
        Ey = t*Dy+Ay
        
        // compute the euclidean distance from E to C
        LEC = sqrt( (pow(Double(Ex-Cx),2)) + (pow(Double(Ey-Cy),2)) )
        //let LECm = LEC*(111.32 * 1000 * cos(Cy * (M_PI / 180)))
        let LECm = DecimalDegreesToMeters(decimalDegrees: LEC, latitude: Cy)
        
        
        
        if (LECm < radius)
        {
            if (dACm > radius && dBCm > radius){
                return []
            }
            else
            {
                return [StartingPoint,EndingPoint]
            }
            
        }
        else
        {
            return []
        }
        
        

    }
    
    
    static public func isPolygonIntersectingCircle(StartPoint:CLLocation , EndingPoint:CLLocation,CircleCenter:CLLocation,radius:Double) -> [CLLocation]
    {
        var Ax, Bx, Ay,By,Dx,Dy,LAB,t,Cx,Cy,Ex,Ey,R,LEC,Fx,Fy,Gx,Gy,dt,ddt:Double
        var dAC,dBC:Double
        var dACm, dBCm:Double
        var LABm:Double
        
        
        
        Ax = StartPoint.coordinate.longitude
        Ay = StartPoint.coordinate.latitude
        
        Bx = EndingPoint.coordinate.longitude
        By = EndingPoint.coordinate.latitude
        
        Cx = CircleCenter.coordinate.longitude
        Cy = CircleCenter.coordinate.latitude
        
        R = MetersToDecimalDegrees(meters: radius, latitude: Cy)
        
        
        // compute the euclidean distance between A and B
        LAB = sqrt( (pow(Double(Bx-Ax),2)) + (pow(Double(By-Ay),2)) )
        LABm = DecimalDegreesToMeters(decimalDegrees: LAB, latitude: Cy)
        
        
        //Compute the Euclidean distance between A and C
        dAC = sqrt( (pow(Double(Cx-Ax),2)) + (pow(Double(Cy-Ay),2)) )
        dACm = DecimalDegreesToMeters(decimalDegrees: dAC, latitude: Cy)
        
        //Compute the Euclidean distance between B and C
        dBC = sqrt( (pow(Double(Cx-Bx),2)) + (pow(Double(Cy-By),2)) )
        dBCm = DecimalDegreesToMeters(decimalDegrees: dBC, latitude: Cy)
        
        if (LAB == 0 ) {
            //  print("Distance between A and B is Null")
            return [];
        }
        
        // compute the direction vector D from A to B
        Dx = (Bx-Ax)/LAB
        Dy = (By-Ay)/LAB
        
        // Now the line equation is x = Dx*t + Ax, y = Dy*t + Ay with 0 <= t <= 1.
        
        // compute the value t of the closest point to the circle center (Cx, Cy)
        t = Dx*(Cx-Ax) + Dy*(Cy-Ay)
        
        // This is the projection of C on the line from A to B.
        
        // compute the coordinates of the point E on line and closest to C
        Ex = t*Dx+Ax
        Ey = t*Dy+Ay
        
        // compute the euclidean distance from E to C
        LEC = sqrt( (pow(Double(Ex-Cx),2)) + (pow(Double(Ey-Cy),2)) )
        //let LECm = LEC*(111.32 * 1000 * cos(Cy * (M_PI / 180)))
        let LECm = DecimalDegreesToMeters(decimalDegrees: LEC, latitude: Cy)
        
        if (LECm < radius)
        {
            if (dACm > radius && dBCm > radius){
                return []
            }
            else
            {
                return [StartPoint,EndingPoint]
            }
            
        }
        else
        {
            return []
        }
        
  
    }
    
    
    static public func getNearByFeatures(PoIs:[CLLocation], Beacons:[CLLocation], Paths: [[CLLocation]], Zones:[[CLLocation]],position:CLLocation, radius:Double) -> ([CLLocation],[CLLocation],[[CLLocation]],[[CLLocation]])
    {
        var NearbyPoIs = [CLLocation]()
        var NearbyBeacons = [CLLocation]()
        var NearbyPaths = [[CLLocation]]()
        var NearbyZones = [[CLLocation]]()
        
        
        for(eachPoIs) in PoIs
        {
            
            var returnedPoints = self.isPointIntersectingCircle(CircleCenter: position, PointLocation: eachPoIs, Radius: radius)
            
            if (returnedPoints.coordinate.latitude != 0.0 && returnedPoints.coordinate.longitude != 0.0)
            {
                NearbyPoIs.append(returnedPoints)
                
            }
        }
        
        
        for eachBeacon in Beacons {
            
            
            
            var returnedPoints = self.isPointIntersectingCircle(CircleCenter: position, PointLocation: eachBeacon, Radius: radius)
            
            if (returnedPoints.coordinate.latitude != 0.0 && returnedPoints.coordinate.longitude != 0.0)
            {
                NearbyBeacons.append(returnedPoints)
                
            }
        }
        
        for(_,eachPath) in Paths.enumerated() {
            
            
            var returnedPaths = self.isSegmentIntersectingCircle(StartingPoint: eachPath.first! , EndingPoint: eachPath.last!, BeaconLocation: position, radius: radius)
            
            if (returnedPaths.count > 0 && returnedPaths != [])
            {
                
                NearbyPaths.append(returnedPaths)
            }
        }
        
        for eachZone in Zones {
            for (i,_) in eachZone.enumerated() {
                
                
                if(i < eachZone.count-1)
                {
      
                    var points = self.isPolygonIntersectingCircle(StartPoint: eachZone[i], EndingPoint: eachZone[i+1], CircleCenter: position, radius: radius)
                    
                    if (points.count > 0 && points != [])
                    {
                        NearbyZones.append(eachZone)
                        break
                    }
                    
                }
                        }
         
        }
        
       // For printing the Featuers
        /*
        print ("Beacons")
        
        for beacons in NearbyBeacons
        {
            print ("[ \(beacons.coordinate.longitude), \(beacons.coordinate.latitude)],")
            
        }
        
        print ("POIS")
        for pois in NearbyPoIs{
            
            print ("[ \(pois.coordinate.longitude), \(pois.coordinate.latitude)],")
            
        }
        print ("Paths")
        for pat in NearbyPaths
        {
            print ("[[")
            
            for pathend in pat
            {
                print ("[ \(pathend.coordinate.longitude), \(pathend.coordinate.latitude)],")
            }
            
            print ("]],")
        }
        print ("Zones")
        for zone in NearbyZones
        {
            print ("[[")
            
            for zonecorner in zone
            {
                print ("[ \(zonecorner.coordinate.longitude), \(zonecorner.coordinate.latitude)],")
            }
            
            print ("]],")
        }
 */
        
        return (NearbyPoIs,NearbyBeacons,NearbyPaths,NearbyZones)
}


}
