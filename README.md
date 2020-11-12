# pwman_basys3
Password manager and generator for the BASYS3 prototyping board.

#### Importing the Project - IGNORE THESE INSTRUCTIONS
Vivado has very poor support for VCS so the process is overly complicated.

1. Clone the repo.
2. In Vivado, open the TCL console by going to Window > TCL Console.
3. In the console, 'cd' to the above the location where you want the project.

In my case:
```
# Will create project in subdirectory /home/dd/ece351_pwman/
cd /home/dd/
```

4. Import the TCL project file using the console.

```
source /path/to/git/repo/ece351_pwman.tcl
```

5. You can now edit the project.

#### Committing Changes
Please try to commit as little as possible as importing the project might destroy local changes.

1. With the project open, go to File > Project > Write TCL.
2. A dialog will pop up asking you where to save. Just overwrite the previous TCL file in the repo.
3. Commit the changes.

#### Other Notes
- There are likely a few kinks in this method but we should be able to iron them out as we get working.
- See [here](http://www.fpgadeveloper.com/2014/08/version-control-for-vivado-projects.html) for details on this method.
