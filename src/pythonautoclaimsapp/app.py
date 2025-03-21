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
                              QPushButton, QWidget, QLabel)
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
        self.setup_ui()
        
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
        accounts_button.setFixedSize(800,100)
        vehicles_button = QPushButton("Vehicles",parent=None)
        vehicles_button.setFixedSize(800,100)
        homes_button = QPushButton("Homes",parent=None)
        homes_button.setFixedSize(800,100)
        policies_button = QPushButton("Policies",parent=None)
        policies_button.setFixedSize(800,100)
        vehicle_coverages_button = QPushButton("Vehicle Coverages",parent=None)
        vehicle_coverages_button.setFixedSize(800,100)
        vehicle_claims_button = QPushButton("Vehicle Claims",parent=None)
        vehicle_claims_button.setFixedSize(800,100)
        
        # Connect buttons to the accounts menu handler temporarily
        # This will need to be replaced with the actual handlers for each button
        
        accounts_button.clicked.connect(AccountsMenuClass())
        #accounts_button.clicked.connect(AccountsMenuClass.accountsMenu())
        vehicles_button.clicked.connect(AccountsMenuClass())
        homes_button.clicked.connect(AccountsMenuClass())
        policies_button.clicked.connect(AccountsMenuClass())
        vehicle_coverages_button.clicked.connect(AccountsMenuClass())
        vehicle_claims_button.clicked.connect(AccountsMenuClass())
        
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
        self.second_window = AccountsMenuClass()
        self.second_window.show()


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