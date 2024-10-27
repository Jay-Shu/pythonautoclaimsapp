# Stadnard set of imports.
#from pythonautoclaimsapp.function_library.vehicleclaims import *
#from pythonautoclaimsapp.function_library.vehiclecoverages import *
#from pythonautoclaimsapp.function_library.policies import *
#from pythonautoclaimsapp.function_library.homes import *
#from pythonautoclaimsapp.function_library.vehicles import *
from pythonautoclaimsapp.function_library.accounts import *
from toga.sources import ListSource
from toga.style.pack import COLUMN, ROW, CENTER, LEFT, RIGHT, Pack
from toga.style import Pack
import toga.sources
import tracemalloc
import toga
import time
import json
import logging
import pyodbc
import asyncio

import toga.validators

logger = logging.getLogger(__name__)


tracemalloc.start()
"""
This function is intended for Updating a singular account.
Batch updating can be a later feature.
"""


class ValidationClass():
    def __init__(self, app, accouuntVal, substring, min_length, max_length, data_type, value,accountsJson):
        self.app = app
        self.accouuntVal = accouuntVal
        self.substring = substring
        self.min_length = min_length
        self.max_length = max_length
        self.data_type = data_type
        self.value = value
        self.accountsJson = accountsJson

    def validate_account_length(accouuntVal, min_length=11, max_length=11):

        substring = accouuntVal[3:]
        if not (min_length <= len(accouuntVal) <= max_length):
            raise ValueError(
                f"Value must be between {min_length} and {max_length} characters long.")
        else:
            if substring == "ICA":
                raise ValueError(
                    f"Value must contain the substring '{substring}'.")
            else:
                return True

    def validate_data_type(accouuntVal, data_type):
        # self.accountVal = accountVal
        if not isinstance(accouuntVal, data_type):
            raise TypeError(f"Value must be of type {data_type.__name__}.")
        else:
            return True

    def validate_length(accouuntVal, min_length, max_length):
        # self.accountVal = accountVal
        if not (min_length <= len(accouuntVal) <= max_length):
            raise ValueError(
                f"Value must be between {min_length} and {max_length} characters long.")

        else:
            return True


