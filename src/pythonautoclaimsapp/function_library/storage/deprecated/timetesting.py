# -*- coding: utf-8 -*-
import toga

import time

class nothing(toga.App):
    def startup(self):
        self.main_window = toga.MainWindow()
        self.main_window.content = toga.Box()
        
        self.label = toga.Label("?")
        self.main_window.content.add(self.label)

        # execute first time without delay
        #self.loop.call_soon(self.change, self.label)
        #self.loop.call_later(0, self.change, self.label)
        self.change()
        
        self.main_window.show()

    def change(self):
        # if code needs more time then better set next execution first
        self.loop.call_later(1, self.change)
    
        self.label.text = time.strftime('%Y.%m.%d %H.%M.%S')

        
if __name__ == '__main__':
    app = nothing("Timer", "org.beeware.toga.tutorial")
    app.main_loop()  