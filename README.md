Dynamic library for Mac OS X. Allow disable sharing content of "search for" field between applications.

## Disclaimer

**Use this library at your own risk and ONLY if you are SURE what you are doing!** Tested only on Mac OS X 10.9 x86_64

This should works well for most applications but could be dangerous for global usage.

## Known issues

Some applications crash at launch:

* Skype - crashes when any (even empty) library injected
* Mou - requires library compiled with `-fobjc-gb` but gcc does not support it any more
* something else I have no installed

## Description

Many application in Mac OS X share same content for search field.
So you search something in browser than switch to IDE and disclose your previous search replaced with string from browser...

And there is no preference for disabling such behaviour. So why this library was implemented.

## Implemenation

Library replaces AppKit's `[NSPasteboard setData:forType:]` and `[NSPasteboard dataForType:]` with own implementation which just do nothing when called on *NSFindPboard* pasteboard. Library loaded at application launch with setting `DYLD_INSERT_LIBRARIES` to appropriate value.

## Build

Build universal 32-bit & 64-bit library (required for running 32-bit applications on 64-bit OS which will crash at run otherswise)

```bash
gcc -arch i386 -arch x86_64 -Wno-objc-method-access \
    -framework AppKit -framework Foundation \
    -dynamiclib -o DisableSearchSharing.dylib \
    DisableSearchSharing.m
```

or only native (only for 32-bit OS)

```bash
gcc -Wno-objc-method-access \
    -framework AppKit -framework Foundation \
    -dynamiclib -o DisableSearchSharing.dylib \
    DisableSearchSharing.m
```

## Run

#### Run specified application from terminal

```bash
DYLD_INSERT_LIBRARIES=/path/to/DisableSearchSharing.dylib open -a ApplicationName
```

Of course you could define alias

```bash
alias dss='DYLD_INSERT_LIBRARIES=/path/to/DisableSearchSharing.dylib open'
dss file.txt
dss -a Sublime\ Text file.txt
```

## Global setting

#### WARNING! Not recommended, may crash every application in your system.

**Make sure library works correct for single application by running command above! For example incorrect library arch or missed file will CRASH ALL APPLICATIONS at launch! And by *ALL* I really mean every application, you could not even run console text editor to edit config or run `launchd unsetenv` to reset variable.** I accidentally do it on my system while researching Skype crash, it was *scary*.

#### Enable

**Do NOT do it if in doubt.**

I wanted remove that section at all but decide to keep it just as note if somebody find it a good idea to make library global for all applications. That idea is not as good as it may seem.

But if you still here you could run

```bash
launchctl setenv DYLD_INSERT_LIBRARIES /path/to/DisableSearchSharing.dylib
```

and optionally append following line to `/etc/launchd.conf`:

```bash
setenv DYLD_INSERT_LIBRARIES /path/to/DisableSearchSharing.dylib
```

to preserve setting after reboot.

#### Disable

```bash
launchctl unsetenv DYLD_INSERT_LIBRARIES
```

and remove line from `/etc/launchd.conf`
