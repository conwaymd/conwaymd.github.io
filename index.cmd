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

OrdinaryDictionaryReplacement: #bold-code
- queue_position: BEFORE #display-code
- apply_mode: SIMULTANEOUS
* @( --> <b>
* )@ --> </b>
- concluding_replacements: #placeholder-protect

OrdinaryDictionaryReplacement: #details-summary-shorthand
- queue_position: BEFORE #whitespace
- apply_mode: SIMULTANEOUS
* {{def -->
    '{{{-open}
    <summary>Definition</summary>
  '
* {{des -->
    '{{
    <summary>Description</summary>
  '
* {{syn -->
    '{{
    <summary>Syntax</summary>
  '
* {{ex -->
    '{{
    <summary>Examples</summary>
  '
* {{dep -->
    '{{{-open}
    <summary>Dependants</summary>
  '

FixedDelimitersReplacement: #details
- queue_position: AFTER #details-summary-shorthand
- syntax_type: INLINE
- opening_delimiter: {{
- attribute_specifications: open
- closing_delimiter: }}
- tag_name: details


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

ExtensibleFenceReplacement: #html-as-display-code
- queue_position: BEFORE #placeholder-unprotect
- syntax_type: BLOCK
- prologue_delimiter: <
- extensible_delimiter: ||
- attribute_specifications: .html
- content_replacements:
    #placeholder-unprotect
    #escape-html
    #de-indent
    #reduce-whitespace
    #code-tag-wrap
    #placeholder-protect
- epilogue_delimiter: >
- tag_name: pre

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

--
To get started with writing __`{.cmd .cmdc} «main content»`__,
read the listing of [standard CMD replacement rules](#standard-rules).
--
--
To learn about writing user-defined __`{.cmd .cmdr} «replacement rules»`__,
read about [CMD replacement rule syntax](#replacement-rule-syntax).
--


##{#standard-rules} Standard CMD replacement rules

--
These section lists standard CMD replacement rules
as defined by the constant string __`STANDARD_RULES`__ in [`cmd.py`].
--
--
Some replacement rules are [queued](#standard-queued-replacements),
in that they appear explicitly in the replacement queue.
--
--
Other replacement rules are [unqueued](#standard-unqueued-replacements),
in that they do not appear explicitly in the replacement queue.
However, they might be called by queued replacements.
--

###{#standard-queued-replacements} Standard queued replacements

####{#placeholder-markers} 0. `#placeholder-markers`
[`#placeholder-markers`]: #placeholder-markers

{{def
  ``{.cmd .cmdr}
  PlaceholderMarkerReplacement: #placeholder-markers
  - queue_position: ROOT
  ``
}}
{{des
  --
  Replaces occurrences of the placeholder marker `«U+F8FF»`
  with a [placeholder]
  so that the occurrences will not be confounding.
  --
}}

####{#literals} 1. `#literals`
[`#literals`]: #literals

{{def
  ``{.cmd .cmdr}
  ExtensibleFenceReplacement: #literals
  - queue_position: AFTER #placeholder-markers
  - syntax_type: INLINE
  - allowed_flags:
      u=KEEP_HTML_UNESCAPED
      i=KEEP_INDENTED
      w=REDUCE_WHITESPACE
  - prologue_delimiter: <
  - extensible_delimiter: `
  - content_replacements:
      #escape-html
      #de-indent
      #trim-whitespace
      #reduce-whitespace
      #placeholder-protect
  - epilogue_delimiter: >
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @(<)@@(`)@ «content» @(`)@@(>)@
  ````
  ````{.cmd .cmdc}
    «flags»@(<)@@(`)@ «content» @(`)@@(>)@
  ````
  ====
  - `{.cmd .cmdc} «flags»`:
    ==
    - `{.cmd .cmdc} u`: keep HTML unescaped (do not apply [`#escape-html`])
    - `{.cmd .cmdc} t`: keep indented (do not apply [`#de-indent`])
    - `{.cmd .cmdc} w`: reduce whitespace (apply [`#reduce-whitespace`])
    ==
  - The number of backticks ``{.cmd .cmdc} @(`)@ ``
    may be increased arbitrarily.
  ====
}}
{{des
  --
  Preserves `{.cmd .cmdc} «content»` literally.
  --
}}
{{ex
  ++
  1.
    Write a literal string:
    ==
    - CMD: ``{.cmd .cmdc} <`` <` <b>Foo</b> `> ``> ``
    - HTML: <| <` <b>Foo</b> `> |>
    - Rendered: <` <b>Foo</b> `>
    ==
  1.
    Keep HTML unescaped:
    ==
    - CMD: ``{.cmd .cmdc} <`` u<` <b>Foo</b> `> ``> ``
    - HTML: <| u<` <b>Foo</b> `> |>
    - Rendered: u<` <b>Foo</b> `>
    ==
  1.
    Increase the number of backticks to include content
    that matches the `#literals` syntax itself:
    ==
    - CMD: ``{.cmd .cmdc} <``` <`` Literally <`literal`>. ``> ```> ``
    - HTML: <| <`` Literally <`literal`>. ``> |>
    - Rendered: <`` Literally <`literal`>. ``>
    ==
  ++
}}

####{#display-code} 2. `#display-code`
[`#display-code`]: #display-code

{{def
  ``{.cmd .cmdr}
  ExtensibleFenceReplacement: #display-code
  - queue_position: AFTER #literals
  - syntax_type: BLOCK
  - allowed_flags:
      u=KEEP_HTML_UNESCAPED
      i=KEEP_INDENTED
      w=REDUCE_WHITESPACE
  - extensible_delimiter: ``
  - attribute_specifications: EMPTY
  - content_replacements:
      #escape-html
      #de-indent
      #reduce-whitespace
      #code-tag-wrap
      #placeholder-protect
  - tag_name: pre
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @(``)@
      «content»
    @(``)@
  ````
  ````{.cmd .cmdc}
    @(``)@{«attribute specifications»}
      «content»
    @(``)@
  ````
  ````{.cmd .cmdc}
    «flags»@(``)@
      «content»
    @(``)@
  ````
  ````{.cmd .cmdc}
    «flags»@(``)@{«attribute specifications»}
      «content»
    @(``)@
  ````
  ====
  - `{.cmd .cmdc} «flags»`:
    ==
    - `{.cmd .cmdc} u`: keep HTML unescaped (do not apply [`#escape-html`])
    - `{.cmd .cmdc} t`: keep indented (do not apply [`#de-indent`])
    - `{.cmd .cmdc} w`: reduce whitespace (apply [`#reduce-whitespace`])
    ==
  - The number of backticks ``{.cmd .cmdc} @(`)@ ``
    may be increased arbitrarily.
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ====
}}
{{des
  --
  Produces (pre-formatted) display code:
  --
  ````{.html}
    @(<pre)@«attribute sequence»@(><code>)@«content»
    @(</code></pre>)@
  ````
}}
{{ex
  ++
  1.
    Display code:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ``{.java}
          for (int index = 0; index < count; index++)
          {
            // etc. etc.
          }
        ``
      ````
    - HTML:
      <|||
        ``{.java}
          for (int index = 0; index < count; index++)
          {
            // etc. etc.
          }
        ``
      |||>
    - Rendered:
        ``{.java}
          for (int index = 0; index < count; index++)
          {
            // etc. etc.
          }
        ``
    ==
  1.
    Use [`#literals`] with flag `{.cmd .cmdc} u` to inject HTML:
    ==
    - CMD:
      ``````{.cmd .cmdc}
      <````
        ``
          Injection of <b> element u<` <b>here</b> `>.
        ``
      ````>
      ``````
    - HTML:
      <||
        ``
          Injection of <b> element u<` <b>here</b> `>.
        ``
      ||>
    - Rendered:
        ``
          Injection of <b> element u<` <b>here</b> `>.
        ``
    ==
  ++
}}

####{#comments} 3. `#comments`
[`#comments`]: #comments

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #comments
  - queue_position: AFTER #display-code
  * [^\S\n]*
    [<]
      (?P<hashes> [#]+ )
        [\s\S]*?
      (?P=hashes)
    [>]
      -->
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @(<)@@(#)@ «content» @(#)@@(>)@
  ````
  ====
  - The number of hashes ``{.cmd .cmdc} @(#)@ `` may be increased arbitrarily.
  ====
}}
{{des
  --
  Remove CMD comments, along with all preceding whitespace.
  --
}}
{{ex
  ++
  1.
    [`#display-code`] prevails over `#comments`:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ``
          Before.
          <# This be a comment. #>
          After.
        ``
      ````
    - HTML:
      <||
        ``
          Before.
          <# This be a comment. #>
          After.
        ``
      ||>
    - Rendered:
        ``
          Before.
          <# This be a comment. #>
          After.
        ``
    ==
  1.
    `#comments` prevail over [`#inline-code`]:
    ==
    - CMD: ``{.cmd .cmdc} <`` `Before. <# This be a comment. #> After.` ``> ``
    - HTML: <| `Before. <# This be a comment. #> After.` |>
    - Rendered: `Before. <# This be a comment. #> After.`
    ==
  1.
    Use [`#literals`] to make [`#inline-code`] prevail over `#comments`:
    ==
    - CMD:
      ``{.cmd .cmdc} <`` ` <`Before. <# This be a comment. #> After.`> ` ``> ``
    - HTML:
        <|| ` <`Before. <# This be a comment. #> After.`> ` ||>
    - Rendered:
        ` <`Before. <# This be a comment. #> After.`> `
    ==
  ++
}}

####{#divisions} 4. `#divisions`
[`#divisions`]: #divisions

{{def
  ``{.cmd .cmdr}
  ExtensibleFenceReplacement: #divisions
  - queue_position: AFTER #comments
  - syntax_type: BLOCK
  - extensible_delimiter: ||
  - attribute_specifications: EMPTY
  - content_replacements:
      #divisions
      #prepend-newline
  - tag_name: div
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @(||)@
      «content»
    @(||)@
  ````
  ````{.cmd .cmdc}
    @(||)@{«attribute specifications»}
      «content»
    @(||)@
  ````
  ====
  - The number of pipes ``{.cmd .cmdc} @(|)@ `` may be increased arbitrarily.
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ====
}}
{{des
  --
  Produces a division:
  --
  ````{.html}
    @(<div)@«attribute sequence»@(>)@
    «content»
    @(</div>)@
  ````
}}
{{ex
  ++
  1.
    Division:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ||{#test-div-id .test-div-class}
          This be a division.
        ||
      ````
    - HTML:
      <||
        ||{#test-div-id .test-div-class}
          This be a division.
        ||
      ||>
    ==
  1.
    More pipes for nested divisions:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ||||{.outer}
          ||{.inner}
            This be a division.
          ||
        ||||
      ````
    - HTML:
      <||
        ||||{.outer}
          ||{.inner}
            This be a division.
          ||
        ||||
      ||>
    ==
  ++
}}

####{#blockquotes} 5. `#blockquotes`
[`#blockquotes`]: #blockquotes

{{def
  ``{.cmd .cmdr}
  ExtensibleFenceReplacement: #blockquotes
  - queue_position: AFTER #divisions
  - syntax_type: BLOCK
  - extensible_delimiter: ""
  - attribute_specifications: EMPTY
  - content_replacements:
      #blockquotes
      #prepend-newline
  - tag_name: blockquote
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @("")@
      «content»
    @("")@
  ````
  ````{.cmd .cmdc}
    @("")@{«attribute specifications»}
      «content»
    @("")@
  ````
  ====
  - The number of double-quotes ``{.cmd .cmdc} @(")@ ``
    may be increased arbitrarily.
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ====
}}
{{des
  --
  Produces a blockquote:
  --
  ````{.html}
    @(<blockquote)@«attribute sequence»@(>)@
    «content»
    @(</blockquote>)@
  ````
}}
{{ex
  ++
  1.
    Blockquote:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ""{#test-blockquote-id .test-blockquote-class}
          This be a blockquote.
        ""
      ````
    - HTML:
      <||
        ""{#test-blockquote-id .test-blockquote-class}
          This be a blockquote.
        ""
      ||>
    ==
  ++
}}

####{#unordered-lists} 6. `#unordered-lists`
[`#unordered-lists`]: #unordered-lists

{{def
  ``{.cmd .cmdr}
  ExtensibleFenceReplacement: #unordered-lists
  - queue_position: AFTER #blockquotes
  - syntax_type: BLOCK
  - extensible_delimiter: ==
  - attribute_specifications: EMPTY
  - content_replacements:
      #unordered-lists
      #unordered-list-items
      #prepend-newline
  - tag_name: ul
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @(==)@
    @(-)@ «item»
    «...»
    @(==)@
  ````
  ````{.cmd .cmdc}
    @(==)@{«attribute specifications»}
    @(-)@{«attribute specifications»} «item»
    «...»
    @(==)@
  ````
  ====
  - The number of equals signs ``{.cmd .cmdc} @(=)@ ``
    may be increased arbitrarily.
  - The item delimiter may be
    `{.cmd .cmdc} @(-)@`, `{.cmd .cmdc} @(+)@`, or `{.cmd .cmdc} @(*)@`,
    see [`#unordered-list-items`].
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ====
}}
{{des
  --
  Produces an unordered list:
  --
  ````{.html}
    @(<ul)@«attribute sequence»@(>)@
    @(<li>)@
    «item»
    @(</li>)@
    «...»
    @(</ul>)@
  ````
}}
{{ex
  ++
  1.
    Nested list:
    ========
    - CMD:
      ````{.cmd .cmdc}
        ======
        * A
          ===={style="background: yellow"}
          - A1
          - A2
          ====
        - B
          ====
          +{style="color: purple"} B1
          - B2
          ====
        ======
      ````
    - Rendered:
        ======
        * A
          ===={style="background: yellow"}
          - A1
          - A2
          ====
        - B
          ====
          +{style="color: purple"} B1
          - B2
          ====
        ======
    ========
  ++
}}

####{#ordered-lists} 7. `#ordered-lists`
[`#ordered-lists`]: #ordered-lists

{{def
  ``{.cmd .cmdr}
  ExtensibleFenceReplacement: #ordered-lists
  - queue_position: AFTER #unordered-lists
  - syntax_type: BLOCK
  - extensible_delimiter: ++
  - attribute_specifications: EMPTY
  - content_replacements:
      #ordered-lists
      #ordered-list-items
      #prepend-newline
  - tag_name: ol
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @(++)@
    @(1.)@ «item»
    «...»
    @(++)@
  ````
  ````{.cmd .cmdc}
    @(++)@{«attribute specifications»}
    @(1.)@{«attribute specifications»} «item»
    «...»
    @(++)@
  ````
  ====
  - The number of plus signs ``{.cmd .cmdc} @(+)@ ``
    may be increased arbitrarily.
  - The item delimiter may be any __run of digits__
    followed by a __full stop__,
    see [`#ordered-list-items`].
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ====
}}
{{des
  --
  Produces an ordered list:
  --
  ````{.html}
    @(<ol)@«attribute sequence»@(>)@
    @(<li>)@
    «item»
    @(</li>)@
    «...»
    @(</ol>)@
  ````
}}
{{ex
  ++++++++
  1.
    Any run of digits can be used in the item delimiter:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ++
        1. A
        2. B
        3. C
        0. D
        99999999. E
        ++
      ````
    - Rendered:
        ++
        1. A
        2. B
        3. C
        0. D
        99999999. E
        ++
    ==
  2.
    Nested ordered lists:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ++++
        1. This shall be respected.
        2. This shall be read aloud if:
          ++{type="a"}
          1. I say so;
          2. I think so; or
          3.{style="color: purple"} Pigs fly.
          ++
        ++++
      ````
    - Rendered:
        ++++
        1. This shall be respected.
        2. This shall be read aloud if:
          ++{type="a"}
          1. I say so;
          2. I think so; or
          3.{style="color: purple"} Pigs fly.
          ++
        ++++
    ==
  3.
    Zero-based indexing:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ++{start=0}
        0. Nil
        1. One
        ++
      ````
    - Rendered:
        ++{start=0}
        0. Nil
        1. One
        ++
    ==
  ++++++++
}}


###{#standard-unqueued-replacements} Standard unqueued replacements

####{#placeholder-protect} `#placeholder-protect`
[`#placeholder-protect`]: #placeholder-protect

{{def
  ``{.cmd .cmdr}
  PlaceholderProtectionReplacement: #placeholder-protect
  ``
}}
{{des
  --
  Protects a string with a [placeholder].
  --
}}
{{dep
  ==
  - [`#literals`]
  - [`#display-code`]
  - [`#inline-code`]
  - [`#cmd-properties`]
  - [`#boilerplate-protect`]
  - [`#backslash-escapes`]
  - [`#angle-bracket-wrap`]
  ==
}}

####{#de-indent} `#de-indent`
[`#de-indent`]: #de-indent

{{def
  ``{.cmd .cmdr}
  DeIndentationReplacement: #de-indent
  - negative_flag: KEEP_INDENTED
  ``
}}
{{des
  --
  Removes the longest common indentation in a string.
  --
}}
{{dep
  ==
  - [`#literals`]
  - [`#display-code`]
  - [`#inline-code`]
  ==
}}

####{#escape-html} `#escape-html`
[`#escape-html`]: #escape-html

{{def
  ``{.cmd .cmdr}
  OrdinaryDictionaryReplacement: #escape-html
  - negative_flag: KEEP_HTML_UNESCAPED
  - apply_mode: SIMULTANEOUS
  * & --> &amp;
  * < --> &lt;
  * > --> &gt;
  ``
}}
{{des
  --
  Escapes `&`, ` < `, and ` > ` as their respective HTML ampersand entities.
  --
}}
{{dep
  ==
  - [`#literals`]
  - [`#display-code`]
  - [`#inline-code`]
  ==
}}

####{#trim-whitespace} `#trim-whitespace`
[`#trim-whitespace`]: #trim-whitespace

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #trim-whitespace
  * \A [\s]* -->
  * [\s]* \Z -->
  ``
}}
{{des
  --
  Removes whitespace at the very start and very end of the string.
  --
}}
{{dep
  ==
  - [`#literals`]
  - [`#table-headers`]
  - [`#table-data`]
  - [`#inline-code`]
  ==
}}

####{#reduce-whitespace} `#reduce-whitespace`
[`#reduce-whitespace`]: #reduce-whitespace

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #reduce-whitespace
  - positive_flag: REDUCE_WHITESPACE
  * ^ [^\S\n]+ -->
  * [^\S\n]+ $ -->
  * [\s]+ (?= <br> ) -->
  * [\n]+ --> \n
  ``
}}
{{des
  ++
  1. Removes leading horizontal whitespace on each line.
  1. Removes trailing horizontal whitespace on each line.
  1. Removes whitespace before `{.cmd .cmdc} <br>`.
  1. Collapsed multiple consecutive newlines into a single newline.
  ++
}}
{{dep
  ==
  - [`#literals`]
  - [`#display-code`]
  - [`#inline-code`]
  - [`#boilerplate-protect`]
  - [`#whitespace`]
  ==
}}

####{#code-tag-wrap} `#code-tag-wrap`
[`#code-tag-wrap`]: #code-tag-wrap

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #code-tag-wrap
  * \A --> <code>
  * \Z --> </code>
  ``
}}
{{des
  --
  Wraps a string in opening and closing `code` tags.
  --
}}
{{dep
  ==
  - [`#display-code`]
  ==
}}

####{#prepend-newline} `#prepend-newline`
[`#prepend-newline`]: #prepend-newline

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #prepend-newline
  * \A --> \n
  ``
}}
{{des
  --
  Adds a newline at the very start of a string.
  --
}}
{{dep
  ==
  - [`#divisions`]
  - [`#blockquotes`]
  - [`#unordered-list-items`]
  - [`#unordered-lists`]
  - [`#ordered-list-items`]
  - [`#ordered-lists`]
  - [`#table-rows`]
  - [`#table-head`]
  - [`#table-body`]
  - [`#table-foot`]
  - [`#tables`]
  - [`#paragraphs`]
  ==
}}

####{#unordered-list-items} `#unordered-list-items`
[`#unordered-list-items`]: #unordered-list-items

{{def
  ``{.cmd .cmdr}
  PartitioningReplacement: #unordered-list-items
  - starting_pattern: [-+*]
  - attribute_specifications: EMPTY
  - content_replacements:
      #prepend-newline
  - ending_pattern: [-+*]
  - tag_name: li
  ``
}}
{{des
  --
  Partitions content into list items based on leading occurrences of
  `{.cmd .cmdc} @(-)@`, `{.cmd .cmdc} @(+)@`, or `{.cmd .cmdc} @(*)@`.
  --
}}
{{dep
  ==
  - [`#unordered-lists`]
  ==
}}

####{#ordered-list-items} `#ordered-list-items`
[`#ordered-list-items`]: #ordered-list-items

{{def
  ``{.cmd .cmdr}
  PartitioningReplacement: #ordered-list-items
  - starting_pattern: [0-9]+ [.]
  - attribute_specifications: EMPTY
  - content_replacements:
      #prepend-newline
  - ending_pattern: [0-9]+ [.]
  - tag_name: li
  ``
}}
{{des
  --
  Partitions content into list items based on leading occurrences of
  a __run of digits__ followed by a __full stop__.
  --
}}
{{dep
  ==
  - [`#ordered-lists`]
  ==
}}

####{#mark-table-headers-for-preceding-table-data}
  `#mark-table-headers-for-preceding-table-data`
[`#mark-table-headers-for-preceding-table-data`]:
  #mark-table-headers-for-preceding-table-data

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #mark-table-headers-for-preceding-table-data
  * \A --> ;{}
  # Replaces `<th«attributes_sequence»>` with `;{}<th«attributes_sequence»>`,
  # so that #table-data will know to stop before it.
  ``
}}
{{des
  --
  Replaces `{.cmd .cmdc} <th«attributes_sequence»>`
  with `{.cmd .cmdc} ;{}<th«attributes_sequence»>`
  so that [`#table-data`] will know to stop before it.
  --
}}
{{dep
  ==
  - [`#table-headers`]
  ==
}}

####{#table-headers} `#table-headers`
[`#table-headers`]: #table-headers

{{def
  ``{.cmd .cmdr}
  PartitioningReplacement: #table-headers
  - starting_pattern: [;]
  - attribute_specifications: EMPTY
  - content_replacements:
      #trim-whitespace
  - ending_pattern: [;,]
  - tag_name: th
  - concluding_replacements:
      #mark-table-headers-for-preceding-table-data
  ``
}}
{{des
  --
  Partitions content into table headers
  based on leading occurrences of `{.cmd .cmdc} @(;)@`
  up to the next leading `{.cmd .cmdc} @(;)@` or `{.cmd .cmdc} @(,)@`.
  --
}}
{{dep
  ==
  - [`#table-rows`]
  ==
}}

####{#table-data} `#table-data`
[`#table-data`]: #table-data

{{def
  ``{.cmd .cmdr}
  PartitioningReplacement: #table-data
  - starting_pattern: [,]
  - attribute_specifications: EMPTY
  - content_replacements:
      #trim-whitespace
  - ending_pattern: [;,]
  - tag_name: td
  ``
}}
{{des
  --
  Partitions content into table data
  based on leading occurrences of `{.cmd .cmdc} @(,)@`
  up to the next leading `{.cmd .cmdc} @(;)@` or `{.cmd .cmdc} @(,)@`.
  --
}}
{{dep
  ==
  - [`#table-rows`]
  ==
}}


##{#replacement-rule-syntax} CMD replacement rule syntax


##{#cmd-placeholders} CMD placeholders
[placeholder]: #cmd-placeholders

--
There are many instances in which the result of a replacement
should not be altered further by replacements to follow.
To protect a string from further alteration,
it is temporarily replaced by a __placeholder__
consisting of code points in the main Unicode Private Use Area.
--
--
Specifically, the placeholder for a string shall be of the following form:
--
``{.cmd .cmdc}
@(«marker»)@@(«run_characters»)@@(«marker»)@
``
==
- __`{.cmd .cmdc} «marker»`__ is `«U+F8FF»`.
- __`{.cmd .cmdc}«run_characters»`__ are between `«U+E000»` and `«U+E0FF»`
  each representing a Unicode byte of the string.
==

--
It is assumed that the user will not define replacement rules that
tamper with strings of the form
`{.cmd .cmdc} «marker»«run_characters»«marker»`.
--

### Example

==
- Consider the string `{.cmd .cmdc} £3`.
- Its code points are `U+00A3` and `U+0033`.
- The corresponding Unicode bytes are
  `\x@(C2)@\x@(A3)@` and u`\x@(33)@`.
- The `{.cmd .cmdc}«run_characters»` are therefore
  `«U+E0@(C2)@»«U+E0@(A3)@»«U+E0@(33)@»`.
- The full placeholder is therefore
  `«U+F8FF»«U+E0@(C2)@»«U+E0@(A3)@»«U+E0@(33)@»«U+F8FF»`.
==


##{#cmd-attribute-specifications} CMD attribute specifications
[CMD attribute specifications]: #cmd-attribute-specifications

--
When a CMD replacement rule is defined with
`{.cmd .cmdr} attribute_specifications` not equal to `{.cmd .cmdr} NONE`,
it allows HTML attributes to be specified by __CMD attribute specifications__
enclosed in curly brackets.
--
--
CMD attribute specifications may be of the following forms:
--
``{.cmd .cmdc}
«name»@(=)@"«quoted value (whitespace allowed)»"
«name»@(=)@«bare-value»
@(#)@«id»
@(.)@«class»
@(r)@«rowspan»
@(c)@«colspan»
@(w)@«width»
@(h)@«height»
@(-)@«delete-name»
«boolean-name»
``
--
In the two forms with an explicit equals sign,
the following abbreviations are allowed for `{.cmd .cmdc} «name»`:
--
==
- `{.cmd .cmdc} #` for `{.cmd .cmdc} id`
- `{.cmd .cmdc} .` for `{.cmd .cmdc} class`
- `{.cmd .cmdc} l` for `{.cmd .cmdc} lang`
- `{.cmd .cmdc} r` for `{.cmd .cmdc} rowspan`
- `{.cmd .cmdc} c` for `{.cmd .cmdc} colspan`
- `{.cmd .cmdc} w` for `{.cmd .cmdc} width`
- `{.cmd .cmdc} h` for `{.cmd .cmdc} height`
- `{.cmd .cmdc} s` for `{.cmd .cmdc} style`
==

### Examples

++
1.
  Behaviour for the standard rule [`#inline-code`]:
  ==
  - CMD: ``{.cmd .cmdc} `{#foo .bar l=en-AU title="baz"} test` ``
  - HTML: <| `{#foo .bar l=en-AU title="baz"} test` |>
  ==

1. Empty attribute specifications:
  ==
  - CMD: ``{.cmd .cmdc} `{} test` ``
  - HTML: <| `{} test` |>
  ==

1.
  Non-`class` values will supersede earlier ones:
  ==
  - CMD: ``{.cmd .cmdc} `{#1 #2 title=A title=B} test` ``
  - HTML: <| `{#1 #2 title=A title=B} test` |>
  ==

1.
  `class` values will accumulate:
  ==
  - CMD: ``{.cmd .cmdc} `{.a .b class=c .d} test` ``
  - HTML: <| `{.a .b class=c .d} test` |>
  ==

1.
  Delete `class` to reset it:
  ==
  - CMD: ``{.cmd .cmdc} `{.a .b -class class=c .d} test` ``
  - HTML: <| `{.a .b -class class=c .d} test` |>
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
