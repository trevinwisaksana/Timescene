//
//  EventsViewController.swift
//  Scene
//
//  Created by Trevin Wisaksana on 11/02/2018.
//  Copyright © 2018 Trevin Wisaksana. All rights reserved.
//

import UIKit
import ReSwift

// MARK: - Imports
import UIKit
import CoreLocation
import GoogleMaps
import Reachability
import GoogleAPIClientForREST
import FirebaseAuthUI
import GoogleSignIn
import MapKit

// MARK: - EventsViewController
final class EventsViewController: UIViewController {
    
    //---- IBOutlet ----//
    // MARK: - IBOutlet
    
    @IBOutlet var eventsCollectionView: EventsCollectionView!
    @IBOutlet var mainView: EventsMainView!
    @IBOutlet weak var menuButton: UIButton!
    
    //---- Properties ----//
    // MARK: - Properties
    
    let viewModel = EventsViewModel()
    fileprivate var source = TSEventsDataSource(store: mainStore)
    private let reachabiltyHelper = ReachabilityHelper()
    
    private let refreshControl = UIRefreshControl()
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    weak var delegate: CenterViewControllerDelegate?

    //---- Lifecycle ----//
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeReachabilityListener()
    }
    
    //---- IBAction ----//
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        delegate?.toggleLeftPanel!()
    }
    
    //---- View Controller Configuration ----//
    
    private func configure() {
        
        source.delegate = self
        
        //---- Sign In silently ----//
        configureGoogleSignIn()
        
        // Subscribe to state changes
        // mainStore.subscribe(self)
        
        //---- Set default map ----//
        MapOptions.set(.appleMaps)
        
        //---- Collection View Cell ----//
        eventsCollectionView.registerCollectionViewCellNib()
        
        //---- Request Location Authorization ----//
        viewModel.locationHelper.requestAuthorization()
        
        //---- Request Calendar Authorization ----//
        viewModel.eventHelper.requestAccess()
        
        //---- Start Networking Monitoring ----//
        reachabiltyHelper.startMonitoring()
        reachabiltyHelper.add(listener: self)
        
        // TODO: Move the refresh control logic
        //---- Configure refresh control ----//
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        refreshControl.layer.zPosition = -1
        eventsCollectionView?.addSubview(refreshControl)
        
        // TODO: Move to main view
        menuButton.roundEdges(cornerRadius: menuButton.frame.width / 2)
    }
    
    func removeReachabilityListener() {
        reachabiltyHelper.stopMonitoring()
        reachabiltyHelper.remove(listener: self)
    }
    
    func refreshNetworkStatusSection() {
        let section = IndexSet(integer: 0)
        eventsCollectionView.reloadSections(section)
    }

}

