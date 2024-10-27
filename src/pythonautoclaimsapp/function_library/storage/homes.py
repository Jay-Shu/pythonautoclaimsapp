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


class HomesClass:
    def __init__(self,cnxn,data,columns):
        self.app = toga.App
        self.cnxn = cnxn
        self.data = data
        self.table = toga.Table
        self.columns = columns
        self.list_source = toga.sources.ListSource

    def getHomes():
        #global data
        
        try:
            cnxn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
            cnxn.setencoding('utf-8')
            cursor = cnxn.cursor() # Cursor is necessary for it to function properly
            cursor.execute("{CALL paca.getHomes_v1}") # This will be moved along with the connection
            #tempcount = cursor.rowcount
            #print(tempcount)
            """
            A list Source was necessary for proper attribute assignment.
            """
            columns = ["HOMES_INTERNAL_ID","HOMES_ACCOUNT_NUM","HOMES_PREMIUM","HOMES_ADDRESS","HOMES_SEC1_DW","HOMES_SEC1_DWEX","HOMES_SEC1_PER_PROP","HOMES_SEC1_LOU","HOMES_SEC1_FD_SC","HOMES_SEC1_SL","HOMES_SEC1_BU_SD","HOMES_SEC2_PL","HOMES_SEC2_DPO","HOMES_SEC2_MPO"]

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
                list_source.append({'HOMES_INTERNAL_ID':row[0],'HOMES_ACCOUNT_NUM':row[1],'HOMES_PREMIUM':row[2],'HOMES_ADDRESS':row[3],'HOMES_SEC1_DW':row[4],'HOMES_SEC1_DWEX':row[5],'HOMES_SEC1_PER_PROP':row[6],'HOMES_SEC1_LOU':row[7],'HOMES_SEC1_FD_SC':row[8],'HOMES_SEC1_SL':row[9],'HOMES_SEC1_BU_SD':row[10],'HOMES_SEC2_PL':row[11],'HOMES_SEC2_DPO':row[12],'HOMES_SEC2_MPO':row[13]})
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
            #PythonListener.disconnect_connection(conn) # We need to disconnect at some point when the application closes.
            
        return columns,list_source
    
    def homes_secondary_box(self,widget):
        #global columns,list_source,table

        columns,list_source = HomesClass.getHomes()
        #print(list_source[0])

        second_window = toga.Window(title="Homes")
        label = toga.Label('Homes Results',style=Pack(padding=10,font_size=14))
        
        
        try:
             table = toga.Table(
                    headings=["HOMES_INTERNAL_ID","HOMES_ACCOUNT_NUM","HOMES_PREMIUM","HOMES_ADDRESS","HOMES_SEC1_DW","HOMES_SEC1_DWEX","HOMES_SEC1_PER_PROP","HOMES_SEC1_LOU","HOMES_SEC1_FD_SC","HOMES_SEC1_SL","HOMES_SEC1_BU_SD","HOMES_SEC2_PL","HOMES_SEC2_DPO","HOMES_SEC2_MPO"],style=Pack(direction=COLUMN,alignment=CENTER,font_size=14),
                    #headings=columns,
                    #selection=data
                    data=list_source,
                    accessors=["HOMES_INTERNAL_ID","HOMES_ACCOUNT_NUM","HOMES_PREMIUM","HOMES_ADDRESS","HOMES_SEC1_DW","HOMES_SEC1_DWEX","HOMES_SEC1_PER_PROP","HOMES_SEC1_LOU","HOMES_SEC1_FD_SC","HOMES_SEC1_SL","HOMES_SEC1_BU_SD","HOMES_SEC2_PL","HOMES_SEC2_DPO","HOMES_SEC2_MPO"]
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
    return HomesClass()