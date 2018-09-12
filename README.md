# plotUlog

plotUlog is octave(open source equivalance of matlab) .m script package for plotting ULog files parsed and converted by pyulog. ULog is a self-describing logging format which is documented  [here](http://dev.px4.io/advanced-ulog-file-format.html).

[GNU Octave](https://www.gnu.org/software/octave/) is powerful mathmatics software with built in plotting and visualization tools which runs on Linux, macOS, BSD and Windows. 

[![Youtube plotUlog](http://img.youtube.com/vi/EZv81fV9Rec/0.jpg)](https://www.youtube.com/watch?v=EZv81fV9Rec "plotUlog")

## Installation


- Install octave
```bash
$ sudo apt-get install octave
```
Octave can be run from launch bar in ubuntu 

- Install **pyulog** which will parse ULog file and convert to .csv files.

**pyulog** can be downloaded from [here](https://github.com/PX4/pyulog)
or visit https://github.com/PX4/pyulog

- clone plotulog git or download and unzip package in any folder.

## File name


Depending on the version of px4 firmware, ULog file can have different names. 

In 1.8.0, ULog files are created as

**/log/yyyy-mm-dd/hh_mm_ss.ulg**

For convenience, change the .ulg file as 

**log###.ulg**

## Run


Launch octave and go to the folder you just cloned or unzipped.

Copy a ULog file into the folder.

In octave terminal, enter

```bash
plotUlog("log###.ulg","Description")
```
Description can be any of your choice for identifying the foldr.

**plotUlog** will call **pyulog** to create .csv files under **###_Description/** folder and start generating plots. 

Once .csv files are created you can re-plot by entering the folder created from above.

```bash
plotUlog("###_Description/")
```

## Development


See what's inside the script file and manipulate any of data you want. 

Octave script is similar to matlab code and easy to handle lots of data.

