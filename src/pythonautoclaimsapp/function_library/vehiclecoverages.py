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


class VehicleCoveragesClass:
    def __init__(self,cnxn,data,columns):
        self.app = toga.App
        self.cnxn = cnxn
        self.data = data
        self.table = toga.Table
        self.columns = columns
        self.list_source = toga.sources.ListSource

    def getVehicleCoverages():
        #global data
        
        try:
            cnxn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
            cnxn.setencoding('utf-8')
            cursor = cnxn.cursor() # Cursor is necessary for it to function properly
            cursor.execute("{CALL paca.getVehicleCoverages_v1}") # This will be moved along with the connection
            #tempcount = cursor.rowcount
            #print(tempcount)
            """
            A list Source was necessary for proper attribute assignment.
            """
            columns = ["VEHICLES_COVERAGE_ACCOUNT_NUM","VEHICLES_COVERAGE_VEHICLE","VEHICLES_COVERAGE_LIABILITY","VEHICLES_COVERAGE_COLLISION","VEHICLES_COVERAGE_COMPREHENSIVE","VEHICLES_COVERAGE_PIP","VEHICLES_COVERAGE_MEDPAY","VEHICLES_COVERAGE_UNMOTO","VEHICLES_COVERAGE_RENTAL_REIMB","VEHICLES_COVERAGE_ROADSIDE_TOW"]

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
                list_source.append({'VEHICLES_COVERAGE_ACCOUNT_NUM':row[0],'VEHICLES_COVERAGE_VEHICLE':row[1],'VEHICLES_COVERAGE_LIABILITY':row[2],'VEHICLES_COVERAGE_COLLISION':row[3],'VEHICLES_COVERAGE_COMPREHENSIVE':row[4],'VEHICLES_COVERAGE_PIP':row[5],'VEHICLES_COVERAGE_MEDPAY':row[6],'VEHICLES_COVERAGE_UNMOTO':row[7],'VEHICLES_COVERAGE_RENTAL_REIMB':row[8],'VEHICLES_COVERAGE_ROADSIDE_TOW':row[9]})
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
    
    def vehicle_coverages_secondary_box(self,widget):
        #global columns,list_source,table

        columns,list_source = VehicleCoveragesClass.getVehicleCoverages()
        #print(list_source[0])

        second_window = toga.Window(title="Vehicle Coverages")
        label = toga.Label('Vehicle Coverages Results',style=Pack(padding=10,font_size=14))
        
        
        try:
             table = toga.Table(
                    headings=["VEHICLES_COVERAGE_ACCOUNT_NUM","VEHICLES_COVERAGE_VEHICLE","VEHICLES_COVERAGE_LIABILITY","VEHICLES_COVERAGE_COLLISION","VEHICLES_COVERAGE_COMPREHENSIVE","VEHICLES_COVERAGE_PIP","VEHICLES_COVERAGE_MEDPAY","VEHICLES_COVERAGE_UNMOTO","VEHICLES_COVERAGE_RENTAL_REIMB","VEHICLES_COVERAGE_ROADSIDE_TOW"],style=Pack(direction=COLUMN,alignment=CENTER,font_size=14),
                    #headings=columns,
                    #selection=data
                    data=list_source,
                    accessors=["VEHICLES_COVERAGE_ACCOUNT_NUM","VEHICLES_COVERAGE_VEHICLE","VEHICLES_COVERAGE_LIABILITY","VEHICLES_COVERAGE_COLLISION","VEHICLES_COVERAGE_COMPREHENSIVE","VEHICLES_COVERAGE_PIP","VEHICLES_COVERAGE_MEDPAY","VEHICLES_COVERAGE_UNMOTO","VEHICLES_COVERAGE_RENTAL_REIMB","VEHICLES_COVERAGE_ROADSIDE_TOW"]
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
    return VehicleCoveragesClass()