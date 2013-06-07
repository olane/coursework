# Coursework

## What is this?

Coursework is a text editor for writing technical documents, using Markdown for simple markup, and LaTeX for typesetting mathematical equations.

## What does it do?

It basically just ties together [Ace Editor][], [Marked][] and [MathJax][] and adds a couple of buttons.

Type code in the editor on the left, see results in realtime in the viewer on the right. Try [the demo][] to see how it works. If you want to save files you'll need to install it locally.

## How do I get it?

### Download a build

Coming soon

### Build from scratch

Assuming you have Git and Node and are using some sort of Unix:

    # Install Grunt for building and Volo for package managing
    [sudo] npm install -g grunt-cli volo

    # Get the code
    git clone https://github.com/lavelle/coursework.git
    cd coursework

    npm install      # Install build tools
    volo install     # Install libraries
    grunt            # Build the project
    open index.html  # Use it

## Why did you make it?

I wanted to move to an all-digital solution for taking notes in lectures. I have to write lots of equations down, so I needed something for typesetting maths, but I also wanted a clean syntax for regular markup. LaTeX and Markdown fill these roles respectively, but I couldn't find anything that let you use both, and had a realtime preview.

Written using CoffeeScript and Sass for bonus hipster points.

## Credits
- [Ace editor][]
- [MathJax][]
- [Marked][]
- [Highlight.js][]
- [Dropbox.js][]
- [jQuery][]

[the demo]: https://lavelle.github.io/coursework

[ace editor]: http://ace.ajax.org/
[marked]: https://github.com/chjj/marked
[mathjax]: http://www.mathjax.org/
[highlight.js]: https://github.com/isagalaev/highlight.js
[dropbox.js]: https://github.com/dropbox/dropbox-js
[jquery]: http://jquery.com/

## License

MIT
