# Vault -- Encrypt / Decrypt a folder (for macOS / Linux / UNIX)


## Usage:


### Setup
```
> ./setup.sh
Enter vault file: ~/google-drive/my_vault_folder/my.vault
Creating folder: /Users/me/google-drive/my_vault_folder/my.vault
Enter password:

Created initial vault contents at /tmp/vault.initial.mtFJNMf0
```

This is prompting for 2 things:
  - vault file: (e.g. `~/google-drive/my_vault_folder/my.vault`, can use TAB for autocomplete)
  - password: (e.g. `P@ssw0rd`, doesn't show on screen)

_**TIP:** It's a good idea to use a cloud-synced folder for the encrypted vault storage._


### Examine decrypted folder
```
> cd /tmp/vault.initial.mtFJNMf0
> ls -lR 
total 40
-rw-r--r--  1 pi  wheel   984  4 Jun 20:28 __decrypt.sh
-rw-r--r--  1 pi  wheel     9  4 Jun 20:28 __encrypted_filepath.txt
-rw-r--r--  1 pi  wheel     2  4 Jun 20:28 __password.txt
-rwxr-xr-x  1 pi  wheel  1902  4 Jun 20:28 encrypt
drwxr-xr-x  3 pi  wheel    96  4 Jun 20:28 files
-rw-r--r--  1 pi  wheel    53  4 Jun 20:28 init.sh

./files:
total 8
-rw-r--r--  1 pi  wheel  4  4 Jun 20:28 foo.txt
```

Your vault is in the `files/` folder

_Note that `setup.sh` creates `/usr/bin/local/decrypt` executable, and initial vault at specified filepath._


### Edit the `init.sh` file, if you wish
  This file will execute after every time you decrypt.
  The default is:
```
> cat init.sh
# Upon decryption, commands here will execute
open .
```
  On macOS, this will open `Finder` in the decompressed vault folder.  
  If you are running on another operating system, you  probably want to change this.


### Modify your vault contents
```
> cat files/foo.txt
bar
> echo quux >> files/foo.txt
> cat files/foo.txt
bar
quux
```


### Encrypt
```
> ./encrypt
Encrypted to /Users/me/google-drive/my_vault_folder/my.vault
```

**NOTE**: Remember that there will be a copy of `decrypt` in your `/usr/bin/local/` which should be in your path.  
For convenience, a copy is also placed alongside the encrypted vault file:
```
> ls /Users/me/google-drive/my_vault_folder/
decrypt my.vault
```


### Decrypt
```
> decrypt ~/google-drive/my_vault_folder/my.vault
/Users/me/google-drive/my_vault_folder
my.vault
enter aes-256-cbc decryption password:
Unpacked to: /tmp/vault.SSieXxCW
```


### Examine, modify files, etc.
```
> cat /tmp/vault.SSieXxCW/files/foo.txt
bar
quux
```
Rinse and repeat!

_**TIP:** Execute sensitive commands with preceding space, e.g.: ` decrypt my.vault` & they won't get stored in `~/.bash_history`_
    ([ref.](https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell))


# NOTES

## macOS

This works with `OpenSSL 1.1.1b  26 Feb 2019` installed at `/usr/local/anaconda3/bin/openssl`
It DOESN'T work with the `openssl` that ships with macOS
