"""
Python Auto Claims app - Simple. Intended for interactions with an MS SQL DB.

In it's current state the Python side has not yet been started. Therefaore, in it's base form.

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
    2024-08-21: Updated references for the connecttomssqlserver. Still pending resolution of
        resolving.

Functions

https://stackoverflow.com/questions/66084762/call-function-from-another-file-without-import-clause

Author Notes:
    Our connection to MS SQL Server.
"""

import toga
from toga.style import Pack
from toga.style.pack import COLUMN, ROW
from pythonautoclaimsapp.customscript.dbfiles.ctmsqlserver import get_accts


class pythonautoclaimsapp(toga.App):
    def open_secondary(self,widget):
        get_accts(self.main_window)
        
    def startup(self):
        main_box = toga.Box(style=Pack(direction=COLUMN))
        
        button = toga.Button(
            "Accounts",
            on_press=self.open_secondary,
            style=Pack(padding=5),
        )
        
        main_box.add(button)
        
        self.main_window = toga.MainWindow(title=self.formal_name)
        self.main_window.content = main_box
        self.main_window.show()

def main():
    return pythonautoclaimsapp()
