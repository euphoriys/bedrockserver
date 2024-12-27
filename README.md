<div align="center">
  <h1 align="center">Bedrux</h2>
  <h3>Create a Minecraft Bedrock Server using Termux on Android</h3>
</div>

## ⚡Getting Started
> [!IMPORTANT]
> To set up your Minecraft Bedrock Server, begin by downloading [Termux](https://f-droid.org/repo/com.termux_1000.apk). Once installed, launch Termux and allow it to complete the initial setup process. When ready, enter the following command and wait for it to complete. After that, enter this command bellow to setup your environment.
> ```bash
> bash <(curl -s https://raw.githubusercontent.com/euphoriys/bedrockserver/main/setup.sh)
> ```

## Starting your Server
You can start the server with **`./start.sh`** or start it with **`./autostart.sh`** in the **`bedrock-server`** directory.

## 💡 Important Notes
### ARM64 Compatibility
The Minecraft Bedrock Dedicated Server is not originally designed for ARM64 architecture, which is common in most Android phones. To make this work, we utilize [Box64](https://github.com/ptitSeb/box64) to translate the server from AMD64 to ARM64.

> [!WARNING]
> Although this translation works, be aware that the performance may be reduced, and some issues may arise. The server’s performance will vary heavily depending on your device’s specifications.

## 🌟 Why Bedrux?
Bedrux is a easy to use solution for running Minecraft Bedrock Dedicated Servers directly on your Android device, using Termux as the backbone. This saves you much work and time by installing everything that is needed for your Server hosting. Experience the fun of Minecraft without the need for a traditional PC or cloud hosting. You have full control of everything.

## 📚 Additional Resources
- [Termux Wiki](https://wiki.termux.com/wiki/Main_Page)
- [Box64 GitHub](https://github.com/ptitSeb/box64)
- [Minecraft Bedrock Dedicated Server](https://www.minecraft.net/de-de/download/server/bedrock)

### For any questions or issues, please open an issue on this repository. I'm here to help!
