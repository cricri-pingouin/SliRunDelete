# SliRunDelete
Runs a file, then allow to delete and/or power off the computer. Written to trurn an old laptop into a media player that launches the first available video file, then delete it and power off the machine, hence watching the next video on next boot. Written in Turbo Delphi. 
<br>
<br><u>INI file explanation:</u>
<BR>ExecutablePath=C:\MPC\mpc-hc64.exe ; full path of app that will run the file; if none specified, ShellExecute will just open the file, which will thus be opened with whatever app is associated to the file type in Windows; in other words, this option is useful to either override the system default app, or if no app is associated with the file extension 
<br>FilesPath=C:\Video\  ; this is the path to look for files into
<br>OpenExtensions=*.mkv ; this is the extension of files to look for in the path above (e.g. *.* for any file type); directories are always ignored
<br>DeletePermanently=1  ; if set to 1, pressing the "Delete" button will delete the file permanently, if set to 0 the file is sent to the recycle bin
<br>AutoRun=1            ; if set to 1, the file is launched on startup, if set to 0 the file will only be launched if/when the "Run" button is pressed
<br>AutoShutDown=0       ; if set to 1, the machined is powered down after the file is deleted, if set to 0 the machine will only be powered off if/when the "Power off" button is pressed
<br>
<br><u>In the example above:</u>
<br>The first .mkv file from the folder D:\Video will be opened automatically with MPC-HC when the app starts, then clicking the "Delete" button will permanently delete the .mkv file and immediately power off the machine thereafter.
