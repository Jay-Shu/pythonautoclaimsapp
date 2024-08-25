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
#import sys
#sys.path.app.parent("E:/scripts/python/pythonautoclaimsapp/src/pythonautoclaimsapp/")
#sys.path.append("dbfiles")

#import importlib
#connecttomssqlserver = importlib.import_module("ctmsqlserver")

import toga
from toga.style import Pack
from toga.style.pack import COLUMN, ROW
from pythonautoclaimsapp.customscript.dbfiles.ctmsqlserver import connect


class pythonautoclaimsapp(toga.App):
    def startup(self):
        main_box = toga.Box(style=Pack(direction=COLUMN))

        #name_label = toga.Label(
        #    "Your name: ",
        #    style=Pack(padding=(0, 5)),
        #)
        #self.name_input = toga.TextInput(style=Pack(flex=1))

        #name_box = toga.Box(style=Pack(direction=ROW, padding=5))
        #name_box.add(name_label)
        #name_box.add(self.name_input)
        
        # Each of these buttons will need to open a new Window.
        # This is to reduce clutter and as such, be separate files as well.
        
        button = toga.Button(
            "Accounts",
            on_press=self.ctdb,
            style=Pack(padding=5),
        )

        button2 = toga.Button(
            "Vehicles",
            on_press=self.ctdb,
            style=Pack(padding=5),
        )

        button3 = toga.Button(
            "Homes",
            on_press=self.ctdb,
            style=Pack(padding=5),
        )

        button4 = toga.Button(
            "Policies",
            on_press=self.ctdb,
            style=Pack(padding=5),
        )

        button5 = toga.Button(
            "Vehicle Coverages",
            on_press=self.ctdb,
            style=Pack(padding=5),
        )

        button6 = toga.Button(
            "Vehicle Claims",
            on_press=self.ctdb,
            style=Pack(padding=5),
        )

        #main_box.add(name_box)
        main_box.add(button)
        main_box.add(button2)
        main_box.add(button3)
        main_box.add(button4)
        main_box.add(button5)
        main_box.add(button6)
        
        
        #self.formal_name="Python Auto Claims App"
        self.main_window = toga.MainWindow(title=self.formal_name)
        self.main_window.content = main_box
        self.main_window.show()

#    def say_hello(self, widget):
#       print(f"Hello, {self.name_input.value}")
     
    def ctdb():
        connect()
        #print("Initializing Connection...")

def main():
    return pythonautoclaimsapp("Python Auto Claims App","com.self.published")
