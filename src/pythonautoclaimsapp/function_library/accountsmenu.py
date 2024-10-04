from pythonautoclaimsapp.function_library.accountsactions import *
from pythonautoclaimsapp.function_library.accountsmenu import *
from pythonautoclaimsapp.function_library.accounts import *
from toga.style.pack import COLUMN, ROW, CENTER
from toga.style import Pack
import toga.sources
import tracemalloc
import toga
import time
import logging
logger = logging.getLogger(__name__)


tracemalloc.start()


class AccountsMenuClass:
    def __init__(self, cnxn, data, columns):
        self.app = toga.App
        self.cnxn = cnxn
        self.data = data
        self.table = toga.Table
        self.columns = columns
        self.list_source = toga.sources.ListSource

    def accountsMenu(self, widget):
        accountsmenu = toga.Box(style=Pack(direction=COLUMN))

        # label = toga.Label('Accounts Results',style=Pack(padding=10,font_size=14))
        getAccountsButton = toga.Button('Get Accounts', style=Pack(
            padding=5), on_press=AccountsMenuClass._get_accounts_callback)
        updateAccountButton = toga.Button('Update Account', style=Pack(
            padding=5), on_press=AccountsMenuClass._update_account_callback)
        createAccountButton = toga.Button('Create Account', style=Pack(
            padding=5), on_press=AccountsMenuClass._create_account_callback)
        deleteAccountsButton = toga.Button('Delete Account', style=Pack(
            padding=5), on_press=AccountsMenuClass._delete_account_callback)

        accountsmenu.add(getAccountsButton)
        accountsmenu.add(updateAccountButton)
        accountsmenu.add(createAccountButton)
        accountsmenu.add(deleteAccountsButton)

        self.account_window = toga.Window(title="Accounts Menu")
        self.account_window.content = accountsmenu

        return self.account_window.show()

    def _get_accounts_callback(self, widget):
        # Stage for Menu
        # Needs the correct pieces
        # Refactor of this later is needed.
        AccountsClass.accounts_secondary_box(self, widget)

    def _update_account_callback(self, widget):
        # Stage for Menu
        # Needs the correct pieces
        UpdAccountClass.updateAccount(self, widget)

    def _create_account_callback(self, widget):
        # Stage for Menu
        # Needs the correct pieces
        CreAccountClass.createAccount(self, widget)

    def _delete_account_callback(self, widget):
        # Stage for Menu
        # Needs the correct pieces
        DeleteAccountClass.deleteAccount(self, widget)


snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

print("[ Top 10 ]")
for stat in top_stats[:10]:
    print(stat)


def main():
    return AccountsMenuClass()
