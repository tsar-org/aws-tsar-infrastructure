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

1. ociのAPI Keyを発行

- API署名Key生成方法 <https://docs.oracle.com/ja-jp/iaas/Content/API/Concepts/apisigningkey.htm#two>
- `.env`に必要な情報を記述

    ```sh
    cp .env.example .env
    ```

- 秘密鍵を`./.oci`に配置

1. 環境立ち上げ

    ```sh
    task up
    ```

## `secret.enc.yaml`に情報を追加する方法

```sh
task es
```

## commit emoji

- <https://gitmoji.dev/>
