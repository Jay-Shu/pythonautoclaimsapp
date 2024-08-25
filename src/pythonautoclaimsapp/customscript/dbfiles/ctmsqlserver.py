import pyodbc
import toga
from toga.style import Pack
from toga.constants import COLUMN

# Specifying the ODBC driver, server name, database, etc. directly
"""
Changelog:
        2024-08-25: Moving to OOP (Object Oriented Programming) model.
        2024-08-25: Updated columns from their original template to the proper
            template of Accounts.
        2024-08-25: Moved all functions underneath class getAccts.
        2024-08-25: Removed SaveFile attribute from ODBC Connection String.




Citations:
    1. DSN and Connection String Keywords and Attributes, https://learn.microsoft.com/en-us/sql/connect/odbc/dsn-connection-string-attribute?view=sql-server-ver16#supported-dsnconnection-string-keywords-and-connection-attributes
    
Author Notes:
    Moving to an Object Oriented Programming model. In the long run this
        will promote simpler and easier code maintenance.
    TrustServerCertifcate is mandatory for newer versions of MS SQL Server.
        Post 2019 Versions to my own knowledge. Additionally, this will
        require Encrypt as Yes. We need the connection to be secure if
        possible.
    Paramterization will be our method of execution as it will be what
        MS SQL Server is expecting.
    Json usage; is intended for serialization and deserialization for
        MS SQL Server. In Conjunction with Parameterization we can
        reduce the likelyhood of SQL Injection.
"""

class getAccts(toga.App):
    def __init__(self):
        # Create the main window
        self.main_window = toga.MainWindow(title=self.name)

        # Define columns for the table
        columns = ['ACCOUNT_NUM', 'ACCOUNT_HONORIFICS', 'ACCOUNT_FIRST_NAME','ACCOUNT_LAST_NAME','ACCOUNT_SUFFIX','ACCOUNT_STREET_ADD_1','ACCOUNT_STREET_ADD_2','ACCOUNT_CITY','ACCOUNT_STATE','ACCOUNT_ZIP','ACCOUNT_PO_BOX','ACCOUNT_DATE_START','ACCOUNT_DATE_RENEWAL','ACCOUNT_TYPE']  # Modify based on your stored procedure output
        self.table = toga.Table(headings=columns, style=Pack(flex=1))

        # Call the method to fetch data from the stored procedure
        data = self.fetch_data()

        # Populate the table with data
        self.table.data.extend(data)

        # Add the table to the main window
        self.main_window.content = self.table

        # Show the main window
        self.main_window.show()

    def retrieveAccounts(self):
        cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES')
        cnxn.setencoding('utf-8')

        params = None
    
        cnxn.execute("{CALL paca.getAccounts_v1}",params)
    
        rows = cnxn.fetchall()
    
        cnxn.close()
    
        data = [tuple(row) for row in rows]
    
        return data

    

"""def getAccounts(accountNum): """

"""
    Name of Script: connect_to_mssql_server.py
    Author: Jacob Shuster
    Role: Consultant - 1099
    Umbrella Company: N/A
    Creation Date: 2024-08-11
    Script Cost: N/A
    Rate: 100.00 (Based on 2019*)

    Changelog:
        2024-08-11: Updated naming convention of script. Hyphens cannot be used.
            It must be underscores.
    
    Functions

    
    Author Notes:
        Our connection to MS SQL Server.
"""
    