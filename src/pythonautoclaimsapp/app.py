"""
Python Auto Claims app - Simple. Intended for interactions with an MS SQL DB.

In it's current state the Python side has not yet been started. Therefaore, in it's base form.

Name of Script: app.py
Author: Jacob Shuster
Role: Consultant - 1099
Umbrella Company: N/A
Creation Date: 2024-08-11
Script Cost: N/A
Rate: 100.00 (Based on 2019*)

Changelog:
    2024-08-11: Updated naming convention of script. Hyphens cannot be used.
        It must be underscores.
    2024-08-21: Updated references for the connecttomssqlserver. Still pending resolution of
        resolving.
    2024-08-27: Troubleshooting with tracemalloc.

Functions

https://stackoverflow.com/questions/66084762/call-function-from-another-file-without-import-clause
https://toga.readthedocs.io/en/stable/reference/api/window.html

Author Notes:
    Our connection to MS SQL Server.
"""

import tracemalloc
import toga
import time
import logging
logger = logging.getLogger(__name__)

import toga.sources
from toga.style import Pack
from toga.style.pack import COLUMN, ROW, CENTER
from toga.sources import ListSource

from pythonautoclaimsapp.function_library.accounts import *
from pythonautoclaimsapp.function_library.vehicles import *
from pythonautoclaimsapp.function_library.homes import *
from pythonautoclaimsapp.function_library.policies import *
from pythonautoclaimsapp.function_library.vehiclecoverages import *
from pythonautoclaimsapp.function_library.vehicleclaims import *

tracemalloc.start()


class PythonAutoClaimsApp(toga.App):
    def startup(self):
        logging.basicConfig(
            filename='E:\\scripts\\python\\togatesting\\togatesting.log',
            level=logging.DEBUG,
            format='%(filename)s %(lineno)d %(asctime)s %(message)s %(module)s %(msecs)d'
            )
        self.app = toga.App
        #logging.INFO(self.app)
        """Construct and show the Toga application.
       
        https://docs.python.org/3.12/library/logging.html#logrecord-attributes

        Usually, you would add your application to a main content box.
        We then create a main window (with a name matching the app), and
        show the main window.
        """
        #PythonSources._create_listeners(self)
        main_box = toga.Box(style=Pack(direction=COLUMN))
        
        #accountsLabel = toga.Label('Main Section')
        #main_box.add(accountsLabel)

        accountsButton = toga.Button('Accounts',style=Pack(padding=5),on_press=self._accounts_callback)
        vehiclesButton = toga.Button('Vehicles',style=Pack(padding=5),on_press=self._vehicles_callback)
        homesButton = toga.Button('Homes',style=Pack(padding=5),on_press=self._homes_callback)
        policiesButton = toga.Button('Policies',style=Pack(padding=5),on_press=self._policies_callback)
        vehicleCoveragesButton = toga.Button('Vehicle Coverages',style=Pack(padding=5),on_press=self._vehicle_coverages_callback)
        vehicleClaimsButton = toga.Button('Vehicle Claims',style=Pack(padding=5),on_press=self._vehicle_claims_callback)

        main_box.add(accountsButton)
        main_box.add(vehiclesButton)
        main_box.add(homesButton)
        main_box.add(policiesButton)
        main_box.add(vehicleCoveragesButton)
        main_box.add(vehicleClaimsButton)

        self.main_window = toga.MainWindow(title=self.formal_name)
        self.main_window.content = main_box
        self.main_window.show()

    def _accounts_callback(self,widget):
        # Stage for Menu
        # Needs the correct pieces
        AccountsClass.accounts_secondary_box(self,widget)
        

    def _homes_callback(self,widget):
        # Stage for Menu
        # Needs the correct pieces
        HomesClass.homes_secondary_box(self,widget)


    def _vehicles_callback(self,widget):
        # Stage for Menu
        # Needs the correct pieces
        VehiclesClass.vehicles_secondary_box(self,widget)


    def _policies_callback(self,widget):
        # Stage for Menu
        # Needs the correct pieces
        PoliciesClass.policies_secondary_box(self,widget)


    def _vehicle_coverages_callback(self,widget):
        # Stage for Menu
        # Needs the correct pieces
        VehicleCoveragesClass.vehicle_coverages_secondary_box(self,widget)


    def _vehicle_claims_callback(self,widget):
        # Stage for Menu
        # Needs the correct pieces
        VehicleClaimsClass.vehicle_claims_secondary_box(self,widget)


def main():
    return PythonAutoClaimsApp()

snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

print("[ Top 10 ]")
for stat in top_stats[:10]:
    print(stat)