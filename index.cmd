%%%%

%author Conway
%title Conway's markdown (CMD)
%date-created 2020-04-05
%date-modified 2020-04-07
%resources
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/cmd.css">

%%%%


<!-- {^^ Syntax (display) ^^} -->
{% \{ \^\^ [\s]* % <pre class="cmd syntax"><code> %}
{% [\s]* \^\^ \} % </code></pre> %}

<!-- {^ Inline syntax ^} -->
{% \{ \^ [\s]* % <code> %}
{% [\s]* \^ \} % </code> %}

<!-- {{ Repeatable delimiter }} -->
{% {{ [\s]* % <span class="repeatable-delimiter"> %}
{% [\s]* }} % </span> %}

<!-- {.Mandatory.} -->
{: {. : <span class="mandatory-argument">{ :}
{: .} : }</span> :}

<!-- {.Optional.} -->
{: [. : <span class="optional-argument">[ :}
{: .] : ]</span> :}

<!-- Heading self-link anchors (<h2> to <h6>) -->
{%
  (?P<leading_whitespace> ^ [\S\n]* )
  (?P<hashes> [#]{2,6} )
  (?P<id_> [^\s]* )
  (?P<removable_whitespace> [\s]* )
    (?P<content> [\s\S]*? )
  (?P=hashes)
%
  \g<leading_whitespace>\g<hashes>\g<id_>
    <a class="self-link" href="#\g<id_>"></a>\\
    \g<content>
  \g<hashes>
%}

<!-- U+21B5 DOWNWARDS ARROW WITH CORNER LEFTWARDS -->
{: \newline : ↵ :}


# %title #


|||| page-properties
  First created: %date-created \\
  Last modified: %date-modified
||||

====
* This page's source CMD: [`index.cmd`][source-cmd]
* This page's output HTML: [`index.html`][output-html]
* GitHub repository: [`conway-markdown`][cmd-github]
====


----
Conway's fence-style markdown,
implemented in Python using regex replacements.
----

----
Conway's markdown (CMD) is the result of someone joking that
"the filenames would look like Windows executables from the 90s".
Inspired by the backticks of John Gruber's [markdown][],
Conway's markdown uses fence-style constructs
where an {{arbitrarily repeatable delimiter symbol}}
is used to wrap shorter runs of that symbol.
----


##usage
  Usage
##

----
Convert a CMD file to HTML, outputting to `cmd_name.html`:
----

````
$ python cmd.py [cmd_name[.[cmd]]]
````

----
Omit `[cmd_name[.[cmd]]]` to convert all CMD files
in the current directory (at all levels),
except those listed in `.cmdignore`.
----


##syntax
  Syntax
##

----
Since CMD-to-HTML conversion is merely a bunch of regex replacements
(with some dictionaries for temporary storage of strings),
the syntax for earlier replacements will have higher precedence
than that for later replacements.
The syntax of CMD, in the order of processing, is thus:
----


###cmd-literals
  CMD literals
###

{^^
  ({{!}} {.content.} {{!}})
^^}

----
Literal {^ {.content.} ^},
with HTML syntax-character escaping and de-indentation.
Whitespace around {^ {.content.} ^} is stripped.
For {^ {.content.} ^} containing one or more consecutive exclamation marks
followed by a closing round bracket,
use a greater number of {{exclamation marks}} in the delimiters.
----

====
* CMD
  ```` cmd
  (!!!!
    Escaping: (! & < > !).
    Whitespace stripping: {(!      yes      !)}.
    Enough exclamation marks: (!!! (!! (! never !) !!) !!!).
  !!!!)
  ````

* HTML
  ```` html
  (!!!!
    Escaping: &amp; &lt; &gt;.
    Whitespace stripping: {yes}.
    Enough exclamation marks: (!! (! never !) !!).
  !!!!)
  ````

* Rendered
  ----
    Escaping: (! & < > !).
    Whitespace stripping: {(!      yes      !)}.
    Enough exclamation marks: (!!! (!! (! never !) !!) !!!).
  ----

====


###display-code
  Display code
###

{^^
  {{ (!``!) }}[.id.] [.class.]\newline {.content.} {{ (!``!) }}
^^}

----
Display code
{^
  (! <pre !)
    id="[.id.]" class="[.class.]"(! > !)\
      (! <code> !)\
        {.content.}\
      (! </code> !)\
  (! </pre> !)
^},
with HTML syntax-character escaping
and de-indentation for {^ {.content.} ^}.
For {^ {.content.} ^} containing two or more consecutive backticks,
use a greater number of {{backticks}} in the delimiters.
----

====
* CMD
  `````` cmd
  (!!!!
    ``id-0 class-1 class-2
        Escaping: & < >.
        Note that CMD literals have higher precedence,
        since they are processed first: (!! (! literally !) !!).
            Uniform
            de-indentation:
            yes.
    ``
    ````
      ``
      Use more backticks as required.
      If [id] and [class] are omitted,
      no corresponding attributes are generated.
      ``
    ````
  !!!!)
  ``````

* HTML
  `````` html
  (!!!!
    <pre id="id-0" class="class-1 class-2"><code>Escaping: &amp; &lt; &gt;.
    Note that CMD literals have higher precedence,
    since they are processed first: (! literally !).
        Uniform
        de-indentation:
        yes.
    </code></pre>
    <pre><code>``
    Use more backticks as required.
    If [id] and [class] are omitted,
    no corresponding attributes are generated.
    ``
    </code></pre>
  !!!!)
  ``````

* Rendered
    ``id-0 class-1 class-2
        Escaping: & < >.
        Note that CMD literals have higher precedence,
        since they are processed first: (!! (! literally !) !!).
            Uniform
            de-indentation:
            yes.
    ``
    ````
      ``
      Use more backticks as required.
      If [id] and [class] are omitted,
      no corresponding attributes are generated.
      ``
    ````

====


###inline-code
  Inline code
###

{^^
  {{ (!`!) }} {.content.} {{ (!`!) }}
^^}

----
Inline code
{^
  (! <code> !)\
    {.content.}\
  (! </code> !)
^},
with HTML syntax-character escaping
and de-indentation for {^ {.content.} ^}.
Whitespace around {^ {.content.} ^} is stripped.
For {^ {.content.} ^} containing one or more consecutive backticks
which are not already protected by [CMD literals](#cmd-literals),
use a greater number of {{backticks}} in the delimiters.
----

====
* CMD
  ```` cmd
    `` The escaped form of & is &amp;. ``
  ````

* HTML
  ```` html
    <code>The escaped form of &amp; is &amp;amp;.</code>
  ````

* Rendered
  ----
    `` The escaped form of & is &amp;. ``
  ----

====


###comments
  Comments
###

{^^
  (! <!-- !) {.comment.} (! --> !)
^^}

----
Removed, along with any preceding horizontal whitespace.
Although comments are weaker than literals and code
they may still be used to remove them.
For instance ` (!! (! A <!-- B --> !) !!) ` becomes ` A <!-- B --> `,
whereas ` (!! <!-- A (! B !) --> !!) ` is removed entirely.
----

%footer-element


@@[cmd-github]
  https://github.com/conway-markdown/conway-markdown/
  GitHub: Conway's markdown
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

@@[markdown]
  https://daringfireball.net/projects/markdown/
  Daring Fireball: Markdown
@@