// MARK: - UICollectionViewDataSource
extension EventsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //---- Collection View Data Source ----//
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Used to check if a user exists
        let defaults = UserDefaults.standard
        let currentUser = defaults.object(forKey: Constants.UserDefaults.currentUser)
        
        switch section {
        // If user has logged in before, remove the cell in the other sections
        case 0:
            if ReachabilityHelper.isConnectedToNetwork() {
               return 0
            } else {
                return 1
            }
        case 1:
            if currentUser != nil {
                return 1
            } else {
                return 2
            }
        case 2:
            if currentUser != nil {
                return 0
            } else {
                return 1
            }
        case 3:
            if viewModel.numberOfEvents() == 0 && currentUser != nil {
                return 1
            } else {
                return viewModel.numberOfEvents()
            }
        case 4:
            if currentUser != nil {
                return 1
            } else {
                return 0
            }
        default:
            return 0
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            
            let cell: ErrorCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure()
            return cell
            
        case 1:
            
            if row == 0 {
                let cell: WelcomeCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure()
                return cell
            } else {
                let cell: InformationCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure()
                return cell
            }
            
        case 2:
            
            let cell: GoogleSignInCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure()
            return cell
            
        case 3:
            
            if viewModel.numberOfEvents() == 0 {
                let cell: NoEventCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.configure()
                return cell
            }
            
            // UNCOMMENT
            // let subject = source.data(atIndex: row)
            // return TSEventCell.view(collectionView, indexPath: indexPath, subject: subject)
            
            let cell: EventCell = collectionView.dequeueReusableCell(for: indexPath)
            let event = viewModel.event(at: indexPath)
            
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            viewModel.getTravelTime(for: event) { (isSuccessful) in
                if isSuccessful {
                    dispatchGroup.leave()
                } else {
                    // TODO: Handle error
                }
                
                guard let currentMap = MapOptions.current else {
                    fatalError("Map option has not been set.")
                }
                
                cell.configure(event, with: currentMap)
            }
            
            dispatchGroup.notify(queue: .main) {

                if MapOptions.current == .googleMaps {
                    
                    guard let gmsMapView = cell.gmsMapView else {
                        print("Google Map View has not been instantiated or is removed.")
                        return
                    }
                    
                    gmsMapView.delegate = self
                    
                    self.viewModel.displayPath(for: event, on: gmsMapView) { (isSuccessful) in
                        if !isSuccessful {
                            // TODO: Handle error
                        }
                    }
                    
                } else {
                    
                    guard let appleMapView = cell.appleMapView else {
                        print("Apple Map View has not been instantiated or is removed.")
                        return
                    }
                    
                    appleMapView.delegate = self
                    self.viewModel.displayPath(for: event, on: appleMapView) { (isSuccessful) in
                        if !isSuccessful {
                            // TODO: Handle error
                        }
                    }
                }
            }
            
            return cell
            
        case 4:
            
            let cell: UserCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.signOutDelegate = self
            cell.mapSwitchableDelegate = self
            cell.configure()
            
            return cell
            
        default:
            fatalError("Cell cannot be found.")
        }
    }
    
    @objc
    private func reloadTimeline() {
        
        //---- Dispatch Group ----//
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        print("Loading")
        
        //---- Get location ----//
        if viewModel.currentLocation == nil {
            viewModel.getCurrentLocation { (error) in
                // TODO: Show loading indicator
                dispatchGroup.leave()
                print("Location found")
            }
        } else {
            print("Location already exists")
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            
            //---- Get events ----//
            self.viewModel.getGoogleEvents { (error) in
                if let _ = error {
                    // TODO: Show animating loading cells
                    print("Failed to get events")
                }
                
                //---- Refresh collection view cells ----//
                
                let section: IndexSet = [1, 2, 3, 4]
                self.eventsCollectionView?.reloadSections(section)
                
                //---- Stop refresh control ----//
                
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EventsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.numberOfEvents() == 0 {
            return eventsCollectionView.determineCellSize(for: indexPath, isEventsEmpty: true)
        } else {
            return eventsCollectionView.determineCellSize(for: indexPath, isEventsEmpty: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return eventsCollectionView.setCellSpacing(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return eventsCollectionView.setCellInset(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0:
            break
        case 1:
            break
        case 2:
            presentGoogleAuthUI()
        case 3:
            break
        case 4:
            eventsCollectionView.expandCell(at: indexPath)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        eventsCollectionView.animateCellEntry(for: cell, at: indexPath)
    }
       
}

// MARK: - TSEventsDataSource
extension EventsViewController: TSEventsDataSourceDelegate {
    
    func contentChanged() {
        
    }
    
}

// MARK: - GMSMapViewDelegate
extension EventsViewController: GMSMapViewDelegate { }

extension EventsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        
        return MKPolylineRenderer()
    }
    
}

// MARK: - Google Sign In
extension EventsViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            return
        } else {
            guard let uid = user.userID else { return }
            viewModel.setCurrentUser(id: uid, email: user.profile.email)
            viewModel.eventHelper.googleCalendarService.authenticate(user)
        }
    }
    
    func configureGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeCalendarReadonly]
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    func presentGoogleAuthUI() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
   
}

// MARK: - Center View Controller Delegate
extension EventsViewController: CenterViewControllerDelegate {}

// MARK: - Sign Out Delegate
extension EventsViewController: SignOutDelegate {
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()
        
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Constants.UserDefaults.currentUser)
        
        // TODO: Animate deletion
        viewModel.removeEvents()
        eventsCollectionView.isExpanded = false
        
        let section: IndexSet = [1, 2, 3, 4]
        eventsCollectionView?.reloadSections(section)
    }
    
}

// MARK: - Map Switchable Delegate
extension EventsViewController: MapSwitchable {
    
    func switchMaps() {
        let section: IndexSet = [3]
        eventsCollectionView.reloadSections(section)
    }
    
}

//---- Network Listener ----//
// MARK: - Network Listener
extension EventsViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.Connection) {
        switch status {
        case .none, .cellular, .wifi:
            refreshNetworkStatusSection()
        }
    }
    
}
