## Create a Minecraft Bedrock Server using Termux on Android

> [!IMPORTANT]
> To set up your Minecraft Bedrock Server, begin by downloading [Termux](https://f-droid.org/repo/com.termux_1000.apk). Once installed, launch Termux and allow it to complete the initial setup process. When ready, enter the following command and wait for it to complete.


```bash
bash <(curl -s https://raw.githubusercontent.com/euphoriys/bedrockserver/main/setup.sh)
```

> [!WARNING]
> Because the Minecraft Bedrock Dedicated Server wasn't made for the specific CPU architecture for phones, we need to translate it. This can lead to slower performance and might cause some issues. We use [Box64](https://github.com/ptitSeb/box64) to translate the server from AMD64 to ARM64.
