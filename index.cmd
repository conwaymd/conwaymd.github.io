OrdinaryDictionaryReplacement: #boilerplate-properties-override
- queue_position: BEFORE #boilerplate-properties
- apply_mode: SIMULTANEOUS
* %head-elements-before-viewport -->
    <meta name="author" content="Conway">
    <meta name="description" content="Documentation for Conway-Markdown (CMD).">
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

ExtensibleFenceReplacement: #html-as-inline-code
- queue_position: BEFORE #placeholder-unprotect
- syntax_type: INLINE
- prologue_delimiter: <
- extensible_delimiter: |
- attribute_specifications: .html
- content_replacements:
    #placeholder-unprotect
    #escape-html
    #de-indent
    #trim-whitespace
    #reduce-whitespace
    #placeholder-protect
- epilogue_delimiter: >
- tag_name: code

%%%


# %title

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


##{#installation-and-usage} Installation and usage

++{start=0}
0.
  Clone the [repository of the Python implementation][conway-markdown]:
  ``
  $ git clone https://github.com/conway-markdown/conway-markdown
  ``
  --
  Since `cmd.py` is [a shitty single-file script][`cmd.py`],
  it will not be turned into a proper Python package.
  --
++

[`cmd.py`]:
  https://github.com/conway-markdown/conway-markdown/blob/master/cmd.py


###{#linux-terminals} Linux terminals, macOS Terminal, Git BASH for Windows

++
1.
  Make an alias for `cmd.py` in whatever dotfile
  you configure your aliases in:
  ``
  alias cmd='path/to/cmd.py'
  ``

2.
  Invoke the alias to convert a CMD file to HTML:
  ``
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
  ``
++

###{#windows-command-prompt} Windows Command Prompt

++
1.
  Add the folder containing `cmd.py` to the `%PATH%` variable

2.
  Invoke `cmd.py` to convert a CMD file to HTML:
  ``
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
  ``
++

--
**WARNING: on Windows, be careful not to run any `.cmd` files by accident;
they might break your computer. God save!**
--


##{#authoring-cmd-files} Authoring CMD files

--
CMD files are parsed thus:
--
u``{.cmd}
<b class="cmdr">«replacement rules»</b>
«delimiter»
<b class="cmdc">«main content»</b>
``
==
- __`{.cmd .cmdr} «replacement rules»`__ are user-defined CMD replacement rules
  that will be used in addition to the standard CMD replacement rules.
- `{.cmd} «delimiter»` is the first occurrence of
  3-or-more percent signs on its own line.
  (If no `{.cmd} «delimiter»` is found in the file,
  the whole file is parsed as `{.cmd .cmdc} «main content»`.)
- __`{.cmd .cmdc} «main content»`__ is the CMD content
  that will be converted to HTML according to
  the standard and user-defined CMD replacement rules.
==
--
In the implementation:
--
++
1. An empty __replacement queue__ is initialised.
2. __`STANDARD_RULES`__ in [`cmd.py`] are parsed,
   and CMD replacement rules are added to the replacement queue accordingly.
3. __`{.cmd .cmdr} «replacement rules»`__ in the CMD file are parsed,
   and CMD replacement rules are added or inserted into the replacement queue
   accordingly.
4. The CMD replacement rules in the replacement queue are
   __applied sequentially to `{.cmd .cmdc} «main content»`__
   to convert it to HTML.
++


##{#cmd-attribute-specifications} CMD attribute specifications

--
When a CMD replacement rule is defined with
`{.cmd .cmdr} attribute_specifications` not equal to `{.cmd .cmdr} NONE`,
it allows HTML attributes to be specified by __CMD attribute specifications__
enclosed in curly brackets.
--
--
CMD attribute specifications may be of the following forms:
--
u``{.cmd .cmdc}
«name»<b>=</b>"«quoted value (whitespace allowed)»"
«name»<b>=</b>«bare-value»
<b>#</b>«id»
<b>.</b>«class»
<b>r</b>«rowspan»
<b>c</b>«colspan»
<b>w</b>«width»
<b>h</b>«height»
<b>-</b>«delete-name»
«boolean-name»
``

### Examples

++
1.
  Behaviour for the standard rule `#inline-code`:
  ==
  - CMD: ``{.cmd .cmdc} `{#foo .bar title="baz"} test` ``
  - HTML: <| `{#foo .bar title="baz"} test` |>
  ==

1.
  Non-`class` values will supersede:
  ==
  - CMD: ``{.cmd .cmdc} `{#1 #2 title=A title=B} test` ``
  - HTML: <| `{#1 #2 title=A title=B} test` |>
  ==

1.
  `class` values will accumulate:
  ==
  - CMD: ``{.cmd .cmdc} `{.a .b class=c} test` ``
  - HTML: <| `{.a .b class=c} test` |>
  ==

1.
  Delete `class` to reset it:
  ==
  - CMD: ``{.cmd .cmdc} `{.a .b -class class=c} test` ``
  - HTML: <| `{.a .b -class class=c} test` |>
  ==
++


##{#repository-links} Repository links

==
- This page's CMD: [%cmd-basename.cmd]
- This page's HTML: [%cmd-basename.html]
- This page's repository: [conway-markdown.github.io]
- Python implementation's repository: [conway-markdown]
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


<footer class="page-properties">
  First created: 2020-04-05 <br>
  Last modified: 2022-04-30 <br>
</footer>
