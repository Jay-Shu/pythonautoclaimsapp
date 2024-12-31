"""
Python Auto Claims app - Simple. Intended for interactions with an MS SQL DB.

In it's current state the Python side has not yet been started. Therefaore, in it's base form.

Name of Script: app.py
Author: Jacob Shuster
Role: Consultant - 1099
Umbrella Company: N/A
Creation Date: 2024-08-11
Script Cost: N/A
Rate: 100.00 (Based on 2019*)

Changelog:
    2024-08-11: Updated naming convention of script. Hyphens cannot be used.
        It must be underscores.
    2024-08-21: Updated references for the connecttomssqlserver. Still pending resolution of
        resolving.
    2024-08-27: Troubleshooting with tracemalloc.

Functions

https://stackoverflow.com/questions/66084762/call-function-from-another-file-without-import-clause
https://toga.readthedocs.io/en/stable/reference/api/window.html

Author Notes:
    Our connection to MS SQL Server.
"""

# from pythonautoclaimsapp.function_library.accountsmenu import AccountsMenuClass
# from pythonautoclaimsapp.function_library.vehicleclaims import VehicleClaimsClass
# from pythonautoclaimsapp.function_library.vehiclecoverages import VehicleCoveragesClass
# from pythonautoclaimsapp.function_library.policies import PoliciesClass
# from pythonautoclaimsapp.function_library.homes import HomesClass
# from pythonautoclaimsapp.function_library.vehicles import VehiclesClass
# from pythonautoclaimsapp.function_library.accounts import AccountsClass
# from pythonautoclaimsapp.function_library.accountsactions import *
import asyncio
import json
import pyodbc
from toga.sources import ListSource
from toga.style.pack import COLUMN, ROW, CENTER, LEFT, RIGHT, Pack
import toga.sources
import tracemalloc
import toga
import time
import logging
# import asyncio
logger = logging.getLogger(__name__)


tracemalloc.start()


