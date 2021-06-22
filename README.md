# Pazz: the ultimate free & open source password manager for both team and individual

Pazz(previously called `passbase`) utilizes the inherent cryptographical methods of Keybase to store and access individual or team crendentials to be used in different circumstances. It's simple, lightweight and secure by nature.  

## architecture & user experience
```
(1) Create/Search/Update  +----------------+      (2) Store/Retrieve
           +------------->| SQLite3        |<------------+
           |              +----------------+             |
           |                                             |
           V                                             V
   +----------------+                             +----------------+
   | Pazz           |<------(Password)-------🔒---|  Keybase(KBFS) |
   +----------------+                             +----------------+
                        (3) Decrypt/Encrypt
```
## Usage

```
$ pazz [team name]

```

## UX & Workflow
- [x] Running on Linux(several distros), Mac and Windows via command line (Keybase runtime needed)
- [x] automatically check keybase/sqlite3 installation status and run them up if necessary
- [x] Use sqlite3 as DB to manage usernames and servcies entries
- [x] Interactive command line to create, search or update a password
- [x] Input or generate a password upon user's choice
- [x] Search in command line about one or multiple password/other secrets using fuzzy criterias
- [ ] Change a password
- [ ] Use keybase to decrypt the password artifact if user want to view it,can be copied to clipboard while viewing it
- [ ] Save password artifacts with keybase encryption saltpack, directly in sqlite ~~(too big?)~~
    ~~- [ ] create a new password entry in DB and point to saltpack file~~
- [ ] on Mobile devices (TBD)
