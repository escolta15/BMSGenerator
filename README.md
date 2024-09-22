# BMSGenerator

This repository contains the generator for the master's thesis **'Optimization in the Automatic Generation of a Building Management System through a Line of Touchscreens'**.

The generator helps manage **variability** and **scalability** through DSLs for Angular projects and touchscreens.

When the generator is executed, a project is created that contains a *Host* application and *Remote* applications, which are the touchscreens. This architecture is called **Native Federation**.

## Table of Contents

1. [Installation](#installation)
2. [Dependencies](#dependencies)
3. [Use](#use)
4. [License](#license)
5. [Authors](#authors)
6. [References](#references)

## Installation

Instructions for installing the project on your local machine.
```bash
git clone https://github.com/escolta15/BMSGenerator.git
```

## Dependencies

The generator was built with the following dependencies:

- Ruby: 2.7.3p183 (2021-04-05 revision 6847ee089d) [x64-mingw32]
- NPM: 10.4.0
- Node.js: 20.11.1
- Angular CLI: 17.3.8

## Use

There is at the moment only one way to launch the generator: reading a JSON File.

There is a file called 'demo_example.json' where you can configure the structure that the BMS will have. The content of the file must include the following:

- projectName: name for the project.
- touchscreens: an array with all the touchscreens.
  - type: the type of touchscreen. The values are: z100, z70, z50, z41Com, z41Pro, z41Lite, z40, z35 and z28.
  - name: the name for the tocuhscreen.
  - color: the color of the touchscreen. It depends on the type.
  - licenses: an array of strings with the possible licenses. It depends on the type.
  - boxes: an array with all the functionalities for the touchscreen.
    - name: name for the functionality.
    - type: it can be boolean, number or string.

The file to launch is 'read_file_problem_dsl.rb' by running the command:
```bash
ruby read_file_problem_dsl.rb
```

You can change the name of the configuration file inside.

## Licence

This work is licensed under the license **Creative Commons Attribution 4.0 International**.

## Authors

- Student: Pablo Mora Herreros. LinkedIn www.linkedin.com/in/pablo-mora-herreros-675611114
- Director: Rubén Heradio Gil

## References

- Native Federation: https://github.com/manfredsteyer
