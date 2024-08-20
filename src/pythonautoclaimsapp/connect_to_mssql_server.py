'''
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
'''

import pyodbc

# Specifying the ODBC driver, server name, database, etc. directly

def connect():
    cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=PACA;UID=pacauser;PWD=pacauser;Encrypt=True;TrustServerCertificate=True')
    cnxn.setencoding('utf-8')
    return cnxn


def getAccounts(accountNum):
    