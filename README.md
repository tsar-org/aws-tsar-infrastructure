# aws-tsar-infrastructure

## Requirement

- docker(<https://www.docker.com/ja-jp/>)
- task(<https://taskfile.dev/installation/>)
- sops(<https://github.com/getsops/sops>)
- age(<https://github.com/FiloSottile/age>)
- vscode cli

## credentials setup

1. generate key pare by age

    ```sh
    mkdir -p age
    age-keygen -o age/keys.txt
    ```

    表示されたpublic keyを既に登録済みの人に共有する。

2. add generated public key to `secret.enc.yaml`

    ```sh
    sops updatekeys secret.enc.yaml
    ```

## How to Develop

1. `credentials setup`を行う

1. 環境立ち上げ

    ```sh
    task up
    ```

1. `.env`に必要な情報を記述

    ```text
    AWS_ACCESS_KEY_ID=""
    AWS_SECRET_ACCESS_KEY=""
    ```

## `secret.enc.yaml`に情報を追加する方法

```sh
task es
```

## commit emoji

- <https://gitmoji.dev/>
