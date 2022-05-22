OrdinaryDictionaryReplacement: #boilerplate-properties-override
- queue_position: BEFORE #boilerplate-properties
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
* @( --> <b>
* )@ --> </b>
- concluding_replacements: #placeholder-protect

OrdinaryDictionaryReplacement: #details-summary-shorthand
- queue_position: BEFORE #whitespace
* {{def -->
    '{{
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
* {{std -->
    '{{
    <summary>Standard rules usage</summary>
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


##{#contents} Contents

======
- [Installation and usage](#installation-and-usage)
- [Authoring CMD files](#authoring-cmd-files)
- [Standard CMD replacement rules](#standard-rules)
  ====
  - [Standard queued replacements](#standard-queued-replacements)
    ++{start=0}
    0. [`#placeholder-markers`]
    1. [`#literals`]
    2. [`#display-code`]
    3. [`#comments`]
    4. [`#divisions`]
    5. [`#blockquotes`]
    6. [`#unordered-lists`]
    7. [`#ordered-lists`]
    8. [`#tables`]
    9. [`#headings`]
    10. [`#paragraphs`]
    11. [`#inline-code`]
    12. [`#boilerplate`]
    13. [`#boilerplate-properties`]
    14. [`#cmd-properties`]
    15. [`#boilerplate-protect`]
    16. [`#backslash-escapes`]
    17. [`#backslash-continuations`]
    18. [`#reference-definitions`]
    19. [`#specified-images`]
    20. [`#referenced-images`]
    21. [`#explicit-links`]
    22. [`#specified-links`]
    23. [`#referenced-links`]
    24. [`#inline-semantics`]
    25. [`#escape-idle-html`]
    26. [`#whitespace`]
    27. [`#placeholder-unprotect`]
    ++
  - [Standard unqueued replacements](#standard-unqueued-replacements)
    ==
    - [`#placeholder-protect`]
    - [`#de-indent`]
    - [`#escape-html`]
    - [`#trim-whitespace`]
    - [`#reduce-whitespace`]
    - [`#code-tag-wrap`]
    - [`#prepend-newline`]
    - [`#unordered-list-items`]
    - [`#ordered-list-items`]
    - [`#mark-table-headers-for-preceding-table-data`]
    - [`#table-headers`]
    - [`#table-data`]
    - [`#unmark-table-headers-for-preceding-table-data`]
    - [`#table-rows`]
    - [`#table-head`]
    - [`#table-body`]
    - [`#table-foot`]
    - [`#suppress-scheme`]
    - [`#angle-bracket-wrap`]
    ==
  ====
- [CMD replacement rule syntax](#replacement-rule-syntax)
  ==
  - [`ReplacementSequence`]
  - [`PlaceholderMarkerReplacement`]
  - [`PlaceholderProtectionReplacement`]
  - [`PlaceholderUnprotectionReplacement`]
  - [`DeIndentationReplacement`]
  - [`OrdinaryDictionaryReplacement`]
  - [`RegexDictionaryReplacement`]
  - [`FixedDelimitersReplacement`]
  - [`ExtensibleFenceReplacement`]
  - [`PartitioningReplacement`]
  - [`InlineAssortedDelimitersReplacement`]
  - [`HeadingReplacement`]
  - [`ReferenceDefinitionReplacement`]
  - [`SpecifiedImageReplacement`]
  -  [`ReferencedImageReplacement`]
  - [`ExplicitLinkReplacement`]
  - [`SpecifiedLinkReplacement`]
  - [`ReferencedLinkReplacement`]
  ==
- [CMD placeholders](#cmd-placeholders)
- [CMD attribute specifications](#cmd-attribute-specifications)
- [Repository links](#repository-links)
======


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
[Authoring CMD files]: #authoring-cmd-files

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
This section lists the standard CMD replacement rules
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
    - `{.cmd .cmdc} i`: keep indented (do not apply [`#de-indent`])
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
    - `{.cmd .cmdc} i`: keep indented (do not apply [`#de-indent`])
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

####{#tables} 8. `#tables`
[`#tables`]: #tables

{{def
  ``{.cmd .cmdr}
  ExtensibleFenceReplacement: #tables
  - queue_position: AFTER #ordered-lists
  - syntax_type: BLOCK
  - extensible_delimiter: ''
  - attribute_specifications: EMPTY
  - content_replacements:
      #tables
      #table-head
      #table-body
      #table-foot
      #table-rows
      #prepend-newline
  - tag_name: table
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @('')@
    @(|^)@ «item»
      @(//)@ «item»
        @(;)@ «item»
        @(,)@ «item»
        «...»
      «...»
    @(|:)@ «item»
      «...»
    @(|_)@ «item»
      «...»
    @('')@
  ````
  ````{.cmd .cmdc}
    @('')@
    @(//)@ «item»
      @(;)@ «item»
      @(,)@ «item»
      «...»
    «...»
    @('')@
  ````
  ````{.cmd .cmdc}
    @('')@{«attribute specifications»}
    «...»
    @('')@
  ````
  ====
  - The number of single-quotes ``{.cmd .cmdc} @(')@ ``
    may be increased arbitrarily.
  - Table parts:
    ==
    - `{.cmd .cmdc} @(|^)@` for table head, see [`#table-head`].
    - `{.cmd .cmdc} @(|:)@` for table body, see [`#table-body`].
    - `{.cmd .cmdc} @(|:)@` for table foot, see [`#table-foot`].
    ==
  - Table cells:
    ==
    - `{.cmd .cmdc} @(;)@` for table headers, see [`#table-headers`].
    - `{.cmd .cmdc} @(,)@` for table data, see [`#table-data`].
    ==
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ====
}}
{{des
  --
  Produces a table:
  --
  ````{.html}
    @(<table)@«attribute sequence»@(>)@
    «...»
    @(</table>)@
  ````
}}
{{ex
  ++++++++
  1.
    Table without parts:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ''
        //
          ; A
          , 1
        //
          ; B
          , 2
        ''
      ````
    - HTML:
      <||
        ''
        //
          ; A
          , 1
        //
          ; B
          , 2
        ''
      ||>
    - Rendered:
        ''
        //
          ; A
          , 1
        //
          ; B
          , 2
        ''
    ==
  1.
    Table with head and body:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ''
        |^
          //
            ; A
            ; B
        |:
          //
            , 1
            , 2
          //
            , First
            , Second
        ''
      ````
    - HTML:
      <||
        ''
        |^
          //
            ; A
            ; B
        |:
          //
            , 1
            , 2
          //
            , First
            , Second
        ''
      ||>
    - Rendered:
        ''
        |^
          //
            ; A
            ; B
        |:
          //
            , 1
            , 2
          //
            , First
            , Second
        ''
    ==
  1.
    Cell merging
    ==
    - CMD:
      ````{.cmd .cmdc}
        ''
        //
          ,{c3} 3*1
          , 14
        //
          , 21
          , 22
          , 23
          , 24
        //
          ,{rowspan=2 colspan="2"} 2*2
          , 33
          ,{r2} 2*1
        //
          , 43
        ''
      ````
    - Rendered
        ''
        //
          ,{c3} 3*1
          , 14
        //
          , 21
          , 22
          , 23
          , 24
        //
          ,{rowspan=2 colspan="2"} 2*2
          , 33
          ,{r2} 2*1
        //
          , 43
        ''
    ==
  ++++++++
}}

####{#headings} 9. `#headings`
[`#headings`]: #headings

{{def
  ``{.cmd .cmdr}
  HeadingReplacement: #headings
  - queue_position: AFTER #tables
  - attribute_specifications: EMPTY
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @(#)@ «content»
  ````
  ````{.cmd .cmdc}
    @(#)@{«attribute specifications»} «content»
  ````
  ====
  - The number of hashes ``{.cmd .cmdc} @(#)@ `` may be between 1 and 6.
  - ``{.cmd .cmdc} «content»`` may be optionally closed by hashes.
  - For continuation of ``{.cmd .cmdc} «content»``,
    indent the continuation more than the leading hashes.
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ====
}}
{{des
  --
  Produces a heading:
  --
  ````{.html}
    @(<h«hash count»>)@«content»@(</h«hash count»>)@
  ````
}}
{{ex
  ++
  1.
    Empty headings:
    ==
    - CMD:
      ````{.cmd .cmdc}
        #
        ##
        ###
        ####
        #####
        ######
      ````
    - HTML:
      <||
        #
        ##
        ###
        ####
        #####
        ######
      ||>
    ==
  1.
    Non-empty headings require whitespace after the hashes:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ## OK
        #lacks-whitespace
      ````
    - HTML:
      <||
        ## OK
        #lacks-whitespace
      ||>
    ==
  1.
    Optional closing hashes:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ## Closed ##
        ## Fewer closing hashes is OK #
        ## More closing hashes is OK ###
      ````
    - HTML:
      <||
        ## Closed ##
        ## Fewer closing hashes is OK #
        ## More closing hashes is OK ###
      ||>
    ==
  1.
    Continuation:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ##{.interesting-heading-class}
          This heading is so long, I have used continuation.
          Second continuation line.
        This line is not a continuation due to insufficient indentation.
      ````
    - HTML:
      <||
        ##{.interesting-heading-class}
          This heading is so long, I have used continuation.
          Second continuation line.
        This line is not a continuation due to insufficient indentation.
      ||>
    ==
  ++
}}

####{#paragraphs} 10. `#paragraphs`
[`#paragraphs`]: #paragraphs

{{def
  ``{.cmd .cmdr}
  ExtensibleFenceReplacement: #paragraphs
  - queue_position: AFTER #headings
  - syntax_type: BLOCK
  - extensible_delimiter: --
  - attribute_specifications: EMPTY
  - prohibited_content: BLOCKS
  - content_replacements:
      #prepend-newline
  - tag_name: p
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @(--)@
    «content»
    @(--)@
  ````
  ````{.cmd .cmdc}
    @(--)@{«attribute specifications»}
    «content»
    @(--)@
  ````
  ====
  - The number of hyphens ``{.cmd .cmdc} @(-)@ `` may be increased arbitrarily.
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ====
}}
{{des
  --
  Produces a paragraph:
  --
  ````{.html}
    @(<p)@«attribute sequence»@(>)@
    «content»
    @(</p>)@
  ````
}}
{{ex
  ++
  1.
    Paragraph:
    ==
    - CMD:
      ````{.cmd .cmdc}
        --
        The quick brown fox etc. etc.
        --
      ````
    - HTML:
      <||
        --
        The quick brown fox etc. etc.
        --
      ||>
    - Rendered:
        --
        The quick brown fox etc. etc.
        --
    ==
  1.
    Paragraphs cannot be nested:
    ==
    - CMD:
      ````{.cmd .cmdc}
        ----
        Before.
        --
        Not a nested paragraph.
        --
        After.
        ----
      ````
    - HTML:
      <||
        ----
        Before.
        --
        Not a nested paragraph.
        --
        After.
        ----
      ||>
    - Rendered:
        ----
        Before.
        --
        Not a nested paragraph.
        --
        After.
        ----
    ==
  ++
}}

####{#inline-code} 11. `#inline-code`
[`#inline-code`]: #inline-code

{{def
  ``{.cmd .cmdr}
  ExtensibleFenceReplacement: #inline-code
  - queue_position: AFTER #paragraphs
  - syntax_type: INLINE
  - allowed_flags:
      u=KEEP_HTML_UNESCAPED
      i=KEEP_INDENTED
      w=REDUCE_WHITESPACE
  - extensible_delimiter: `
  - attribute_specifications: EMPTY
  - prohibited_content: ANCHORED_BLOCKS
  - content_replacements:
      #escape-html
      #de-indent
      #trim-whitespace
      #reduce-whitespace
      #placeholder-protect
  - tag_name: code
  ``
}}
{{syn
  ````{.cmd .cmdc}
    @(`)@ «content» @(`)@
  ````
  ````{.cmd .cmdc}
    @(`)@{«attribute specifications»} «content» @(`)@
  ````
  ````{.cmd .cmdc}
    «flags»@(`)@ «content» @(`)@
  ````
  ````{.cmd .cmdc}
    «flags»@(`)@{«attribute specifications»} «content» @(`)@
  ````
  ====
  - `{.cmd .cmdc} «flags»`:
    ==
    - `{.cmd .cmdc} u`: keep HTML unescaped (do not apply [`#escape-html`])
    - `{.cmd .cmdc} i`: keep indented (do not apply [`#de-indent`])
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
  Produces inline code:
  --
  ````{.html}
  @(<code)@«attribute sequence»@(>)@«content»@(</code>)@
  ````
}}
{{ex
  ++
  1.
    Code:
    ==
    - CMD: ``{.cmd .cmdc} `<br>` ``
    - HTML: <| `<br>` |>
    - Rendered: `<br>`
    ==
  1.
    Code containing backticks:
    ==
    - CMD: ````{.cmd .cmdc} ``A `backticked` word.`` ````
    - HTML: <| ``A `backticked` word.`` |>
    - Rendered: ``A `backticked` word.``
    ==
  1.
    Use [`#literals`] with flag `{.cmd .cmdc} u` to inject HTML:
    ==
    - CMD: ``{.cmd .cmdc} <`` `Some u<`<b>bold</b>`> code` ``> ``
    - HTML: <| `Some u<`<b>bold</b>`> code` |>
    - Rendered: `Some u<`<b>bold</b>`> code`
    ==
  ++
}}

####{#boilerplate} 12. `#boilerplate`
[`#boilerplate`]: #boilerplate

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #boilerplate
  - queue_position: AFTER #inline-code
  * \A -->
      <!DOCTYPE html>
      <html lang="%lang">
        <head>
          <meta charset="utf-8">
          %head-elements-before-viewport
          <meta name="viewport" content="%viewport-content">
          %head-elements-after-viewport
          <title>%title</title>
          <style>
            %styles
          </style>
        </head>
        <body>\n
  * \Z -->
        </body>
      </html>\n
  ``
}}
{{des
  --
  Wraps content in the HTML5 boilerplate:
  --
  ==
  - `{.html} <!DOCTYPE html>` through `{.html} <body>` at the start
  - `{.html} </body></html>` at the end
  ==
  --
  The default boilerplate properties
  `{.cmd .cmdc} %lang`,
  `{.cmd .cmdc} %head-elements-before-viewport`,
  `{.cmd .cmdc} %viewport-content`,
  `{.cmd .cmdc} %head-elements-after-viewport`,
  `{.cmd .cmdc} %title`, and
  `{.cmd .cmdc} %styles`
  are set in [`#boilerplate-properties`].
  --
}}

####{#boilerplate-properties} 13. `#boilerplate-properties`
[`#boilerplate-properties`]: #boilerplate-properties

{{def
  ``{.cmd .cmdr}
  OrdinaryDictionaryReplacement: #boilerplate-properties
  - queue_position: AFTER #boilerplate
  * %lang --> en
  * %head-elements-before-viewport -->
  * %viewport-content --> width=device-width, initial-scale=1
  * %head-elements-after-viewport -->
  * %title --> Title
  * %styles -->
  ``
}}
{{des
  --
  Makes replacements for the default boilerplate properties:
  --
  ''''
  |^
    //
      ; Property
      ; Default value
  |:
    //
      , `{.cmd .cmdc} %lang`
      , `{.html} en`
    //
      , `{.cmd .cmdc} %head-elements-before-viewport`
      , (empty)
    //
      , `{.cmd .cmdc} %viewport-content`
      , `{.html} width=device-width, initial-scale=1`
    //
      , `{.cmd .cmdc} %head-elements-after-viewport`
      , (empty)
    //
      , `{.cmd .cmdc} %title`
      , `{.html} Title`
    //
      , `{.cmd .cmdc} %styles`
      , (empty)
  ''''
}}
{{ex
  ++
  1.
    Defaults:
    ==
    - CMD:
      ``{.cmd .cmdc}
      # %title
      This document hath `lang` equal to <code>%lang</code>.
      ``
    - HTML (including boilerplate):
      ``{.html}
      <!DOCTYPE html>
      <html lang="en">
      <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Title</title>
      </head>
      <body>
      <h1>Title</h1>
      This document hath <code>lang</code> equal to <code>en</code>.
      </body>
      </html>
      ``
    ==
  1.
    Override the defaults:
    ==
    - CMD:
      u````{.cmd}
      <span class="cmdr"><``
        OrdinaryDictionaryReplacement: #boilerplate-properties-override
        - queue_position: BEFORE #boilerplate-properties
        * %lang --> en-AU
        * %head-elements-before-viewport --> <meta name="author" content="Me">
        * %title --> Overridden title
      ``></span>
      <`` ``>
      %%%
      <`` ``>
      <span class="cmdc"><``
        # %title
        This document hath `lang` equal to <code>%lang</code>.
      ``></span>
      ````
    - HTML (including boilerplate):
      ``{.html}
      <!DOCTYPE html>
      <html lang="en-AU">
      <head>
      <meta charset="utf-8">
      <meta name="author" content="Me">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Overridden title</title>
      </head>
      <body>
      <h1>Overridden title</h1>
      This document hath <code>lang</code> equal to <code>en-AU</code>.
      </body>
      </html>
      ``
    ==
  ++
}}

####{#cmd-properties} 14. `#cmd-properties`
[`#cmd-properties`]: #cmd-properties

{{def
  ``{.cmd .cmdr}
  OrdinaryDictionaryReplacement: #cmd-properties
  - queue_position: AFTER #boilerplate-properties
  * %cmd-version --> CMD_VERSION
  * %cmd-name --> CMD_NAME
  * %cmd-basename --> CMD_BASENAME
  - concluding_replacements:
      #placeholder-protect
  ``
}}
{{des
  --
  Makes replacements for CMD properties:
  --
  ''''
  |^
    //
      ; Property
      ; Description
  |:
    //
      , `{.cmd .cmdc} %cmd-version`
      , `__version__` in [`cmd.py`]
        (currently <code class="html">%cmd-version</code>)
    //
      , `{.cmd .cmdc} %cmd-name`
      , CMD file name, relative to working directory, without extension
    //
      , `{.cmd .cmdc} %cmd-basename`
      , CMD file name, without path, without extension
  ''''
}}

####{#boilerplate-protect} 15. `#boilerplate-protect`
[`#boilerplate-protect`]: #boilerplate-protect

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #boilerplate-protect
  - queue_position: AFTER #cmd-properties
  * <style>[\s]*?</style>[\s]* -->
  * <style>[\s\S]*?</style> --> \g<0>
  * <head>[\s\S]*?</head> --> \g<0>
  - concluding_replacements:
      #reduce-whitespace
      #placeholder-protect
  ``
}}
{{des
  --
  Protects boilerplate elements:
  --
  ==
  - Removes empty `<style>` element
  - Protects `<style>` element
  - Protects `<head>` element
  ==
}}

####{#backslash-escapes} 16. `#backslash-escapes`
[`#backslash-escapes`]: #backslash-escapes

{{def
  ``{.cmd .cmdr}
  OrdinaryDictionaryReplacement: #backslash-escapes
  - queue_position: AFTER #boilerplate-protect
  * \\ --> \
  * \# --> #
  * \& --> &amp;
  * \( --> (
  * \) --> )
  * \* --> *
  * \< --> &lt;
  * \> --> &gt;
  * \[ --> [
  * \] --> ]
  * \_ --> _
  * \{ --> {
  * \| --> |
  * \} --> }
  * "\ " --> " "
  * \t --> "	"
  - concluding_replacements:
      #placeholder-protect
  ``
}}
{{des
  --
  Applies backslash escapes:
  --
  ''''
  |^
    //
      ; Escaped
      ; Unescaped
  |:
    //
      , `{.cmd .cmdc} \\`
      , <| \\ |>
    //
      , `{.cmd .cmdc} \#`
      , <| \# |>
    //
      , `{.cmd .cmdc} \&`
      , <| \& |>
    //
      , `{.cmd .cmdc} \(`
      , <| \( |>
    //
      , `{.cmd .cmdc} \)`
      , <| \) |>
    //
      , `{.cmd .cmdc} \*`
      , <| \* |>
    //
      , `{.cmd .cmdc} \< `
      , <| \< |>
    //
      , `{.cmd .cmdc} \>`
      , <| \> |>
    //
      , `{.cmd .cmdc} \[`
      , <| \[ |>
    //
      , `{.cmd .cmdc} \]`
      , <| \] |>
    //
      , `{.cmd .cmdc} \_`
      , <| \_ |>
    //
      , `{.cmd .cmdc} \{`
      , <| \{ |>
    //
      , `{.cmd .cmdc} \|`
      , <| \| |>
    //
      , `{.cmd .cmdc} \}`
      , <| \} |>
    //
      , `{.cmd .cmdc} \ <` `>`
      , (space)
    //
      , `{.cmd .cmdc} \t`
      , (tab)
  ''''
}}

####{#backslash-continuations} 17. `#backslash-continuations`
[`#backslash-continuations`]: #backslash-continuations

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #backslash-continuations
  - queue_position: AFTER #backslash-escapes
  * \\ \n [^\S\n]* -->
  ``
}}
{{des
  --
  Applies backslash continuation.
  --
}}

####{#reference-definitions} 18. `#reference-definitions`
[`#reference-definitions`]: #reference-definitions

{{def
  ``{.cmd .cmdr}
  ReferenceDefinitionReplacement: #reference-definitions
  - queue_position: AFTER #backslash-continuations
  - attribute_specifications: EMPTY
  ``
}}
{{syn
  ````{.cmd .cmdc}
  @([)@«label»@(])@@(:)@ «uri»
  @([)@«label»@(])@@(:)@ @(<)@«uri»@(>)@
  ````
  ````{.cmd .cmdc}
  @([)@«label»@(])@@(:)@ «...» @(")@«title»@(")@
  @([)@«label»@(])@@(:)@ «...» @(')@«title»@(')@
  ````
  ````{.cmd .cmdc}
  @([)@«label»@(])@{«attribute specifications»}@(:)@ «...»
  ````
  ==
  - For continuation of `{.cmd .cmdc} «uri»` or `{.cmd .cmdc} «title»`,
    indent the continuation more than the leading square bracket.
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ==
}}
{{des
  --
  Defines a reference, to be used by
  [`#referenced-images`] or [`#referenced-links`].
  --
}}

####{#specified-images} 19. `#specified-images`
[`#specified-images`]: #specified-images

{{def
  ``{.cmd .cmdr}
  SpecifiedImageReplacement: #specified-images
  - queue_position: AFTER #reference-definitions
  - attribute_specifications: EMPTY
  - prohibited_content: BLOCKS
  ``
}}
{{syn
  ````{.cmd .cmdc}
  @(!)@@([)@«alt text»@(])@@(()@«src»@())@
  @(!)@@([)@«alt text»@(])@@(()@@(<)@«src»@(>)@@())@
  ````
  ````{.cmd .cmdc}
  @(!)@@([)@«alt text»@(])@@(()@«...» @(")@«title»@(")@@())@
  @(!)@@([)@«alt text»@(])@@(()@«...» @(')@«title»@(')@@())@
  ````
  ````{.cmd .cmdc}
  @(!)@@([)@«alt text»@(])@{«attribute specifications»}@(()@«...»@())@
  ````
  ==
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ==
}}
{{des
  --
  Produces an image:
  --
  ````{.html}
  @(<img)@«attribute sequence»@(>)@
  ````
  --
  Here, `{.html} «attribute sequence»` is the sequence of attributes
  built from
  --
  ==
  - `{.cmd .cmdc} «alt text»`
  - `{.cmd .cmdc} «src»`
  - `{.cmd .cmdc} «title»`
  - `{.cmd .cmdc} «attribute specifications»`
  ==
  --
  parsed in that order.
  --
}}
{{ex
  ++
  1.
    Basic usage:
    ==
    - CMD:
      ````{.cmd .cmdc}
      ![Rembrandt painting: The Anatomy Lesson of Dr Nicolaes Tulp.](rembrandt-anatomy.jpg)
      ````
    - HTML:
      <||
      ![Rembrandt painting: The Anatomy Lesson of Dr Nicolaes Tulp.](rembrandt-anatomy.jpg)
      ||>
    - Rendered:
      --
      ![Rembrandt painting: The Anatomy Lesson of Dr Nicolaes Tulp.](rembrandt-anatomy.jpg)
      --
    ==
  1.
    Set width:
    ==
    - CMD:
      ````{.cmd .cmdc}
      ![Rembrandt painting: The Anatomy Lesson of Dr Nicolaes Tulp.]{w=120}(rembrandt-anatomy.jpg)
      ````
    - HTML:
      <||
      ![Rembrandt painting: The Anatomy Lesson of Dr Nicolaes Tulp.]{w=120}(rembrandt-anatomy.jpg)
      ||>
    - Rendered:
      --
      ![Rembrandt painting: The Anatomy Lesson of Dr Nicolaes Tulp.]{w=120}(rembrandt-anatomy.jpg)
      --
    ==
  1.
    Empty alt text for decorative images,
    or images where adjacent text already describes the image:
    ==
    - CMD:
      ````{.cmd .cmdc}
      ![](/favicon-16x16.png) Conway-Markdown is dumb.
      ````
    - HTML:
      <||
      ![](/favicon-16x16.png) Conway-Markdown is dumb.
      ||>
    - Rendered:
      --
      ![](/favicon-16x16.png) Conway-Markdown is dumb.
      --
    ==
  ++
}}

####{#referenced-images} 20. `#referenced-images`
[`#referenced-images`]: #referenced-images

{{def
  ``{.cmd .cmdr}
  ReferencedImageReplacement: #referenced-images
  - queue_position: AFTER #specified-images
  - attribute_specifications: EMPTY
  - prohibited_content: BLOCKS
  ``
}}
{{syn
  ````{.cmd .cmdc}
  @(!)@@([)@«alt text»@(])@@([)@«label»@(])@
  @(!)@@([)@«alt text»@(])@
  ````
  ````{.cmd .cmdc}
  @(!)@@([)@«alt text»@(])@{«attribute specifications»}@([)@«label»@(])@
  @(!)@@([)@«alt text»@(])@{«attribute specifications»}
  ````
  ==
  - `{.cmd .cmdc} «label»`: must correspond to a defined
    [reference definition](#reference-definitions), up to case.
    If `{.cmd .cmdc} «label»` is omitted,
    `{.cmd .cmdc} «alt text»` is used in its stead.
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ==
}}
{{des
  --
  Produces an image:
  --
  ````{.html}
  @(<img)@«attribute sequence»@(>)@
  ````
  --
  Here, `{.html} «attribute sequence»` is the sequence of attributes
  built from
  --
  ==
  - `{.cmd .cmdc} «alt text»`
  - `{.cmd .cmdc} «src»` equal to `{.cmd .cmdc} «uri»`
    of the [reference definition](#reference-definitions)
    defined for `{.cmd .cmdc} «label»`
  - `{.cmd .cmdc} «title»`
    of the [reference definition](#reference-definitions)
    defined for `{.cmd .cmdc} «label»`
  - `{.cmd .cmdc} «attribute specifications»`
    of the [reference definition](#reference-definitions)
    defined for `{.cmd .cmdc} «label»`
  - `{.cmd .cmdc} «attribute specifications»`
  ==
  --
  parsed in that order.
  --
}}
{{ex
  ++
  1.
    Basic usage:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [moses]: rembrandt-moses.jpg
      
      ![Rembrandt painting: Moses Breaking the Tablets of the Law.][moses]
      ````
    - HTML:
      <||
      [moses]: rembrandt-moses.jpg
      
      ![Rembrandt painting: Moses Breaking the Tablets of the Law.][moses]
      ||>
    - Rendered:
      --
      [moses]: rembrandt-moses.jpg
      
      ![Rembrandt painting: Moses Breaking the Tablets of the Law.][moses]
      --
    ==
  1.
    Use `{.cmd .cmdc} «alt text»` for `{.cmd .cmdc} «label»`:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [Conway-Markdown logo.]: /favicon-32x32.png "Conway-Markdown is dumb."
      
      ![Conway-Markdown logo.]
      ````
    - HTML:
      <||
      [Conway-Markdown logo.]: /favicon-32x32.png "Conway-Markdown is dumb."
      
      ![Conway-Markdown logo.]
      ||>
    - Rendered:
      --
      [Conway-Markdown logo.]: /favicon-32x32.png "Conway-Markdown is dumb."
      
      ![Conway-Markdown logo.]
      --
    ==
  1.
    `{.cmd .cmdc} «label»` is case-insensitive:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [image-label-case]: insensitive.png
      
      [Hooray.][image-label-case]
      [Hooray.][image-label-CASE]
      [Hooray.][ImAGe-laBEl-CAsE]
      ````
    - HTML:
      <||
      [image-label-case]: insensitive.png
      
      [Hooray.][image-label-case]
      [Hooray.][image-label-CASE]
      [Hooray.][ImAGe-laBEl-CAsE]
      ||>
    ==
  1.
    Later reference definitions prevail:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [image-label]{.class1}: file1.png
      [image-label]{.class2}: file2.png
      
      [Second definition wins.][image-label]
      ````
    - HTML:
      <||
      [image-label]{.class1}: file1.png
      [image-label]{.class2}: file2.png
      
      [Second definition wins.][image-label]
      ||>
    ==
  ++
}}

####{#explicit-links} 21. `#explicit-links`
[`#explicit-links`]: #explicit-links

{{def
  ``{.cmd .cmdr}
  ExplicitLinkReplacement: #explicit-links
  - queue_position: AFTER #referenced-images
  - allowed_flags:
      b=ANGLE_BRACKET_WRAP
      s=SUPPRESS_SCHEME
  - attribute_specifications: EMPTY
  - content_replacements:
      #suppress-scheme
  - concluding_replacements:
      #angle-bracket-wrap
  ``
}}
{{syn
  ``{.cmd .cmdc}
  @(<)@«uri»@(>)@
  ``
  ``{.cmd .cmdc}
  @(<)@{«attribute specifications»} «uri»@(>)@
  ``
  ``{.cmd .cmdc}
  «flags»@(<)@«uri»@(>)@
  ``
  ``{.cmd .cmdc}
  «flags»@(<)@{«attribute specifications»} «uri»@(>)@
  ``
  ====
  - `{.cmd .cmdc} «flags»`:
    ==
    - `{.cmd .cmdc} b`: wrap in angle brackets (apply [`#angle-bracket-wrap`])
    - `{.cmd .cmdc} s`: suppress scheme (apply [`#suppress-scheme`])
    ==
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ====
}}
{{des
  --
  Produces a link:
  --
  ````{.html}
  @(<a)@«attribute sequence»@(>)@«uri»@(</a>)@
  ````
  --
  Or:
  --
  ````{.html}
  @(&lt;<a)@«attribute sequence»@(>)@«uri»@(</a>&gt;)@
  ````
  --
  Here, `{.html} «attribute sequence»` is the sequence of attributes
  built from
  --
  ==
  - `{.cmd .cmdc} «uri»` as `href`
  - `{.cmd .cmdc} «attribute specifications»`
  ==
  --
  parsed in that order.
  --
}}
{{ex
  ++
  1.
    Basic usage:
    ==
    - CMD: `{.cmd .cmdc} <https://example.com> `
    - HTML: <| <https://example.com> |>
    - Rendered: <https://example.com>
    ==
  1.
    Wrap in angle brackets:
    ==
    - CMD: `{.cmd .cmdc} b<https://example.com> `
    - HTML: <| b<https://example.com> |>
    - Rendered: b<https://example.com>
    ==
  1.
    Suppress scheme:
    ==
    - CMD: `{.cmd .cmdc} s<https://example.com> `
    - HTML: <| s<https://example.com> |>
    - Rendered: s<https://example.com>
    ==
  1.
    _{lang=es} ¿Por qué no los dos?_
    ==
    - CMD: `{.cmd .cmdc} bs<https://example.com> `
    - HTML: <| bs<https://example.com> |>
    - Rendered: bs<https://example.com>
    ==
  1.
    Invitation to spammers:
    ==
    - CMD: `{.cmd .cmdc} s<mailto:mail@example.com> `
    - HTML: <| s<mailto:mail@example.com> |>
    - Rendered: s<mailto:mail@example.com>
    ==
  ++
}}

####{#specified-links} 22. `#specified-links`
[`#specified-links`]: #specified-links

{{def
  ``{.cmd .cmdr}
  SpecifiedLinkReplacement: #specified-links
  - queue_position: AFTER #explicit-links
  - attribute_specifications: EMPTY
  - prohibited_content: BLOCKS
  ``
}}
{{syn
  ````{.cmd .cmdc}
  @([)@«link text»@(])@@(()@«href»@())@
  @([)@«link text»@(])@@(()@@(<)@«href»@(>)@@())@
  ````
  ````{.cmd .cmdc}
  @([)@«link text»@(])@@(()@«...» @(")@«title»@(")@@())@
  @([)@«link text»@(])@@(()@«...» @(')@«title»@(')@@())@
  ````
  ````{.cmd .cmdc}
  @([)@«link text»@(])@{«attribute specifications»}@(()@«...»@())@
  ````
  ==
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ==
}}
{{des
  --
  Produces a link:
  --
  ````{.html}
  @(<a)@«attribute sequence»@(>)@«link text»@(</a>)@
  ````
  --
  Here, `{.html} «attribute sequence»` is the sequence of attributes
  built from
  --
  ==
  - `{.cmd .cmdc} «href»`
  - `{.cmd .cmdc} «title»`
  - `{.cmd .cmdc} «attribute specifications»`
  ==
  --
  parsed in that order.
  --
}}
{{ex
  ++
  1.
    Basic usage:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [Wikipedia](https://en.wikipedia.org/wiki/Main_Page)
      ````
    - HTML:
      <||
      [Wikipedia](https://en.wikipedia.org/wiki/Main_Page)
      ||>
    - Rendered:
      --
      [Wikipedia](https://en.wikipedia.org/wiki/Main_Page)
      --
    ==
  1.
    Title:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [Wikipedia](
        https://en.wikipedia.org/wiki/Main_Page
        "Wikipedia, the free encyclopedia"
      )
      ````
    - HTML:
      <||
      [Wikipedia](
        https://en.wikipedia.org/wiki/Main_Page
        "Wikipedia, the free encyclopedia"
      )
      ||>
    - Rendered:
      --
      [Wikipedia](
        https://en.wikipedia.org/wiki/Main_Page
        "Wikipedia, the free encyclopedia"
      )
      --
    ==
  1.
    Override `href`
    ==
    - CMD:
      ````{.cmd .cmdc}
      [Beware]{href=https://example.com/evil}(https://example.com/good)
      ````
    - HTML:
      <||
      [Beware]{href=https://example.com/evil}(https://example.com/good)
      ||>
    - Rendered:
      --
      [Beware]{href=https://example.com/evil}(https://example.com/good)
      --
    ==
  ++
}}

####{#referenced-links} 23. `#referenced-links`
[`#referenced-links`]: #referenced-links

{{def
  ``{.cmd .cmdr}
  ReferencedLinkReplacement: #referenced-links
  - queue_position: AFTER #specified-links
  - attribute_specifications: EMPTY
  - prohibited_content: BLOCKS
  ``
}}
{{syn
  ````{.cmd .cmdc}
  @([)@«link text»@(])@@([)@«label»@(])@
  @([)@«link text»@(])@
  ````
  ````{.cmd .cmdc}
  @([)@«link text»@(])@{«attribute specifications»}@([)@«label»@(])@
  @([)@«link text»@(])@{«attribute specifications»}
  ````
  ==
  - `{.cmd .cmdc} «label»`: must correspond to a defined
    [reference definition](#reference-definitions), up to case.
    If `{.cmd .cmdc} «label»` is omitted,
    `{.cmd .cmdc} «link text»` is used in its stead.
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  ==
}}
{{des
  --
  Produces a link:
  --
  ````{.html}
  @(<a)@«attribute sequence»@(>)@«link text»@(</a>)@
  ````
  --
  Here, `{.html} «attribute sequence»` is the sequence of attributes
  built from
  --
  ==
  - `{.cmd .cmdc} «href»` equal to `{.cmd .cmdc} «uri»`
    of the [reference definition](#reference-definitions)
    defined for `{.cmd .cmdc} «label»`
  - `{.cmd .cmdc} «title»`
    of the [reference definition](#reference-definitions)
    defined for `{.cmd .cmdc} «label»`
  - `{.cmd .cmdc} «attribute specifications»`
    of the [reference definition](#reference-definitions)
    defined for `{.cmd .cmdc} «label»`
  - `{.cmd .cmdc} «attribute specifications»`
  ==
  --
  parsed in that order.
  --
}}
{{ex
  ++
  1.
    Basic usage:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [wiki]: https://en.wikipedia.org/wiki/Main_Page
      
      [Wikipedia's main page.][wiki]
      ````
    - HTML:
      <||
      [wiki]: https://en.wikipedia.org/wiki/Main_Page
      
      [Wikipedia's main page.][wiki]
      ||>
    - Rendered:
      --
      [wiki]: https://en.wikipedia.org/wiki/Main_Page
      
      [Wikipedia's main page.][wiki]
      --
    ==
  1.
    Use `{.cmd .cmdc} «link text»` for `{.cmd .cmdc} «label»`:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [Wikipedia]: https://en.wikipedia.org/wiki/Main_Page
      
      [Wikipedia]
      ````
    - HTML:
      <||
      [Wikipedia]: https://en.wikipedia.org/wiki/Main_Page
      
      [Wikipedia]
      ||>
    - Rendered:
      --
      [Wikipedia]: https://en.wikipedia.org/wiki/Main_Page
      
      [Wikipedia]
      --
    ==
  1.
    `{.cmd .cmdc} «label»` is case-insensitive:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [link-label-case]: https://example.com
      
      [Hooray.][link-label-case]
      [Hooray.][link-label-CASE]
      [Hooray.][LiNK-laBEl-CAsE]
      ````
    - HTML:
      <||
      [link-label-case]: https://example.com
      
      [Hooray.][link-label-case]
      [Hooray.][link-label-CASE]
      [Hooray.][LiNK-laBEl-CAsE]
      ||>
    ==
  1.
    Later reference definitions prevail:
    ==
    - CMD:
      ````{.cmd .cmdc}
      [link-label]{.class1}: https://example.com/1
      [link-label]{.class2}: https://example.com/2
      
      [Second definition wins.][link-label]
      ````
    - HTML:
      <||
      [link-label]{.class1}: https://example.com/1
      [link-label]{.class2}: https://example.com/2
      
      [Second definition wins.][link-label]
      ||>
    ==
  ++
}}

####{#inline-semantics} 24. `#inline-semantics`
[`#inline-semantics`]: #inline-semantics

{{def
  ``{.cmd .cmdr}
  InlineAssortedDelimitersReplacement: #inline-semantics
  - queue_position: AFTER #referenced-links
  - delimiter_conversion:
      __=b
      _=i
      **=strong
      *=em
      ''=cite
      ""=q
  - attribute_specifications: EMPTY
  - prohibited_content: BLOCKS
  ``
}}
{{syn
  ````{.cmd .cmdc}
  @(__)@«b content»@(__)@
  @(_)@«i content»@(_)@
  @(**)@«strong content»@(**)@
  @(*)@«em content»@(*)@
  @('')@«cite content»@('')@
  @("")@«q content»@("")@
  ````
  ````{.cmd .cmdc}
  @(«...»)@{«attribute specifications»} «content»@(«...»)@
  ````
  ````{.cmd .cmdc}
  @(|)@@(«...»)@«content»@(«...»)@
  ````
  ````{.cmd .cmdc}
  @(|)@@(«...»)@{«attribute specifications»} «content»@(«...»)@
  ````
  ==
  - `{.cmd .cmdc} «attribute specifications»`:
    see [CMD attribute specifications].
  - The leading optional pipe is to be used
    as a disambiguator in some edge cases.
    If present, it indicates that the delimiter directly after it
    is opening rather than closing.
  - The opening delimiter must not be followed by whitespace,
    nor by `{.html} </` (the beginning of a closing tag).
  - The closing delimiter must not be preceded by whitespace,
    nor be a pipe `{.cmd .cmdc} |`.
  ==
}}
{{des
  --
  Produces an inline semantic:
  --
  ````{.html}
  @(<b)@«attribute sequence»@(>)@«b content»@(</b>)@
  @(<i)@«attribute sequence»@(>)@«i content»@(</i>)@
  @(<strong)@«attribute sequence»@(>)@«strong content»@(</strong>)@
  @(<em)@«attribute sequence»@(>)@«em content»@(</em>)@
  @(<cite)@«attribute sequence»@(>)@«cite content»@(</cite>)@
  @(<q)@«attribute sequence»@(>)@«q content»@(</q>)@
  ````
}}
{{ex
  --
  In HTML5, `{.html} <b>` and `{.html} <i>` are *not* deprecated,
  see [W3C: Using `{.html} <b>` and `{.html} <i>` elements].
  --
  [W3C: Using `{.html} <b>` and `{.html} <i>` elements]:
    https://www.w3.org/International/questions/qa-b-and-i-tags.en
  ++++
  1.
    Bring to attention `{.html} <b>`:
    ++{type=i}
    0. Keywords:
      ==
      - CMD: `{.cmd .cmdc} Meals are served with __rice__ or __pasta__. `
      - HTML: <| Meals are served with __rice__ or __pasta__. |>
      - Rendered: Meals are served with __rice__ or __pasta__.
      ==
    ++
  1.
    Idiomatic offset `{.html} <i>`:
    ++{type=i}
    0. Foreign phrases:
      ==
      - CMD: `{.cmd .cmdc} Write out _{lang=la} Romani ite domum_ 100 times.`
      - HTML: <| Write out _{lang=la} Romani ite domum_ 100 times. |>
      - Rendered: Write out _{lang=la} Romani ite domum_ 100 times.
      ==
    0. Translator-supplied words in the King James Bible:
      ==
      - CMD: `{.cmd .cmdc} I _{.translator-supplied} am_ the LORD.`
      - HTML: <| I _{.translator-supplied} am_ the LORD. |>
      - Rendered: I _{.translator-supplied} am_ the LORD.
      ==
    0. Thoughts:
      ==
      - CMD: `{.cmd .cmdc} _Screw 'em._`
      - HTML: <| _Screw 'em._ |>
      - Rendered: _Screw 'em._
      ==
    ++
  1.
    Strong importance `{.html} <strong>`:
    ++{type=i}
    0. Warnings:
      ==
      - CMD: `{.cmd .cmdc} **{lang=de} Achtung!**`
      - HTML: <| **{lang=de} Achtung!** |>
      - Rendered: **{lang=de} Achtung!**
      ==
    ++
  1.
    Stress emphasis `{.html} <em>`:
    ++{type=i}
    0. Stress a particular word in a sentence:
      ==
      - CMD: `{.cmd .cmdc} I don't know *who* took it.`
      - HTML: <| I don't know *who* took it. |>
      - Rendered: I don't know *who* took it.
      ==
    ++
  1.
    Citation `{.html} <cite>`:
    ++{type=i}
    0. Book titles:
      ==
      - CMD: `{.cmd .cmdc} ''Nineteen Eighty-Four'' is already upon us.`
      - HTML: <| ''Nineteen Eighty-Four'' is already upon us. |>
      - Rendered: ''Nineteen Eighty-Four'' is already upon us.
      ==
    ++
  1.
    Quotation `{.html} <q>`:
    ++{type=i}
    0. Inline quotes:
      ==
      - CMD: `{.cmd .cmdc} ""It wasn't me.""`
      - HTML: <| ""It wasn't me."" |>
      - Rendered: ""It wasn't me.""
      ==
    ++
  1.
    Nesting and disambiguation:
    ''''
    |^
      //
        ; Pattern
        ; CMD
        ; HTML
    |:
      //
        , 1-1
        , `{.cmd .cmdc} *foo* `
        , <| *foo* |>
      //
        , 2-2
        , `{.cmd .cmdc} **foo** `
        , <| **foo** |>
      //
        , 3-3 (12-21)
        , `{.cmd .cmdc} ***foo*** `
        , <| ***foo*** |>
      //
        , 12-3 (12-21)
        , `{.cmd .cmdc} *foo **bar*** `
        , <| *foo **bar*** |>
      //
        , 3-21 (12-21)
        , `{.cmd .cmdc} ***foo** bar* `
        , <| ***foo** bar* |>
      //
        , 2|1-3 (21-12)
        , `{.cmd .cmdc} **|*foo*** `
        , <| **|*foo*** |>
      //
        , 21-3 (21-12)
        , `{.cmd .cmdc} **foo *bar*** `
        , <| **foo *bar*** |>
      //
        , 3-12 (21-12)
        , `{.cmd .cmdc} ***foo* bar** `
        , <| ***foo* bar** |>
      //
        , 4-4 (22-22)
        , `{.cmd .cmdc} ****foo**** `
        , <| ****foo**** |>
      //
        , 1|2|1-4 (121-121)
        , `{.cmd .cmdc} *|**|*foo**** `
        , <| *|**|*foo**** |>
    ''''
  ++++
}}

####{#escape-idle-html} 25. `#escape-idle-html`
[`#escape-idle-html`]: #escape-idle-html

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #escape-idle-html
  - queue_position: AFTER #inline-semantics
  * [&]
    (?!
      (?:
        [a-zA-Z]{1,31}
          |
        [#] (?: [0-9]{1,7} | [xX] [0-9a-fA-F]{1,6} )
      )
      [;]
    )
      --> &amp;
  * [<] (?= [\s] ) --> &lt;
  ``
}}
{{des
  --
  Escapes idle HTML:
  --
  ++
  1. Replaces non-entity ampersand with <| & |>.
  1. Replaces opening angle brackets before whitespace with <| < |>
  ++
}}

####{#whitespace} 26. `#whitespace`
[`#whitespace`]: #whitespace

{{def
  ``{.cmd .cmdr}
  ReplacementSequence: #whitespace
  - queue_position: AFTER #escape-idle-html
  - replacements:
      #reduce-whitespace
  ``
}}
{{des
  --
  Reduces whitespace. See [`#reduce-whitespace`].
  --
}}

####{#placeholder-unprotect} 27. `#placeholder-unprotect`
[`#placeholder-unprotect`]: #placeholder-unprotect

{{def
  ``{.cmd .cmdr}
  PlaceholderUnprotectionReplacement: #placeholder-unprotect
  - queue_position: AFTER #whitespace
  ``
}}
{{des
  --
  Unprotects all [placeholder strings][placeholder].
  --
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

####{#unmark-table-headers-for-preceding-table-data}
  `#unmark-table-headers-for-preceding-table-data`
[`#unmark-table-headers-for-preceding-table-data`]:
  #unmark-table-headers-for-preceding-table-data

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #unmark-table-headers-for-preceding-table-data
  * ^ [;] \{ \} <th (?P<bracket_or_placeholder_marker> [>\uF8FF] )
      -->
    <th\g<bracket_or_placeholder_marker>
  # Replaces `;{}<th«attributes_sequence»>` with `<th«attributes_sequence»>`
  # so that #mark-table-headers-for-preceding-table-data is undone.
  ``
}}
{{des
  --
  Replaces `{.cmd .cmdc} ;{}<th«attributes_sequence»>`
  with `{.cmd .cmdc} <th«attributes_sequence»>`
  so that [`#mark-table-headers-for-preceding-table-data`] is undone.
  --
}}
{{dep
  ==
  - [`#table-rows`]
  ==
}}

####{#table-rows} `#table-rows`
[`#table-rows`]: #table-rows

{{def
  ``{.cmd .cmdr}
  PartitioningReplacement: #table-rows
  - starting_pattern: [/]{2}
  - attribute_specifications: EMPTY
  - ending_pattern: [/]{2}
  - content_replacements:
      #table-headers
      #table-data
      #unmark-table-headers-for-preceding-table-data
      #prepend-newline
  - tag_name: tr
  ``
}}
{{des
  --
  Partitions content into table rows
  based on leading occurrences of `{.cmd .cmdc} @(//)@`.
  --
}}
{{dep
  ==
  - [`#table-head`]
  - [`#table-body`]
  - [`#table-foot`]
  - [`#tables`]
  ==
}}

####{#table-head} `#table-head`
[`#table-head`]: #table-head

{{def
  ``{.cmd .cmdr}
  PartitioningReplacement: #table-head
  - starting_pattern: [|][\^]
  - attribute_specifications: EMPTY
  - ending_pattern: [|][:_]
  - content_replacements:
      #table-rows
      #prepend-newline
  - tag_name: thead
  ``
}}
{{des
  --
  Partitions content into table heads
  based on leading occurrences of `{.cmd .cmdc} @(|^)@`
  up to the next leading `{.cmd .cmdc} @(|:)@` or `{.cmd .cmdc} @(|_)@`.
  --
}}
{{dep
  ==
  - [`#tables`]
  ==
}}

####{#table-body} `#table-body`
[`#table-body`]: #table-body

{{def
  ``{.cmd .cmdr}
  PartitioningReplacement: #table-body
  - starting_pattern: [|][:]
  - attribute_specifications: EMPTY
  - ending_pattern: [|][_]
  - content_replacements:
      #table-rows
      #prepend-newline
  - tag_name: tbody
  ``
}}
{{des
  --
  Partitions content into table bodies
  based on leading occurrences of `{.cmd .cmdc} @(|:)@`
  up to the next leading `{.cmd .cmdc} @(|_)@`.
  --
}}
{{dep
  ==
  - [`#tables`]
  ==
}}

####{#table-foot} `#table-foot`
[`#table-foot`]: #table-foot

{{def
  ``{.cmd .cmdr}
  PartitioningReplacement: #table-foot
  - starting_pattern: [|][_]
  - attribute_specifications: EMPTY
  - content_replacements:
      #table-rows
      #prepend-newline
  - tag_name: tfoot
  ``
}}
{{des
  --
  Partitions content into table feet
  based on leading occurrences of `{.cmd .cmdc} @(|_)@`.
  --
}}
{{dep
  ==
  - [`#tables`]
  ==
}}

####{#suppress-scheme} `#suppress-scheme`
[`#suppress-scheme`]: #suppress-scheme

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #suppress-scheme
  - positive_flag: SUPPRESS_SCHEME
  * \A [\S]+ [:] (?: [/]{2} )? -->
  ``
}}
{{des
  --
  Suppresses the scheme
  (including the colon and possibly two slashes)
  of a URI.
  --
}}
{{dep
  ==
  - [`#explicit-links`]
  ==
}}

####{#angle-bracket-wrap} `#angle-bracket-wrap`
[`#angle-bracket-wrap`]: #angle-bracket-wrap

{{def
  ``{.cmd .cmdr}
  RegexDictionaryReplacement: #angle-bracket-wrap
  - positive_flag: ANGLE_BRACKET_WRAP
  * \A --> &lt;
  * \Z --> &gt;
  - concluding_replacements:
      #placeholder-protect
  ``
}}
{{des
  --
  Wraps a string in angle brackets.
  --
}}
{{dep
  ==
  - [`#explicit-links`]
  ==
}}


##{#replacement-rule-syntax} CMD replacement rule syntax

--
This section gives the syntax for writing user-defined CMD replacement rules,
which go before the `{.cmd} «delimiter»` when [authoring CMD files].
--
--
In CMD replacement rule syntax, a line must be one of the following:
--
++
1.
  __Whitespace-only__.
  <br>
  Ends the definition of a replacement rule.
2.
  A __comment__:
  ````{.cmd .cmdr}
  @(#)@ «comment»
  ````
  Is ignored.
3.
  A __rules inclusion__:
  ````{.cmd .cmdr}
  @(<)@ «included_file_name»
  ````
  Includes the content of `{.cmd .cmdr} «included_file_name»`
  as CMD replacement rules.
  ==
  - If `{.cmd .cmdr} «included_file_name»` begins with a slash,
    it is parsed relative to the working directory.
  - If `{.cmd .cmdr} «included_file_name»` does not begin with a slash,
    it is parsed relative to the file in which the inclusion is invoked.
  ==
  The convention is for `{.cmd .cmdr} «included_file_name»`
  is to have the extension `.cmdr`.
4.
  A __class declaration__:
  ``{.cmd .cmdr}
  «ClassName»@(:)@ @(#)@«id»
  ``
  Begins the definition of a replacement rule
  with class `{.cmd .cmdr} «ClassName»`.
  ==
  - `{.cmd .cmdr} «ClassName»` must be one of
    [`ReplacementSequence`],
    [`PlaceholderMarkerReplacement`],
    [`PlaceholderProtectionReplacement`],
    [`PlaceholderUnprotectionReplacement`],
    [`DeIndentationReplacement`],
    [`OrdinaryDictionaryReplacement`],
    [`RegexDictionaryReplacement`],
    [`FixedDelimitersReplacement`],
    [`ExtensibleFenceReplacement`],
    [`PartitioningReplacement`],
    [`InlineAssortedDelimitersReplacement`],
    [`HeadingReplacement`],
    [`ReferenceDefinitionReplacement`],
    [`SpecifiedImageReplacement`],
    [`ReferencedImageReplacement`],
    [`ExplicitLinkReplacement`],
    [`SpecifiedLinkReplacement`],
      or
    [`ReferencedLinkReplacement`].
  - `{.cmd .cmdr} «id»` may only contain lower case letters or hyphens.
  ==
5.
  The start of an __attribute declaration__:
  ``{.cmd .cmdr}
  @(-)@ «name»@(:)@ «value»
  ``
  Declares an attribute for the replacement that is currently being defined.
  ==
  - `{.cmd .cmdr} «name»` must be one of the valid attribute names
    for the replacement that is currently being defined.
  - `{.cmd .cmdr} «value»` must be a suitable attribute value
    for that attribute name.
  ==
6.
  The start of an __substitution declaration__:
  ``{.cmd .cmdr}
  @(*)@ «pattern» @(-->)@ «substitute»
  ``
  Declares a substitution for the replacement that is currently being defined
  (which must be an [`OrdinaryDictionaryReplacement`]
  or a [`RegexDictionaryReplacement`]).
  ==
  - The number of hyphens in the delimiter `{.cmd .cmdr} @(-->)@`
    may be arbitrarily increased should `{.cmd .cmdr} «pattern»` contain
    a run of hyphens followed by a closing angle-bracket.
  ==
7.
  A __continuation__ (of an attribute declaration or substitution declaration),
  beginning with whitespace.
++

###{#ReplacementSequence} `ReplacementSequence`
[`ReplacementSequence`]: #ReplacementSequence

{{syn
  ````{.cmd .cmdr}
  ReplacementSequence: #«id»
  - queue_position: (def) NONE | ROOT | BEFORE #«id» | AFTER #«id»
  - replacements: (def) NONE | #«id» [...]
  ````
  ==
  - `{.cmd .cmdr} queue_position`: position in the replacement queue
  - `{.cmd .cmdr} replacements`: sequence of replacements to be applied
  ==
}}
{{des
  --
  Defines a replacement rule that applies a sequence of replacement rules.
  --
}}
{{std
  ==
  - [`#whitespace`]
  ==
}}

###{#PlaceholderMarkerReplacement} `PlaceholderMarkerReplacement`
[`PlaceholderMarkerReplacement`]: #PlaceholderMarkerReplacement

{{syn
  ````{.cmd .cmdr}
  PlaceholderMarkerReplacement: #«id»
  - queue_position: (def) NONE | ROOT | BEFORE #«id» | AFTER #«id»
  ````
  ==
  - `{.cmd .cmdr} queue_position`: position in the replacement queue
  ==
}}
{{des
  --
  Defines a rule for replacing the placeholder marker with a [placeholder].
  --
}}
{{std
  ==
  - [`#placeholder-markers`]
  ==
}}

###{#PlaceholderProtectionReplacement} `PlaceholderProtectionReplacement`
[`PlaceholderProtectionReplacement`]: #PlaceholderProtectionReplacement

{{syn
  ````{.cmd .cmdr}
  PlaceholderProtectionReplacement: #«id»
  - queue_position: (def) NONE | ROOT | BEFORE #«id» | AFTER #«id»
  ````
  ==
  - `{.cmd .cmdr} queue_position`: position in the replacement queue
  ==
}}
{{des
  --
  Defines a replacement rule for protecting strings with a [placeholder].
  --
}}
{{std
  ==
  - [`#placeholder-protect`]
  ==
}}

###{#PlaceholderUnprotectionReplacement} `PlaceholderUnprotectionReplacement`
[`PlaceholderUnprotectionReplacement`]: #PlaceholderUnprotectionReplacement

{{syn
  ````{.cmd .cmdr}
  PlaceholderUnprotectionReplacement: #«id»
  - queue_position: (def) NONE | ROOT | BEFORE #«id» | AFTER #«id»
  ````
  ==
  - `{.cmd .cmdr} queue_position`: position in the replacement queue
  ==
}}
{{des
  --
  Defines a replacement rule for restoring [placeholders] to their strings.
  --
}}
{{std
  ==
  - [`#placeholder-unprotect`]
  ==
}}


##{#cmd-placeholders} CMD placeholders
[placeholder]: #cmd-placeholders
[placeholders]: #cmd-placeholders

--
There are many instances in which the result of a replacement
should not be altered further by replacements to follow.
To protect a string from further alteration,
it is temporarily replaced by a __placeholder__
consisting of code points in the main Unicode Private Use Area.
--
--
Specifically, the placeholder for a string is of the following form:
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