class UpdAccountClass:
    def __init__(self, cnxn, data, columns, accountsJson, key, value):
        self.app = toga.App
        self.cnxn = cnxn
        self.data = data
        self.table = toga.Table
        self.columns = columns
        self.list_source = toga.sources.ListSource
        self.accountsJson = accountsJson
        self.key = key
        self.value = value
        self.widget = toga.App.widgets
        
    def wrap_async_function(async_func, *args, **kwargs):
        def sync_wrapper(widget):
            asyncio.run(async_func(*args, **kwargs))
        return sync_wrapper
        
    def run_stored_procedure(json_processor):
        tempJson = json.dumps(json_processor, indent=4)
        print(tempJson)
        #update_json = json.loads(tempJson)
        cnxn = pyodbc.connect(
            'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
        cnxn.setencoding('utf-8')
        cursor = cnxn.cursor()  # Cursor is necessary for it to function properly
        # This will be updated to it's respective file's needs.
        
        #print(tempJson)
        
        cursor.execute("{CALL paca.updateAccounts_v1 (?)}", tempJson)
        cursor.close()
        cnxn.close()
        account_window = toga.Window()
        #account_window.content = None
        return account_window.close()
        
    async def cancel_handler(self,widget):
        #widget = self.app.widgets
        # account_window = toga.Window()
        # account_window.content = None
        # account_window.window.close()
        #print(self)
        # for window in list(self.windows):
        #     if not isinstance(window,toga.MainWindow):
        #         window.close()
        pass

    async def submission_handler(self, widget, accountNumText, accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText, accountHonorificsSwitch, accountFNSwitch, accountLNSwitch, accountSuffixSwitch, accountStreetAdd1Switch, accountStreetAdd2Switch, accountCitySwitch, accountStateSwitch, accountZIPSwitch, accountPOBoxSwitch, accountDateStartSwitch, accountDateRenewalSwitch, accountTypeSwitch):
        widget = self.app.widgets
        # First we need to connect to the Database until we establish a persistent connection.
        # global inputColumn,input,inputValue
        # Beginning of For-Loop
        # ata = json.loads(accountsJson)
        
        json_processor = {}

    # Ingest values into JSON
        json_processor["ACCOUNT_NUM"] = accountNumText.value
        json_processor["ACCOUNT_HONORIFICS"] = accountHonorificsText.value if not accountHonorificsSwitch.value else (accountHonorificsText.value or 'NULL')
        json_processor["ACCOUNT_FIRST_NAME"] = accountFNText.value if not accountFNSwitch.value else (accountFNText.value or 'NULL')
        json_processor["ACCOUNT_LAST_NAME"] = accountLNText.value if not accountLNSwitch.value else (accountLNText.value or 'NULL')
        json_processor["ACCOUNT_SUFFIX"] = accountSuffixText.value if not accountSuffixSwitch.value else (accountSuffixText.value or 'NULL')
        json_processor["ACCOUNT_STREET_ADD_1"] = accountStreetAdd1Text.value if not accountStreetAdd1Switch.value else (accountStreetAdd1Text.value or 'NULL')
        json_processor["ACCOUNT_STREET_ADD_2"] = accountStreetAdd2Text.value if not accountStreetAdd2Switch.value else (accountStreetAdd2Text.value or 'NULL')
        json_processor["ACCOUNT_CITY"] = accountCityText.value if not accountCitySwitch.value else (accountCityText.value or 'NULL')
        json_processor["ACCOUNT_STATE"] = accountStateText.value if not accountStateSwitch.value else (accountStateText.value or 'NULL')
        json_processor["ACCOUNT_ZIP"] = accountZIPText.value if not accountZIPSwitch.value else (accountZIPText.value or 'NULL')
        json_processor["ACCOUNT_PO_BOX"] = accountPOBoxText.value if not accountPOBoxSwitch.value else (accountPOBoxText.value or 'NULL')
        json_processor["ACCOUNT_DATE_START"] = accountDateStartText.value if not accountDateStartSwitch.value else (accountDateStartText.value or 'NULL')
        json_processor["ACCOUNT_DATE_RENEWAL"] = accountDateRenewalText.value if not accountDateRenewalSwitch.value else (accountDateRenewalText.value or 'NULL')
        json_processor["ACCOUNT_TYPE"] = accountTypeText.value if not accountTypeSwitch.value else (accountTypeText.value or 'NULL')
        return await self.queue.put(UpdAccountClass.run_stored_procedure(json_processor))

    # Convert to JSON format

    def updateAccount(self, widget):
        accountnumbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accounthonbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountfnbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountlnbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountsufbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountstradd1box = toga.Box(style=Pack(direction=ROW,padding=10))
        accountstradd2box = toga.Box(style=Pack(direction=ROW,padding=10))
        accountcitybox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountstatebox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountzipbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountpoboxbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountdatestartbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountdaterenbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accounttypebox = toga.Box(style=Pack(direction=ROW,padding=10))
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
            'Account Honorifics', style=Pack(flex=1,font_size=16))
        accountFNLabel = toga.Label(
            'Account First Name', style=Pack(flex=1,font_size=16))
        accountLNLabel = toga.Label(
            'Account Last Name', style=Pack(flex=1,font_size=16))
        accountSuffixLabel = toga.Label(
            'Account Suffix', style=Pack(flex=1,font_size=16))
        accountStreetAdd1Label = toga.Label(
            'Account Street Address 1', style=Pack(flex=1,font_size=16))
        accountStreetAdd2Label = toga.Label(
            'Account Street Address 2', style=Pack(flex=1,font_size=16))
        accountCityLabel = toga.Label('Account City', style=Pack(flex=1,font_size=16))
        accountStateLabel = toga.Label(
            'Account State', style=Pack(font_size=16,flex=1))
        accountZIPLabel = toga.Label('Account ZIP', style=Pack(flex=1,font_size=16))
        accountPOBoxLabel = toga.Label(
            'Account PO Box', style=Pack(flex=1,font_size=16))
        accountDateStartLabel = toga.Label(
            'Account Date Start', style=Pack(flex=1,font_size=16))
        accountDateRenewalLabel = toga.Label(
            'Account Date Renewal', style=Pack(flex=1,font_size=16))
        accountTypeLabel = toga.Label('Account Type', style=Pack(flex=1,font_size=16))

        """
        This section is intended only during the developmental phase.
        
        
        """
        if test_enabled == True:
            # This must be supplied.
            accountNumText = toga.TextInput(on_change=None,style=Pack(width=150,flex=1,font_size=16))
            accountNumText.value = 'ICA00000000'
            accountHonorificsText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountFNText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountLNText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountSuffixText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountStreetAdd1Text = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountStreetAdd2Text = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountCityText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountStateText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            # This needs to incorporate the isinstanceof(value,dict)
            accountZIPText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountPOBoxText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountDateStartText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountDateRenewalText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
            accountTypeText = toga.TextInput(on_change=None,style=Pack(width=150,flex=5,font_size=16))
        else:
            # This must be supplied.
            accountNumText = toga.TextInput(
                validators=[ValidationClass.validate_account_length()], on_change=None)
            accountHonorificsText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 16)], on_change=None)
            accountFNText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountLNText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountSuffixText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 16)], on_change=None)
            accountStreetAdd1Text = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountStreetAdd2Text = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountCityText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountStateText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountZIPText = toga.TextInput(validators=[ValidationClass.validate_data_type(
                int())])  # This needs to incorporate the isinstanceof(value,dict)
            accountPOBoxText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountDateStartText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 32)], on_change=None)
            accountDateRenewalText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 32)], on_change=None)
            accountTypeText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 64)], on_change=None)

        # We need to pass our value of False or True onto the next part. A def will be required for updating these properly each.
        # accountNumSwitch = toga.Switch('NULL?',style=Pack(font_size=14),value=False,on_change=self._update_account_handler('ACCOUNT_NUM',accountNumText,accountsJson))

        """
        This section is for setting the NULLs
        """
        accountHonorificsSwitch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountFNSwitch = toga.Switch('NULL?', style=Pack(
            font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountLNSwitch = toga.Switch('NULL?', style=Pack(
            font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountSuffixSwitch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountStreetAdd1Switch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountStreetAdd2Switch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountCitySwitch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountStateSwitch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountZIPSwitch = toga.Switch('NULL?', style=Pack(
            font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountPOBoxSwitch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountDateStartSwitch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountDateRenewalSwitch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)
        accountTypeSwitch = toga.Switch(
            'NULL?', style=Pack(font_size=14,text_align=RIGHT,flex=5), value=False, on_change=None)

        # accounthonbox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountfnbox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountlnbox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountsufbox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountstradd1box = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountstradd2box = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountcitybox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountstatebox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountzipbox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountpoboxbox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountdatestartbox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accountdaterenbox = toga.Box(style=Pack(direction=ROW,padding=10))
        # accounttypebox = toga.Box(style=Pack(direction=ROW,padding=10))
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

        # accountsJson = {"ACCOUNT_NUM": None,
        #                 "ACCOUNT_HONORIFICS": None,
        #                 "ACCOUNT_FIRST_NAME": None,
        #                 "ACCOUNT_LAST_NAME": None,
        #                 "ACCOUNT_SUFFIX": None,
        #                 "ACCOUNT_STREET_ADD_1": None,
        #                 "ACCOUNT_STREET_ADD_2": None,
        #                 "ACCOUNT_CITY": None,
        #                 "ACCOUNT_STATE": None,
        #                 "ACCOUNT_ZIP": None,
        #                 "ACCOUNT_PO_BOX": None,
        #                 "ACCOUNT_DATE_START": None,
        #                 "ACCOUNT_DATE_RENEWAL": None,
        #                 "ACCOUNT_TYPE": None}
        loop = asyncio.get_event_loop()
        submitButton = toga.Button('Submit', style=Pack(padding=5), on_press=UpdAccountClass.wrap_async_function(UpdAccountClass.submission_handler(self, widget, accountNumText, accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText, accountHonorificsSwitch, accountFNSwitch, accountLNSwitch, accountSuffixSwitch, accountStreetAdd1Switch, accountStreetAdd2Switch, accountCitySwitch, accountStateSwitch, accountZIPSwitch, accountPOBoxSwitch, accountDateStartSwitch, accountDateRenewalSwitch, accountTypeSwitch)))
        cancelButton = toga.Button('Cancel', style=Pack(
            padding=5), on_press=UpdAccountClass.wrap_async_function(UpdAccountClass.cancel_handler(self,widget)))
        
        decisionsBox = toga.Box(style=Pack(direction=ROW,padding=10))
        decisionsBox.add(submitButton)
        decisionsBox.add(cancelButton)
        
        main_account_box = toga.Box(style=Pack(direction=COLUMN,padding=10))
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

class CreAccountClass:
    def __init__(self, cnxn, data, columns):
        self.app = toga.App
        self.cnxn = cnxn
        self.data = data
        self.table = toga.Table
        self.columns = columns
        self.list_source = toga.sources.ListSource
        self.widget = toga.App.widgets

    def createAccount(self, widget):
        test_enabled = True
        
        #accountnumbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accounthonbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountfnbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountlnbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountsufbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountstradd1box = toga.Box(style=Pack(direction=ROW,padding=10))
        accountstradd2box = toga.Box(style=Pack(direction=ROW,padding=10))
        accountcitybox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountstatebox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountzipbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountpoboxbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountdatestartbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accountdaterenbox = toga.Box(style=Pack(direction=ROW,padding=10))
        accounttypebox = toga.Box(style=Pack(direction=ROW,padding=10))
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
        accountCityLabel = toga.Label('Account City', style=Pack(font_size=14))
        accountStateLabel = toga.Label(
            'Account State', style=Pack(font_size=14))
        accountZIPLabel = toga.Label('Account ZIP', style=Pack(font_size=14))
        accountPOBoxLabel = toga.Label(
            'Account PO Box', style=Pack(font_size=14))
        accountDateStartLabel = toga.Label(
            'Account Date Start', style=Pack(font_size=14))
        accountDateRenewalLabel = toga.Label(
            'Account Date Renewal', style=Pack(font_size=14))
        accountTypeLabel = toga.Label('Account Type', style=Pack(font_size=14))

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
            accountDateRenewalText = toga.TextInput(on_change=None,read_only=True)
            accountTypeText = toga.TextInput(on_change=None)
        else:
            # accountNumText = toga.TextInput(validators=[ValidationClass.validate_account_length()],on_change=None)  # This must be supplied.

            accountHonorificsText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 16)], on_change=None)
            accountFNText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountLNText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountSuffixText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 16)], on_change=None)
            accountStreetAdd1Text = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountStreetAdd2Text = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountCityText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountStateText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountZIPText = toga.TextInput(validators=[ValidationClass.validate_data_type(
                int())])  # This needs to incorporate the isinstanceof(value,dict)
            accountPOBoxText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 128)], on_change=None)
            accountDateStartText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 32)], on_change=None)
            accountDateRenewalText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 32)], on_change=None)
            accountTypeText = toga.TextInput(
                validators=[ValidationClass.validate_length(0, 64)], on_change=None)

        # accountbox.add(accountNumLabel)
        # accountbox.add(accountNumText)
        # accountbox.add(accountNumSwitch)
       

        
        submitButton = toga.Button('Submit', style=Pack(
            padding=5), on_press=CreAccountClass.submission_handler(self,  accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText))
        cancelButton = toga.Button('Cancel', style=Pack(
            padding=5), on_press=CreAccountClass.cancel_handler(self,widget))
        
        decisionsBox = toga.Box(style=Pack(direction=ROW,padding=10))
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
        
        main_account_box = toga.Box(style=Pack(direction=COLUMN,padding=10))
        #main_account_box.add(accountnumbox)
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

    def submission_handler(self, accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText):
        # First we need to connect to the Database until we establish a persistent connection.
        # global inputColumn,input,inputValue
        #widget = self.app.widgets
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

        for key in accountsJson.items():
            # accountsJson[key]
            match key:
               # ACCOUNT_NUM will later be removed from processing. An update to it should fail anyhow due to key constraints.
               # case "ACCOUNT_NUM":
               # if accountsJson[key] is not None:
               #    accountsJson[key] = accountNumText
               # elif accountsJson[key] is None:
               #   raise Exception("You must provide an Account Number to Update.")
               # not necessary, we should never be updating the Account Num.
               # self._update_account_handler(key,input,accountsJson[key],accountsJson)

                case "ACCOUNT_HONORIFICS":

                    if accountHonorificsText is None:
                        value = 'NULL'
                    elif accountHonorificsText == 'NULL':
                        value = 'NULL'
                    elif accountHonorificsText is not None:
                        value = accountHonorificsText

                    json_processor += ({"ACCOUNT_HONORIFICS": value})

                case "ACCOUNT_FIRST_NAME":

                    if accountFNText is None:
                        value = 'NULL'
                    elif accountFNText == 'NULL':
                        value = 'NULL'
                    elif accountFNText is not None:
                        value = accountFNText

                    json_processor += ({"ACCOUNT_FIRST_NAME": value})

                case "ACCOUNT_LAST_NAME":

                    if accountLNText is None:
                        value = 'NULL'
                    elif accountLNText == 'NULL':
                        value = 'NULL'
                    elif accountLNText is not None:
                        value = accountLNText

                    json_processor += ({"ACCOUNT_LAST_NAME": value})

                case "ACCOUNT_SUFFIX":

                    if accountSuffixText is None:
                        value = 'NULL'
                    elif accountSuffixText == 'NULL':
                        value = 'NULL'
                    elif accountSuffixText is not None:
                        value = accountSuffixText

                    json_processor += ({"ACCOUNT_SUFFIX": value})

                case "ACCOUNT_STREET_ADD_1":

                    if accountStreetAdd1Text is None:
                        value = 'NULL'
                    elif accountStreetAdd1Text == 'NULL':
                        value = 'NULL'
                    elif value is not None:
                        value = accountStreetAdd1Text

                    json_processor += ({"ACCOUNT_STREET_ADD_1": value})

                case "ACCOUNT_STREET_ADD_2":

                    if accountStreetAdd2Text is None:
                        value = 'NULL'
                    elif accountStreetAdd2Text == 'NULL':
                        value = 'NULL'
                    elif value is not None:
                        value = accountStreetAdd2Text

                    json_processor += ({"ACCOUNT_STREET_ADD_2": value})

                case "ACCOUNT_CITY":

                    if accountCityText is None:
                        value = 'NULL'
                    elif accountCityText == 'NULL':
                        value = 'NULL'
                    elif accountCityText is not None:
                        value = accountCityText

                    json_processor += ({"ACCOUNT_CITY": value})

                case "ACCOUNT_STATE":

                    if accountStateText is None:
                        value = 'NULL'
                    elif accountStateText == 'NULL':
                        value = 'NULL'
                    elif accountStateText is not None:
                        value = accountStateText

                    json_processor += ({"ACCOUNT_STATE": value})

                case "ACCOUNT_ZIP":

                    if accountZIPText is None:
                        value = 'NULL'
                    elif accountZIPText == 'NULL':
                        value = 'NULL'
                    elif accountZIPText is not None:
                        value = accountZIPText

                    json_processor += ({"ACCOUNT_ZIP": value})

                case "ACCOUNT_PO_BOX":

                    if accountPOBoxText is None:
                        value = 'NULL'
                    elif accountPOBoxText == 'NULL':
                        value = 'NULL'
                    elif value is not None:
                        value = accountPOBoxText

                    json_processor += ({"ACCOUNT_PO_BOX": value})

                case "ACCOUNT_DATE_START":
                    if accountDateStartText is None:
                        value = 'NULL'
                    elif accountDateStartText == 'NULL':
                        value = 'NULL'
                    elif accountDateStartText is not None:
                        value = accountDateStartText

                    json_processor += ({"ACCOUNT_DATE_START": value})

                case "ACCOUNT_DATE_RENEWAL":

                    if accountDateRenewalText is None:
                        value = 'NULL'
                    elif accountDateRenewalText == 'NULL':
                        value = 'NULL'
                    elif value is not None:
                        value = accountDateRenewalText

                    # This is calculated by the MS SQL Server via DATEADD(YY,1,'YYYY-MM-DD')
                    #json_processor += ({"ACCOUNT_DATE_RENEWAL": value})

                case "ACCOUNT_TYPE":

                    if accountTypeText is None:
                        value = 'NULL'
                    elif accountTypeText == 'NULL':
                        value = 'NULL'
                    elif value is not None:
                        value = accountTypeText

                    json_processor += ({"ACCOUNT_TYPE": value})

                # case _:
                #     raise Exception("Invalid Entry Provided.")
                    
            return json_processor

    def cancel_handler(self,widget):
        # for window in list(self.windows):
        #     if not isinstance(window,toga.MainWindow):
        #         window.close()
        pass


