# bullet3-src

This repository, **bullet3-src**, contains a stripped-down version of the source code from the [Bullet Physics Library](https://github.com/bulletphysics/bullet3). The purpose of this repository is to provide a lightweight, easily accessible version of the Bullet source code that can be quickly downloaded and included in static C++ builds.

The Bullet Physics Library is a powerful, feature-rich physics engine that is widely used in games, simulations, and other interactive applications. However, the full Bullet repository includes various additional assets, examples, and tools that may not be necessary for all projects.

**bullet3-src** addresses this by providing just the essential source code, making it easier to integrate into your own projects. By maintaining this stripped-down version, developers can include the necessary directly into their static C++ builds without having to download extra files and directories.


## Contents
This repository contains the following:

- The `src/` directory, which includes all the essential C++ source files needed to build the Bullet Physics Library.

## How to Use

To include Bullet Physics in your project:

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/bullet3-src.git
2. Include your prefered files (for example `src/btBulletCollisionAll.cpp`, `src/btBulletDynamicsAll.cpp` and `src/btLinearMathAll.cpp`) in your C++ project's build system.


# Source
This repository is derived from the original [Bullet Physics Library](https://github.com/bulletphysics/bullet3). For more comprehensive information, examples, and additional tools, you can visit the original repository.

Please refer to the original Bullet repository for detailed documentation, usage examples, and the full suite of tools and demos that Bullet offers.

# Licence
The source code in this repository is licensed under the same terms as the original Bullet Physics Library. See the LICENSE.txt file for details.
