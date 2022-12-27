# Acquiring pcvocab.mdb for Protocol 7

Protocol 7 focuses heavily on speech phrases, and the phrases are built using arrays of 10-bit codes that represent
speech data.  The arrays of codes can be built from English words using `TimexDatalinkClient::Protocol7::PhraseBuilder`,
as seen in [the protocol 7 documentation](dsi_ebrain_protocol_7.md).  This class requires the original DSI e-BRAIN
database file, `pcvocab.mdb`.

## Extracting pcvocab.mdb from the DSI e-BRAIN software CD

The `pcvocab.mdb` file is buried inside of installer files on the DSI e-BRAIN software CD.  First, acquire an ISO image
of the DSI e-BRAIN CD.  If you need to download it, you can find it on
[the Internet Archive](https://archive.org/details/ebrain-1.1.6) (here's a
[direct link](https://archive.org/download/ebrain-1.1.6/ebrain-1.1.6.iso)).

With the ISO downloaded, follow the directions below to extract pcvocab.mdb from the image.

### From UNIX-compatible systems with 7z

These instructions will use 7z, which is a part of [p7zip](https://p7zip.sourceforge.net), so make sure this is
installed first.  p7zip is probably a package in your distro's package manager, so install it this way, if
possible.

`pcvocab.mdb` is called `pcvocab.mdb1` in the `Cabs.w4.cab` archive, which is inside of `eBrain.MSI` on the ISO.  We
need to perform a few extractions, then rename the database file, like so:

```shell
7z e ebrain-1.1.6.iso eBrain.MSI
7z e eBrain.MSI Cabs.w4.cab
7z e Cabs.w4.cab pcvocab.mdb1

mv pcvocab.mdb1 pcvocab.mdb
```

### From Windows with 7zip

These instructions will use [7zip](https://www.7-zip.org), so make sure this is installed first.

Right-click on `ebrain-1.1.6.iso`, hover over 7zip, and click on Open archive:

![image](https://user-images.githubusercontent.com/820984/209248423-fbf19df8-0854-4db0-852d-8c70b3b35741.png)

In the 7zip browser, you'll see `eBrain.MSI`.  Right-click on this file, and click on Open Inside:

![image](https://user-images.githubusercontent.com/820984/209248532-b9b883b5-e53b-4109-8267-d2d55882084f.png)

In `eBrain.MSI`, find `Cabs.w4.cab`.  Right-click on this file, and click on Open Inside:

![image](https://user-images.githubusercontent.com/820984/209248587-cdbb09ba-f978-4497-add4-b9fe68c43cec.png)

Then, right-click `pcvocab.mdb1` and click Copy To...

A window will appear that will ask you where you want to extract the file.  Pick a location, then click OK.

![image](https://user-images.githubusercontent.com/820984/209248681-429705d7-b74d-4323-8f53-de3d67f71ac2.png)

After the file has been extracted, rename it to `pcvocab.mdb`.
