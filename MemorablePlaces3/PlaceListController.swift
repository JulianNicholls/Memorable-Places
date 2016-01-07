//
//  PlaceListController.swift
//  MemorablePlaces3
//
//  Created by Julian Nicholls on 07/01/2016.
//  Copyright © 2016 Really Big Shoe. All rights reserved.
//

import UIKit

var places = [NSDictionary]()

var activePlace = -1

class PlaceListController: UITableViewController {

    let PSKEY = "MemorablePlaces"

    @IBOutlet var placeList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let loaded = NSUserDefaults.standardUserDefaults().objectForKey(PSKEY)

        if loaded != nil {
            places = loaded as! [NSDictionary]
        }
        else {
            places = [["address": "The Taj Mahal", "location": [27.175277, 78.042128]]]
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("place", forIndexPath: indexPath)

        let address = places[indexPath.row]["address"] as! String
        cell.textLabel?.text = address

        return cell
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activePlace = indexPath.row

        return indexPath
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addPlace" {
            activePlace = -1
        }
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            places.removeAtIndex(indexPath.row)
            updatePlaces()
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    override func viewDidAppear(animated: Bool) {
        updatePlaces()
    }

    func updatePlaces() {
        placeList.reloadData()
        NSUserDefaults.standardUserDefaults().setObject(places, forKey: PSKEY)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
