# **Database Documentation**

### This document describes some general information about the database and the functions that are available.
---
---
## Table of Contents:
1. [Database Functions](#database-functions)
    1. [insert_User](#insert_user)
---

## *Database Functions:*

## ***insert_User***

### Description:
#### This function inserts a new user into the database.
## Usage:
#### `SELECT insert_User('username', 'password');`
### Parameters:
- `username` - The username of the user.
- `password` - The password of the user.
### Returns:
- `0` - If the user was successfully inserted.
- `1` - If the user was not successfully inserted (the user already exists).


