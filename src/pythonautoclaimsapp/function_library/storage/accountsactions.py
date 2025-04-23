import sys
import pyodbc

from PySide6.QtWidgets import (QApplication, QMainWindow, QVBoxLayout, QHBoxLayout, 
                              QPushButton, QWidget, QLabel, QToolBar, QMessageBox,
                              QTableView, QHeaderView)
from PySide6.QtGui import QIcon, QAction
from PySide6.QtCore import Qt, QAbstractTableModel

class SqlTableModel(QAbstractTableModel):
    """Model to display SQL query results in a table view with improved error handling"""
    
    def __init__(self, data=None, headers=None):
        super().__init__()
        self.data = data or []
        self.headers = headers or []
        
    def rowCount(self, parent=None):
        return len(self.data)
        
    def columnCount(self, parent=None):
        return len(self.headers) if self.headers else 0
        
    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid():
            return None
            
        if role == Qt.DisplayRole:
            value = self.data[index.row()][index.column()]
            
            # Handle None/NULL values
            if value is None:
                return ""
                
            # Try to convert to string safely
            try:
                return str(value)
            except:
                return "Error"
                
        return None
        
    def headerData(self, section, orientation, role=Qt.DisplayRole):
        if orientation == Qt.Horizontal and role == Qt.DisplayRole:
            if 0 <= section < len(self.headers):
                return self.headers[section]
        return None
        
    def update_data(self, data, headers):
        self.beginResetModel()
        self.data = data or []
        self.headers = headers or []
        self.endResetModel()
        
        
class GetAccounts_v1(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Get Accounts V1 Stored Procedure")
        self.resize(800, 600)
        self.setup_ui()
        
    def setup_ui(self):
        # Central widget and layout
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)
        
        # Connection status label
        self.status_label = QLabel("Not connected to database")
        layout.addWidget(self.status_label)
        
        # Execute button
        execute_button = QPushButton("Execute Stored Procedure")
        execute_button.clicked.connect(self.execute_stored_procedure)
        layout.addWidget(execute_button)
        
        # Table view for results
        self.table_view = QTableView()
        self.table_view.horizontalHeader().setSectionResizeMode(QHeaderView.Stretch)
        self.table_model = SqlTableModel()
        self.table_view.setModel(self.table_model)
        layout.addWidget(self.table_view)
        
        
    def execute_stored_procedure(self):
        """Execute a stored procedure and display results with enhanced error handling"""
        try:
        # Setup connection
            conn_str = (
            "DRIVER={ODBC Driver 17 for SQL Server};"
            "SERVER=127.0.0.1;"
            "DATABASE=PACA;"
            "UID=pacauser;"
            "PWD=pacauser;"
        )
        
        # Update status before connecting
            self.status_label.setText("Connecting to database...")
        
        # Connect with timeout
            conn = pyodbc.connect(conn_str, timeout=10)
            cursor = conn.cursor()
        
        # Update status
            self.status_label.setText("Connected to database")
        
        # Execute stored procedure
            proc_name = "paca.getAccounts_v1"
        
            self.status_label.setText(f"Executing {proc_name}...")
        
        # Execute the procedure
            cursor.execute("{CALL " + proc_name + "}")
        
        # Fetch all results
            rows = cursor.fetchall()
            self.debug_sql_data(rows, cursor.description)
        
        # Check if we got any rows
            if not rows:
                self.status_label.setText(f"Executed {proc_name} - No data returned")
            # Update with empty data
                self.table_model.update_data([], [])
                return
            
        # Get column names from cursor description
            headers = [column[0] for column in cursor.description]
        
        # Convert row objects to list of tuples for easier handling
        # This creates a copy of the data that's safer to work with
            data_list = []
            for row in rows:
                row_data = []
                for item in row:
                    row_data.append(item)
                    data_list.append(row_data)
        
        # Update the table model with new data
            self.table_model.update_data(data_list, headers)
        
        # Close connection
            cursor.close()
            conn.close()
        
            self.status_label.setText(f"Executed {proc_name} successfully - {len(rows)} rows returned")
        
        except pyodbc.Error as e:
            error_message = f"Database Error: {str(e)}"
            QMessageBox.critical(self, "Database Error", error_message)
            self.status_label.setText(error_message)
        
        except Exception as e:
            error_message = f"Unexpected Error: {str(e)}"
            QMessageBox.critical(self, "Error", error_message)
            self.status_label.setText(error_message)
        
    def debug_sql_data(self, rows, description):
        """Print detailed debug information about SQL results to help diagnose issues"""
        print("\n==== SQL DEBUG INFO ====")
        print(f"Number of rows: {len(rows) if rows else 0}")
        print(f"Number of columns: {len(description) if description else 0}")
    
        if not rows:
            print("No data returned from query")
            return
        
    # Print column info
        print("\nColumn Information:")
        for i, col_info in enumerate(description):
            col_name = col_info[0]
            col_type = col_info[1]
            print(f"  Column {i}: {col_name} (Type: {col_type})")
    
    # Print first row data with type information
        if rows:
            print("\nFirst Row Data:")
            first_row = rows[0]
            for i, val in enumerate(first_row):
                print(f"  Column {i}: {val} (Python Type: {type(val).__name__})")
            
        print("==== END DEBUG INFO ====\n")