class PythonAutoClaimsApp(toga.App):
    def getAccounts():
        # global data

        try:
            cnxn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
            cnxn.setencoding('utf-8')
            cursor = cnxn.cursor()  # Cursor is necessary for it to function properly
            # This will be moved along with the connection
            cursor.execute("{CALL paca.getAccounts_v1}")
            # tempcount = cursor.rowcount
            # print(tempcount)
            """
            A list Source was necessary for proper attribute assignment.
            """
            columns = ['ACCOUNT_NUM', 'ACCOUNT_HONORIFICS', 'ACCOUNT_FIRST_NAME', 'ACCOUNT_LAST_NAME', 'ACCOUNT_SUFFIX', 'ACCOUNT_STREET_ADD_1',
                       'ACCOUNT_STREET_ADD_2', 'ACCOUNT_CITY', 'ACCOUNT_STATE', 'ACCOUNT_ZIP', 'ACCOUNT_PO_BOX', 'ACCOUNT_DATE_START', 'ACCOUNT_DATE_RENEWAL', 'ACCOUNT_TYPE']

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
                    list_source.append({'ACCOUNT_NUM': row[0], 'ACCOUNT_HONORIFICS': row[1], 'ACCOUNT_FIRST_NAME': row[2], 'ACCOUNT_LAST_NAME': row[3], 'ACCOUNT_SUFFIX': row[4], 'ACCOUNT_STREET_ADD_1': row[5], 'ACCOUNT_STREET_ADD_2': row[6],
                                       'ACCOUNT_CITY': row[7], 'ACCOUNT_STATE': row[8], 'ACCOUNT_ZIP': row[9], 'ACCOUNT_PO_BOX': row[10], 'ACCOUNT_DATE_START': row[11], 'ACCOUNT_DATE_RENEWAL': row[12], 'ACCOUNT_TYPE': row[13]})
                    # print(list_source[i])
                    # time.sleep(1)
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

        return columns, list_source

    def accounts_secondary_box(self, widget):
        # global columns,list_source,table

        columns, list_source = self.getAccounts()
        # print(list_source[0])

        second_window = toga.Window(title="Accounts")
        label = toga.Label('Accounts Results',
                           style=Pack(padding=10, font_size=14))

        try:
            table = toga.Table(
                headings=['ACCOUNT_NUM', 'ACCOUNT_HONORIFICS', 'ACCOUNT_FIRST_NAME', 'ACCOUNT_LAST_NAME', 'ACCOUNT_SUFFIX', 'ACCOUNT_STREET_ADD_1', 'ACCOUNT_STREET_ADD_2', 'ACCOUNT_CITY', 'ACCOUNT_STATE', 'ACCOUNT_ZIP', 'ACCOUNT_PO_BOX', 'ACCOUNT_DATE_START', 'ACCOUNT_DATE_RENEWAL', 'ACCOUNT_TYPE'], style=Pack(direction=COLUMN, alignment=CENTER, font_size=14),
                # headings=columns,
                # selection=data
                data=list_source,
                accessors=['ACCOUNT_NUM', 'ACCOUNT_HONORIFICS', 'ACCOUNT_FIRST_NAME', 'ACCOUNT_LAST_NAME', 'ACCOUNT_SUFFIX', 'ACCOUNT_STREET_ADD_1',
                           'ACCOUNT_STREET_ADD_2', 'ACCOUNT_CITY', 'ACCOUNT_STATE', 'ACCOUNT_ZIP', 'ACCOUNT_PO_BOX', 'ACCOUNT_DATE_START', 'ACCOUNT_DATE_RENEWAL', 'ACCOUNT_TYPE']
            )
        except Exception as ERROR:
            print(ERROR)

        finally:
            pass

        second_box = toga.Box(children=[label, table], style=Pack(
            direction=COLUMN, alignment=CENTER, font_size=14))
        second_window.content = second_box
        # second_window.show()

        return second_window.show()

    async def vehicles_callback(self, widget):
        # Staged for future development
        pass

    async def homes_callback(self, widget):
        pass

    async def policies_callback(self, widget):
        pass

    async def vehicle_coverages_callback(self, widget):
        pass

    async def vehicle_claims_callback(self, widget):
        pass

    async def update_account(self, widget):
        pass
    
    async def delete_account(self,widget):
        pass
    
    async def create_account(self,widget):
        pass

    async def accountsMenu(self, widget):
        accountsmenu = toga.Box(style=Pack(direction=COLUMN))

        # label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))
        getAccountsButton = toga.Button(
            'Get Accounts', style=Pack(padding=5), on_press=self.getAccounts)
        updateAccountButton = toga.Button('Update Account', style=Pack(
            padding=5), on_press=self.update_account)
        createAccountButton = toga.Button('Create Account', style=Pack(
            padding=5), on_press=self.create_account)
        deleteAccountsButton = toga.Button('Delete Account', style=Pack(
            padding=5), on_press=self.delete_account)

        accountsmenu.add(getAccountsButton)
        accountsmenu.add(updateAccountButton)
        accountsmenu.add(createAccountButton)
        accountsmenu.add(deleteAccountsButton)

        self.account_window = toga.Window(title="Accounts Menu")
        self.account_window.content = accountsmenu
        
        async_window_task = asyncio.create_task(self.account_window.show())
        
        await async_window_task
        pass

    def startup(self):
        logging.basicConfig(
            filename='E:\\scripts\\python\\togatesting\\togatesting.log',
            level=logging.DEBUG,
            format='%(filename)s %(lineno)d %(asctime)s %(message)s %(module)s %(msecs)d'
        )
        self.app = toga.App
        widget = self.app.widgets
        # self.widget = toga.App.widget
        # logging.INFO(self.app)
        """Construct and show the Toga application.
       
        https://docs.python.org/3.12/library/logging.html#logrecord-attributes

        Usually, you would add your application to a main content box.
        We then create a main window (with a name matching the app), and
        show the main window.
        """
        # PythonSources._create_listeners(self)
        main_box = toga.Box(style=Pack(direction=COLUMN))

        # accountsLabel = toga.Label('Main Section')
        # main_box.add(accountsLabel)

        accountsButton = toga.Button('Accounts', style=Pack(
            padding=5), on_press=self.accountsMenu(widget))  # This needs to open a Menu
        # accountsButton = toga.Button('Accounts', style=Pack(
        #    padding=5), on_press=self.wrap_async_function(self.accountsMenu(self,widget))) # This needs to open a Menu

        vehiclesButton = toga.Button('Vehicles', style=Pack(
            padding=5), on_press=self.vehicles_callback(widget))  # Current Iteration only retrieves what is current within the given table.
        homesButton = toga.Button('Homes', style=Pack(
            padding=5), on_press=self.homes_callback(widget))
        policiesButton = toga.Button('Policies', style=Pack(
            padding=5), on_press=self.policies_callback(widget))
        vehicleCoveragesButton = toga.Button('Vehicle Coverages', style=Pack(
            padding=5), on_press=self.vehicle_coverages_callback(widget))
        vehicleClaimsButton = toga.Button('Vehicle Claims', style=Pack(
            padding=5), on_press=self.vehicle_claims_callback(widget))

        main_box.add(accountsButton)
        main_box.add(vehiclesButton)
        main_box.add(homesButton)
        main_box.add(policiesButton)
        main_box.add(vehicleCoveragesButton)
        main_box.add(vehicleClaimsButton)

        self.main_window = toga.MainWindow(title=self.formal_name)
        self.main_window.content = main_box
        self.main_window.show()


def main():
    return PythonAutoClaimsApp()


snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

print("[ Top 10 ]")
for stat in top_stats[:10]:
    print(stat)
