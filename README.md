# architecture & user experience of keybase-based password manager for individual and/or team


(1) Search/Create/Update  +----------------+      (2) Store/Retrieve
           +------------->| SQLite3        |-------------+
           |              +----------------+             |
           |                                             |
           |                                             V
   +----------------+                             +----------------+
   | Passbase       |<------🔒(Password)----------|  Keybase(KBFS) |
   +----------------+                             +----------------+
                        (3) Decrypt/Encrypt

- automatically check keybase/sqlite3 installation status and run them up if necessary
- save password artifacts with keybase encryption saltpack or directly in sqlite (too big?)
- use sqlite3 as DB to manage usernames and servcies entries
- create a new password entry in DB and point to saltpack file
- use keybase to decrypt the password artifact if user want to view it, will be copied to clipboard
- search in command line about one or multiple password/other secrets using fuzzy criterias
- change a password or generate a password automatically
