# Acquiring SPC and ZAP files for protocols 3 and 4

SPC files are sound themes, and ZAP files are WristApp programs.  Sound themes and WristApp programs are supported in
protocols 3 and 4, namely the Timex Datalink 150 and 150s.  These files can be transferred using the `SoundTheme` and
`WristApp` models described in the [protocol 3](docs/timex_datalink_protocol_3.md) and
[protocol 4](docs/timex_datalink_protocol_4.md) documentation.

## Extracting SPC and ZAP files from the Timex Datalink software

First, we want to acquire the last version of the Timex Datalink software, which is version 2.1d.  This can be
downloaded from [Timex's website](https://assets.timex.com/html/data_link_software.html) (here's a
[direct link](https://assets.timex.com/downloads/TDL21D.EXE)).

With the software downloaded, follow the directions below to extract SPC and ZAP files from the installer.

### From UNIX-compatible systems with 7z

These instructions will use 7z, which is a part of [p7zip](https://p7zip.sourceforge.net), so make sure this is
installed first.  p7zip is probably a package in your distro's package manager, so install it this way, if
possible.

The SPC and ZAP files are in the `SETUP.EXE` file, which is inside of `TDL21D.EXE`.  These commands will extract
`SETUP.EXE` from `TDL21D.EXE`, create `sound-themes` and `wrist-apps` directories, and extract the SPC and ZAP files to
the appropriate directories.

```
7z e TDL21D.EXE SETUP.EXE
7z e SETUP.EXE -osound-themes *.SPC
7z e SETUP.EXE -owrist-apps *.ZAP
```

### From Windows with 7zip

These instructions will use [7zip](https://www.7-zip.org), so make sure this is installed first.

Right-click on `TDL21D.EXE`, hover over 7zip, and click on Open archive:

![image](https://user-images.githubusercontent.com/820984/209208705-169a793d-c977-4dbc-8f26-1f85401e086d.png)

In the 7zip browser, you'll see `SETUP.EXE`.  Right-click on this file, and click on Open Inside:

![image](https://user-images.githubusercontent.com/820984/209208792-c925a6ec-6e95-4ef9-9c46-8c758ace8e89.png)

Then, we can extract the sound themes by selecting the SPC files, right-clicking on the selection, and clicking Copy
To...

A window will appear that will ask you where you want to extract the sound themes.  Pick a location, then click OK.

![image](https://user-images.githubusercontent.com/820984/209209056-cddc237f-a757-48c5-9a5b-b6f328984f33.png)

The WristApps can also be extracted by selecting the ZAP files, right-clicking on the selection, and clicking Copy
To...

A window will appear that will ask you where you want to extract the WristApps.  Pick a location, then click OK.

![image](https://user-images.githubusercontent.com/820984/209209169-a7269cfe-d213-4a50-a671-3bb49f01325a.png)