class DeleteAccountClass:
    def __init__(self, cnxn, data, columns, widget):
        self.app = toga.App
        self.cnxn = cnxn
        self.data = data
        self.table = toga.Table
        self.columns = columns
        self.list_source = toga.sources.ListSource
        self.widget = self.app.widgets

    def deleteAccount(self, widget):
        accountnumbox = toga.Box(style=Pack(direction=ROW,padding=10))
        widget = self.app.widgets

        # label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))

        accountNumLabel = toga.Label(
            'Account Number', style=Pack(font_size=14))
        accountNumText = toga.TextInput(on_change=None,style=Pack(width=150,padding=10))

        deleteAccountButton = toga.Button('Delete Account', style=Pack(
            padding=5), on_press=self.delete_account_callback(self, widget, accountNumText))
        cancelAccountButton = toga.Button('Cancel Account', style=Pack(
            padding=5), on_press=self.cancel_handler(self,widget))
        
        main_account_box = toga.Box(style=Pack(direction=ROW,padding=10))
        
        decisions_box = toga.Box(style=Pack(direction=ROW,padding=10))
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
        initJson += ({"ACCOUNT_NUM":accountNumText})
        
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
        

    def cancel_handler(self,widget):
        #widget = self.app.widgets
        # for window in list(self.windows):
        #     if not isinstance(window,toga.MainWindow):
        #         window.close()
        #print(self)
        #print(widget)
        pass


snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

print("[ Top 10 ]")
for stat in top_stats[:10]:
    print(stat)


def main():
    return UpdAccountClass(), CreAccountClass(), DeleteAccountClass(), ValidationClass()
