%%%%

%author Conway
%title Conway's markdown (CMD)
%date-created 2020-04-05
%date-modified 2020-07-19
%resources a~~
  <link rel="stylesheet" href="/cmd.min.css">
  <link rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css"
    integrity="sha384-\
      zB1R0rpPzHqg7Kpt0Aljp8JPLqbXI3bhnPWROx27a9N0Ll6ZP/+DiW/UqRcLbRjq\
    "
    crossorigin="anonymous">
  <script defer
    src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js"
    integrity="sha384-\
      y23I5Q6l+B6vatafAwxRu/0oK/79VlbSz7Q9aiSZUvyWYIYsd+qj+o24G5ZU2zJz\
    "
    crossorigin="anonymous"></script>
  <script>
  document.addEventListener("DOMContentLoaded", function() {
    let elements = document.getElementsByClassName("js-maths");
    for (let i = 0; i < elements.length; i++) {
      let element = elements[i]
      katex.render(
        element.textContent,
        element,
        {displayMode: element.tagName == "DIV"}
      );
    }
  })
  </script>
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
  <link rel="manifest" href="/site.webmanifest">
  <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#7000ff">
  <meta name="msapplication-TileColor" content="#00aba9">
  <meta name="theme-color" content="#ffffff">
~~
%%%%


<## {^^ Syntax (display) ^^} ##>
{%
  \{ \^\^ [\s]*
    (?P<content> [\s\S]*? )
  [\s]* \^\^ \}
%
  <pre class="cmd syntax"><code>\g<content></code></pre>
%}

<## {^ Inline syntax ^} ##>
{%
  \{ \^ [\s]*
    (?P<content> [\s\S]*? )
  [\s]* \^ \}
%
  <code>\g<content></code>
%}

<## Delimiting character or run \C \X \Y \Z ##>
{%
  \\ (?P<character> [CXYZ])
%
  \\<\g<character>\\>
%}

<## {{ Repeatable delimiter }} ##>
{%
  \{{2} [\s]*
    (?P<content> [\s\S]*? )
  [\s]* \}{2}
%
  <span class="repeatable-delimiter">\g<content></span>
%}

<## <|MANDATORY|> ##>
{%
  < [|]
    (?P<content> [A-Z ]+? )
  [|] >
%
  <span class="mandatory-argument">\\<\g<content>\\></span>
%}

<## <|optional|> ##>
{%
  < [|]
    (?P<content> [a-z ]+? )
  [|] >
%
  <span class="optional-argument">\\<\g<content>\\></span>
%}

