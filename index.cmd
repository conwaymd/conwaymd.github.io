OrdinaryDictionaryReplacement: #boilerplate-properties-override
- queue_position: BEFORE #boilerplate-properties
- apply_mode: SIMULTANEOUS
* %head-elements-before-viewport -->
    <meta name="author" content="Conway">
* %head-elements-after-viewport -->
    <link rel="stylesheet" href="/cmd.css">
    <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
    <link rel="manifest" href="/site.webmanifest">
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#7000ff">
    <meta name="msapplication-TileColor" content="#00aba9">
    <meta name="theme-color" content="#ffffff">
* %title --> Conway-Markdown (CMD) v%cmd-version

RegexDictionaryReplacement: #heading-permalinks
- queue_position: BEFORE #headings
* (?P<opening_hashes_etc>
    [#]{2,6}
    \{
      [#] (?P<id_> [\S]+ )
    \}
    [\s]+
  )
    -->
  \g<opening_hashes_etc> []{.permalink aria-label=Permalink}(#\g<id_>)

%%%


# %title

||{.page-properties}
  First created: 2020-04-05 <br>
  Last modified: 2022-04-30
||

--
Conway-Markdown (CMD) is:
--
==
- A replacement-driven markup language inspired by Markdown.
- A demonstration of the folly of throwing regex at a parsing problem.
- The result of someone joking that
  ""the filenames would look like Windows executables from the 90s"".
- Implemented in [Python 3.{whatever Debian stable is at}][python3].
- Licensed under "MIT No Attribution" (MIT-0).
==

[python3]: https://packages.debian.org/stable/python3


##{#useful-links} Useful links

==
- This page's CMD: [%cmd-basename.cmd]
- This page's HTML: [%cmd-basename.html]
- Repository of this page: [conway-markdown.github.io]
- Repository of Python implementation (`cmd.py`): [conway-markdown]
==
[%cmd-basename.cmd]:
  https://github.com/conway-markdown/conway-markdown.github.io/blob/master/\
    %cmd-name.cmd
[%cmd-basename.html]:
  https://github.com/conway-markdown/conway-markdown.github.io/blob/master/\
    %cmd-name.html
[conway-markdown.github.io]:
  https://github.com/conway-markdown/conway-markdown.github.io/
[conway-markdown]:
  https://github.com/conway-markdown/conway-markdown


##{#command-line-usage} Command-line usage

--
Since `cmd.py` is [a shitty single-file script],
it will not be turned into a proper Python package.
--
[a shitty single-file script]:
  https://github.com/conway-markdown/conway-markdown/blob/master/cmd.py

###{#linux} Linux terminals, macOS Terminal, Git BASH for Windows

++++
1.
  Make an alias for `cmd.py` in whatever dotfile
  you configure your aliases in:
  ````
  alias cmd='path/to/cmd.py'
  ````

2.
  Invoke the alias to convert a CMD file to HTML:
  ````
  $ cmd [-h] [-v] [-x] [file.cmd]

  Convert Conway-Markdown (CMD) to HTML.

  positional arguments:
    file.cmd       Name of CMD file to be converted. Abbreviate as `file` or
                   `file.` for increased productivity. Omit to convert all CMD
                   files under the working directory.

  optional arguments:
    -h, --help     show this help message and exit
    -v, --version  show program's version number and exit
    -x, --verbose  run in verbose mode (prints every replacement applied)
  ````
++++

###{#windows} Windows Command Prompt

++++
1.
  Add the folder containing `cmd.py` to the `%PATH%` variable

2.
  Invoke `cmd.py` to convert a CMD file to HTML:
  ````
  > cmd.py [-h] [-v] [-x] [file.cmd]

  Convert Conway-Markdown (CMD) to HTML.

  positional arguments:
    file.cmd       Name of CMD file to be converted. Abbreviate as `file` or
                   `file.` for increased productivity. Omit to convert all CMD
                   files under the working directory.

  optional arguments:
    -h, --help     show this help message and exit
    -v, --version  show program's version number and exit
    -x, --verbose  run in verbose mode (prints every replacement applied)
  ````
++++

--
**WARNING: on Windows, be careful not to run any `.cmd` files by accident;
they might break your computer. God save!**
--


##{#authoring-documents} Authoring documents

--
CMD files are parsed as
--
````{.cmd}
«replacement_rules»
«delimiter»
«main_content»
````
--
where `«delimiter»` is the first occurrence of
3-or-more percent signs on its own line.
If the file is free of `«delimiter»`,
the whole file is parsed is parsed as `«main_content»`.
--
