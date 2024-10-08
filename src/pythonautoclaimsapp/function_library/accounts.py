import pyodbc
import time
import toga
import inspect
import logging
logger = logging.getLogger(__name__)

from toga.style import Pack
from toga.style.pack import COLUMN, ROW, CENTER
from toga.sources import ListSource
from pprint import *

# This is the location when referenced by other py files.
# from togatesting.function_library.accounts import *

# THIS FILE NEEDS TO MERGE WITH accountsactions/py


class AccountsClass:
    def __init__(self,cnxn,data,columns):
        self.app = toga.App
        self.cnxn = cnxn
        self.data = data
        self.table = toga.Table
        self.columns = columns
        self.list_source = toga.sources.ListSource

    def getAccounts():
        #global data
        
        try:
            cnxn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
            cnxn.setencoding('utf-8')
            cursor = cnxn.cursor() # Cursor is necessary for it to function properly
            cursor.execute("{CALL paca.getAccounts_v1}") # This will be moved along with the connection
            #tempcount = cursor.rowcount
            #print(tempcount)
            """
            A list Source was necessary for proper attribute assignment.
            """
            columns = ['ACCOUNT_NUM','ACCOUNT_HONORIFICS','ACCOUNT_FIRST_NAME','ACCOUNT_LAST_NAME','ACCOUNT_SUFFIX','ACCOUNT_STREET_ADD_1','ACCOUNT_STREET_ADD_2','ACCOUNT_CITY','ACCOUNT_STATE','ACCOUNT_ZIP','ACCOUNT_PO_BOX','ACCOUNT_DATE_START','ACCOUNT_DATE_RENEWAL','ACCOUNT_TYPE']

            list_source = ListSource(
            accessors=columns
            )
            
            i = 0
            st = time.time()

            sum_x = 0
            for i in range(1000000):
                sum_x += i

            rows = cursor.fetchall()
            for row in rows:
                list_source.append({'ACCOUNT_NUM':row[0],'ACCOUNT_HONORIFICS':row[1],'ACCOUNT_FIRST_NAME':row[2],'ACCOUNT_LAST_NAME':row[3],'ACCOUNT_SUFFIX':row[4],'ACCOUNT_STREET_ADD_1':row[5],'ACCOUNT_STREET_ADD_2':row[6],'ACCOUNT_CITY':row[7],'ACCOUNT_STATE':row[8],'ACCOUNT_ZIP':row[9],'ACCOUNT_PO_BOX':row[10],'ACCOUNT_DATE_START':row[11],'ACCOUNT_DATE_RENEWAL':row[12],'ACCOUNT_TYPE':row[13]})
                #print(list_source[i])
                #time.sleep(1)
                """             
                print("Account Number" + row[0])
                print("Account Honorifics" + row[1])
                print("Account First Name" + row[2])
                print("Account Last Name" + row[3])
                print("Account Number" + row[4])
                print("Account Number" + row[5])
                print("Account Number" + row[6])
                print("Account Number" + row[7])
                print("Account Number" + row[8])
                print("Account Number" + row[9])
                print("Account Number" + row[10])
                print("Account Number" + row[11])
                print("Account Number" + row[12])
                print("Account Number" + row[13]) 
                """
                i += 1
            et = time.time()
            elapsed_time = et - st
            print('Execution time:', elapsed_time, 'seconds')
            
        except Exception as ERROR:
            print(ERROR)
        finally:
            cursor.close()
            cnxn.close()
            
        return columns,list_source
    
    def accounts_secondary_box(self,widget):
        #global columns,list_source,table

        columns,list_source = AccountsClass.getAccounts()
        #print(list_source[0])

        second_window = toga.Window(title="Accounts")
        label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))
        
        
        try:
             table = toga.Table(
                    headings=['ACCOUNT_NUM','ACCOUNT_HONORIFICS','ACCOUNT_FIRST_NAME','ACCOUNT_LAST_NAME','ACCOUNT_SUFFIX','ACCOUNT_STREET_ADD_1','ACCOUNT_STREET_ADD_2','ACCOUNT_CITY','ACCOUNT_STATE','ACCOUNT_ZIP','ACCOUNT_PO_BOX','ACCOUNT_DATE_START','ACCOUNT_DATE_RENEWAL','ACCOUNT_TYPE'],style=Pack(direction=COLUMN,alignment=CENTER,font_size=14),
                    #headings=columns,
                    #selection=data
                    data=list_source,
                    accessors=['ACCOUNT_NUM','ACCOUNT_HONORIFICS','ACCOUNT_FIRST_NAME','ACCOUNT_LAST_NAME','ACCOUNT_SUFFIX','ACCOUNT_STREET_ADD_1','ACCOUNT_STREET_ADD_2','ACCOUNT_CITY','ACCOUNT_STATE','ACCOUNT_ZIP','ACCOUNT_PO_BOX','ACCOUNT_DATE_START','ACCOUNT_DATE_RENEWAL','ACCOUNT_TYPE']
                )
        except Exception as ERROR:
            print(ERROR)
        
        finally:
           pass
   
        second_box = toga.Box(children=[label,table], style=Pack(direction=COLUMN,alignment=CENTER,font_size=14))
        second_window.content = second_box
        #second_window.show()

        return second_window.show()

def main():
    return AccountsClass()