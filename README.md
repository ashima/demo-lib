# Ashima demo-lib

Ashima demo-lib contains the tools Ashima uses to produce
widely-accessible WebGL and HTML5 demos. The software is free and open
source under the MIT Expat license which can be found in the LICENSE
file.

## WebGL Demo Compatibility

**demo-lib** makes a small number of DOM assumptions about its page target. These are:

 - The HTML fragment to be lifted into a wrapped demo is found in an **article** tag
 - The URLs of resources tracked by the manifest system are expressed relative to the present URL