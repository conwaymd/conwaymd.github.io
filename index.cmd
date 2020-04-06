%%%%

%author Conway
%title Conway's markdown
%date-created 2020-04-05
%date-modified 2020-04-06
%resources
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="cmd.css">

%%%%


{% \{ \^\^ [\s]* % <pre class="cmd syntax"><code> %}
{% [\s]* \^\^ \} % </code></pre> %}

{% \{ \^ [\s]* % <code> %}
{% [\s]* \^ \} % </code> %}

{% {{ [\s]* % <span class="repeatable-delimiter"> %}
{% [\s]* }} % </span> %}

{: {. : <span class="mandatory-argument">{ :}
{: .} : }</span> :}


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


////

Conway's fence-style markdown,
implemented in Python using regex replacements.

////


////

Conway's markdown (CMD) is the result of someone joking that
"the filenames would look like Windows executables from the 90s".
Inspired by the backticks of John Gruber's [markdown][],
Conway's markdown uses fence-style constructs
for which a delimiter symbol may be {{arbitrarily repeated}}
in order to wrap shorter runs of that symbol.

////


##usage
  Usage
##

////
Convert a CMD file to HTML, outputting to `cmd_name.html`:
////

````
$ python cmd.py [cmd_name[.[cmd]]]
````

////
Omit `[cmd_name[.[cmd]]]` to convert all CMD files
in the current directory (at all levels),
except those listed in `.cmdignore`.
////


##literals
  CMD literals
##

{^^
  ({{!}} {.content.} {{!}})
^^}

////

Literal {^ {.content.} ^},
with HTML syntax-character escaping and de-indentation.
Whitespace around {^ {.content.} ^} is stripped.
For {^ {.content.} ^} containing one or more consecutive exclamation marks
followed by a closing round bracket,
use a greater number of exclamation marks in the delimiters.

////

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
  ////
    Escaping: (! & < > !).
    Whitespace stripping: {(!      yes      !)}.
    Enough exclamation marks: (!!! (!! (! never !) !!) !!!).
  ////


====


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
