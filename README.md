## Create a Minecraft Bedrock Server using Termux on Android

> [!IMPORTANT]
> To set up your Minecraft Bedrock Server, begin by downloading [Termux](https://f-droid.org/repo/com.termux_1000.apk). Once installed, launch Termux and allow it to complete the initial setup process. When ready, enter the following command and wait for it to complete. After that, enter this command bellow to setup your environment


```bash
bash <(curl -s https://raw.githubusercontent.com/euphoriys/bedrockserver/main/setup.sh)
```

> [!WARNING]
> The Minecraft Bedrock Dedicated Server is not natively designed for the ARM64 architecture found in most phones. To bridge this gap, we use [Box64](https://github.com/ptitSeb/box64) to translate the server from AMD64 to ARM64. Please note, this process may result in reduced performance and potential issues, with performance varying significantly depending on your device.

