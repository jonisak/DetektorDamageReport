//
//  DetectorMapViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-10-15.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
import MapKit

class DetectorAnnotation: NSObject, MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var detectorId : Int
    init(coor: CLLocationCoordinate2D, detectorid: Int)
    {
        coordinate = coor
        detectorId = detectorid
    }
}

class ShowDetectorValuesButton : UIButton {
    var annotation: DetectorAnnotation? = nil
}


class DetectorMapViewController: UIViewController, MKMapViewDelegate {
    var delegate:reloadStartViewDelegate?

    var map : MKMapView = {
        var m = MKMapView()
        m.translatesAutoresizingMaskIntoConstraints = false
        return m
    }();

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(map);
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stäng", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.closeView))

        map.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true;
        map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true;
        map.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true;
        map.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true;
        map.delegate = self
        
        for detector in (UIApplication.shared.delegate as! AppDelegate).detectornDTOList {
            if  detector.Latitude != nil && detector.Longitude != nil && detector.DetectorType != "RFID Reader"
            {
                let annotation = DetectorAnnotation(coor: CLLocationCoordinate2D(latitude: Double(detector.Latitude!)!, longitude: Double(detector.Longitude!)!), detectorid: detector.DetectorId)
                annotation.title = detector.Name
                annotation.subtitle = detector.DetectorType

                map.addAnnotation(annotation)
            }
        }

    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      // 2
      guard let annotation = annotation as? DetectorAnnotation else { return nil }

        // 3
      let identifier = "marker"
      var view: MKMarkerAnnotationView
      // 4
      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        as? MKMarkerAnnotationView {
        dequeuedView.annotation = annotation
        view = dequeuedView
        
        let button = ShowDetectorValuesButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(self.showAnnotationDisclosure(_:)), for: .touchUpInside)
        view.rightCalloutAccessoryView = button

        
        if let button = view.rightCalloutAccessoryView as? ShowDetectorValuesButton {
            button.annotation = annotation
        }
        
        view.rightCalloutAccessoryView = button
      } else {
        // 5
        view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        view.glyphImage =  UIImage(named: "Detector")
        view.glyphImage = view.glyphImage?.resize(withSize: CGSize(width: 15, height: 15), contentMode: .contentAspectFill)
        
        let button = ShowDetectorValuesButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(self.showAnnotationDisclosure(_:)), for: .touchUpInside)
        view.rightCalloutAccessoryView = button

        
        if let button = view.rightCalloutAccessoryView as? ShowDetectorValuesButton {
            button.annotation = annotation
        }
        }
      return view
    }
    
    @objc func showAnnotationDisclosure(_ sender: ShowDetectorValuesButton) {
        (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.SelectedDetectorsDTOList.removeAll()
        if let detectorID = sender.annotation?.detectorId
        {
            for detector in (UIApplication.shared.delegate as! AppDelegate).detectornDTOList {
                if detectorID == detector.DetectorId
                {
                    (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.SelectedDetectorsDTOList.append(detector);
                }
            }
        }
        self.closeView()
    }


    
    
    
    @objc func closeView(){
        self.delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}
