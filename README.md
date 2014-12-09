Dynamic library for SIMBL. Allows to disable sharing content of "search for" field between applications.

## Disclaimer

**Use this library at your own risk and ONLY if you are SURE what you are doing! Some applications may just crash at launch.** Tested only on Mac OS X 10.9 x86_64

This should works well for most applications but could be dangerous for global usage.

## Description

Many applications in Mac OS X share same content for search field.
So, whenever you search something in browser then switch to IDE, you disclose your previous search replaced with string from browser...

There is no preference for disabling such behaviour. This is why this library was implemented.

## Download

[Get universal build](https://github.com/comscandiumplumbumd/DisableSearchSharing/releases/latest)

## Implemenation

Library replaces AppKit's `[NSPasteboard setData:forType:]` and `[NSPasteboard dataForType:]` with own implementation which just do nothing when called on *NSFindPboard* pasteboard. Library loaded at application launch with setting `DYLD_INSERT_LIBRARIES` to appropriate value.

## Build

Build universal 32-bit & 64-bit library using Xcode or xcodebuild CLI.

## Install

Copy built .bundle to [~]/Library/Application Support/SIMBL/Plugins.
