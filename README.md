> [!NOTE]
> Create a Minecraft Bedrock Server using Termux on Android

> [!IMPORTANT]
> In order to create our Minecraft Bedrock Server we need to download [Termux](https://f-droid.org/repo/com.termux_1000.apk).
After installing Termux, open it and wait until it downloads all packages until you can enter commands.
When that finishes enter this command and wait until it finishes.
```bash
bash <(curl -s https://raw.githubusercontent.com/euphoriys/bedrockserver/main/setup.sh)
```
Now the download is done and we can use our Minecraft Bedrock Server.
> [!TIP]
> You can start the server with `startb`
>
> You can automatically start the server with `autostarb` incase the server crashes.
> 
> You can gain access to the server files using `storageb`

> [!WARNING]
> Because the Minecraft Bedrock Dedicated Server wasn't made for the specific CPU architecture for phones, we need to translate it. This can lead to slower performance and might cause some issues. We use [Box64](https://github.com/ptitSeb/box64) to translate the server from AMD64 to ARM64.
