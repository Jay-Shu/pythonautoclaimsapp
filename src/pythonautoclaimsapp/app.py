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
    def wrap_async_function(async_func, *args, **kwargs):
        def sync_wrapper(widget):
            asyncio.run(async_func(*args, **kwargs))
        return sync_wrapper

    async def getAccounts():
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

        return await columns, list_source

        async def accounts_secondary_box(self, widget):
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

            return await second_window.show()

        def run_stored_procedure(json_processor):
            tempJson = json.dumps(json_processor, indent=4)
            print(tempJson)
            # update_json = json.loads(tempJson)
            cnxn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
            cnxn.setencoding('utf-8')
            cursor = cnxn.cursor()  # Cursor is necessary for it to function properly
            # This will be updated to it's respective file's needs.

            # print(tempJson)

            cursor.execute("{CALL paca.updateAccounts_v1 (?)}", tempJson)
            cursor.close()
            cnxn.close()
            account_window = toga.Window()
            # account_window.content = None
            return account_window.close()

        async def update_account_submission_handler(self, widget, accountNumText, accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText, accountHonorificsSwitch, accountFNSwitch, accountLNSwitch, accountSuffixSwitch, accountStreetAdd1Switch, accountStreetAdd2Switch, accountCitySwitch, accountStateSwitch, accountZIPSwitch, accountPOBoxSwitch, accountDateStartSwitch, accountDateRenewalSwitch, accountTypeSwitch):
            widget = self.app.widgets
            # First we need to connect to the Database until we establish a persistent connection.
            # global inputColumn,input,inputValue
            # Beginning of For-Loop
            # ata = json.loads(accountsJson)

            json_processor = {}

        # Ingest values into JSON
            json_processor["ACCOUNT_NUM"] = accountNumText.value
            json_processor["ACCOUNT_HONORIFICS"] = accountHonorificsText.value if not accountHonorificsSwitch.value else (
                accountHonorificsText.value or 'NULL')
            json_processor["ACCOUNT_FIRST_NAME"] = accountFNText.value if not accountFNSwitch.value else (
                accountFNText.value or 'NULL')
            json_processor["ACCOUNT_LAST_NAME"] = accountLNText.value if not accountLNSwitch.value else (
                accountLNText.value or 'NULL')
            json_processor["ACCOUNT_SUFFIX"] = accountSuffixText.value if not accountSuffixSwitch.value else (
                accountSuffixText.value or 'NULL')
            json_processor["ACCOUNT_STREET_ADD_1"] = accountStreetAdd1Text.value if not accountStreetAdd1Switch.value else (
                accountStreetAdd1Text.value or 'NULL')
            json_processor["ACCOUNT_STREET_ADD_2"] = accountStreetAdd2Text.value if not accountStreetAdd2Switch.value else (
                accountStreetAdd2Text.value or 'NULL')
            json_processor["ACCOUNT_CITY"] = accountCityText.value if not accountCitySwitch.value else (
                accountCityText.value or 'NULL')
            json_processor["ACCOUNT_STATE"] = accountStateText.value if not accountStateSwitch.value else (
                accountStateText.value or 'NULL')
            json_processor["ACCOUNT_ZIP"] = accountZIPText.value if not accountZIPSwitch.value else (
                accountZIPText.value or 'NULL')
            json_processor["ACCOUNT_PO_BOX"] = accountPOBoxText.value if not accountPOBoxSwitch.value else (
                accountPOBoxText.value or 'NULL')
            json_processor["ACCOUNT_DATE_START"] = accountDateStartText.value if not accountDateStartSwitch.value else (
                accountDateStartText.value or 'NULL')
            json_processor["ACCOUNT_DATE_RENEWAL"] = accountDateRenewalText.value if not accountDateRenewalSwitch.value else (
                accountDateRenewalText.value or 'NULL')
            json_processor["ACCOUNT_TYPE"] = accountTypeText.value if not accountTypeSwitch.value else (
                accountTypeText.value or 'NULL')
            return await self.queue.put(run_stored_procedure(json_processor))

        # Convert to JSON format

        def updateAccount(self, widget):
            accountnumbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accounthonbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountfnbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountlnbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountsufbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountstradd1box = toga.Box(style=Pack(direction=ROW, padding=10))
            accountstradd2box = toga.Box(style=Pack(direction=ROW, padding=10))
            accountcitybox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountstatebox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountzipbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountpoboxbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountdatestartbox = toga.Box(
                style=Pack(direction=ROW, padding=10))
            accountdaterenbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accounttypebox = toga.Box(style=Pack(direction=ROW, padding=10))
            widget = self.app.widgets
            test_enabled = True
            """
            We need to build our initial json for updating later.
            """

            """
            We need the following:
            'ACCOUNT_NUM',
            'ACCOUNT_HONORIFICS',
            'ACCOUNT_FIRST_NAME',
            'ACCOUNT_LAST_NAME',
            'ACCOUNT_SUFFIX',
            'ACCOUNT_STREET_ADD_1',
            'ACCOUNT_STREET_ADD_2',
            'ACCOUNT_CITY',
            'ACCOUNT_STATE',
            'ACCOUNT_ZIP',
            'ACCOUNT_PO_BOX',
            'ACCOUNT_DATE_START',
            'ACCOUNT_DATE_RENEWAL',
            'ACCOUNT_TYPE'
            
            The labels are defined for the Accounts here.
            """
            accountNumLabel = toga.Label(
                'Account Number', style=Pack(font_size=16))
            accountHonorificsLabel = toga.Label(
                'Account Honorifics', style=Pack(flex=1, font_size=16))
            accountFNLabel = toga.Label(
                'Account First Name', style=Pack(flex=1, font_size=16))
            accountLNLabel = toga.Label(
                'Account Last Name', style=Pack(flex=1, font_size=16))
            accountSuffixLabel = toga.Label(
                'Account Suffix', style=Pack(flex=1, font_size=16))
            accountStreetAdd1Label = toga.Label(
                'Account Street Address 1', style=Pack(flex=1, font_size=16))
            accountStreetAdd2Label = toga.Label(
                'Account Street Address 2', style=Pack(flex=1, font_size=16))
            accountCityLabel = toga.Label(
                'Account City', style=Pack(flex=1, font_size=16))
            accountStateLabel = toga.Label(
                'Account State', style=Pack(font_size=16, flex=1))
            accountZIPLabel = toga.Label(
                'Account ZIP', style=Pack(flex=1, font_size=16))
            accountPOBoxLabel = toga.Label(
                'Account PO Box', style=Pack(flex=1, font_size=16))
            accountDateStartLabel = toga.Label(
                'Account Date Start', style=Pack(flex=1, font_size=16))
            accountDateRenewalLabel = toga.Label(
                'Account Date Renewal', style=Pack(flex=1, font_size=16))
            accountTypeLabel = toga.Label(
                'Account Type', style=Pack(flex=1, font_size=16))

            """
            This section is intended only during the developmental phase.
            
            
            """
            if test_enabled == True:
                # This must be supplied.
                accountNumText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=1, font_size=16))
                accountNumText.value = 'ICA00000000'
                accountHonorificsText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountFNText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountLNText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountSuffixText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountStreetAdd1Text = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountStreetAdd2Text = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountCityText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountStateText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                # This needs to incorporate the isinstanceof(value,dict)
                accountZIPText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountPOBoxText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountDateStartText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountDateRenewalText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
                accountTypeText = toga.TextInput(
                    on_change=None, style=Pack(width=150, flex=5, font_size=16))
            else:
                # This must be supplied.
                accountNumText = toga.TextInput(
                    validators=[self.validate_account_length()], on_change=None)
                accountHonorificsText = toga.TextInput(
                    validators=[self.validate_length(0, 16)], on_change=None)
                accountFNText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountLNText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountSuffixText = toga.TextInput(
                    validators=[self.validate_length(0, 16)], on_change=None)
                accountStreetAdd1Text = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountStreetAdd2Text = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountCityText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountStateText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountZIPText = toga.TextInput(validators=[self.validate_data_type(
                    int())])  # This needs to incorporate the isinstanceof(value,dict)
                accountPOBoxText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountDateStartText = toga.TextInput(
                    validators=[self.validate_length(0, 32)], on_change=None)
                accountDateRenewalText = toga.TextInput(
                    validators=[self.validate_length(0, 32)], on_change=None)
                accountTypeText = toga.TextInput(
                    validators=[self.validate_length(0, 64)], on_change=None)

            # We need to pass our value of False or True onto the next part. A def will be required for updating these properly each.
            # accountNumSwitch = toga.Switch('NULL?',style=Pack(font_size=14),value=False,on_change=self._update_account_handler('ACCOUNT_NUM',accountNumText,accountsJson))

            """
            This section is for setting the NULLs
            """
            accountHonorificsSwitch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountFNSwitch = toga.Switch('NULL?', style=Pack(
                font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountLNSwitch = toga.Switch('NULL?', style=Pack(
                font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountSuffixSwitch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountStreetAdd1Switch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountStreetAdd2Switch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountCitySwitch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountStateSwitch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountZIPSwitch = toga.Switch('NULL?', style=Pack(
                font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountPOBoxSwitch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountDateStartSwitch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountDateRenewalSwitch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)
            accountTypeSwitch = toga.Switch(
                'NULL?', style=Pack(font_size=14, text_align=RIGHT, flex=5), value=False, on_change=None)

            accountnumbox.add(accountNumLabel)
            accountnumbox.add(accountNumText)
            accounthonbox.add(accountHonorificsLabel)
            accounthonbox.add(accountHonorificsText)
            accounthonbox.add(accountHonorificsSwitch)
            accountfnbox.add(accountFNLabel)
            accountfnbox.add(accountFNText)
            accountfnbox.add(accountFNSwitch)
            accountlnbox.add(accountLNLabel)
            accountlnbox.add(accountLNText)
            accountlnbox.add(accountLNSwitch)
            accountsufbox.add(accountSuffixLabel)
            accountsufbox.add(accountSuffixText)
            accountsufbox.add(accountSuffixSwitch)
            accountstradd1box.add(accountStreetAdd1Label)
            accountstradd1box.add(accountStreetAdd1Text)
            accountstradd1box.add(accountStreetAdd1Switch)
            accountstradd2box.add(accountStreetAdd2Label)
            accountstradd2box.add(accountStreetAdd2Text)
            accountstradd2box.add(accountStreetAdd2Switch)
            accountcitybox.add(accountCityLabel)
            accountcitybox.add(accountCityText)
            accountcitybox.add(accountCitySwitch)
            accountstatebox.add(accountStateLabel)
            accountstatebox.add(accountStateText)
            accountstatebox.add(accountStateSwitch)
            accountzipbox.add(accountZIPLabel)
            accountzipbox.add(accountZIPText)
            accountzipbox.add(accountZIPSwitch)
            accountpoboxbox.add(accountPOBoxLabel)
            accountpoboxbox.add(accountPOBoxText)
            accountpoboxbox.add(accountPOBoxSwitch)
            accountdatestartbox.add(accountDateStartLabel)
            accountdatestartbox.add(accountDateStartText)
            accountdatestartbox.add(accountDateStartSwitch)
            accountdaterenbox.add(accountDateRenewalLabel)
            accountdaterenbox.add(accountDateRenewalText)
            accountdaterenbox.add(accountDateRenewalSwitch)
            accounttypebox.add(accountTypeLabel)
            accounttypebox.add(accountTypeText)
            accounttypebox.add(accountTypeSwitch)

            loop = asyncio.get_event_loop()
            submitButton = toga.Button('Submit', style=Pack(padding=5), on_press=self.wrap_async_function(self.create_account_submission_handler(self, widget, accountNumText, accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText,
                                       accountDateStartText, accountDateRenewalText, accountTypeText, accountHonorificsSwitch, accountFNSwitch, accountLNSwitch, accountSuffixSwitch, accountStreetAdd1Switch, accountStreetAdd2Switch, accountCitySwitch, accountStateSwitch, accountZIPSwitch, accountPOBoxSwitch, accountDateStartSwitch, accountDateRenewalSwitch, accountTypeSwitch)))
            cancelButton = toga.Button('Cancel', style=Pack(
                padding=5), on_press=self.wrap_async_function(self.cancel_handler(self, widget)))

            decisionsBox = toga.Box(style=Pack(direction=ROW, padding=10))
            decisionsBox.add(submitButton)
            decisionsBox.add(cancelButton)

            main_account_box = toga.Box(
                style=Pack(direction=COLUMN, padding=10))
            main_account_box.add(accountnumbox)
            main_account_box.add(accounthonbox)
            main_account_box.add(accountfnbox)
            main_account_box.add(accountlnbox)
            main_account_box.add(accountsufbox)
            main_account_box.add(accountstradd1box)
            main_account_box.add(accountstradd2box)
            main_account_box.add(accountcitybox)
            main_account_box.add(accountstatebox)
            main_account_box.add(accountzipbox)
            main_account_box.add(accountpoboxbox)
            main_account_box.add(accountdatestartbox)
            main_account_box.add(accountdaterenbox)
            main_account_box.add(accounttypebox)
            main_account_box.add(decisionsBox)

            account_window = toga.Window(title="Update Account")
            account_window.content = main_account_box

            return account_window.show()

        def createAccount(self, widget):
            test_enabled = True

            # accountnumbox = toga.Box(style=Pack(direction=ROW,padding=10))
            accounthonbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountfnbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountlnbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountsufbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountstradd1box = toga.Box(style=Pack(direction=ROW, padding=10))
            accountstradd2box = toga.Box(style=Pack(direction=ROW, padding=10))
            accountcitybox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountstatebox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountzipbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountpoboxbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accountdatestartbox = toga.Box(
                style=Pack(direction=ROW, padding=10))
            accountdaterenbox = toga.Box(style=Pack(direction=ROW, padding=10))
            accounttypebox = toga.Box(style=Pack(direction=ROW, padding=10))
            widget = self.app.widgets

            # label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))

            # accountNumLabel = toga.Label('Account Number', style=Pack(font_size=14))
            accountHonorificsLabel = toga.Label(
                'Account Honorifics', style=Pack(font_size=14))
            accountFNLabel = toga.Label(
                'Account First Name', style=Pack(font_size=14))
            accountLNLabel = toga.Label(
                'Account Last Name', style=Pack(font_size=14))
            accountSuffixLabel = toga.Label(
                'Account Suffix', style=Pack(font_size=14))
            accountStreetAdd1Label = toga.Label(
                'Account Street Address 1', style=Pack(font_size=14))
            accountStreetAdd2Label = toga.Label(
                'Account Street Address 2', style=Pack(font_size=14))
            accountCityLabel = toga.Label(
                'Account City', style=Pack(font_size=14))
            accountStateLabel = toga.Label(
                'Account State', style=Pack(font_size=14))
            accountZIPLabel = toga.Label(
                'Account ZIP', style=Pack(font_size=14))
            accountPOBoxLabel = toga.Label(
                'Account PO Box', style=Pack(font_size=14))
            accountDateStartLabel = toga.Label(
                'Account Date Start', style=Pack(font_size=14))
            accountDateRenewalLabel = toga.Label(
                'Account Date Renewal', style=Pack(font_size=14))
            accountTypeLabel = toga.Label(
                'Account Type', style=Pack(font_size=14))

            if test_enabled == True:
                # We do not supply an Account Number as the system back-end will create this for us.
                # Maintaining accuracy and processing CHECKIDENT() will be necessary at this current time (2024-10-05)
                # accountNumText = toga.TextInput(on_change=None)  # This must be supplied.

                accountHonorificsText = toga.TextInput(on_change=None)
                accountFNText = toga.TextInput(on_change=None)
                accountLNText = toga.TextInput(on_change=None)
                accountSuffixText = toga.TextInput(on_change=None)
                accountStreetAdd1Text = toga.TextInput(on_change=None)
                accountStreetAdd2Text = toga.TextInput(on_change=None)
                accountCityText = toga.TextInput(on_change=None)
                accountStateText = toga.TextInput(on_change=None)
                # This needs to incorporate the isinstanceof(value,dict)
                accountZIPText = toga.TextInput(on_change=None)
                accountPOBoxText = toga.TextInput(on_change=None)
                accountDateStartText = toga.TextInput(on_change=None)
                accountDateRenewalText = toga.TextInput(
                    on_change=None, read_only=True)
                accountTypeText = toga.TextInput(on_change=None)
            else:
                # accountNumText = toga.TextInput(validators=[ValidationClass.validate_account_length()],on_change=None)  # This must be supplied.

                accountHonorificsText = toga.TextInput(
                    validators=[self.validate_length(0, 16)], on_change=None)
                accountFNText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountLNText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountSuffixText = toga.TextInput(
                    validators=[self.validate_length(0, 16)], on_change=None)
                accountStreetAdd1Text = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountStreetAdd2Text = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountCityText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountStateText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountZIPText = toga.TextInput(validators=[self.validate_data_type(
                    int())])  # This needs to incorporate the isinstanceof(value,dict)
                accountPOBoxText = toga.TextInput(
                    validators=[self.validate_length(0, 128)], on_change=None)
                accountDateStartText = toga.TextInput(
                    validators=[self.validate_length(0, 32)], on_change=None)
                accountDateRenewalText = toga.TextInput(
                    validators=[self.validate_length(0, 32)], on_change=None)
                accountTypeText = toga.TextInput(
                    validators=[self.validate_length(0, 64)], on_change=None)

            # accountbox.add(accountNumLabel)
            # accountbox.add(accountNumText)
            # accountbox.add(accountNumSwitch)

            submitButton = toga.Button('Submit', style=Pack(
                padding=5), on_press=self.create_account_submission_handler(self,  accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText))
            cancelButton = toga.Button('Cancel', style=Pack(
                padding=5), on_press=self.cancel_handler(self, widget))

            decisionsBox = toga.Box(style=Pack(direction=ROW, padding=10))
            decisionsBox.add(submitButton)
            decisionsBox.add(cancelButton)

            accounthonbox.add(accountHonorificsLabel)
            accounthonbox.add(accountHonorificsText)
            accountfnbox.add(accountFNLabel)
            accountfnbox.add(accountFNText)
            accountlnbox.add(accountLNLabel)
            accountlnbox.add(accountLNText)
            accountsufbox.add(accountSuffixLabel)
            accountsufbox.add(accountSuffixText)
            accountstradd1box.add(accountStreetAdd1Label)
            accountstradd1box.add(accountStreetAdd1Text)
            accountstradd2box.add(accountStreetAdd2Label)
            accountstradd2box.add(accountStreetAdd2Text)
            accountcitybox.add(accountCityLabel)
            accountcitybox.add(accountCityText)
            accountstatebox.add(accountStateLabel)
            accountstatebox.add(accountStateText)
            accountzipbox.add(accountZIPLabel)
            accountzipbox.add(accountZIPText)
            accountpoboxbox.add(accountPOBoxLabel)
            accountpoboxbox.add(accountPOBoxText)
            accountdatestartbox.add(accountDateStartLabel)
            accountdatestartbox.add(accountDateStartText)
            accountdaterenbox.add(accountDateRenewalLabel)
            accountdaterenbox.add(accountDateRenewalText)
            accounttypebox.add(accountTypeLabel)
            accounttypebox.add(accountTypeText)

            main_account_box = toga.Box(
                style=Pack(direction=COLUMN, padding=10))
            # main_account_box.add(accountnumbox)
            main_account_box.add(accounthonbox)
            main_account_box.add(accountfnbox)
            main_account_box.add(accountlnbox)
            main_account_box.add(accountsufbox)
            main_account_box.add(accountstradd1box)
            main_account_box.add(accountstradd2box)
            main_account_box.add(accountcitybox)
            main_account_box.add(accountstatebox)
            main_account_box.add(accountzipbox)
            main_account_box.add(accountpoboxbox)
            main_account_box.add(accountdatestartbox)
            main_account_box.add(accountdaterenbox)
            main_account_box.add(accounttypebox)
            main_account_box.add(decisionsBox)

            account_window = toga.Window(title="Create Account")
            account_window.content = main_account_box

            return account_window.show()

        async def create_account_submission_handler(self, accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText):
            # First we need to connect to the Database until we establish a persistent connection.
            # global inputColumn,input,inputValue
            # widget = self.app.widgets
            accountsJson = {
                "ACCOUNT_HONORIFICS": None,
                "ACCOUNT_FIRST_NAME": None,
                "ACCOUNT_LAST_NAME": None,
                "ACCOUNT_SUFFIX": None,
                "ACCOUNT_STREET_ADD_1": None,
                "ACCOUNT_STREET_ADD_2": None,
                "ACCOUNT_CITY": None,
                "ACCOUNT_STATE": None,
                "ACCOUNT_ZIP": None,
                "ACCOUNT_PO_BOX": None,
                "ACCOUNT_DATE_START": None,
                "ACCOUNT_DATE_RENEWAL": None,
                "ACCOUNT_TYPE": None
            }
            # data = json.loads(accountsJson)
            json_processor = {}

        # Ingest values into JSON
            # json_processor["ACCOUNT_NUM"] = accountNumText.value
            json_processor["ACCOUNT_HONORIFICS"] = accountHonorificsText.value if not None else (
                accountHonorificsText.value or 'NULL')
            json_processor["ACCOUNT_FIRST_NAME"] = accountFNText.value if not None else (
                accountFNText.value or 'NULL')
            json_processor["ACCOUNT_LAST_NAME"] = accountLNText.value if not None else (
                accountLNText.value or 'NULL')
            json_processor["ACCOUNT_SUFFIX"] = accountSuffixText.value if not None else (
                accountSuffixText.value or 'NULL')
            json_processor["ACCOUNT_STREET_ADD_1"] = accountStreetAdd1Text.value if not None else (
                accountStreetAdd1Text.value or 'NULL')
            json_processor["ACCOUNT_STREET_ADD_2"] = accountStreetAdd2Text.value if not None else (
                accountStreetAdd2Text.value or 'NULL')
            json_processor["ACCOUNT_CITY"] = accountCityText.value if not None else (
                accountCityText.value or 'NULL')
            json_processor["ACCOUNT_STATE"] = accountStateText.value if not None else (
                accountStateText.value or 'NULL')
            json_processor["ACCOUNT_ZIP"] = accountZIPText.value if not None else (
                accountZIPText.value or 'NULL')
            json_processor["ACCOUNT_PO_BOX"] = accountPOBoxText.value if not None else (
                accountPOBoxText.value or 'NULL')
            json_processor["ACCOUNT_DATE_START"] = accountDateStartText.value if not None else (
                accountDateStartText.value or 'NULL')
            json_processor["ACCOUNT_DATE_RENEWAL"] = accountDateRenewalText.value if not None else (
                accountDateRenewalText.value or 'NULL')
            json_processor["ACCOUNT_TYPE"] = accountTypeText.value if not None else (
                accountTypeText.value or 'NULL')
            return await self.queue.put(run_stored_procedure(json_processor))

        async def cancel_handler(self, widget):
            # for window in list(self.windows):
            #     if not isinstance(window,toga.MainWindow):
            #         window.close()
            pass

        def deleteAccount(self, widget):
            accountnumbox = toga.Box(style=Pack(direction=ROW, padding=10))
            widget = self.app.widgets

            # label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))

            accountNumLabel = toga.Label(
                'Account Number', style=Pack(font_size=14))
            accountNumText = toga.TextInput(
                on_change=None, style=Pack(width=150, padding=10))

            deleteAccountButton = toga.Button('Delete Account', style=Pack(
                padding=5), on_press=self.delete_account_callback(self, widget, accountNumText))
            cancelAccountButton = toga.Button('Cancel Account', style=Pack(
                padding=5), on_press=self.cancel_handler(self, widget))

            main_account_box = toga.Box(style=Pack(direction=ROW, padding=10))

            decisions_box = toga.Box(style=Pack(direction=ROW, padding=10))
            accountnumbox.add(accountNumLabel)
            accountnumbox.add(accountNumText)
            decisions_box.add(deleteAccountButton)
            decisions_box.add(cancelAccountButton)

            main_account_box.add(accountnumbox)
            main_account_box.add(decisions_box)
            account_window = toga.Window(title="Delete Account Menu")
            account_window.content = main_account_box

            return account_window.show()

        def delete_account_callback(self, widget, accountNumText):
            widget = self.app.widgets

            initJson = {}
            initJson += ({"ACCOUNT_NUM": accountNumText})

            cnxn = pyodbc.connect(
                'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
            cnxn.setencoding('utf-8')
            cursor = cnxn.cursor()  # Cursor is necessary for it to function properly
        # This will be updated to it's respective file's needs.
            cursor.execute("{CALL paca.removeAccount_v1 (?)}", initJson)
            cursor.close()
            cnxn.close()
            account_window = toga.Window()
            account_window.content = None

            return account_window.close()

        def cancel_handler(self, widget):
            # widget = self.app.widgets
            # for window in list(self.windows):
            #     if not isinstance(window,toga.MainWindow):
            #         window.close()
            # print(self)
            # print(widget)
            pass

        async def get_accounts_callback(self, widget):
            # Stage for Menu
            # Needs the correct pieces
            # Refactor of this later is needed.
            return await self.accounts_secondary_box(self, widget)

        async def update_account_callback(self, widget):
            # Stage for Menu
            # Needs the correct pieces
            return await self.updateAccount(self, widget)

        async def create_account_callback(self, widget):
            # Stage for Menu
            # Needs the correct pieces
            return await self.createAccount(self, widget)

        async def delete_account_callback(self, widget):
            # Stage for Menu
            # Needs the correct pieces
            return await self.deleteAccount(self, widget)

        def accountsMenu(self, widget):
            accountsmenu = toga.Box(style=Pack(direction=COLUMN))

            # label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))
            getAccountsButton = toga.Button('Get Accounts', style=Pack(
                padding=5), on_press=self.get_accounts_callback(self, widget))
            updateAccountButton = toga.Button('Update Account', style=Pack(
                padding=5), on_press=self.update_account_callback(self, widget))
            createAccountButton = toga.Button('Create Account', style=Pack(
                padding=5), on_press=self.create_account_callback(self, widget))
            deleteAccountsButton = toga.Button('Delete Account', style=Pack(
                padding=5), on_press=self.delete_account_callback(self, widget))

            accountsmenu.add(getAccountsButton)
            accountsmenu.add(updateAccountButton)
            accountsmenu.add(createAccountButton)
            accountsmenu.add(deleteAccountsButton)

            self.account_window = toga.Window(title="Accounts Menu")
            self.account_window.content = accountsmenu

            return self.account_window.show()

    async def homes_callback(self, widget):
        # Stage for Menu
        # Needs the correct pieces
        return await self.homes_secondary_box(self, widget)
        pass

    async def vehicles_callback(self, widget):
        # Stage for Menu
        # Needs the correct pieces
        return await self.vehicles_secondary_box(self, widget)
        pass

    async def policies_callback(self, widget):
        # Stage for Menu
        # Needs the correct pieces
        return await self.policies_secondary_box(self, widget)
        pass

    async def vehicle_coverages_callback(self, widget):
        # Stage for Menu
        # Needs the correct pieces
        return await self.vehicle_coverages_secondary_box(self, widget)
        pass

    async def vehicle_claims_callback(self, widget):
        # Stage for Menu
        # Needs the correct pieces
        return await self.vehicle_claims_secondary_box(self, widget)
        pass

    def startup(self):
        logging.basicConfig(
            filename='E:\\scripts\\python\\togatesting\\togatesting.log',
            level=logging.DEBUG,
            format='%(filename)s %(lineno)d %(asctime)s %(message)s %(module)s %(msecs)d'
        )
        self.app = toga.App
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
            padding=5), on_press=self.accounts_callback)
        vehiclesButton = toga.Button('Vehicles', style=Pack(
            padding=5), on_press=self.vehicles_callback)
        homesButton = toga.Button('Homes', style=Pack(
            padding=5), on_press=self.homes_callback)
        policiesButton = toga.Button('Policies', style=Pack(
            padding=5), on_press=self.policies_callback)
        vehicleCoveragesButton = toga.Button('Vehicle Coverages', style=Pack(
            padding=5), on_press=self.vehicle_coverages_callback)
        vehicleClaimsButton = toga.Button('Vehicle Claims', style=Pack(
            padding=5), on_press=self.vehicle_claims_callback)

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
