Dynamic library for Mac OS X. Allow disable sharing content of "search for" field between applications.

## Disclaimer

**Use this library at your own risk and ONLY if you are SURE what you are doing! Some applications may just crash at launch.** Tested only on Mac OS X 10.9 x86_64

This should works well for most applications but could be dangerous for global usage.

## Known issues

Some applications crash at launch:

* Skype - crashes when any (even empty) library injected
* Mou - requires library compiled with `-fobjc-gb` but gcc does not support it any more
* iOS Simulator does not work (starts with black screen) if XCode was launched with this library injected
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

#### Enable

Global setting is not as useful since you have to launch that command by hand after system reboot (do not ever try preserve variable after reboot, see warning below) and not all applications could be launched with this library. But if most does for you, you could enable it for current session with

```bash
launchctl setenv DYLD_INSERT_LIBRARIES /path/to/DisableSearchSharing.dylib
```

and launch not working applications from command line with

```bash
DYLD_INSERT_LIBRARIES= open -a Skype
```

And if something even goes wrong you could reboot at any time and got fresh new session after system start.

#### Disable

```bash
launchctl unsetenv DYLD_INSERT_LIBRARIES
```

### WARNING!

**Never** try add `DYLD_INSERT_LIBRARIES` to `$HOME/.launchd.conf` or `/etc/launchd.conf` for preserving option after reboot. It could bring more problems than benefit. For example incorrect library arch or missed file will CRASH ALL APPLICATIONS at their launch! And by *ALL* I really mean every application, you could not even run console text editor to edit config or run `launchd unsetenv` to reset variable.

While you still in current session with opened terminal you have a chance to resolve some troubles with something like

```bash
export DYLD_INSERT_LIBRARIES=
launchctl unsetenv DYLD_INSERT_LIBRARIES
nano /etc/launchd.conf # and remove necessary line
```

But after reboot I'm afraid everything will be lost...

Even fixing current session may not be so easy. I have custom PROMPT_COMMAND with several commands like fetching current git branch, so I could run only one command per terminal window, and after that command execution I have never seen promt again.
