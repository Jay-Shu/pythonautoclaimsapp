import sys
from pythonautoclaimsapp.function_library.storage.accountsactions import GetAccounts_v1

from PySide6.QtWidgets import (QApplication, QMainWindow, QVBoxLayout, QHBoxLayout, 
                              QPushButton, QWidget, QLabel, QToolBar, QMessageBox,
                              QTableView, QHeaderView)
from PySide6.QtGui import QIcon, QAction
from PySide6.QtCore import Qt, QAbstractTableModel

class SqlTableModel(QAbstractTableModel):
    """Model to display SQL query results in a table view"""
    
    def __init__(self, data=None, headers=None):
        super().__init__()
        self.data = data or []
        self.headers = headers or []
        
    def rowCount(self, parent=None):
        return len(self.data)
        
    def columnCount(self, parent=None):
        return len(self.headers) if self.headers else 0
        
    def data(self, index, role=Qt.DisplayRole):
        if role == Qt.DisplayRole:
            return str(self.data[index.row()][index.column()])
        return None
        
    def headerData(self, section, orientation, role=Qt.DisplayRole):
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            return self.headers[section]
        return None
        
    def update_data(self, data, headers):
        self.beginResetModel()
        self.data = data
        self.headers = headers
        self.endResetModel()




class AccountsMenuClass(QWidget):
    def __init__(self,parent=None):
        super().__init__()
        # Create the central widget
        central_widget = QWidget()
        # Set the window title
        self.setWindowTitle("Accounts Menu")
        
        # Setup the Layout
        layout = QHBoxLayout()
        get_accounts_button = QPushButton("Get Accounts",parent=None)
        get_accounts_button.setFixedSize(600,50)
        create_account_button = QPushButton("Create Account",parent=None)
        create_account_button.setFixedSize(600,50)
        update_account_button = QPushButton("Update Account",parent=None)
        update_account_button.setFixedSize(600,50)
        remove_account_button = QPushButton("Remove Account",parent=None)
        remove_account_button.setFixedSize(600,50)
        
        
        # Connect buttons to the accounts menu handler temporarily
        # This will need to be replaced with the actual handlers for each button
        
        get_accounts_button.clicked.connect(self.get_accounts_handler)
        #vehicles_button.clicked.connect(self.create_account_button)
        #homes_button.clicked.connect(self.update_account_button)
        #policies_button.clicked.connect(self.open_policies_menu)
        
        # Add buttons to the layout
        layout.addWidget(get_accounts_button)
        layout.addWidget(create_account_button)
        layout.addWidget(update_account_button)
        layout.addWidget(remove_account_button)
        
        # Create the Label
        #self.label = QLabel("Accounts Menu")
        
        # Add the label
        #layout.addWidget(self.label)
        
        # Set the Layout
        self.setLayout(layout)
        
        # Set our Window Size (X, Y) respectively
        self.resize(600,800)
        
    def get_accounts_handler(self):
        self.accounts_window = GetAccounts_v1()
        self.accounts_window.show()