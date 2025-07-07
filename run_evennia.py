#!/usr/bin/env python3
"""
Simple script to run Evennia from the development directory
"""
import sys
import os

# Add the evennia directory to Python path
evennia_path = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, evennia_path)

# Import and run Evennia launcher
from evennia.server.evennia_launcher import main

if __name__ == "__main__":
    main()
