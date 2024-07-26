# Microstack (OpenStack) Configurer WSL2

Microstack Configurer WSL2 is a simple SH script that automates WSL2 configuration to install Microstack inside WSL2

### Requirements:
- Windows 10 or Windows 11 (22H2)
- WSL2 with Systemd support
- Clean WSL Distro with Ubuntu 20.04 or 22.04

### Script Installation

The first thing you need to do is clone the current repository to download the script:

```
git clone https://github.com/Sorecchione07435/Microstack-Configurer-WSL2.git
```

After the repository has been cloned enter it with

```
cd Microstack-Configurer-WSL2
```

ATTENTION!: before actually running the script you must specify inside the name of the user under which you are running Ubuntu WSL

Open the SH file with any text editor and in the ```WINDOWS_USERNAME``` directive enter your username as a value, this is very important, never forget it!

Now before running the script you will need to grant yourself permission with chmod

```
sudo su
chmod +x WSL2-Ubuntu-Microstack-Configurer.sh
```

Finally run the script with:
```
./WSL2-Ubuntu-Microstack-Configurer.sh
```

And now you will have to wait quite a while, the script will install the necessary libraries to precompile the kernel, compile the kernel, install its modules, install the multipath tools and finally enable systemd, it's all automated

And make sure you're connected to the internet to do this!

When all operations are completed successfully this output will be written to you:

```
**** WSL2 Distro Configured Successfully ******

Your WSL2 Ubuntu distro is now ready to install Microstack
To install microstack run: 'sudo snap install microstack --edge --devmode' and 'sudo microstack init --auto --control'

Before installing Microstack on the distro restart the distro with 'wsl --shutdown'

Script Completed!
```

Finally restart your distro with ```wsl --shutdown```

And if after reboot by typing command ```uname -r``` and you get this output

```
5.15.xx.x-microsoft-custom-WSL2-ovs-multipath-xxxxxxxxxxxxx
```

The custom kernel has been 100% loaded on your Ubuntu WSL2 distro.
Now you can go to install Microstack

### Microstack Installation

Since we saw earlier that we have successfully compiled and run a kernel with Openvswitch and Multipath integrated, we can start with installing Microstack

Install Microstack with:
```
sudo snap install microstack --edge --devmode
```

And now you will be able to do initialization with as well

```
sudo microstack init --auto --control
```

the initialization will take some time, and after that if the initialization is completed you can access the OpenStack Dashboard from **https://yourip/**

To get the administrator password: ```sudo snap get microstack config.credentials.keystone-password```

![login](https://github.com/Sorecchione07435/Microstack-Configurer-WSL2/assets/111366201/c84dd7d5-a164-4f61-a705-d4f58bf74a3c)


That's it, now you can have fun creating instances, floating IP images and much more

![dashboard](https://github.com/Sorecchione07435/Microstack-Configurer-WSL2/assets/111366201/9ceaa8b2-3198-4e93-b2e8-d10bbb2d7aea)


**NOTE!: This script can ONLY be run in WSL2 environments on Ubuntu, not on non WSL2 environments, if you run it the script will break immediately, as Microstack would already work on an Ubuntu distro**

## Changelogs

- Added Systemd enable check, when systemd is already enabled the step is skipped, sometimes with an Ubuntu installation from automatic WSL Systemd is automatically enabled
- Fixed the problem that the script would break at the end of each command
- 
**Warning: This script is about to be deprecated, please follow this new guide to install the latest WSL2 kernel which includes both OpenvSwitch and DM Multipath: https://gist.github.com/Sorecchione07435/37071fa25d108965a8fdbe5424a2a7ec**
