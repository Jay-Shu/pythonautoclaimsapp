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
    2024-08-27: Troubleshooting with tracemalloc.

Functions

https://stackoverflow.com/questions/66084762/call-function-from-another-file-without-import-clause

Author Notes:
    Our connection to MS SQL Server.
"""

import toga
import tracemalloc
from toga.style import Pack
from toga.style.pack import COLUMN, ROW
from pythonautoclaimsapp.customscript.dbfiles.ctmsqlserver import GetAccts

tracemalloc.start()


class PythonAutoClaimsApp(toga.App):
    def startup(self):
        main_box = toga.Box(style=Pack(direction=COLUMN))

        account_button = toga.Button(
            "Accounts",
            on_press=self.open_secondary,
            style=Pack(padding=5),
        )

        main_box.add(account_button)

        self.main_window = toga.MainWindow(title=self.formal_name)
        self.main_window.content = main_box
        self.main_window.show()

    def open_secondary(self, widget):
        try:
            t = GetAccts(widget)
            t.__match_args__(self)
            print(repr(t))
            GetAccts(widget)
            print("Getting Accounts")
        
        except Exception as ERROR:
            print(ERROR)


snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')

print("[ Top 10 ]")
for stat in top_stats[:10]:
    print(stat)


def main():
    return PythonAutoClaimsApp()