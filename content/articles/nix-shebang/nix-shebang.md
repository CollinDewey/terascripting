---
title: Nix Shebang
author: Collin Dewey
date: '2024-12-31'
lastmod: '2024-12-31'
type: Article
slug: nix-shebang
description: "Using Nix Shebang"
---

# Executing Files
---

On Linux and some other UNIX-like OSes, files are marked as "executable" by a mode flag on the file, referred to as the execute bit. This execute bit can be set with the change mode utility `chmod`, along with the modes for if the user/group/everyone can read and write the file. When you try to run the file you've marked as executable, Linux needs to figure out how to handle that file.

Looking in the Linux kernel source, at [fs/Kconfig.binfmt](https://elixir.bootlin.com/linux/v6.12/source/fs/Kconfig.binfmt), we can see the different executable formats that the Linux kernel recognizes. [^HOWPROGRAMSGETRUN]

| Format | Description |
|---|---|
| ELF | Executable and Linkable Format, this is the format that most executables are going to be for Linux. It's the format that compilers compile to when targeting Linux. |
| ELF_FDPIC | Special version of ELF that allows segments to be located in memory independently of each other, useful for when a Memory Management Unit is not available. |
| SCRIPT [^BINFMT_SCRIPT] | Checks if the file starts with the shebang sequence `#!`. From then, it takes the path to an interpreter, and optionally arguments to the interpreter. |
| FLAT [^FLAT] | uClinux was a version of Linux for systems without a Memory Management Unit. Since ELF required certain Virtual Memory features that were unavailable, a new format was created which stored executable code/data and relocations needed. |
| FLAT_OLD | Older version of FLAT |
| ZFLAT | Compressed FLAT |
| MISC | Supports runtime registration of formats via magic numbers or file extension. This is often used to easily run cross-platform binaries through QEMU or Box86/64. It can be used to run/associate files with an interpreter, such as Wine, Java VM. These can be seen listed in the procfs folder `/proc/sys/fs/binfmt_misc`. It's somewhat like xdg-open but at the kernel level. |

[^HOWPROGRAMSGETRUN]: [David Drysdale's "How programs get run"](https://lwn.net/Articles/630727/)
[^BINFMT_SCRIPT]: [Linux Kernel binfmt_script.c](https://elixir.bootlin.com/linux/v6.12/source/fs/binfmt_script.c)
[^FLAT]: [David McCullough's "uClinux for Linux Programmers"](https://dl.acm.org/doi/fullHtml/10.5555/1005572.1005579)

    [Craig Peacock's "uClinux - BFLT Binary Flat Format"](https://web.archive.org/web/20180507174035/http://retired.beyondlogic.org/uClinux/bflt.htm)


---
# Shebang
---

The SCRIPT format can be pretty useful, because it lets us define our own interpreter at the individual file level, as long as we start the file with a shebang sequence - `#!` - and then the path as to what to run the rest of the file with. Such as...

```
#!/bin/sh
#!/bin/awk
#!/bin/bash
#!/usr/bin/bash
#!/usr/local/bin/bash
#!/bin/false
#!/bin/perl
#!/bin/php
#!/bin/python3
```

This path is usually an absolute path, but relative paths do work as well. Due to different distributions having programs installed in different locations - such as the three bash locations above - it is often encouraged to use `#!/usr/bin/env <program>` as to get the application from the user's `$PATH` variable. This means that as long as that program is available in the path, the script will run. For example, `#!/usr/bin/env bash` will run bash even if bash isn't located in a common path like `/bin/bash`. This is especially useful with Python scripts within virtual environments, where the Python you want to use may not be the same as the globally installed version. This is generally considered more portable across systems, however neither `/bin/sh` or `/usr/bin/env` are required to be in those location, but they are there for the vast majority of systems.

---
# Nix Shell
---

One of the greatest features of Nix is nix-shell. Given a set of package names defined in the Nix package repository [nixpkgs](https://github.com/NixOS/nixpkgs). See available packages [here](https://search.nixos.org/packages). Nix-shell will start a new shell with those packages available.

Such as the `hello` package
```sh
$ which hello
hello not found
$ nix-shell -p hello
this path will be fetched (0.05 MiB download, 0.22 MiB unpacked):
  /nix/store/1q8w6gl1ll0mwfkqc3c2yx005s6wwfrl-hello-2.12.1
copying path '/nix/store/1q8w6gl1ll0mwfkqc3c2yx005s6wwfrl-hello-2.12.1' from 'https://cache.nixos.org'...
$ echo $NIX_SHELL_PACKAGES
hello
$ which hello
/nix/store/1q8w6gl1ll0mwfkqc3c2yx005s6wwfrl-hello-2.12.1/bin/hello
$ hello
Hello, world!
```

This is also very useful for environments where dependency managment can be done through Nix, such as R, Haskell, Python, Emacs, TeX Live, Perl, OCaml, Ruby, Node, etc. Not every package is going to be available in Nixpkgs, or updated to the version desired.

```sh
$ python --version
Python 3.12.7
$ python -c "import pandas"
Traceback (most recent call last):
  File "<string>", line 1, in <module>
ModuleNotFoundError: No module named 'pandas'
$ nix-shell -p python312 python312Packages.pandas
# A bunch of fetching from the internet
$ python --version
Python 3.12.8
$ python -c "import pandas"
$ echo $? # Prints the return code of the last statement, 0 is success
0
```

Starting with Nix version 2.4, the new experimental Nix CLI interface was added. Instead of Nix's features being split upon multiple executables, it's merged into one executable simply named `nix`. This allows for more easily specifying the version of nixpkgs you want to use, or even using a package not located in nixpkgs.

An easy to search list of package versions can be seen on the website [nixhub.io](http://nixhub.io/)

```sh
# Specify specific version using "nix-shell" (Python 3.6)
$ nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/718895c14907b60069520b6394b4dbb6e3aa9c33.tar.gz -p python36

# Specify specific version using "nix shell" (Python 3.6)
# Not specifying a version picks the latest nixpkgs
$ nix shell nixpkgs/718895c14907b60069520b6394b4dbb6e3aa9c33#python36

# Run the package in the github repo https://github.com/MrGlockenspiel/activate-linux
$ nix run github:MrGlockenspiel/activate-linux
```

---
# Nix Shell Shebang
---

While the above is useful for temporarly running an application or environment, Nix has the ability to be run as a shebang interpreter.

So to run our Python version 3.6. We will use nix-shell, which will then read the following lines for what packages it should download, or other arguments.
```python
#!/usr/bin/env nix-shell
#!nix-shell -i python -p python36
#!nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/718895c14907b60069520b6394b4dbb6e3aa9c33.tar.gz
# Specifying the nixpkgs version is optional

import sys
print(sys.version) # Prints "3.6.14 (default, Jun 28 2021, 17:59:20)"
```

With the new features of the Nix CLI, that can be used as well
```python
#!/usr/bin/env nix
#!nix shell nixpkgs/718895c14907b60069520b6394b4dbb6e3aa9c33#python36 -c python
# Specifying the nixpkgs version is optional. You can just use nixpkgs#python3.

import sys
print(sys.version) # Prints "3.6.14 (default, Jun 28 2021, 17:59:20)"
```

---
# What This Means
---

This means that as long as Nix is installed on a system, scripts can be created that know exactly how the applications used are going to act. When making bash scripts to run across many different Linux distributions, I may end up needing to include multiple approaches to the same command. Such as downloading a file, where some distributions may come with only curl, and other only wget.

```bash
#!/usr/bin/env bash
if command -v curl &> /dev/null; then # Check if curl is installed
    curl -o /etc/ssl/certs/ca-bundle.pem https://curl.se/ca/cacert.pem
elif command -v wget &> /dev/null; then # Check if wget is installed
    wget -O /etc/ssl/certs/ca-bundle.pem https://curl.se/ca/cacert.pem
fi
```

Now I can run a script with the commands I want to use, without worring about if a user has them normally available.
```bash
#!/usr/bin/env nix
#!nix shell nixpkgs#wget nixpkgs#bash -c bash
wget -O /etc/ssl/certs/ca-bundle.pem https://curl.se/ca/cacert.pem
```

So I can use a bunch of weird tools to make a checklist filled with random words.
```bash
#!/usr/bin/env nix
#!nix shell nixpkgs#rusty-diceware nixpkgs#ctodo nixpkgs#coreutils nixpkgs#gawk nixpkgs#lolcat nixpkgs#bash -c bash
tmp=$(mktemp)
diceware | awk 'BEGIN {print ""} {for(i=1;i<=NF;i++) print "[ ]"$i}' > $tmp
ctodo $tmp | lolcat
rm $tmp
```

<div id="nix-shebang-asciinema"></div>

<link rel="stylesheet" type="text/css" href="/css/asciinema-player.css" />
<script nonce="7AnF83KoB" src="/js/asciinema-player.min.js"></script>
<script nonce="7AnF83KoB">
    AsciinemaPlayer.create('./nix-shebang.cast', document.getElementById('nix-shebang-asciinema'), {
        loop: true,
        theme: 'auto/solarized-dark',
        cols: 128,
        rows: 21,
        markers: [
            [2.0, "Pasting Script"],
            [9.0, "First Run"],
            [18.0, "Second Run"]
        ]
    });
</script>


Unfortunately, most people aren't going to have nix installed. Especially with Nix's rather intrusive default installer. More on that in another post in the future.