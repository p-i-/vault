- edit enc.sh:
    ```
    STORE_FOLDER=/Users/pi/google-drive/vault/
    TIMESTAMP=201905251430.41
    ```

- `setup.sh`

SECURITY NOTE:
  Execute sensitive commands with preceding space, e.g.: " dec my_vault.raw"
    (https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell)


TODO:
- extern STORE_FOLDER  ??
- env -i HELLO=world bash  ??
- `st .`
- `cp vault.raw vault.raw.backup`
- handle wrong password!