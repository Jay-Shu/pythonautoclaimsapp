import pyodbc
import toga
import tracemalloc
from toga.style import Pack
#from toga.constants import COLUMN
from toga.style.pack import COLUMN, CENTER

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
    def __init__(self, app, widget):
        # Create the main window
        super().__init__(title=self.formal_name)
        self.app = app
        self.update()
        
    def update(self):
        box = toga.Box(style=Pack(direction=COLUMN, alignment=CENTER,font_size=14))
        # Define columns for the table
        columns = ['ACCOUNT_NUM', 'ACCOUNT_HONORIFICS', 'ACCOUNT_FIRST_NAME', 'ACCOUNT_LAST_NAME', 'ACCOUNT_SUFFIX', 'ACCOUNT_STREET_ADD_1',
                   'ACCOUNT_STREET_ADD_2', 'ACCOUNT_CITY', 'ACCOUNT_STATE', 'ACCOUNT_ZIP', 'ACCOUNT_PO_BOX', 'ACCOUNT_DATE_START', 'ACCOUNT_DATE_RENEWAL', 'ACCOUNT_TYPE']
        
        # Call the method to fetch data from the stored procedure
        data = self.retrieve_accounts()
        label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))
        box.add(label)
        
        if data:
        # Populate the table with data
            table = toga.Table(headings=columns, style=Pack(flex=1,font_size=10))
            box.add(table)
        
        else:
            error_label = toga.Label('No data found or an error occurred.',style=Pack(padding=10,font_size=14))
            box.add(error_label)

        self.content = box
        self.show()
        
        
    def retrieve_accounts(widget):
        try:
            cnxn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=False)
            cnxn.setencoding('utf-8')
            params = None
            cursor = cnxn.cursor()
            cursor.execute("{CALL paca.getAccounts_v1}", params)
            #rows = cursor.fetchall()
            data = [(row.ACCOUNT_NUM, row.ACCOUNT_HONORIFICS, row.ACCOUNT_FIRST_NAME,row.ACCOUNT_LAST_NAME, row.ACCOUNT_SUFFIX,row.ACCOUNT_STREET_ADD_1,row.ACCOUNT_STREET_ADD_2,row.ACCOUNT_CITY,row.ACCOUNT_STATE,row.ACCOUNT_ZIP,row.ACCOUNT_PO_BOX,row.ACCOUNT_DATE_START,row.ACCOUNT_DATE_RENEWAL,row.ACCOUNT_TYPE) for row in cursor.fetchall()]
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
