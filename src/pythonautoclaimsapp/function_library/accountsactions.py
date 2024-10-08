from pythonautoclaimsapp.function_library.vehicleclaims import *
from pythonautoclaimsapp.function_library.vehiclecoverages import *
from pythonautoclaimsapp.function_library.policies import *
from pythonautoclaimsapp.function_library.homes import *
from pythonautoclaimsapp.function_library.vehicles import *
from pythonautoclaimsapp.function_library.accounts import *
from toga.sources import ListSource
from toga.style.pack import COLUMN, ROW, CENTER
from toga.style import Pack
import toga.sources
import tracemalloc
import toga
import time
import json
import logging
import pyodbc

import toga.validators

logger = logging.getLogger(__name__)


tracemalloc.start()
"""
This function is intended for Updating a singular account.
Batch updating can be a later feature.
"""
class ValidationClass():
    def __init__(self,app,accouuntVal,substring,min_length,max_length,data_type,value):
        self.app = app
        self.accouuntVal = accouuntVal
        self.substring = substring
        self.min_length = min_length
        self.max_length = max_length
        self.data_type = data_type
        self.value = value
        
    def validate_account_length(accouuntVal, min_length=11, max_length=11):
        
        substring = accouuntVal[3:]
        if not (min_length <= len(accouuntVal) <= max_length):
            raise ValueError(f"Value must be between {min_length} and {max_length} characters long.")   
        else:
            if substring == "ICA":
                raise ValueError(f"Value must contain the substring '{substring}'.")
            else:
                return True
            
    def validate_data_type(accouuntVal, data_type):
        #self.accountVal = accountVal
        if not isinstance(accouuntVal, data_type):
            raise TypeError(f"Value must be of type {data_type.__name__}.")
        else:
            return True
        
    
    def validate_length(accouuntVal, min_length, max_length):
        #self.accountVal = accountVal
        if not (min_length <= len(accouuntVal) <= max_length):
            raise ValueError(f"Value must be between {min_length} and {max_length} characters long.")   
        
        else:
            return True



