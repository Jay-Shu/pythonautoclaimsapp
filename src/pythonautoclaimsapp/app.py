"""
Python Auto Claims app - Simple. Intended for interactions with an MS SQL DB.
PySide6 version of the original Toga implementation.

Name of Script: app.py
Author: Original by Jacob Shuster
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
    2025-03-02: Converted from Toga to PySide6

Functions

Author Notes:
    Replacement for Toga was necessary due to multiple instances being produced. Claude AI Utilized
for baseline rewrite.

"""

import sys
import json
import tracemalloc
import time
import logging
from PySide6.QtWidgets import (QApplication, QMainWindow, QVBoxLayout, 
                              QPushButton, QWidget, QLabel, QToolBar)
from PySide6.QtGui import QIcon, QAction
from PySide6.QtCore import Qt

"""
Import our libraries
"""

from pythonautoclaimsapp.function_library.accounts import AccountsMenuClass

# These imports would be uncommented when the modules are created:
# from pythonautoclaimsapp.function_library.storage.accounts import AccountsClass
# from pythonautoclaimsapp.function_library.storage.accountsmenu import AccountsMenuClass
# Configure logging
logger = logging.getLogger(__name__)
logging.basicConfig(
    filename='E:\\scripts\\python\\togatesting\\pyside6testing.log',
    level=logging.DEBUG,
    format='%(filename)s %(lineno)d %(asctime)s %(message)s %(module)s %(msecs)d'
)
logging.info('Started')
# Start memory tracking
tracemalloc.start()

class PythonAutoClaimsApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Python Auto Claims App")
        self.setup_toolbar()
        self.setup_ui()
        
    def setup_toolbar(self):
        """Create and configure the toolbar and menu bar with File menu and Exit option"""
    # Create toolbar
        useOpen = 0
        toolbar = QToolBar("Main Toolbar")
        self.addToolBar(toolbar)
    
    # Create menu bar
        menu = self.menuBar()
    
    # Create File menu
        file_menu = menu.addMenu("&File")
    
    # Create Exit action
        exit_action = QAction("Exit", self)
        exit_action.setStatusTip("Exit the application")
        exit_action.triggered.connect(self.close)
    
    # Add Exit action to the File menu
        file_menu.addAction(exit_action)
    
    # Add a toolbar button if needed
    # Removing this for now. This is marked as Non-Goal or Could Have.
        if useOpen == 1:
            toolbar_action = QAction("Open", self)
            toolbar_action.setStatusTip("Open a file")
    # Connect to a method you'll implement
    # toolbar_action.triggered.connect(self.open_file)
    
    # Add the action to the toolbar
            toolbar.addAction(toolbar_action)
        
    def setup_ui(self):
        """
        Set up the main UI for the application.
        
        This creates a vertical layout with buttons for different sections of the app.
        """
        # Create central widget and layout
        central_widget = QWidget()
        
        self.setCentralWidget(central_widget)
        
        main_layout = QVBoxLayout(central_widget)
        
        # Create buttons with the same functionality as in the Toga version
        accounts_button = QPushButton("Accounts",parent=None)
        accounts_button.setFixedSize(800,50)
        vehicles_button = QPushButton("Vehicles",parent=None)
        vehicles_button.setFixedSize(800,50)
        homes_button = QPushButton("Homes",parent=None)
        homes_button.setFixedSize(800,50)
        policies_button = QPushButton("Policies",parent=None)
        policies_button.setFixedSize(800,50)
        vehicle_coverages_button = QPushButton("Vehicle Coverages",parent=None)
        vehicle_coverages_button.setFixedSize(800,50)
        vehicle_claims_button = QPushButton("Vehicle Claims",parent=None)
        vehicle_claims_button.setFixedSize(800,50)
        
        # Connect buttons to the accounts menu handler temporarily
        # This will need to be replaced with the actual handlers for each button
        
        accounts_button.clicked.connect(self.open_accounts_menu)
        vehicles_button.clicked.connect(self.open_vehicles_menu)
        homes_button.clicked.connect(self.open_homes_menu)
        policies_button.clicked.connect(self.open_policies_menu)
        vehicle_coverages_button.clicked.connect(self.open_vehicle_coverages_menu)
        vehicle_claims_button.clicked.connect(self.open_vehicle_claims_menu)
        
        # Add buttons to the layout
        main_layout.addWidget(accounts_button)
        main_layout.addWidget(vehicles_button)
        main_layout.addWidget(homes_button)
        main_layout.addWidget(policies_button)
        main_layout.addWidget(vehicle_coverages_button)
        main_layout.addWidget(vehicle_claims_button)
        
        # Set some reasonable defaults for the window size
        # Y, X on the resize instead of X, Y
        self.resize(800, 600)
        
    def show_window(self):
        """Show the main window."""
        self.show()
    
    def open_accounts_menu(self):
        self.accounts_window = AccountsMenuClass()
        self.accounts_window.show()
    
    def open_vehicles_menu(self):
        self.vehicles_window = AccountsMenuClass()  # Temporary
        self.vehicles_window.show()
    
    def open_homes_menu(self):
        self.homes_window = AccountsMenuClass()  # Temporary
        self.homes_window.show()
    
    def open_policies_menu(self):
        self.policies_window = AccountsMenuClass()  # Temporary
        self.policies_window.show()
    
    def open_vehicle_coverages_menu(self):
        self.vehicle_coverages_window = AccountsMenuClass()  # Temporary
        self.vehicle_coverages_window.show()
    
    def open_vehicle_claims_menu(self):
        self.vehicle_claims_window = AccountsMenuClass()  # Temporary
        self.vehicle_claims_window.show()


def main():
    """
    Main entry point for the application.
    Creates and shows the application window.
    """
    app = QApplication(sys.argv)
    window = PythonAutoClaimsApp()
    window.show_window()
    
    # Take a memory snapshot before entering the main loop
    snapshot = tracemalloc.take_snapshot()
    top_stats = snapshot.statistics('lineno')

    print("[ Top 10 ]")
    for stat in top_stats[:10]:
        print(stat)
    
    # Start the application main loop
    sys.exit(app.exec())
    logging.info('Finished')


# if __name__ == "__main__":
#     main()