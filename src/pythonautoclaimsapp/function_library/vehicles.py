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


class VehiclesClass:
    def __init__(self,cnxn,data,columns):
        self.app = toga.App
        self.cnxn = cnxn
        self.data = data
        self.table = toga.Table
        self.columns = columns
        self.list_source = toga.sources.ListSource

    def getVehicles():
        global list_source
        
        try:
            cnxn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
            cnxn.setencoding('utf-8')
            cursor = cnxn.cursor() # Cursor is necessary for it to function properly
            cursor.execute("{CALL paca.getVehicles_v1}") # This will be moved along with the connection
            #tempcount = cursor.rowcount
            #print(tempcount)
            """
            A list Source was necessary for proper attribute assignment.
            """
            columns = ["VEHICLE_ACCOUNT_NUM","VEHICLE_VIN","VEHICLE_YEAR","VEHICLE_MAKE","VEHICLE_MODEL","VEHICLE_PREMIUM","VEHICLE_ANNUAL_MILEAGE","VEHICLE_VEHICLE_USE",       "VEHICLE_ADDRESS1_GARAGED","VEHICLE_ADDRESS2_GARAGED"]

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
                list_source.append({'VEHICLE_ACCOUNT_NUM':row[0],'VEHICLE_VIN':row[1],'VEHICLE_YEAR':row[2],'VEHICLE_MAKE':row[3],'VEHICLE_MODEL':row[4],'VEHICLE_PREMIUM':row[5],'VEHICLE_ANNUAL_MILEAGE':row[6],'VEHICLE_VEHICLE_USE':row[7],'VEHICLE_ADDRESS1_GARAGED':row[8],'VEHICLE_ADDRESS2_GARAGED':row[9]})
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
            
            return list_source
    
    def vehicles_secondary_box(self,widget):
        #global columns,list_source,table

        list_source = VehiclesClass.getVehicles()
        #print(list_source[0])

        second_window = toga.Window(title="Vehicles")
        label = toga.Label('Vehicles Results',style=Pack(padding=10,font_size=14))
        
        
        try:
             table = toga.Table(
                    headings=[
                        "VEHICLE_ACCOUNT_NUM",
	                    "VEHICLE_VIN",
	                    "VEHICLE_YEAR",
	                    "VEHICLE_MAKE",
	                    "VEHICLE_MODEL",
	                    "VEHICLE_PREMIUM",
	                    "VEHICLE_ANNUAL_MILEAGE",
	                    "VEHICLE_VEHICLE_USE",
	                    "VEHICLE_ADDRESS1_GARAGED",
	                    "VEHICLE_ADDRESS2_GARAGED"
                        ],style=Pack(direction=COLUMN,alignment=CENTER,font_size=14),
                    #headings=columns,
                    #selection=data
                    data=list_source,
                    accessors=["VEHICLE_ACCOUNT_NUM",
	                    "VEHICLE_VIN",
	                    "VEHICLE_YEAR",
	                    "VEHICLE_MAKE",
	                    "VEHICLE_MODEL",
	                    "VEHICLE_PREMIUM",
	                    "VEHICLE_ANNUAL_MILEAGE",
	                    "VEHICLE_VEHICLE_USE",
	                    "VEHICLE_ADDRESS1_GARAGED",
	                    "VEHICLE_ADDRESS2_GARAGED"]
                )
        except Exception as ERROR:
            print(ERROR)
        
        finally:
           pass
   
        second_box = toga.Box(children=[label,table], style=Pack(direction=COLUMN,alignment=CENTER,font_size=14,flex=0))
        second_window.content = second_box
        #second_window.show()

        return second_window.show()

def main():
    return VehiclesClass()