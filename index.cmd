%%%%

%author Conway
%title Conway's markdown (CMD)
%date-created 2020-04-05
%date-modified 2020-04-12
%resources
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/cmd.css">
  <link rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.css">
  <script defer
    src="https://cdn.jsdelivr.net/npm/katex@0.11.1/dist/katex.min.js">
    </script>
  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
  <link rel="manifest" href="/site.webmanifest">
  <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#7000ff">
  <meta name="msapplication-TileColor" content="#00aba9">
  <meta name="theme-color" content="#ffffff">
%onload-js
  let elements = document.getElementsByClassName("js-maths");
  for (let i = 0; i < elements.length; i++) {
    let element = elements[i]
    katex.render(
      element.textContent,
      element,
      {displayMode: element.tagName == "DIV"}
    );
  }

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

<!-- [.Optional.] -->
{: [. : <span class="optional-argument">[ :}
{: .] : ]</span> :}

<!-- Heading self-link anchors (<h2> to <h6>) -->
{%
  ^ [^\S\n]*
  (?P<hashes> [#]{2,6} (?![#]) )
    (?P<id_> [\S]*? )
  [\s]+
    (?P<content> [\s\S]*? )
  (?P=hashes)
%
  \g<hashes>\g<id_>
    [][self-link:\g<id_>]\\
    \g<content>
  \g<hashes>
  @@[self-link:\g<id_>][self-link]
    \\#\g<id_>
  @@
%}

<!-- U+21B5 DOWNWARDS ARROW WITH CORNER LEFTWARDS -->
{: \newline : ↵ :}

<!-- U+E000 PRIVATE USE AREA -->
{: \e000 :  :}

# %title #


||||[page-properties]
  First created: %date-created \\
  Last modified: %date-modified
||||

====
* This page's source CMD: [`index.cmd`][source-cmd]
* This page's output HTML: [`index.html`][output-html]
* GitHub repositories:
    [`conway-markdown`][cmd-repo],
    [`conway-markdown.github.io`][cmd-docs-repo]
====


----
Conway's fence-style markdown,
implemented in Python using regex replacements.
----

----
Conway's markdown (CMD) is the result of someone joking that
"the filenames would look like Windows executables from the 90s".
Inspired by the backticks of John Gruber's [markdown],
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
with some dictionaries for temporary storage of strings,
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
Produces {^ {.content.} ^} literally,
with HTML syntax-character escaping and de-indentation.
Whitespace around {^ {.content.} ^} is stripped.
For {^ {.content.} ^} containing one or more consecutive exclamation marks
followed by a closing round bracket,
use a greater number of {{exclamation marks}} in the delimiters.
----

====
* CMD
  ````[cmd]
  (!!!!
    Escaping: (! & < > !).
    Whitespace stripping: {(!      yes      !)}.
    Enough exclamation marks: (!!! (!! (! never !) !!) !!!).
  !!!!)
  ````

* HTML
  ````[html]
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

----
CMD literals are very powerful.
For example, `id` and `class` in CMD block syntax
are specified in the form {^ [.id.][[.class.]] ^}.
Now, if for whatever reason you want an `id`
with square brackets, e.g.~`[dumb-id]`,
then wrapping it inside a CMD literal will prevent it
from being interpreted as the class `dumb-id`:
----

====
* CMD
  ````[cmd]
  (!!
    ``[dumb-id]
      Whoops!
    ``
    ``(! [dumb-id] !)
      That's better.
    ``
  !!)
  ````

* HTML
  ````[html]
    <pre class="dumb-id"><code>Whoops!
    </code></pre>
    <pre id="[dumb-id]"><code>That's better.
    </code></pre>
  ````

====



###display-code
  Display code
###

{^^
  {{ (!``!) }}[.id.][[.class.]]\newline {.content.} {{ (!``!) }}
^^}

----
The delimiting backticks must be
the first non-whitespace characters on their lines.
If {^ [.class.] ^} is empty, the square brackets surrounding it may be omitted.
----

----
Produces the display code
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
  ``````[cmd]
  (!!!!
    ``id-0[class-1 class-2]
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
  ``````[html]
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
    ``id-0[class-1 class-2]
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
Produces the inline code
{^
  (! <code> !)\
    {.content.}\
  (! </code> !)
^},
with HTML syntax-character escaping
and de-indentation for {^ {.content.} ^}.
Whitespace around {^ {.content.} ^} is stripped.
For {^ {.content.} ^} containing one or more consecutive backticks
which are not already protected by [CMD literals],
use a greater number of {{backticks}} in the delimiters.
----

====
* CMD
  ````[cmd]
    `` The escaped form of & is &amp;. Here is a tilde: `. ``
  ````

* HTML
  ````[html]
    <code>The escaped form of &amp; is &amp;amp;. Here is a tilde: `.</code>
  ````

* Rendered
  ----
    `` The escaped form of & is &amp;. Here is a tilde: `. ``
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
In this sense they are stronger than literals and code.
----



###display-maths
  Display maths
###

{^^
  {{ (!$$!) }}[.id.][[.class.]]\newline {.content.} {{ (!$$!) }}
^^}

----
The delimiting dollar signs must be
the first non-whitespace characters on their lines.
If {^ [.class.] ^} is empty, the square brackets surrounding it may be omitted.
----

----
Produces
{^
  (! <div !)
    id="[.id.]" class="js-maths [.class.]"(! > !)\
      {.content.}\
  (! </div> !)
^},
with HTML syntax-character escaping
and de-indentation for {^ {.content.} ^}.
For {^ {.content.} ^} containing two or more consecutive dollar signs
which are not already protected by [CMD literals],
use a greater number of {{dollar signs}} in the delimiters.
----

----
This is to be used with some sort of JavaScript code
which renders equations based on the class `js-maths`.
Here I am using [KaTeX].
----

====
* CMD
  ````[cmd]
    $$
      1 + \frac{1}{2^2} + \frac{1}{3^2} + \dots
      = \frac{\pi^2}{6}
      < 2
    $$
  ````

* HTML
  ````[html]
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


###inline-maths
  Inline maths
###

{^^
  {{ (!$!) }} {.content.} {{ (!$!) }}
^^}

----
Produces
{^
  (! <span class="js-maths"> !)\
    {.content.}\
  (! </span> !)
^},
with HTML syntax-character escaping for {^ {.content.} ^}.
Whitespace around {^ {.content.} ^} is stripped.
For {^ {.content.} ^} containing one or more consecutive dollar signs
which are not already protected by [CMD literals],
use a greater number of {{dollar signs}} in the delimiters.
----

----
This is to be used with some sort of JavaScript code
which renders equations based on the class `js-maths`.
Here I am using [KaTeX].
----

====
* CMD
  ````[cmd]
    A contrived instance of multiple dollar signs in inline maths:
    $$$ \text{Yea, \$$d$ means $d$~dollars.} $$$
  ````

* HTML
  ````[html]
    A contrived instance of multiple dollar signs in inline maths:
    <span class="js-maths">\text{Yea, \$$d$ means $d$~dollars.}</span>
  ````

* Rendered
  ----
    A contrived instance of multiple dollar signs in inline maths:
    $$$ \text{Yea, \$$d$ means $d$~dollars.} $$$
  ----

====


###inclusions
  Inclusions
###

{^^
  ({{ (!+!) }} {.(! file_name !).} {{ (!+!) }})
^^}

----
Includes the content of the file {^ {.(! file_name !).} ^}.
For {^ {.(! file_name !).} ^} containing one or more consecutive plus signs
followed by a closing round bracket,
use a greater number of {{plus signs}} in the delimiters.
----

----
All of the syntax above (CMD literals through to inline maths) is processed.
Unlike nested `\input` in LaTeX, nested inclusions are not processed.
----

====
* CMD
  ````[cmd]
    (+ inclusion.txt +)
  ````

* HTML
  ````[html]
  This is content from <a href="/inclusion.txt"><code>inclusion.txt</code></a>.
  Nested inclusions are not processed,
  so there is no need to worry about recursion errors: (+ inclusion.txt +)
  ````

* Rendered
  ----
    (+ inclusion.txt +)
  ----

====


###regex-replacements
  Regex replacements
###

{^^
  (!{!){{ (!%!) }} {.pattern.} {{ (!%!) }} {.replacement.} {{ (!%!) }}(!}!)
^^}

----
Processes regex replacements of {^ {.pattern.} ^} by {^ {.replacement.} ^}
in Python syntax with the flags `re.MULTILINE` and `re.VERBOSE` enabled.
Whitespace around {^ {.pattern.} ^} and {^ {.replacement.} ^} is stripped.
For {^ {.pattern.} ^} or {^ {.replacement.} ^} containing
one or more consecutive percent signs,
use a greater number of {{percent signs}} in the delimiters.
For {^ {.pattern.} ^} matching any of the syntax above,
which should not be processed using that syntax, use CMD literals.
----

----
All regex replacement specifications are read and stored
before being applied in order.
If the same pattern is specified more than once,
the latest specification shall prevail.
----

----
As an example, the following regex replacement is used
to automatically insert the self-link anchors
before the section headings (`<h2>` to `<h6>`) in this page:
----
````[cmd]
  {%
    ^ [^\S\n]*
    (?P<hashes> [#]{2,6} (?![#]) )
      (?P<id_> [\S]*? )
    [\s]+
      (?P<content> [\s\S]*? )
    (?P=hashes)
  %
    \g<hashes>\g<id_>
      [][self-link:\g<id_>]\\
      \g<content>
    \g<hashes>
    @@[self-link:\g<id_>][self-link]
      \\#\g<id_>
    @@
  %}
````

----
**Warning:** malicious or careless user-defined regex replacements
will break the normal CMD syntax.
To avoid breaking placeholder storage
(used to protect portions of the markup from further processing),
do not use replacements to alter placeholder strings,
which are of the form {^ \e000{.n.}\e000 ^},
where {^ \e000 ^} is the placeholder marker `U+E000` (Private Use Area)
and {^ {.n.} ^} is an integer.
To avoid breaking properties,
do not use replacements to alter property strings,
which are of the form {^ %{.property name.} ^}.
----


###ordinary-replacements
  Ordinary replacements
###

{^^
  (!{!){{ (!:!) }} {.pattern.} {{ (!:!) }} {.replacement.} {{ (!:!) }}(!}!)
^^}

----
Processes ordinary replacements of {^ {.pattern.} ^} by {^ {.replacement.} ^}.
Whitespace around {^ {.pattern.} ^} and {^ {.replacement.} ^} is stripped.
For {^ {.pattern.} ^} or {^ {.replacement.} ^} containing
one or more consecutive colons,
use a greater number of {{colons}} in the delimiters.
----

----
All ordinary replacement specifications are read and stored
before being applied in order.
If the same pattern is specified more than once,
the latest specification shall prevail.
----

====
* CMD
  ````[cmd]
    {: |hup-hup| : Huzzah! :}
    |hup-hup| \\
    
    {: \def1 : Earlier specifications lose. :}
    {: \def1 : Later specifications win. :}
    \def1 \\
    
    \def2 \\
    {: \def2 : Specifications can be given anywhere. :}
    
    {: <out> : Nesting will work provided the <in> is given later. :}
    {: <in> : inner specification :}
    <out>
  ````

* Rendered
  ----
    {: |hup-hup| : Huzzah! :}
    |hup-hup| \\
    
    {: \def1 : Earlier specifications lose. :}
    {: \def1 : Later specifications win. :}
    \def1 \\
    
    \def2 \\
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
which are of the form {^ \e000{.n.}\e000 ^},
where {^ \e000 ^} is the placeholder marker `U+E000` (Private Use Area)
and {^ {.n.} ^} is an integer.
To avoid breaking properties,
do not use replacements to alter property strings,
which are of the form {^ %{.property name.} ^}.
----


###preamble
  Preamble
###

{^^
  {{ (!%%!) }}\newline {.content.} {{ (!%%!) }}
^^}

----
The delimiting percent signs must be
the first non-whitespace characters on their lines.
----

----
Processes the preamble, whose {^ {.content.} ^} is to consist of
property specifications of the form
{^ %{.property name.} {.property markup.} ^},
which are stored and may be referenced by writing {^ %{.property name.} ^},
called a property string, anywhere else in the document.
{^ {.property name.} ^} may only contain letters, digits, and hyphens.
If the same property is specified more than once,
the latest specification shall prevail.
----

----
This produces the HTML preamble,
i.e.~everything from `<!DOCTYPE html>` through to `<body>`.
----

----
For {^ {.property markup.} ^} matching a {^ {.property name.} ^} pattern,
use a CMD literal, e.g. `(!! (! a literal %propety-name !) !!)`.
For {^ {.content.} ^} containing two or more consecutive percent signs
which are not already protected by CMD literals,
use a greater number of {{percent signs}} in the delimiters.
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
````[cmd]
  %lang en
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
````[cmd]
  %html-lang-attribute
  %meta-element-author
  %meta-element-description
  %title-element
  %style-element
  %body-onload-attribute
  %year-created
  %year-modified
  %year-modified-next
  %footer-element
  %url
````

####preamble-1 Example 1: a minimal HTML file ####

====
* CMD
  ````[cmd]
    %%
    %%
  ````

* HTML
  ````[html]
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <meta charset="utf-8">
    <title>Title</title>
    </head>
    <body>
    </body>
    </html>
  ````

====

####preamble-2 Example 2: a not-so-minimal HTML file ####

====
* CMD
  ````[cmd]
    %%
      %lang en-AU
      %title My title
      %title-suffix \ | My site
      %author Me
      %date-created 2020-04-11
      %date-modified 2020-04-11
      %description
        This is the description. Hooray for automatic escaping (&, <, >, ")!
      %css
        #special {
          color: purple;
        }
      %onload-js
        special.textContent += ' This is a special paragraph!'
    %%
    
    # %title #
    
    ----special
      The title of this page is "%title", and the author is %author.
      At the time of writing, next year will be %year-modified-next.
    ----

    %footer-element
  ````

* HTML
  ````[html]
    <!DOCTYPE html>
    <html lang="en-AU">
    <head>
    <meta charset="utf-8">
    <meta name="author" content="Me">
    <meta name="description" content="This is the description. Hooray for automatic escaping (&amp;, &lt;, &gt;, &quot;)!">
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
    <hr>
    ©&nbsp;2020&nbsp;Me.
    </footer>
    </body>
    </html>
  ````

====


###headings
  Headings
###

{^^
  \#[.id.] {.content.} \#
^^}

----
Produces the heading
{^
  (! <h1 !)
    id="[.id.]"(! > !)\
      {.content.}\
  (! </h1> !)
^}.
Whitespace around {^ {.content.} ^} is stripped.
For `<h2>` to `<h6>`, use 2 to 6 delimiting hashes respectively.
For {^ {.content.} ^} containing the delimiting number of
or more consecutive hashes, use [CMD literals].
----

====
* CMD
  ````[cmd]
    ###some-id Heading with id ###
    #### Heading without id ####
  ````

* HTML
  ````[html]
    <h3 id="some-id">Heading with id</h3>
    <h4>Heading without id</h4>
  ````

====


###blocks
  Blocks
###

{^^
  {{ cccc }}[.id.][[.class.]]\newline {.content.} {{ cccc }}
^^}

----
The delimiting characters (`c`) must be
the first non-whitespace characters on their lines.
If {^ [.class.] ^} is empty, the square brackets surrounding it may be omitted.
----

----
Produces the block
{^
  \<{.tag name.}
    id="[.id.]" class="[.class.]"\>\newline\
      {.content.}\
  \</{.tag name.}\>
^}.
For {^ {.content.} ^} containing four or more
consecutive delimiting characters
which are not already protected by [CMD literals],
use a greater number of {{delimiting characters}} in the delimiters.
----

----
The following delimiting characters (`c`) are used:
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

####list-items
  List items
####

----
For list blocks, {^ {.content.} ^} is split into list items `<li>`
according to leading occurrences
(i.e. occurrences preceded only by whitespace on their lines)
of the following:
----

{^^ Y[.id.][[.class.]] ^^}

----
The following delimiters (`Y`) for list items are used:
----
====
* `*`
* `1.` (or any run of digits followed by a full stop)
====
----
If {^ [.class.] ^} is empty,
the square brackets surrounding it may be omitted.
----

####blocks-1 Example 1: nesting ####

================
* CMD
  ````[cmd]
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
      * Asterisk `<li>` markers can be used for `<ol>`.
      2.  An easy way to remember the list delimiters is that
          unordered list items stay constant (`=`) while
          ordered list items increment (`+`).
      ++++
    0. Numbered `<li>` markers can be used for `<ul>`
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
      * Asterisk `<li>` markers can be used for `<ol>`.
      2.  An easy way to remember the list delimiters is that
          unordered list items stay constant (`=`) while
          ordered list items increment (`+`).
      ++++
    0. Numbered `<li>` markers can be used for `<ul>`
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

####blocks-2 Example 2: `id` and `class` ####

================
* CMD
  ````[cmd]
    ----p-id[p-class]
    Paragraph with `id` and `class`.
    ----
    ======
    *li-id List item with `id` and no `class`.
    0.[li-class] List item with `class` and no `id`.
    1.[li-class]
      Put arbitrary whitespace after the class for more clarity.
    ======
  ````

* HTML
  ````[html]
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


%footer-element

@@[CMD literals]
  #cmd-literals
@@


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