class UpdAccountClass:
    def __init__(self, cnxn, data, columns,accountsJson,key):
        self.app = toga.App
        self.cnxn = cnxn
        self.data = data
        self.table = toga.Table
        self.columns = columns
        self.list_source = toga.sources.ListSource
        self.accountsJson = accountsJson
        self.key = key
        
    def _cancel_handler(self):
        return self.account_window.close()
        pass

    def _update_account_handler(inputColumn, input, inputValue, accountsJson):
        # input is
        if input == True:
            inputValue = 'NULL'
        elif input == False:
            logging.debug("No Change in Input Value")
            inputValue = inputValue
            pass

        if inputColumn in accountsJson:
            accountsJson[inputColumn] = inputValue

        return accountsJson
        pass
        
    def _submission_handler(self, accountsJson, accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText, accountHonorificsSwitch, accountFNSwitch, accountLNSwitch, accountSuffixSwitch, accountStreetAdd1Switch, accountStreetAdd2Switch, accountCitySwitch, accountStateSwitch, accountZIPSwitch, accountPOBoxSwitch, accountDateStartSwitch, accountDateRenewalSwitch, accountTypeSwitch):
        # First we need to connect to the Database until we establish a persistent connection.
        # global inputColumn,input,inputValue
        #Beginning of For-Loop
        for key in accountsJson:
            #accountsJson[key]
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
                    if accountHonorificsSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountHonorificsText

                    self._update_account_handler(
                        key, accountHonorificsSwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_FIRST_NAME":
                    if accountFNSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountFNText

                    self._update_account_handler(
                        key, accountFNSwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_LAST_NAME":
                    if accountLNSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountLNText

                    self._update_account_handler(
                        key, accountLNSwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_SUFFIX":
                    if accountSuffixSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountSuffixText

                    self._update_account_handler(
                        key, accountSuffixSwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_STREET_ADD_1":
                    if accountStreetAdd1Switch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountStreetAdd1Text

                    self._update_account_handler(
                        key, accountStreetAdd1Switch, accountsJson[key], accountsJson)

                case "ACCOUNT_STREET_ADD_2":
                    if accountStreetAdd2Switch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountStreetAdd2Text

                    self._update_account_handler(
                        key, accountStreetAdd2Switch, accountsJson[key], accountsJson)

                case "ACCOUNT_CITY":
                    if accountCitySwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountCityText

                    self._update_account_handler(
                        key, accountCitySwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_STATE":
                    if accountStateSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountStateText

                    self._update_account_handler(
                        key, accountStateSwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_ZIP":
                    if accountZIPSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountZIPText

                    self._update_account_handler(
                        key, accountZIPSwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_PO_BOX":
                    if accountPOBoxSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountPOBoxText

                    self._update_account_handler(
                        key, accountPOBoxSwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_DATE_START":
                    if accountDateStartSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountDateStartText

                    self._update_account_handler(
                        key, accountDateStartSwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_DATE_RENEWAL":
                    if accountDateRenewalSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountDateRenewalText

                    self._update_account_handler(
                        key, accountDateRenewalSwitch, accountsJson[key], accountsJson)

                case "ACCOUNT_TYPE":
                    if accountTypeSwitch == True:
                       accountsJson[key] = 'Null'

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                    elif accountsJson[key] == 'NULL':
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountTypeText

                    self._update_account_handler(
                        key, accountTypeSwitch, accountsJson[key], accountsJson)

                case _:
                    raise Exception("Invalid Entry Provided.")

        cnxn = pyodbc.connect(
            'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
        cnxn.setencoding('utf-8')
        cursor = cnxn.cursor()  # Cursor is necessary for it to function properly
        # This will be updated to it's respective file's needs.
        cursor.execute("{CALL paca.updateAccounts_v1 (?)}", accountsJson)
        cursor.close()
        cnxn.close()
        self.account_window.close()
        
    def updateAccount(self, widget):
        accountsmenu = toga.Box(style=Pack(direction=COLUMN))
        widget = self.app.widgets
        test_enabled = True
        """
        We need to build our initial json for updating later.
        """
        accountsJson = {"ACCOUNT_NUM": "", "ACCOUNT_HONORIFICS": "", "ACCOUNT_FIRST_NAME": "", "ACCOUNT_LAST_NAME": "", "ACCOUNT_SUFFIX": "", "ACCOUNT_STREET_ADD_1": "",
                        "ACCOUNT_STREET_ADD_2": "", "ACCOUNT_CITY": "", "ACCOUNT_STATE": "", "ACCOUNT_ZIP": "", "ACCOUNT_PO_BOX": "", "ACCOUNT_DATE_START": "", "ACCOUNT_DATE_RENEWAL": "", "ACCOUNT_TYPE": ""}

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
        accountNumLabel = toga.Label('Account Number', style=Pack(font_size=14))
        accountHonorificsLabel = toga.Label(
            'Account Honorifics', style=Pack(font_size=14))
        accountFNLabel = toga.Label('Account First Name', style=Pack(font_size=14))
        accountLNLabel = toga.Label('Account Last Name', style=Pack(font_size=14))
        accountSuffixLabel = toga.Label('Account Suffix', style=Pack(font_size=14))
        accountStreetAdd1Label = toga.Label(
            'Account Street Address 1', style=Pack(font_size=14))
        accountStreetAdd2Label = toga.Label(
            'Account Street Address 2', style=Pack(font_size=14))
        accountCityLabel = toga.Label('Account City', style=Pack(font_size=14))
        accountStateLabel = toga.Label('Account State', style=Pack(font_size=14))
        accountZIPLabel = toga.Label('Account ZIP', style=Pack(font_size=14))
        accountPOBoxLabel = toga.Label('Account PO Box', style=Pack(font_size=14))
        accountDateStartLabel = toga.Label(
            'Account Date Start', style=Pack(font_size=14))
        accountDateRenewalLabel = toga.Label(
            'Account Date Renewal', style=Pack(font_size=14))
        accountTypeLabel = toga.Label('Account Type', style=Pack(font_size=14))
        
        """
        This section is intended only during the developmental phase.
        
        
        """
        if test_enabled == True:
            accountNumText = toga.TextInput(on_change=None)  # This must be supplied.
            accountHonorificsText = toga.TextInput(on_change=None)
            accountFNText = toga.TextInput(on_change=None)
            accountLNText = toga.TextInput(on_change=None)
            accountSuffixText = toga.TextInput(on_change=None)
            accountStreetAdd1Text = toga.TextInput(on_change=None)
            accountStreetAdd2Text = toga.TextInput(on_change=None)
            accountCityText = toga.TextInput(on_change=None)
            accountStateText = toga.TextInput(on_change=None)
            accountZIPText = toga.TextInput(on_change=None) # This needs to incorporate the isinstanceof(value,dict)
            accountPOBoxText = toga.TextInput(on_change=None)
            accountDateStartText = toga.TextInput(on_change=None)
            accountDateRenewalText = toga.TextInput(on_change=None)
            accountTypeText = toga.TextInput(on_change=None)
        else:
            accountNumText = toga.TextInput(validators=[ValidationClass.validate_account_length()],on_change=None)  # This must be supplied.
            accountHonorificsText = toga.TextInput(validators=[ValidationClass.validate_length(0,16)],on_change=None)
            accountFNText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
            accountLNText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
            accountSuffixText = toga.TextInput(validators=[ValidationClass.validate_length(0,16)],on_change=None)
            accountStreetAdd1Text = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
            accountStreetAdd2Text = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
            accountCityText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
            accountStateText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
            accountZIPText = toga.TextInput(validators=[ValidationClass.validate_data_type(int())]) # This needs to incorporate the isinstanceof(value,dict)
            accountPOBoxText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
            accountDateStartText = toga.TextInput(validators=[ValidationClass.validate_length(0,32)],on_change=None)
            accountDateRenewalText = toga.TextInput(validators=[ValidationClass.validate_length(0,32)],on_change=None)
            accountTypeText = toga.TextInput(validators=[ValidationClass.validate_length(0,64)],on_change=None)
            

        # We need to pass our value of False or True onto the next part. A def will be required for updating these properly each.
        # accountNumSwitch = toga.Switch('Null?',style=Pack(font_size=14),value=False,on_change=self._update_account_handler('ACCOUNT_NUM',accountNumText,accountsJson))
        
        """
        This section is for setting the NULLs
        """
        accountHonorificsSwitch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)
        accountFNSwitch = toga.Switch('Null?', style=Pack(
            font_size=14), value=False, on_change=None)
        accountLNSwitch = toga.Switch('Null?', style=Pack(
            font_size=14), value=False, on_change=None)
        accountSuffixSwitch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)
        accountStreetAdd1Switch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)
        accountStreetAdd2Switch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)
        accountCitySwitch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)
        accountStateSwitch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)
        accountZIPSwitch = toga.Switch('Null?', style=Pack(
            font_size=14), value=False, on_change=None)
        accountPOBoxSwitch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)
        accountDateStartSwitch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)
        accountDateRenewalSwitch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)
        accountTypeSwitch = toga.Switch(
            'Null?', style=Pack(font_size=14), value=False, on_change=None)

        accountsmenu.add(accountNumLabel)
        accountsmenu.add(accountNumText)
        accountsmenu.add(accountHonorificsLabel)
        accountsmenu.add(accountHonorificsText)
        accountsmenu.add(accountHonorificsSwitch)
        accountsmenu.add(accountFNLabel)
        accountsmenu.add(accountFNText)
        accountsmenu.add(accountFNSwitch)
        accountsmenu.add(accountLNLabel)
        accountsmenu.add(accountLNText)
        accountsmenu.add(accountLNSwitch)
        accountsmenu.add(accountSuffixLabel)
        accountsmenu.add(accountSuffixText)
        accountsmenu.add(accountSuffixSwitch)
        accountsmenu.add(accountStreetAdd1Label)
        accountsmenu.add(accountStreetAdd1Text)
        accountsmenu.add(accountStreetAdd1Switch)
        accountsmenu.add(accountStreetAdd2Label)
        accountsmenu.add(accountStreetAdd2Text)
        accountsmenu.add(accountStreetAdd2Switch)
        accountsmenu.add(accountCityLabel)
        accountsmenu.add(accountCityText)
        accountsmenu.add(accountCitySwitch)
        accountsmenu.add(accountStateLabel)
        accountsmenu.add(accountStateText)
        accountsmenu.add(accountStateSwitch)
        accountsmenu.add(accountZIPLabel)
        accountsmenu.add(accountZIPText)
        accountsmenu.add(accountZIPSwitch)
        accountsmenu.add(accountPOBoxLabel)
        accountsmenu.add(accountPOBoxText)
        accountsmenu.add(accountPOBoxSwitch)
        accountsmenu.add(accountDateStartLabel)
        accountsmenu.add(accountDateStartText)
        accountsmenu.add(accountDateStartSwitch)
        accountsmenu.add(accountDateRenewalLabel)
        accountsmenu.add(accountDateRenewalText)
        accountsmenu.add(accountDateRenewalSwitch)
        accountsmenu.add(accountTypeLabel)
        accountsmenu.add(accountTypeText)
        accountsmenu.add(accountTypeSwitch)

        submitButton = toga.Button('Submit', style=Pack(padding=5), on_press=self._submission_handler(self, accountsJson, accountNumText, accountHonorificsText, accountFNText, accountLNText, accountSuffixText,
                                   accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText))
        cancelButton = toga.Button('Cancel', style=Pack(
            padding=5), on_press=self._cancel_handler(widget))

        accountsmenu.add(submitButton)
        accountsmenu.add(cancelButton)

        self.account_window = toga.Window(title="Accounts Menu")
        self.account_window.content = accountsmenu

        return self.account_window.show()

    
    


class CreAccountClass:
   def __init__(self, cnxn, data, columns):
      self.app = toga.App
      self.cnxn = cnxn
      self.data = data
      self.table = toga.Table
      self.columns = columns
      self.list_source = toga.sources.ListSource

   def createAccount(self, widget):
      test_enabled = True
      accountsmenu = toga.Box(style=Pack(direction=COLUMN))
      widget = self.app.widgets

      # label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))

      #accountNumLabel = toga.Label('Account Number', style=Pack(font_size=14))
      accountHonorificsLabel = toga.Label(
          'Account Honorifics', style=Pack(font_size=14))
      accountFNLabel = toga.Label('Account First Name', style=Pack(font_size=14))
      accountLNLabel = toga.Label('Account Last Name', style=Pack(font_size=14))
      accountSuffixLabel = toga.Label('Account Suffix', style=Pack(font_size=14))
      accountStreetAdd1Label = toga.Label(
          'Account Street Address 1', style=Pack(font_size=14))
      accountStreetAdd2Label = toga.Label(
          'Account Street Address 2', style=Pack(font_size=14))
      accountCityLabel = toga.Label('Account City', style=Pack(font_size=14))
      accountStateLabel = toga.Label('Account State', style=Pack(font_size=14))
      accountZIPLabel = toga.Label('Account ZIP', style=Pack(font_size=14))
      accountPOBoxLabel = toga.Label('Account PO Box', style=Pack(font_size=14))
      accountDateStartLabel = toga.Label(
          'Account Date Start', style=Pack(font_size=14))
      accountDateRenewalLabel = toga.Label(
          'Account Date Renewal', style=Pack(font_size=14))
      accountTypeLabel = toga.Label('Account Type', style=Pack(font_size=14))

      if test_enabled == True:
          # We do not supply an Account Number as the system back-end will create this for us.
          # Maintaining accuracy and processing CHECKIDENT() will be necessary at this current time (2024-10-05)
          #accountNumText = toga.TextInput(on_change=None)  # This must be supplied.
      
          accountHonorificsText = toga.TextInput(on_change=None)
          accountFNText = toga.TextInput(on_change=None)
          accountLNText = toga.TextInput(on_change=None)
          accountSuffixText = toga.TextInput(on_change=None)
          accountStreetAdd1Text = toga.TextInput(on_change=None)
          accountStreetAdd2Text = toga.TextInput(on_change=None)
          accountCityText = toga.TextInput(on_change=None)
          accountStateText = toga.TextInput(on_change=None)
          accountZIPText = toga.TextInput(on_change=None) # This needs to incorporate the isinstanceof(value,dict)
          accountPOBoxText = toga.TextInput(on_change=None)
          accountDateStartText = toga.TextInput(on_change=None)
          accountDateRenewalText = toga.TextInput(on_change=None)
          accountTypeText = toga.TextInput(on_change=None)
      else:
          #accountNumText = toga.TextInput(validators=[ValidationClass.validate_account_length()],on_change=None)  # This must be supplied.
      
          accountHonorificsText = toga.TextInput(validators=[ValidationClass.validate_length(0,16)],on_change=None)
          accountFNText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
          accountLNText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
          accountSuffixText = toga.TextInput(validators=[ValidationClass.validate_length(0,16)],on_change=None)
          accountStreetAdd1Text = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
          accountStreetAdd2Text = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
          accountCityText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
          accountStateText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
          accountZIPText = toga.TextInput(validators=[ValidationClass.validate_data_type(int())]) # This needs to incorporate the isinstanceof(value,dict)
          accountPOBoxText = toga.TextInput(validators=[ValidationClass.validate_length(0,128)],on_change=None)
          accountDateStartText = toga.TextInput(validators=[ValidationClass.validate_length(0,32)],on_change=None)
          accountDateRenewalText = toga.TextInput(validators=[ValidationClass.validate_length(0,32)],on_change=None)
          accountTypeText = toga.TextInput(validators=[ValidationClass.validate_length(0,64)],on_change=None)


      #accountsmenu.add(accountNumLabel)
      #accountsmenu.add(accountNumText)
      # accountsmenu.add(accountNumSwitch)
      accountsmenu.add(accountHonorificsLabel)
      accountsmenu.add(accountHonorificsText)
      accountsmenu.add(accountFNLabel)
      accountsmenu.add(accountFNText)
      accountsmenu.add(accountLNLabel)
      accountsmenu.add(accountLNText)
      accountsmenu.add(accountSuffixLabel)
      accountsmenu.add(accountSuffixText)
      accountsmenu.add(accountStreetAdd1Label)
      accountsmenu.add(accountStreetAdd1Text)
      accountsmenu.add(accountStreetAdd2Label)
      accountsmenu.add(accountStreetAdd2Text)
      accountsmenu.add(accountCityLabel)
      accountsmenu.add(accountCityText)
      accountsmenu.add(accountStateLabel)
      accountsmenu.add(accountStateText)
      accountsmenu.add(accountZIPLabel)
      accountsmenu.add(accountZIPText)
      accountsmenu.add(accountPOBoxLabel)
      accountsmenu.add(accountPOBoxText)
      accountsmenu.add(accountDateStartLabel)
      accountsmenu.add(accountDateStartText)
      accountsmenu.add(accountDateRenewalLabel)
      accountsmenu.add(accountDateRenewalText)
      accountsmenu.add(accountTypeLabel)
      accountsmenu.add(accountTypeText)

      submitButton = toga.Button('Submit', style=Pack(
          padding=5), on_press=self._update_account_callback(widget))
      cancelButton = toga.Button('Cancel', style=Pack(
          padding=5), on_press=self._cancel_handler(widget))
      accountsmenu.add(submitButton)
      accountsmenu.add(cancelButton)

      self.account_window = toga.Window(title="Accounts Menu")
      self.account_window.content = accountsmenu

      return self.account_window.show()

   def _submission_handler(self, accountsJson, accountHonorificsText, accountFNText, accountLNText, accountSuffixText, accountStreetAdd1Text, accountStreetAdd2Text, accountCityText, accountStateText, accountZIPText, accountPOBoxText, accountDateStartText, accountDateRenewalText, accountTypeText):
       # First we need to connect to the Database until we establish a persistent connection.
       # global inputColumn,input,inputValue

       for key in accountsJson:
           #accountsJson[key]
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

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountHonorificsText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_FIRST_NAME":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountFNText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_LAST_NAME":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountLNText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_SUFFIX":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountSuffixText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_STREET_ADD_1":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountStreetAdd1Text
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_STREET_ADD_2":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountStreetAdd2Text
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_CITY":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountCityText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_STATE":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountStateText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_ZIP":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountZIPText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_PO_BOX":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountPOBoxText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_DATE_START":
                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountDateStartText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_DATE_RENEWAL":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountDateRenewalText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case "ACCOUNT_TYPE":

                    if accountsJson[key] is None:
                       accountsJson[key] = 'NULL'
                       tempKey = True
                    elif accountsJson[key] == 'NULL':
                       tempKey = True
                       pass
                    elif accountsJson[key] is not None:
                       accountsJson[key] = accountTypeText
                       tempKey = False

                    self._update_account_handler(
                        key, tempKey, accountsJson[key], accountsJson)

               case _:
                    raise Exception("Invalid Entry Provided.")

   def _update_account_handler(inputColumn, input, inputValue, accountsJson):
      # input is boolean
      if input == True:
          inputValue = 'NULL'
      elif input == False:
          logging.debug("No Change in Input Value")
          inputValue = inputValue
          pass

      if inputColumn in accountsJson:
          accountsJson[inputColumn] = inputValue

      return accountsJson

   def _cancel_handler(self,widget):
      self.account_window.close()
      pass


class DeleteAccountClass:
   def __init__(self, cnxn, data, columns):
      self.app = toga.App
      self.cnxn = cnxn
      self.data = data
      self.table = toga.Table
      self.columns = columns
      self.list_source = toga.sources.ListSource

   def deleteAccount(self, widget):
      accountsmenu = toga.Box(style=Pack(direction=COLUMN))
      widget = self.app.widgets
      
      initJson = {"ACCOUNT_NUM":""}
      
      
      # label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))
      
     
      accountNumLabel = toga.Label('Account Number', style=Pack(font_size=14))
      accountNumText = toga.TextInput(on_change=None)
      
      accountsmenu.add(accountNumLabel)
      accountsmenu.add(accountNumText)
      
      deleteAccountButton = toga.Button('Delete Account', style=Pack(
          padding=5), on_press=self._delete_account_callback(self,widget,initJson,accountNumText))
      cancelAccountButton = toga.Button('Cancel Account', style=Pack(
          padding=5), on_press=self._cancel_handler(self,widget))
      
      accountsmenu.add(deleteAccountButton)
      accountsmenu.add(cancelAccountButton)

      self.account_window = toga.Window(title="Delete Account Menu")
      self.account_window.content = accountsmenu

      return self.account_window.show()
  
    
   
   def _update_account_handler(inputValue, accountsJson):
      if "ACCOUNT_NUM" in accountsJson:
         accountsJson["ACCOUNT_NUM"] = inputValue
    
      return accountsJson

  
   def _delete_account_callback(self,widget,initJson,accountNumText):
      widget = self.app.widgets
      tempJson = self._update_account_handler(initJson,accountNumText)
      
      cnxn = pyodbc.connect(
       'DRIVER={ODBC Driver 17 for SQL Server};SERVER=127.0.0.1;DATABASE=PACA;UID=pacauser;PWD=pacauser;TrustServerCertificate=YES;Encrypt=YES', autocommit=True)
      cnxn.setencoding('utf-8')
      cursor = cnxn.cursor()  # Cursor is necessary for it to function properly
   # This will be updated to it's respective file's needs.
      cursor.execute("{CALL paca.removeAccount_v1 (?)}", tempJson)
      cursor.close()
      cnxn.close()
      return self.account_window.close()

   def _cancel_handler(self,widget):
      return self.account_window.close()
      pass

snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

print("[ Top 10 ]")
for stat in top_stats[:10]:
    print(stat)


def main():
    return UpdAccountClass(), CreAccountClass(), DeleteAccountClass(),ValidationClass()