<## Heading permalinks (<h2> to <h6>) ##>
{%
  ^ [^\S\n]*
  (?P<hashes> [#]{2,6} )
    \{
      [#] (?P<id_> [\S]+? )
    \}
  [\s]+
    (?P<content> [\s\S]*? )
  (?P=hashes)
%
  \g<hashes>{#\g<id_>}
    <a class="permalink" href="#\g<id_>" aria-label="Permalink"></a>\\
    \g<content>
  \g<hashes>
%}

<## U+E000 PRIVATE USE AREA ##>
{: \e000 :  :}



# %title #



||||{.page-properties}
  First created: %date-created \+
  Last modified: %date-modified
||||

====
* This page's source CMD: [index.cmd][source-cmd]
* This page's output HTML: [index.html][output-html]
* GitHub repositories:
    [conway-markdown][cmd-repo],
    [conway-markdown.github.io][cmd-docs-repo]
====


----
Conway's fence-style markdown,
implemented in Python~3.6+ using regex replacements.
----

----
Conway's markdown (CMD) is the result of someone joking that
"the filenames would look like Windows executables from the 90s".
Inspired by the backticks of John Gruber's [markdown],
CMD uses fence-style constructs
where an {{arbitrarily repeatable delimiter symbol}}
is used to wrap shorter runs of that symbol.
----

----
While markdown is really an excellent syntax,
there are many things which I've always wanted to do in markdown,
which I can't without some sort of extension
(or falling back to writing plain HTML):
----
++++
1.  Set the width of [images](#images)
2.  Add [`id` and `class`](#attribute-specifications) to elements
3.  Write [arbitrary text](#cmd-literals) outside of code elements
    without using backslash escapes or HTML (ampersand) entities
4.  [Include](#inclusions) markdown from another file (e.g.~a template)
5.  Use [`<b>` and `<i>` elements](#inline-semantics),
    not just `<strong>` and `<em>`
6.  Use [`<div>` elements](#blocks) without falling back to HTML
7.  [Define my own syntax](#regex-replacements) as I go.
++++
----
CMD addresses each of these.
----


##{#installation}
  Installation
##

----
Since this is just a crappy, single-file regex converter,
there is no plan on turning it into a proper Python package any time soon.
In the meantime:
----
````
$ cd some-directory/
$ git clone https://github.com/conway-markdown/conway-markdown.git
````
====
* If you are using Linux or Mac,
  make an alias for `some-directory/conway-markdown/cmd.py` and invoke that.
* If you are using Windows,
  add `some-directory` to the `%PATH%` variable and invoke `cmd.py`.
====


##{#usage}
  Usage
##

----
Convert a CMD file to HTML, outputting to `cmd_name.html`:
----

````
$ cmd.py [cmd_name[.[cmd]]]
````

----
Omit `[cmd_name[.[cmd]]]` to convert all CMD files
in the current directory (at all levels),
except those listed in `.cmdignore`.
----


##{#syntax}
  Syntax
##

----
Since CMD-to-HTML conversion is merely a bunch of regex replacements
with some dictionaries for temporary storage of strings,
the syntax for earlier replacements will have higher precedence
than that for later replacements.
The syntax of CMD, in the order of processing, is thus:
----
======
* [CMD literals `~~~ ~~ ~~ ~~~`] [cmd literals]
* [Display code ``` ``↵ `` ```](#display-code)
* [Inline code `` ` ` ``](#inline-code)
* [Comments `<# #>`](#comments)
* [Display maths `$$↵ $$`](#display-maths)
* [Inline maths `$ $`](#inline-maths)
* [Inclusions `{+ +}`](#inclusions)
* [Regex replacements `{% % %}`](#regex-replacements)
* [Ordinary replacements `{: : :}`](#ordinary-replacements)
* [Preamble `%%↵ %%`](#preamble)
* [Blocks `----↵ ----` etc.](#blocks)
  ====
  * [List items `*`, `+`, `-`, `1.`](#list-items)
  ====
* [Tables `''''↵ ''''`](#tables)
  ====
  * [Table cells `;` `,`](#table-cells)
  * [Table rows `==`](#table-rows)
  * [Table parts `|^`, `|:`, `|_`](#table-parts)
  ====
* [Escapes `\\` etc.](#escapes)
* [Line continuations `\↵`](#line-continuations)
* [Images](#images)
  ====
  * [Inline-style images `![ ]( )`](#inline-style-images)
  * [Reference-style images `@@![ ]↵ @@`, `![ ][ ]`](#reference-style-images)
  ====
* [Links](#links)
  ====
  * [Inline-style links `[ ]( )`](#inline-style-links)
  * [Reference-style links `@@[ ]↵ @@`, `[ ][ ]`](#reference-style-links)
  ====
* [Headings `# #`](#headings)
* [Inline semantics `* *`, `** **`, `_ _`, `__ __`](#inline-semantics)
* [Whitespace](#whitespace)
======


###{#attribute-specifications}
  Attribute specifications
###

@[as] #attribute-specifications @

----
Most CMD syntaxes have an optional curly-bracketed part
which allows for the specification of attributes.
The following forms are recognised:
----

{^^
  \#<|ID|>
  .<|CLASS|>
  r<|ROWSPAN|>
  c<|COLSPAN|>
  w<|WIDTH|>
^^}

----
Unrecognised forms are ignored.
If the class attribute is specified more than once,
the new value is appended to the existing values.
If a non-class attribute is specified more than once,
the latest specification shall prevail.
----

====
* CMD
  ````{.cmd}
  ||||{#first .hot #second .cold}
    Blah
  ||||
  ````

* HTML
  ````{.html}
  <div id="second" class="hot cold">
  Blah
  </div>
  ````
====

----
CMD attribute specifications are inspired
by [kramdown's inline attribute lists][ial].
----

@[ial] https://kramdown.gettalong.org/syntax#inline-attribute-lists @



###{#cmd-literals}
  CMD literals
###

{^^
  <|flags|>{{~~~ ~~ ~~~}} <|CONTENT|> {{~~~ ~~ ~~~}}
^^}

----
Produces {^ <|CONTENT|> ^} literally,
with HTML syntax-character escaping and de-indentation.
Whitespace around {^ <|CONTENT|> ^} is stripped.
{^ <|flags|> ^} may consist of zero or more of the following characters:
----
====
* `u` to leave HTML syntax characters unescaped
* `c` to process [line continuations](#line-continuations)
* `w` to process [whitespace](#whitespace) completely
* `a` to enable all flags above
====
----
For {^ <|CONTENT|> ^} containing two or more consecutive tildes,
use a longer run of {{tildes}} in the delimiters.
----

----
A good use case is to wrap `<script>` elements inside `~~~ u~~ ~~ ~~~`.
This makes it immune to all CMD processing
(e.g.~conversion of `* *` to `<em> </em>`).
----

####{#cmd-literals-basic}
  Example 1: basic usage
####

====
* CMD
  ````{.cmd}
  ~~~~~
    Escaping: ~~ & < > ~~.
    Whitespace stripping: {~~      yes      ~~}.
    Enough tildes: ~~~~ ~~~ ~~ never ~~ ~~~ ~~~~.
  ~~~~~
  ````

* HTML
  ````{.html}
  ~~~~~
    Escaping: &amp; &lt; &gt;.
    Whitespace stripping: {yes}.
    Enough tildes: ~~~ ~~ never ~~ ~~~.
  ~~~~~
  ````

* Rendered
  ----
    Escaping: ~~ & < > ~~.
    Whitespace stripping: {~~      yes      ~~}.
    Enough tildes: ~~~~ ~~~ ~~ never ~~ ~~~ ~~~~.
  ----

====

####{#flags}
  Example 2: flags
####

@[flags examples] #flags @

#####{#unescaped-flag}
  2.1~Unescaped flag `u`
#####

====
* CMD
  ````{.cmd}
  ~~~~
    Escaping:     ~~ <b>blah</b> ~~.
    No escaping: u~~ <b>cough</b> ~~.
  ~~~~
  ````

* HTML
  ````{.html}
    Escaping:     &lt;b&gt;blah&lt;/b&gt;.
    No escaping: <b>cough</b>.
  ````

* Rendered
  ----
    Escaping:     ~~ <b>blah</b> ~~.
    No escaping: u~~ <b>cough</b> ~~.
  ----

====

#####{#continuations-flag}
  2.2~Continuations flag `c`
#####

====
* CMD
  ````{.cmd}
  ~~~~
    uc~~
      <pre>
        Blah blah blah\
          Cough cough cough
            Yep yep yep
      </pre>
    ~~
  ~~~~
  ````

* HTML
  ````{.html}
      <pre>
        Blah blah blahCough cough cough
            Yep yep yep
      </pre>
  ````

* Rendered
    uc~~
      <pre>
        Blah blah blah\
          Cough cough cough
            Yep yep yep
      </pre>
    ~~

====

#####{#whitespace-flag}
  2.3~Whitespace flag `w`
#####

@[whitespace flag example] #whitespace-flag @

====
* CMD
  ````{.cmd}
  ~~~~
    uw~~
      <pre>
        Blah blah blah
          Cough cough cough
            Yep yep yep
      </pre>
    ~~
  ~~~~
  ````

* HTML
  ````{.html}
    <pre>
    Blah blah blah
    Cough cough cough
    Yep yep yep
    </pre>
  ````

* Rendered
    uw~~
      <pre>
        Blah blah blah
          Cough cough cough
            Yep yep yep
      </pre>
    ~~

====



###{#display-code}
  Display code
###

{^^
  \/<|flags|>{{ ~~``~~ }}{<|attribute specification|>}
  \/  <|CONTENT|>
  \/{{ ~~``~~ }}
^^}

----
If {^ <|attribute specification|> ^} is empty,
the curly brackets surrounding it may be omitted.
----

----
Produces the display code
{^
  ~~ <pre ~~<|ATTRIBUTES|>~~ > ~~\
    ~~ <code> ~~\
         <|CONTENT|>\
    ~~ </code> ~~\
  ~~ </pre> ~~
^}
where {^ <|ATTRIBUTES|> ^} is the sequence of attributes
[built from {^ <|attribute specification|> ^}][as],
with HTML syntax-character escaping
and de-indentation for {^ <|CONTENT|> ^}.
{^ <|flags|> ^} may consist of zero or more of the following characters
(see [flags examples]):
----
====
* `u` to leave HTML syntax characters unescaped
* `c` to process [line continuations](#line-continuations)
* `w` to process [whitespace](#whitespace) completely
* `a` to enable all flags above
====
----
For {^ <|CONTENT|> ^} containing two or more consecutive backticks,
use a longer run of {{backticks}} in the delimiters.
----

====
* CMD
  ``````{.cmd}
  ~~~~
    ``{#id-0 .class-1 .class-2}
        Escaping: & < >.
        Note that CMD literals have higher precedence,
        since they are processed first: ~~~ ~~ literally ~~ ~~~.
            Uniform
            de-indentation:
            yes.
    ``
    ````
      ``
      Use more backticks as required.
      If <id> and <class> are omitted,
      no corresponding attributes are generated.
      ``
    ````
  ~~~~
  ``````

* HTML
  ``````{.html}
  ~~~~
    <pre id="id-0" class="class-1 class-2"><code>Escaping: &amp; &lt; &gt;.
    Note that CMD literals have higher precedence,
    since they are processed first: ~~ literally ~~.
        Uniform
        de-indentation:
        yes.
    </code></pre>
    <pre><code>``
    Use more backticks as required.
    If &lt;id&gt; and &lt;class&gt; are omitted,
    no corresponding attributes are generated.
    ``
    </code></pre>
  ~~~~
  ``````

* Rendered
    ``{#id-0 .class-1 .class-2}
        Escaping: & < >.
        Note that CMD literals have higher precedence,
        since they are processed first: ~~~ ~~ literally ~~ ~~~.
            Uniform
            de-indentation:
            yes.
    ``
    ````
      ``
      Use more backticks as required.
      If <id> and <class> are omitted,
      no corresponding attributes are generated.
      ``
    ````

====


###{#inline-code}
  Inline code
###

{^^
  <|flags|>{{ ~~`~~ }} <|CONTENT|> {{ ~~`~~ }}
^^}

----
Produces the inline code
{^
  ~~ <code> ~~\
    <|CONTENT|>\
  ~~ </code> ~~
^},
with HTML syntax-character escaping
and de-indentation for {^ <|CONTENT|> ^}.
Whitespace around {^ <|CONTENT|> ^} is stripped.
{^ <|flags|> ^} may consist of zero or more of the following characters
(see [flags examples]):
----
====
* `u` to leave HTML syntax characters unescaped
* `c` to process [line continuations](#line-continuations)
* `w` to process [whitespace](#whitespace) completely
* `a` to enable all flags above
====
----
For {^ <|CONTENT|> ^} containing one or more consecutive backticks
which are not protected by [CMD literals],
use a longer run of {{backticks}} in the delimiters.
----

====
* CMD
  ````{.cmd}
    `` The escaped form of & is &amp;. Here is a tilde: `. ``
  ````

* HTML
  ````{.html}
    <code>The escaped form of &amp; is &amp;amp;. Here is a tilde: `.</code>
  ````

* Rendered
  ----
    `` The escaped form of & is &amp;. Here is a tilde: `. ``
  ----

====


###{#comments}
  Comments
###

{^^
  \<{{\#}} <|COMMENT|> {{\#}}\>
^^}

----
Removed, along with any preceding horizontal whitespace.
For {^ <|COMMENT|> ^} containing one or more consecutive hashes
followed by a closing angle bracket,
use a longer run of {{hashes}} in the delimiters.
----
----
Although comments are weaker than literals and code
they may still be used to remove them.
For instance ` ~~~ ~~ A <# B #> ~~ ~~~ ` becomes ` A <# B #> `,
whereas ` ~~~ <# A ~~ B ~~ #> ~~~ ` is removed entirely.
In this sense they are stronger than literals and code.
----



###{#display-maths}
  Display maths
###

{^^
  \/<|flags|>{{ ~~$$~~ }}{<|attribute specification|>}
  \/  <|CONTENT|>
  \/{{ ~~$$~~ }}
^^}

----
If {^ <|attribute specification|> ^} is empty,
the curly brackets surrounding it may be omitted.
----

----
Produces
{^
  ~~ <div ~~<|ATTRIBUTES|>~~ > ~~\
       <|CONTENT|>\
  ~~ </div> ~~
^}
where {^ <|ATTRIBUTES|> ^} is the sequence of attributes
built from {^ <attribute specification> ^} with `.js-maths` prepended,
with HTML syntax-character escaping
and de-indentation for {^ <|CONTENT|> ^}.
{^ <|flags|> ^} may consist of zero or more of the following characters
(see [whitespace flag example]):
----
====
* `w` to process [whitespace](#whitespace) completely
====
----
For {^ <|CONTENT|> ^} containing two or more consecutive dollar signs
which are not protected by [CMD literals],
use a longer run of {{dollar signs}} in the delimiters.
----

----
This is to be used with some sort of JavaScript code
which renders equations based on the class `js-maths`.
On this page I am using [KaTeX].
----

====
* CMD
  ````{.cmd}
    $$
      1 + \frac{1}{2^2} + \frac{1}{3^2} + \dots
        = \frac{\pi^2}{6}
        < 2
    $$
  ````

* HTML
  ````{.html}
    <div class="js-maths">1 + \frac{1}{2^2} + \frac{1}{3^2} + \dots
      = \frac{\pi^2}{6}
      &lt; 2
    </div>
  ````

* Rendered
    $$
      1 + \frac{1}{2^2} + \frac{1}{3^2} + \dots
        = \frac{\pi^2}{6}
        < 2
    $$

====


###{#inline-maths}
  Inline maths
###

{^^
  <|flags|>{{ ~~$~~ }} <|CONTENT|> {{ ~~$~~ }}
^^}

----
Produces
{^
  ~~ <span class="js-maths"> ~~\
    <|CONTENT|>\
  ~~ </span> ~~
^},
with HTML syntax-character escaping for {^ <|CONTENT|> ^}.
Whitespace around {^ <|CONTENT|> ^} is stripped.
{^ <|flags|> ^} may consist of zero or more of the following characters
(see [whitespace flag example]):
----
====
* `w` to process [whitespace](#whitespace) completely
====
----
For {^ <|CONTENT|> ^} containing one or more consecutive dollar signs
which are not protected by [CMD literals],
use a longer run of {{dollar signs}} in the delimiters.
----

----
This is to be used with some sort of JavaScript code
which renders equations based on the class `js-maths`.
On this page I am using [KaTeX].
----

====
* CMD
  ````{.cmd}
    A contrived instance of multiple dollar signs in inline maths:
    $$$ \text{Yea, \$$d$ means $d$~dollars.} $$$
  ````

* HTML
  ````{.html}
    A contrived instance of multiple dollar signs in inline maths:
    <span class="js-maths">\text{Yea, \$$d$ means $d$~dollars.}</span>
  ````

* Rendered
  ----
    A contrived instance of multiple dollar signs in inline maths:
    $$$ \text{Yea, \$$d$ means $d$~dollars.} $$$
  ----

====


###{#inclusions}
  Inclusions
###

{^^
  ~~ { ~~{{ + }} <|FILE NAME|> {{ + }}~~ } ~~
^^}

----
Includes the content of the file {^ <|FILE NAME|> ^}.
For {^ <|FILE NAME|> ^} containing one or more consecutive plus signs
followed by a closing curly bracket,
use a longer run of {{plus signs}} in the delimiters.
----

----
All of the syntax above (CMD literals through to inline maths) is processed.
Unlike nested `\input` in LaTeX, nested inclusions are not processed.
----

====
* CMD
  ````{.cmd}
    {+ inclusion.txt +}
  ````

* HTML
  ````{.html}
  This is content from <a href="/inclusion.txt"><code>inclusion.txt</code></a>.
  Nested inclusions are not processed,
  so there is no need to worry about recursion errors: {+ inclusion.txt +}
  ````

* Rendered
  ----
    {+ inclusion.txt +}
  ----

====


###{#regex-replacements}
  Regex replacement definitions
###

{^^
  <|flag|>~~{~~{{ % }} <|PATTERN|> {{ % }} <|REPLACEMENT|> {{ % }}~~}~~
^^}

----
Reads and stores all regex replacement definitions
for the replacement of {^ <|PATTERN|> ^} by {^ <|REPLACEMENT|> ^}
according to Python regex syntax,
with the flags `re.ASCII`, `re.MULTILINE`, and `re.VERBOSE` enabled.
Whitespace around {^ <|PATTERN|> ^} and {^ <|REPLACEMENT|> ^} is stripped.
For {^ <|PATTERN|> ^} or {^ <|REPLACEMENT|> ^} containing
one or more consecutive percent signs,
use a longer run of {{percent signs}} in the delimiters.
For {^ <|PATTERN|> ^} matching any of the syntax above,
which should not be processed using that syntax, use CMD literals.
{^ <|flag|> ^} may consist of zero or one of the following characters,
and specifies when the regex replacement is to be applied:
----
====
* `A` for immediately after processing regex replacement definitions
* `p` for just before processing [preamble](#preamble)
* `b` for just before processing [blocks](#blocks)
* `t` for just before processing [tables](#tables)
* `e` for just before processing [escapes]
* `c` for just before processing [line continuations](#line-continuations)
* `i` for just before processing [images](#images)
* `l` for just before processing [links](#links)
* `h` for just before processing [headings](#headings)
* `s` for just before processing [inline semantics](#inline-semantics)
* `w` for just before processing [whitespace](#whitespace)
* `Z` for just before replacing placeholder strings
====
----
If {^ <|flag|> ^} is empty, it defaults to `A`.
----

----
All regex replacement definitions are read and stored.
If the same pattern is specified more than once for a given flag,
the latest definition shall prevail.
----

----
As an example, the following regex replacement is used
to automatically insert the permalinks
before the section headings (`<h2>` to `<h6>`) in this page:
----
````{.cmd}
  {%
    ^ [^\S\n]*
    (?P<hashes> [#]{2,6} )
      \{
        [#] (?P<id_> [\S]+? )
      \}
    [\s]+
      (?P<content> [\s\S]*? )
    (?P=hashes)
  %
    \g<hashes>{#\g<id_>}
      <a class="permalink" href="#\g<id_>" aria-label="Permalink"></a>\\
      \g<content>
    \g<hashes>
  %}
````

----
**Warning:** malicious or careless user-defined regex replacements
will break the normal CMD syntax.
To avoid breaking placeholder storage
(used to protect portions of the markup from further processing),
do not use replacements to alter placeholder strings,
which are of the form {^ \e000<|N|>\e000 ^},
where {^ \e000 ^} is the placeholder marker `U+E000` (Private Use Area)
and {^ <|N|> ^} is an integer.
To avoid breaking properties,
do not use replacements to alter property strings,
which are of the form {^ %<|PROPERTY NAME|> ^}.
----


###{#ordinary-replacements}
  Ordinary replacements
###

{^^
  <|flag|>~~{~~{{ : }} <|PATTERN|> {{ : }} <|REPLACEMENT|> {{ : }}~~}~~
^^}

----
Reads and stores all ordinary replacement definitions
for the replacement of {^ <|PATTERN|> ^} by {^ <|REPLACEMENT|> ^}.
Whitespace around {^ <|PATTERN|> ^} and {^ <|REPLACEMENT|> ^} is stripped.
For {^ <|PATTERN|> ^} or {^ <|REPLACEMENT|> ^} containing
one or more consecutive colons,
use a longer run of {{colons}} in the delimiters.
{^ <|flag|> ^} may consist of zero or one of the following characters,
and specifies when the ordinary replacement is to be applied:
----
====
* `A` for immediately after processing ordinary replacement definitions
* `p` for just before processing [preamble](#preamble)
* `b` for just before processing [blocks](#blocks)
* `t` for just before processing [tables](#tables)
* `e` for just before processing [escapes]
* `c` for just before processing [line continuations](#line-continuations)
* `i` for just before processing [images](#images)
* `l` for just before processing [links](#links)
* `h` for just before processing [headings](#headings)
* `s` for just before processing [inline semantics](#inline-semantics)
* `w` for just before processing [whitespace](#whitespace)
* `Z` for just before replacing placeholder strings
====
----
If {^ <|flag|> ^} is empty, it defaults to `A`.
----

----
All ordinary replacement definitions are read and stored.
If the same pattern is specified more than once for a given flag,
the latest definition shall prevail.
----

====
* CMD
  ````{.cmd}
    {: |hup-hup| : Huzzah! :}
    |hup-hup| \+
    
    {: \def1 : Earlier specifications lose. :}
    {: \def1 : Later specifications win. :}
    \def1 \+
    
    \def2 \+
    {: \def2 : Specifications can be given anywhere. :}
    
    {: <out> : Nesting will work provided the <in> is given later. :}
    {: <in> : inner specification :}
    <out>
  ````

* Rendered
  ----
    {: |hup-hup| : Huzzah! :}
    |hup-hup| \+
    
    {: \def1 : Earlier specifications lose. :}
    {: \def1 : Later specifications win. :}
    \def1 \+
    
    \def2 \+
    {: \def2 : Specifications can be given anywhere. :}
    
    {: <out> : Nesting will work provided the <in> is given later. :}
    {: <in> : inner specification :}
    <out>
  ----

====

----
**Warning:** malicious or careless user-defined ordinary replacements
will break the normal CMD syntax.
To avoid breaking placeholder storage
(used to protect portions of the markup from further processing),
do not use replacements to alter placeholder strings,
which are of the form {^ \e000<|N|>\e000 ^},
where {^ \e000 ^} is the placeholder marker `U+E000` (Private Use Area)
and {^ <|N|> ^} is an integer.
To avoid breaking properties,
do not use replacements to alter property strings,
which are of the form {^ %<|PROPERTY NAME|> ^}.
----


###{#preamble}
  Preamble
###

{^^
  \/{{ %% }}
  \/  <|CONTENT|>
  \/{{ %% }}
^^}

----
Processes the preamble.
{^ <|CONTENT|> ^} is split into property specifications
according to leading occurrences of {^ %<|PROPERTY NAME|> ^},
where {^ <|PROPERTY NAME|> ^} may only contain letters, digits, and hyphens.
Property specifications end at the next property specification,
or at the end of the (preamble) content being split.
Each property is stored and may be referenced
by writing {^ %<|PROPERTY NAME|> ^},
called a property string, anywhere else in the document.
If the same property is specified more than once,
the latest specification shall prevail.
----

----
This produces the HTML preamble,
i.e.~everything from `<!DOCTYPE html>` through to `<body>`.
----

----
For {^ <|CONTENT|> ^} containing two or more consecutive percent signs
which are not protected by CMD literals,
use a longer run of {{percent signs}} in the delimiters.
----

----
Only the first occurrence of a preamble in the markup is processed.
----

----
The following properties, called original properties,
are accorded special treatment.
If omitted from a preamble,
they take the default values shown beside them:
----
````{.cmd}
  %lang en
  %viewport width=device-width, initial-scale=1
  %title Title
  %title-suffix
  %author
  %date-created yyyy-mm-dd
  %date-modified yyyy-mm-dd
  %resources
  %description
  %css
  %onload-js
  %footer-copyright-remark
  %footer-remark
````

----
The following properties, called derived properties,
are computed based on the supplied original properties:
----
````{.cmd}
  %html-lang-attribute
  %meta-element-author
  %meta-element-description
  %meta-element-viewport
  %title-element
  %style-element
  %body-onload-attribute
  %year-created
  %year-modified
  %year-modified-next
  %footer-element
  %url
  %clean-url
````

####{#preamble-minimal} Example 1: a minimal HTML file ####

====
* CMD
  ````{.cmd}
    %%
    %%
  ````

* HTML
  ````{.html}
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Title</title>
    </head>
    <body>
    </body>
    </html>
  ````

====

####{#preamble-not-minimal} Example 2: a not-so-minimal HTML file ####

====
* CMD
  ````{.cmd}
  ~~~~
    %%
      %lang en-AU
      %title My title
      %title-suffix \ | My site
      %author Me
      %date-created 2020-04-11
      %date-modified 2020-04-11
      %description
        This is the description. Hooray for automatic escaping (&, <, >, ")!
      %css a~~
        #special {
          color: purple;
        }
      ~~
      %onload-js
        special.textContent += ' This is a special paragraph!'
    %%
    
    # %title #
    
    ----special
      The title of this page is "%title", and the author is %author.
      At the time of writing, next year will be %year-modified-next.
    ----
    
    %footer-element
  ~~~~
  ````

* HTML
  ````{.html}
    <!DOCTYPE html>
    <html lang="en-AU">
    <head>
    <meta charset="utf-8">
    <meta name="author" content="Me">
    <meta name="description" content="This is the description. Hooray for automatic escaping (&amp;, &lt;, &gt;, &quot;)!">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My title | My site</title>
    <style>#special {
    color: purple;
    }</style>
    </head>
    <body onload="special.textContent += ' This is a special paragraph!'">
    <h1>My title</h1>
    <p id="special">
    The title of this page is "My title", and the author is Me.
    At the time of writing, next year will be 2021.
    </p>
    <footer>
    ©&nbsp;2020&nbsp;Me.
    </footer>
    </body>
    </html>
  ````

====


###{#blocks}
  Blocks
###

{^^
  \/{{ \C\C\C\C }}<|id|>{<|class|>}
  \/  <|CONTENT|>
  \/{{ \C\C\C\C }}
^^}

----
If {^ <|class|> ^} is empty, the curly brackets surrounding it may be omitted.
----

----
Produces the block
{^
  \<<|TAG NAME|>
    id="<|id|>" class="<|class|>"\>↵\
      <|CONTENT|>\
  \</<|TAG NAME|>\>
^}.
For {^ <|CONTENT|> ^} containing four or more
consecutive delimiting characters
which are not protected by [CMD literals],
use a longer run of {{delimiting characters}} in the delimiters.
----

----
The following delimiting characters {^ \C ^} are used:
----
======
* Non-lists:
  ====
  * `-` for `<p>`
  * `|` for `<div>`
  * `"` for `<blockquote>`
  ====
* Lists:
  ====
  * `=` for `<ul>`
  * `+` for `<ol>`
  ====
======

----
In the implementation, a recursive call is used to process nested blocks.
----

####{#list-items}
  List items
####

----
For list blocks, {^ <|CONTENT|> ^} is split into list items `<li>`
according to leading occurrences of the following:
----

{^^ \Y<|id|>{<|class|>} ^^}

----
The following delimiters {^ \Y ^} for list items are used:
----
====
* `*`
* `+`
* `-`
* `1.` (or any run of digits followed by a full stop)
====
----
List items end at the next list item,
or at the end of the content being split.
If {^ <|class|> ^} is empty,
the curly brackets surrounding it may be omitted.
----

####{#blocks-nesting} Example 1: nesting ####

================
* CMD
  ````{.cmd}
    ----
    A paragraph.
    ----
    ======
    * A nested unordered list:
      ====
      1. Unlike John Gruber's markdown, indentation doesn't matter.
          * This is on the same level as the item above.
      ====
    * A nested ordered list:
      ++++
      * A leading asterisk `*` can be used for `<li>` in `<ol>`.
      + Also a plus sign `+`.
      - Also a hyphen `-`.
      2.  An easy way to remember the list delimiters is that
          unordered list items stay constant (`====`) while
          ordered list items increment (`++++`).
      ++++
    0. A leading number and full stop can be used for `<li>` in `<ul>`.
    99999999. Any non-negative integer will do.
      """"""
      Someone might quote this later. 
      ====
      * Yes, I know.
      ====
      """"""
    1. They all get turned into `<li>` tags regardless.
    ======
  ````

* Rendered
    ----
    A paragraph.
    ----
    ======
    * A nested unordered list:
      ====
      1. Unlike John Gruber's markdown, indentation doesn't matter.
          * This is on the same level as the item above.
      ====
    * A nested ordered list:
      ++++
      * A leading asterisk `*` can be used for `<li>` in `<ol>`.
      + Also a plus sign `+`.
      - Also a hyphen `-`.
      2.  An easy way to remember the list delimiters is that
          unordered list items stay constant (`====`) while
          ordered list items increment (`++++`).
      ++++
    0. A leading number and full stop can be used for `<li>` in `<ul>`.
    99999999. Any non-negative integer will do.
      """"""
      Someone might quote this later. 
      ====
      * Yes, I know.
      ====
      """"""
    1. They all get turned into `<li>` tags regardless.
    ======

================

####{#blocks-id-class} Example 2: `id` and `class` ####

================
* CMD
  ````{.cmd}
    ----p-id{p-class}
    Paragraph with `id` and `class`.
    ----
    ======
    *li-id List item with `id` and no `class`.
    0.{li-class} List item with `class` and no `id`.
    1.{li-class}
      Put arbitrary whitespace after the class for more clarity.
    ======
  ````

* HTML
  ````{.html}
    <p id="p-id" class="p-class">
    Paragraph with <code>id</code> and <code>class</code>.
    </p>
    <ul>
    <li id="li-id">List item with <code>id</code> and no <code>class</code>.
    </li>
    <li class="li-class">List item with <code>class</code> and no <code>id</code>.
    </li>
    <li class="li-class">Put arbitrary whitespace after the class for more clarity.
    </li>
    </ul>
  ````

================


###{#tables}
  Tables
###

{^^
  \/{{ '''' }}<|id|>{<|class|>}
  \/  <|CONTENT|>
  \/{{ '''' }}
^^}

----
If {^ <|class|> ^} is empty, the curly brackets surrounding it may be omitted.
----

----
Produces the table
{^
  \<table
    id="<|id|>" class="<|class|>"\>↵\
      <|CONTENT|>\
  \</table\>
^}.
For {^ <|CONTENT|> ^} containing four or more apostrophes
which are not protected by [CMD literals],
use a longer run of {{apostrophes}} in the delimiters.
----

----
In the implementation, a recursive call is used to process nested tables.
----

----
{^ <|CONTENT|> ^} is
----
++++
1.  split into table cells `<th>`, `<td>`
    according to [table cell processing](#table-cells),
2.  split into table rows `<tr>`
    according to [table row processing](#table-rows), and
3.  split into table parts `<thead>`, `<tbody>`, `<tfoot>`
    according to [table part processing](#table-parts).
++++

####{#table-cells}
  Table cells
####

----
{^ <|CONTENT|> ^} is split into table cells `<th>`, `<td>`
according to leading occurrences of the following:
----

{^^ \Z<|id|>{<|class|>}[<|rowspan|>,<|colspan|>] ^^}

----
The following delimiters {^ \Z ^} for table cells are used:
----
====
* `;` for `<th>`
* `,` for `<td>`
====
----
Table cells end at the next table cell, table row, or table part,
or at the end of the content being split.
Non-empty {^ <|rowspan|> ^} and {^ <|colspan|> ^} must consist of digits only.
If {^ <|class|> ^} is empty,
the curly brackets surrounding it may be omitted.
If {^ <|colspan|> ^} is empty, the comma before it may be omitted.
If both {^ <|rowspan|> ^} and {^ <|colspan|> ^} are empty,
the comma between them and the square brackets surrounding them may be omitted.
----

####{#table-rows}
  Table rows
####

----
{^ <|CONTENT|> ^} is split into table rows `<tr>`
according to leading occurrences of the following:
----

{^^ ==<|id|>{<|class|>} ^^}

----
Table rows end at the next table row or table part,
or at the end of the content being split.
If {^ <|class|> ^} is empty,
the curly brackets surrounding it may be omitted.
----

####{#table-parts}
  Table parts
####

----
{^ <|CONTENT|> ^} is split into table parts `<thead>`, `<tbody>`, `<tfoot>`
according to leading occurrences of the following:
----

{^^ \Y<|id|>{<|class|>} ^^}

----
The following delimiters {^ \Y ^} for table parts are used:
----
====
* `|^` for `<thead>`
* `|~` for `<tbody>`
* `|_` for `<tfoot>`
====
----
Table parts end at the next table part,
or at the end of the content being split.
If {^ <|class|> ^} is empty,
the curly brackets surrounding it may be omitted.
----

####{#tables-without-parts}
  Example 1: table *without* `<thead>`, `<tbody>`, `<tfoot>` parts
####

====
* CMD
  ````{.cmd}
    ''''
      ==
        ; A
        ; B
        ; C
        ; D
      ==
        , 1
        ,[2] 2
        , 3
        , 4
      ==
        , 5
        ,[3,2] 6
      ==
        ,[,2] 7
      ==
        , 8
        ; ?
    ''''
  ````

* HTML
  ````{.html}
    <table>
    <tr>
    <th>A</th>
    <th>B</th>
    <th>C</th>
    <th>D</th>
    </tr>
    <tr>
    <td>1</td>
    <td rowspan="2">2</td>
    <td>3</td>
    <td>4</td>
    </tr>
    <tr>
    <td>5</td>
    <td rowspan="3" colspan="2">6</td>
    </tr>
    <tr>
    <td colspan="2">7</td>
    </tr>
    <tr>
    <td>8</td>
    <th>?</th>
    </tr>
    </table>
  ````

* Rendered
    ''''
      ==
        ; A
        ; B
        ; C
        ; D
      ==
        , 1
        ,{r2} 2
        , 3
        , 4
      ==
        , 5
        ,{r3 c2} 6
      ==
        ,{c2} 7
      ==
        , 8
        ; ?
    ''''

====

####{#tables-with-parts}
  Example 2: table *with* `<thead>`, `<tbody>`, `<tfoot>` parts
####

====
* CMD
  ````{.cmd}
    ''''
    |^
      ==
        ; Meals
        ; Cost / \d
    |:
      ==
        ; Lunch
        , 7
      ==
        ; Dinner
        , 10
    |_
      ==
        ; Total
        ,total-cost{some-class}
          17
    ''''
  ````

* HTML
  ````{.html}
    <table>
    <thead>
    <tr>
    <th>Meals</th>
    <th>Cost / $</th>
    </tr>
    </thead>
    <tbody>
    <tr>
    <th>Lunch</th>
    <td>7</td>
    </tr>
    <tr>
    <th>Dinner</th>
    <td>10</td>
    </tr>
    </tbody>
    <tfoot>
    <tr>
    <th>Total</th>
    <td id="total-cost" class="some-class">17</td>
    </tr>
    </tfoot>
    </table>
  ````

* Rendered
    ''''
    |^
      ==
        ; Meals
        ; Cost / \d
    |:
      ==
        ; Lunch
        , 7
      ==
        ; Dinner
        , 10
    |_
      ==
        ; Total
        ,{#total-cost .some-class}
          17
    ''''

====


###{#escapes}
  Escapes
###


||||{.centred-flex}
''''
  ==
    ; CCH
    ; HTML
    ; Rendered
    ; Description
  ==
    , `\\`
    , `\`
    , \\
    , Backslash
  ==
    , `\/`
    , `~~ ~~`
    ,
    , Empty string
  ==
    , `\ /`
    , `~~ ~~ ~~ ~~`
    , \ /
    , Space
  ==
    , `\ ~~ ~~`
    , `~~ ~~ ~~ ~~`
    , \ ~~ ~~
    , Space
  ==
    , `\~`
    , `~`
    , \~
    , Tilde
  ==
    , `~`
    , `&nbsp;`
    , ~
    , Non-breaking space
  ==
    , `\0`
    , `&numsp;`
    , \0
    , Figure space
  ==
    , `\,`
    , `&thinsp;`
    , \,
    , Thin space
  ==
    , `\&`
    , `&amp;`
    , \&
    , Ampersand (entity)
  ==
    , `\<`
    , `&lt;`
    , \<
    , Less than (entity)
  ==
    , `\>`
    , `&gt;`
    , \>
    , Greater than (entity)
  ==
    , `\"`
    , `&quot;`
    , \"
    , Double quote (entity)
  ==
    , `...`
    , `…`
    , ...
    , `U+2026 HORIZONTAL ELLIPSIS`
  ==
    , `---`
    , `—`
    , ---
    , `U+2014 EM DASH`
  ==
    , `--`
    , `–`
    , --
    , `U+2013 EN DASH`
  ==
    , `\P`
    , `¶`
    , \P
    , `U+00B6 PILCROW SIGN`
  ==
    , `\d`
    , `$`
    , \d
    , Dollar sign
  ==
    , `\#`
    , `#`
    , \#
    , Hash
  ==
    , `\[`
    , `[`
    , \[
    , Opening square bracket
  ==
    , `\]`
    , `]`
    , \]
    , Closing square bracket
  ==
    , `\(`
    , `(`
    , \(
    , Opening round bracket
  ==
    , `\)`
    , `)`
    , \)
    , Closing round bracket
  ==
    , `\*`
    , `*`
    , \*
    , Asterisk
  ==
    , `\_`
    , `_`
    , \_
    , Underscore
  ==
    , `\=`
    , `<hr>`
    , \=
    , Thematic break
  ==
    , `\+`
    , `<br>`
    , \+
    , Line break
''''
||||


###{#line-continuations}
  Line continuations
###

----
Use backslashes for line continuation.
All leading whitespace on the next line is stripped.
----

====
* CMD
  ````{.cmd}
    (Line 1)\
      (Line 2)
    (Line 3) \
           (Line 4)
  ````

* HTML
  ````{.html}
    (Line 1)(Line 2)
    (Line 3) (Line 4)
  ````

====


###{#images}
  Images
###


####{#inline-style-images}
  Inline-style images
####

{^^
  ~~ ![ ~~<|ALT|>](<|src|> <|title|>)
^^}

----
Unlike John Gruber's markdown, {^ <|title|> ^} is not surrounded by quotes.
If quotes are supplied to {^ <|title|> ^},
they are automatically escaped as `&quot;`.
----

----
Produces the image
{^
  ~~ <img ~~
    alt="<|ALT|>"
    src="<|src|>"
    title="<|title|>"\
  ~~ > ~~
^}.
For {^ <|ALT|> ^}, {^ <|src|> ^}, or {^ <|title|> ^} containing
one or more closing square or round brackets,
use [escapes] or [CMD literals].
----

====
* CMD
  ````{.cmd}
  ![Dr~Nicolaes Tulp giving an anatomy lesson using a corpse](
    /rembrandt-anatomy.jpg
    The Anatomy Lesson of Dr~Nicolaes Tulp \(Rembrandt\)
  )
  ````

* HTML
  ````{.html}
  <img alt="Dr&nbsp;Nicolaes Tulp giving an anatomy lesson using a corpse" src="/rembrandt-anatomy.jpg" title="The Anatomy Lesson of Dr&nbsp;Nicolaes Tulp (Rembrandt)">
  ````

* Rendered
  ----
  ![Dr~Nicolaes Tulp giving an anatomy lesson using a corpse](
    /rembrandt-anatomy.jpg
    The Anatomy Lesson of Dr~Nicolaes Tulp \(Rembrandt\)
  )
  ----

====


####{#reference-style-images}
  Reference-style images
####

====
* Definition
  {^^
    \/{{ @@ }}![<|LABEL|>]{<|class|>}[<|width|>]
    \/  <|src|> <|title|>
    \/{{ @@ }}
  ^^}

* Image
  {^^
    ![<|ALT|>][<|label|>]
  ^^}

====
----
A single space may be included
between {^ [<|ALT|>] ^} and {^ [<|label|>] ^} in an image.
The referencing strings {^ <|LABEL|> ^} and {^ <|label|> ^}
are case insensitive.
Non-empty {^ <|width|> ^} in a definition must consist of digits only.
If {^ <|class|> ^} in a definition is empty,
the curly brackets surrounding it may be omitted.
If {^ <|width|> ^} in a definition is empty,
the square brackets surrounding it may be omitted.
If {^ <|label|> ^} in an image is empty,
the square brackets surrounding it may be omitted,
and {^ <|ALT|> ^} is used as the label for that image.
----

----
Produces the image
{^
  ~~ <img ~~
    alt="<|ALT|>"
    class="<|class|>"
    src="<|src|>"
    title="<|title|>"
    width="<|width|>"\
  ~~ > ~~
^}.
Whitespace around {^ <|label|> ^} is stripped.
For definitions whose {^ <|LABEL|> ^}, {^ <|class|> ^},
{^ <|src|> ^}, or {^ <|title|> ^} contains
two or more consecutive at signs
which are not protected by CMD literals,
use a longer run of {{at signs}} in the delimiters.
For images whose {^ <|ALT|> ^} or {^ <|label|> ^} contains
one or more closing square brackets,
use [escapes] or [CMD literals].
----

----
All image definitions are read and stored
before being applied in order.
If the same label is specified more than once,
the latest specification shall prevail.
----

====
* CMD
  ````{.cmd}
  @@![moses-breaking-tablets][200]
    /rembrandt-moses.jpg
    Moses Breaking the Tablets of the Law (Rembrandt)
  @@
  
  ![A pissed-off Moses, about to smash the Law Tablets][moses-breaking-tablets]
  ````

* HTML
  ````{.html}
  <img alt="A pissed-off Moses, about to smash the Law Tablets" src="/rembrandt-moses.jpg" title="Moses Breaking the Tablets of the Law (Rembrandt)" width="200">
  ````

* Rendered
  ----
  @@[moses-breaking-tablets]{w200}
    /rembrandt-moses.jpg
    Moses Breaking the Tablets of the Law (Rembrandt)
  @@
  
  ![A pissed-off Moses, about to smash the Law Tablets][moses-breaking-tablets]
  ----

====


###{#links}
  Links
###


####{#inline-style-links}
  Inline-style links
####

{^^
  ~~ [ ~~<|CONTENT|>](<|href|> <|title|>)
^^}

----
Unlike John Gruber's markdown, {^ <|title|> ^} is not surrounded by quotes.
If quotes are supplied to {^ <|title|> ^},
they are automatically escaped as `&quot;`.
----

----
Produces the link
{^
  ~~ <a ~~
    href="<|href|>"
    title="<|title|>"\
  ~~ > ~~\
    <|CONTENT|>\
  ~~ </a> ~~
^}.
Whitespace around {^ <|CONTENT|> ^} is stripped.
For {^ <|CONTENT|> ^}, {^ <|href|> ^}, or {^ <|title|> ^} containing
one or more closing square or round brackets,
use [escapes] or [CMD literals].
----

====
* CMD
  ````{.cmd}
  [Wikimedia Commons](
    https://commons.wikimedia.org/wiki/Main_Page
    Wikimedia Commons
  )
    \+
  [Wikimedia Commons without title](https://commons.wikimedia.org/wiki/Main_Page)
  ````

* HTML
  ````{.html}
  <a href="https://commons.wikimedia.org/wiki/Main_Page" title="Wikimedia Commons">Wikimedia Commons</a><br>
  <a href="https://commons.wikimedia.org/wiki/Main_Page">Wikimedia Commons without title</a>
  ````

* Rendered
  ----
  [Wikimedia Commons](
    https://commons.wikimedia.org/wiki/Main_Page
    Wikimedia Commons
  )
    \+
  [Wikimedia Commons without title](https://commons.wikimedia.org/wiki/Main_Page)
  ----

====


####{#reference-style-links}
  Reference-style links
####

====
* Definition
  {^^
    \/{{ @@ }}[<|LABEL|>]{<|class|>}
    \/  <|href|> <|title|>
    \/{{ @@ }}
  ^^}

* Link
  {^^
    [<|CONTENT|>][<|label|>]
  ^^}

====
----
A single space may be included
between {^ [<|CONTENT|>] ^} and {^ [<|label|>] ^} in a link.
The referencing strings {^ <|LABEL|> ^} and {^ <|label|> ^}
are case insensitive.
If {^ <|class|> ^} in a definition is empty,
the curly brackets surrounding it may be omitted.
If {^ <|label|> ^} in a link is empty,
the square brackets surrounding it may be omitted,
and {^ <|CONTENT|> ^} is used as the label for that link.
----

----
Produces the link
{^
  ~~ <a ~~
    class="<|class|>"
    href="<|href|>"
    title="<|title|>"\
  ~~ > ~~\
    <|CONTENT|>\
  ~~ </a> ~~
^}.
Whitespace around {^ <|CONTENT|> ^} and {^ <|label|> ^} is stripped.
For definitions whose {^ <|LABEL|> ^}, {^ <|class|> ^},
{^ <|href|> ^}, or {^ <|title|> ^} contains
two or more consecutive at signs
which are not protected by CMD literals,
use a longer run of {{at signs}} in the delimiters.
For links whose {^ <|CONTENT|> ^} or {^ <|label|> ^} contains
one or more closing square brackets,
use [escapes] or [CMD literals].
----

----
All link definitions are read and stored
before being applied in order.
If the same label is specified more than once,
the latest specification shall prevail.
----

====
* CMD
  ````{.cmd}
  @@[wikipedia]
    https://en.wikipedia.org/wiki/Main_Page
    Wikipedia, the free encyclopedia
  @@
  
  [Wikipedia's home page][wikipedia] \+
  [Wikipedia][] \+
  [Wikipedia]
  ````

* HTML
  ````{.html}
  <a href="https://en.wikipedia.org/wiki/Main_Page" title="Wikipedia, the free encyclopedia">Wikipedia's home page</a><br>
  <a href="https://en.wikipedia.org/wiki/Main_Page" title="Wikipedia, the free encyclopedia">Wikipedia</a><br>
  <a href="https://en.wikipedia.org/wiki/Main_Page" title="Wikipedia, the free encyclopedia">Wikipedia</a>
  ````

* Rendered
  ----
  @@[wikipedia]
    https://en.wikipedia.org/wiki/Main_Page
    Wikipedia, the free encyclopedia
  @@
  
  [Wikipedia's home page][wikipedia] \+
  [Wikipedia][] \+
  [Wikipedia]
  ----

====


###{#headings}
  Headings
###

{^^
  \#<|id|> <|CONTENT|> \#
^^}

----
Produces the heading
{^
  ~~ <h1 ~~
    id="<|id|>"~~ > ~~\
      <|CONTENT|>\
  ~~ </h1> ~~
^}.
Whitespace around {^ <|CONTENT|> ^} is stripped.
For `<h2>` to `<h6>`, use 2 to 6 delimiting hashes respectively.
For {^ <|CONTENT|> ^} containing the delimiting number of
or more consecutive hashes, use [CMD literals].
----

====
* CMD
  ````{.cmd}
    ###some-id Heading with id ###
    #### Heading without id ####
  ````

* HTML
  ````{.html}
    <h3 id="some-id">Heading with id</h3>
    <h4>Heading without id</h4>
  ````

====


###{#inline-semantics}
  Inline semantics
###

{^^
  \X{<|class|>} <|CONTENT|> \X
^^}

----
{^ <|CONTENT|> ^} must be non-empty.
If {^ <|class|> ^} is empty, the curly brackets surrounding it may be omitted.
----

----
Produces the inline semantic
{^
  \<<|TAG NAME|>
    class="<|class|>"\>\
      <|CONTENT|>\
  \</<|TAG NAME|>\>
^}.
Whitespace around {^ <|CONTENT|> ^} is stripped.
For {^ <|CONTENT|> ^} containing one or more occurrences of `*` or `_`,
use [CMD literals] or the [escapes] `\*` and `\_`.
----

----
The following delimiters {^ \X ^},
equal to one or two delimiting characters {^ \C ^},
are used:
----
======
* `**` for `<strong>`
  (strong importance, seriousness, etc.)

* `*` for `<em>`
  (stress emphasis, sarcasm, etc.)

* `__` for `<b>`
  (bring to attention *without* strong importance,~e.g. keywords)

* `_` for `<i>`
  (offset text *without* stress emphasis, e.g.~book titles, Latin)

======

----
**In HTML5, `<b>` and `<i>` are *not* deprecated.**
See [W3C on using `<b>` and `<i>` elements](
  https://www.w3.org/International/questions/qa-b-and-i-tags.en
).
----

----
In the implementation, matches are sought in the following order
(for brevity, `C` is used in place of {^ \C ^} below):
----

||||{.centred-flex}
''''
|^
  ==
    ; Type
    ; Form
|:
  ==
    , 33
    , {^ CCC{<|inner class|>} <|INNER CONTENT|> CCC ^}
  ==
    , 312
    , {^ CCC{<|inner class|>} <|INNER CONTENT|> C <|OUTER CONTENT|> CC ^}
  ==
    , 321
    , {^ CCC{<|inner class|>} <|INNER CONTENT|> CC <|OUTER CONTENT|> C ^}
  ==
    , 22
    , {^ CC{<|class|>} <|CONTENT|> CC ^}
  ==
    , 11
    , {^ C{<|class|>} <|CONTENT|> C ^}
''''
||||

----
33 is effectively 312 with empty {^ <|OUTER CONTENT|> ^}.
Once such a pattern has been matched,
only three cases need to be handled for the resulting match object:
----
====
* 2-layer special (for 33): \+
  {^^ \X\Y{<|inner class|>} <|INNER CONTENT|> \Y\X ^^}

* 2-layer general (for 312, 321): \+
  {^^ \X\Y{<|inner class|>} <|INNER CONTENT|> \Y <|OUTER CONTENT|> \X ^^}

* 1-layer case (for 22, 11): \+
  {^^ \X{<|class|>} <|CONTENT|> \X ^^}

====

----
Recursive calls are used to process nested inline semantics.
----

||||{.centred-flex}
''''
|^
  ==
    ; CCH
    ; Rendered
|:
  ==
    , `***strong-em***`
    ,  ***strong-em***
  ==
    , `***strong-em* strong**`
    ,  ***strong-em* strong**
  ==
    , `***em-strong** em*`
    ,  ***em-strong** em*
  ==
    , `**strong**`
    ,  **strong**
  ==
    , `*em*`
    ,  *em*
  ==
    , `___b-i___`
    ,  ___b-i___
  ==
    , `___b-i_ b__`
    ,  ___b-i_ b__
  ==
    , `___i-b__ i_`
    ,  ___i-b__ i_
  ==
    , `__b__`
    ,  __b__
  ==
    , `_i_`
    ,  _i_
''''
||||

====
* CMD
  ````{.cmd}
  **Do not confuse `<strong>` and `<em>` with `<b>` and `<i>`.** \+
  They are *not* the same. \+
  Meals come with __rice__ or __pasta__. \+
  I _{translator-supplied} am_ the LORD.
  ````

* HTML
  ````{.html}
  <strong>Do not confuse <code>&lt;strong&gt;</code> and <code>&lt;em&gt;</code> with <code>&lt;b&gt;</code> and <code>&lt;i&gt;</code>.</strong><br>
  They are <em>not</em> the same.<br>
  Meals come with <b>rice</b> or <b>pasta</b>.<br>
  I <i class="translator-supplied">am</i> the LORD.
  ````

* Rendered
  ----
  \/**Do not confuse `<strong>` and `<em>` with `<b>` and `<i>`.** \+
  They are *not* the same. \+
  Meals come with __rice__ or __pasta__. \+
  I _{.translator-supplied} am_ the LORD.
  ----

====


###{#whitespace}
  Whitespace
###

----
Throughout this document, "whitespace" refers specifically to ASCII whitespace.
See [`string.whitespace`][string.whitespace]:
----
""""
~~[~~...~~]~~ all ASCII characters that are considered whitespace.
~~[~~...~~]~~ space, tab, linefeed, return, formfeed, and vertical tab.
""""

----
Whitespace is processed as follows:
----
++++
1.  Leading and trailing horizontal whitespace is removed.
2.  Empty lines are removed. (In the implementation,
    consecutive newlines are replaced with a single newline.)
3.  Whitespace before line break elements `<br>` is removed.
4.  Whitespace for attributes is canonicalised:
    ====
    * a single space is used before the attribute name, and
    * no whitespace is used around the equals sign.
    ====
++++


%footer-element

@[CMD literals] #cmd-literals @
@[escapes] #escapes @

@@[cmd-repo]
  https://github.com/conway-markdown/conway-markdown/
  GitHub: Conway's markdown
@@

@@[cmd-docs-repo]
  https://github.com/conway-markdown/conway-markdown.github.io/
  GitHub: Documentation for Conway's markdown (GitHub pages)
@@

@@[source-cmd]
  https://github.com/conway-markdown/conway-markdown.github.io/\
    blob/master/index.cmd
  GitHub: index.cmd
@@

@@[output-html]
  https://github.com/conway-markdown/conway-markdown.github.io/\
    blob/master/index.html
  GitHub: index.html
@@

@@[katex]
  https://katex.org/
  KaTeX --- The fastest math typesetting library for the web
@@

@@[markdown]
  https://daringfireball.net/projects/markdown/
  Daring Fireball: Markdown
@@

@@[string.whitespace]
  https://docs.python.org/3/library/string.html#string.whitespace
@@
