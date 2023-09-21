# SliRunDelete
Runs the first file (alphabetically) matching the criteria, then allow to delete it and/or power off the computer. Written to turn a PC into a media player that launches the first available video file on boot, then delete it and power off the machine, hence playing the next video on next boot. Written in Turbo Delphi.
<br>
##INI file explanation:
###ExecutablePath=C:\MPC\mpc-hc64.exe
Full path of app that will run the file; if none specified, ShellExecute will just open the file, which will thus be opened with whatever app is associated to the file type in Windows; therefore this option is useful to either override the system default app, or if no default app is associated with the file extension 
###FilesPath=C:\Video\
Path to look for files into
###OpenExtensions=*.mkv
Extension of files to look for in the path above (e.g. *.* for any file type); directories are always ignored
###AutoRun=1
1 = matching file is launched on startup ; 0 = file will only be launched if/when the "Run" button is pressed
<br>RunAndExit=0         ; if set to 1, the application closes immediately after launching the file (deleting and powering off will not happen), if set to 0 the application remains opened
<br>DeletePermanently=1  ; if set to 1, pressing the "Delete" button will delete the file permanently, if set to 0 the file is sent to the recycle bin
<br>AutoShutDown=1       ; if set to 1, the machined is powered down after the file is deleted, if set to 0 the machine will only be powered off if/when the "Power off" button is pressed
<br>
<br><u>In the example above:</u>
<br>The first .mkv file from the folder C:\Video will be opened automatically with MPC-HC when the app starts, then clicking the "Delete" button will permanently delete the .mkv file and immediately power off the machine thereafter.
