# To run the program
simply run ./login.sh in the terminal

# Colors
I added colors to the program to make it look better. Coloring seems to work natively on linux and on Windows using the windows subsystem for linux, but colors may need to be enabled on Macs to work properly. See below.

# Enable colors on Macs
Edit your .bash_profile (since OS X 10.8) — or (for 10.7 and earlier): .profile or .bashrc or /etc/profile (depending on availability) — in your home directory and add following code:
```
export CLICOLOR=1
```
CLICOLOR=1 simply enables coloring of your terminal.
