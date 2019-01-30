# code-browser
Fast interactive code browsing.

This bash script uses ``fzf`` to allow users to interactively search a source tree. It is primarily meant to search code trees but it can be used to repeatedly grep and view/edit any type of text files.

It displays the search results on the left panel and automatically updates the results when the user changes the search query. Unlike other code navigation tools, it dynamically shows the results as the user types and updates the query. The right panel displays a preview of the selected file.

When the user selects an entry from the result list, the tool automatically opens an editor (e.g., vim or emacs) on the line that was selected.

It has only been tested in OS X and with vim/emacs.

## Installation

Installation steps:
  1. Install the required/recommended packages
  2. Install the script
  3. Generate the index and tag files

### Install the required packages

Code-browser only **requires** the ``fzf`` fuzzy search tool and an editor.

The current version supports  ``vim`` and the ``emacs`` editor. It is recommend to use it with ``highlight`` and more importantly ``ctags`` (or similar code navigation tool).  

Installation under OS X using the ``brew`` package manager:
 - Install `brew` (https://brew.sh/)
 - Run the command:

       $ brew install fzf hightlight ctags


### Install the script

In bash execute from the shell (assuming ``code-browser.bash`` file is in the current directory):


    $ git clone git@github.com:rssys/code-browser.git
    $ cd code-browser
    $ source code-browser.bash

To make this change permanent add this source command to your ``~/.bashrc`` file and specify the full path of the ``code-browser.bash`` file.


### Generate the index and tags

This tool requires the generation of an index file (``INDEX.txt``). The index file needs to be updated when the source files change and is simply generated with ``grep``. In addition, to use the tags inside the editor, the tags file should also be generated.

To generate both files:

 1. `cd` to the root of the source tree you want to browse
 2. Generate the `INDEX.txt` file using `grep`:

        $ grep -r . <src_dir> > INDEX.txt

    (Replace <src_dir> with the names of the subdirectories and/or files to be included but don't include any old index or tag file.)
 3. Generate the tags file:

        $ /usr/local/bin/ctags -R .

At the end of this process, there should be two files `tags` and `INDEX.txt` in the root directory of the source tree. Both files need to be updated when the source code changes by re-running the generation commands. Include these commands in the Makefile to make it automatic.

Note: it may also be necessary to tell the editor how to find the tags file. E.g., for vim it may be necessary to add to `~/.virmc` the command: `set tags=./TAGS;/,TAGS;/,./tags;/,tags;/`

## Usage

After installing the package, run the shell command `g` with an optional initial query argument. Make sure to run the command from the directory where the `INDEX.txt` file was created.

Running `gg` instead of `g` will repeatedly loop between the search window and the editor. Exit with "Ctrl+C" or the respective editor command.

Once inside the editor the user can use the `ctags` functions to follow the code path. For instance, in vim, with the default configuration, `Ctrl+]` follows a function/symbol and `Ctrl+T` goes back.

## Demo

[![asciicast](https://asciinema.org/a/oNgGs3dNE6vIQPQ6fPkZrLwDL.svg)](https://asciinema.org/a/oNgGs3dNE6vIQPQ6fPkZrLwDL?autoplay=1&speed=3&loop=1)

## References

- Tools:
  - [ctags](https://ctags.io/)
  - [cscope](cscope.sourceforge.net)
  - [The NERD Tree [vim extension]](https://github.com/vim-scripts/The-NERD-tree)
- Tutorials:
    - [Ctags Tutorial (Vim and Emacs)](https://courses.cs.washington.edu/courses/cse451/10au/tutorials/tutorial_ctags.html)
    - [Using Cscope on large projects (example: the Linux kernel)](http://cscope.sourceforge.net/large_projects.html)
    - [Browsing programs with tags (Vim)](http://vim.wikia.com/wiki/Browsing_programs_with_tags)

## License

[GPLv3](https://www.gnu.org/licenses/quick-guide-gplv3.en.html)

## Contributions

Please send code changes, under the same license, by submitting a pull request on github.

## About

Pedro Fonseca, 2018
https://github.com/rssys/code-browser
