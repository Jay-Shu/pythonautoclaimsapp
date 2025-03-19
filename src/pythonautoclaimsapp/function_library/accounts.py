import sys
from PySide6.QtWidgets import QWidget,QVBoxLayout,QApplication,QLabel


class AccountsMenuClass(QWidget):
    def __init__(self,parent=None):
        super().__init__()

        # Create the central widget
        central_widget = QWidget()

        # Create a layout for the central widget
        layout = QVBoxLayout()
        
        # Add widgets to the layout
        layout.addWidget(QLabel("Hello, world!"))
        #layout.addWidget(QPushButton("Click me!"))

        # Set the layout to the central widget
        central_widget.setLayout(layout)

        # Set the central widget of the main window
        self.setCentralWidget(central_widget)

        # Set window properties (optional)
        self.setWindowTitle("My App")
        self.setGeometry(100, 100, 400, 300) # x, y, width, height
        self.show()