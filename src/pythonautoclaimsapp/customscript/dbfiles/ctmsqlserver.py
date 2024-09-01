import pyodbc
import toga
import tracemalloc
from toga.style import Pack
from toga.constants import COLUMN

tracemalloc.start()

"""
Changelog:
        2024-08-25: Moving to OOP (Object Oriented Programming) model.
        2024-08-25: Updated columns from their original template to the proper
            template of Accounts.
        2024-08-25: Moved all functions underneath class getAccts.
        2024-08-25: Removed SaveFile attribute from ODBC Connection String.
        2024-08-26: Updated __init__ to startup. This change allowed for the
            application to load.
        2024-08-26: 


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


class GetAccts(toga.App):
    def startup(self):
        # Create the main window
        self.second_window = toga.Window(title=self.formal_name)
        # Define columns for the table
        columns = ['ACCOUNT_NUM', 'ACCOUNT_HONORIFICS', 'ACCOUNT_FIRST_NAME', 'ACCOUNT_LAST_NAME', 'ACCOUNT_SUFFIX', 'ACCOUNT_STREET_ADD_1',
                   'ACCOUNT_STREET_ADD_2', 'ACCOUNT_CITY', 'ACCOUNT_STATE', 'ACCOUNT_ZIP', 'ACCOUNT_PO_BOX', 'ACCOUNT_DATE_START', 'ACCOUNT_DATE_RENEWAL', 'ACCOUNT_TYPE']
        self.table = toga.Table(headings=columns, style=Pack(flex=1))
        # Call the method to fetch data from the stored procedure
        data = self.fetch_data()
        # Populate the table with data
        self.table.data.extend(data)
        # Add the table to the main window
        self.second_window.content = self.table
        # Show the main window
        self.second_window.show()

    def retrieve_accounts():
        try:
            cnxn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=False)
            cnxn.setencoding('utf-8')
            params = None
            cursor = cnxn.cursor()
            cursor.execute("{CALL paca.getAccounts_v1}", params)
            rows = cursor.fetchall()
            data = [tuple(row) for row in rows]
            return data

        except Exception as ERROR:
            print(ERROR)
        finally:
            cursor.close()
            cnxn.close()


snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

print("[ Top 10 ]")
for stat in top_stats[:10]:
    print(stat)
