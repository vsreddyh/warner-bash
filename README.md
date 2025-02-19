# warner-bash

A bash script that monitors resources usage, temperature, battery and sends a system notification when specified thresholds are crossed.

# Table of contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Starting Up](#starting-up)
  - [Flags](#flags)
  - [Combination of flags](#combination-of-flags)
- [Contributing](#contributing)
- [License](#license)

# Prerequisites

[(Back to top)](#table-of-contents)

- Linux System
- libnotify
- libsensors

# Installation

[(Back to top)](#table-of-contents)

1. Clone the repository
   ```sh
   git clone https://github.com/vsreddyh/warner-bash
   ```
2. Change Directory and run
   ```sh
   cd warner-bash
   chmod u+x warner.sh
   warner.sh
   ```
3. To assign the keyword warner to warner.sh. Run this command
   ```sh
   sudo cp ./warner.sh /usr/local/bin/warner
   ```
4. To add it to autostart on i3 paste this in .config/i3/config
   ```sh
   exec --no-startup-id warner start &
   ```

# Usage

[(Back to top)](#table-of-contents)

### Starting Up

![image](https://i.imgur.com/mbsKABr.png)

![image](https://imgur.com/OWrzt6r.png)

### Flags

- `-maxTemp` : Changes maximum temperature threshold
- `-maxCpu` : Changes maximum CPU usage threshold
- `-maxRam` : Changes maximum RAM usage threshold
- `-maxBat` : Changes maximum battery threshold
- `-miBat` : Changes minimum battery threshold
  ![image](https://imgur.com/T649Kh6.png)
  ![image](https://imgur.com/CL2sdq4.png)

### Combination of flags

- Multiple flags is also supported
  ![image](https://imgur.com/UCgn9Wt.png)

# Contributing

[(Back to top)](#table-of-contents)

Your contributions are always welcome! Please have a look at the [contribution guidelines](CONTRIBUTING.md) first. :tada:

# License

[(Back to top)](#table-of-contents)

The MIT License (MIT) 2025 - [VsreddyH](https://github.com/vsreddyh/). Please have a look at the [LICENSE.md](LICENSE.md) for more details.
