# pawn-android-toolchain
Develop, edit, and compile Pawn scripts directly on your Android device using the powerful combination of Termux and Acode.

![view](https://raw.githubusercontent.com/neetoons/pawn-android-toolchain/main/view.gif)

---
# Setup Guide

## Installation Prerequisite: F-Droid

For the best experience and to ensure you have the most up-to-date versions of the required tools, we strongly recommend using [F-Droid](https://f-droid.org/F-Droid.apk).

Recommendation: Install the [F-Droid](https://f-droid.org/F-Droid.apk) client first, and then install Termux and Acode directly from the F-Droid store.

## Required applications 

* [Termux](https://f-droid.org/en/packages/com.termux/): This is the terminal emulator that provides a powerful Linux environment on your device. It hosts the Pawn compiler and the server required for communication.
* [Acode](https://f-droid.org/en/packages/com.foxdebug.acode/): This is the primary code editor you will use to write and manage your projects. 
* [AcodeX - Terminal](https://acode.app/plugin/bajrangcoder.acodex): Acode plugin which enables the connection to the Termux server, allowing you to run compilation commands directly from your editor.

> ⚠️ Permissions Note 
During the setup process, if any application (especially Termux or Acode) asks for file access permissions to your storage (e.g., /sdcard), please grant them. This is necessary for the compiler to read your project files and for Acode to write compiled output.

## 1\. Termux Configuration

First, open the Termux application and run the following commands (optional but highly recommended):

```bash
pkg update
pkg upgrade
```

Next, execute the following command to begin the compiler installation using the provided script:

```sh
curl -sL https://raw.githubusercontent.com/neetoons/pawn-android-toolchain/refs/heads/main/environment.sh | bash
```

  * If prompted to grant file access permissions, please do so.
  * If prompted with **Y/N** questions, enter `Y` or just press **Enter**.
  * Once the installation is complete, execute the command `axs`. This command starts a server, allowing the **Acode** application to connect to the Termux environment.
  * This command will display a private IP address and port number that you will use in Acode to establish the connection.

## 2\. Acode Integration

Acode will serve as your primary editor and terminal interface.

  * In the Acode application, go to the **Plugins** section and install the [**AcodeX - Terminal**](https://acode.app/plugin/bajrangcoder.acodex) plugin.
  * To use **AcodeX**, press `Ctrl+K` or search for `"Open Terminal"` in the command palette (which can be opened by pressing `Ctrl+Shift+P`).
  * Enter the port number shown by the `axs` command in Termux, and the terminal session should start.
  * To enter the specialized environment for compilation (often an Alpine Linux container/shell), execute the following command:

<!-- end list -->

```sh
startalpine
```

## 3\. Compiling Your Project

Once you are in the AcodeX terminal running the Alpine environment, you need to navigate to your project files.

To locate your project in the terminal, use the following commands:

```sh
cd /sdcard
# This will display the main folders on your device
ls
# Navigate to the folder containing your gamemode
cd Documents/samp-super-roleplay
```

Once inside your project directory, you can run the compiler. Remember that `main.pwn` is an example name, you must replace it with the name of your gamemode/script:

```sh 
pawncc main.pwn
```

You can re-execute the command quickly by pressing the **Up Arrow** in the AcodeX terminal.
> `pawncc` command will search for the include folder in the qawno directory. If you want it to search for it in the pawno directory, use `pawncc-old`.

---
## Workflow Summary

To view and edit your code, open the **Acode** app and navigate to your gamemode/project folder using the app's file explorer.

Whenever you want to work on your project and compile, you will follow these steps:

1.  Open **Termux** and run `axs`.
2.  Open **Acode**.
3.  Open the **AcodeX Terminal** (it may connect automatically).
4.  Execute `startalpine`.
5.  Navigate to your project folder using `cd` in the `/sdcard` directories.
---
## SAMP/OPEN.MP Server installation

Enter the command `install-omp` or `install-samp` to easily download the SA-MP/OPEN.MP server for Linux into your gamemode.

---
## Why is Alpine Linux used?
The use of Alpine Linux is because the pawncc compiler does not work correctly (on other systems, implicitly), this is a problem that will possibly be solved in the future. Also, it is easier/more convenient to install other programs.