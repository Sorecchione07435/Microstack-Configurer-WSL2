# Microstack Configurer WSL2

Microstack Configurer WSL2 is a simple SH script that automates WSL2 configuration to install Microstack inside WSL2

### Requirements:
- Windows 10 or Windows 11
- WSL2
- WSL Distro with 20.04 or 22.04

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
To install microstack run: 'sudo snap install microstack --edge --devmode' and 'sudo microstack --init --control'

Script Completed!
```

After receiving this success message it is necessary to edit the file ```C:\Users\username\.wslconfig```, because unfortunately the script does not add two backslashes for a
problem
then replace one backslash by putting two

Example:
```
[wsl2]
kernel = C:\\Users\\username\\wsl2\\vmlinux
```

Finally restart your distro with ```wsl --shutdown```

And if after booting by typing command ```uname -r``` and you get this output

```
5.15.xx.x-microsoft-custom-WSL2-ovs-multipath-xxxxxxxxxxxxx
```

You have perfectly configured your WSL2 Distro and it is 100% ready to deploy Microstack (OpenStack)

