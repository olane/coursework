sample = """
# A title

1. The first
2. The second
3. The third

A link to [somewhere](http://example.com)
Some *italic* and **bold** text.

Header 1 | Header 2
---------|---------
An item  | Another

```javascript
var x = 1;
```

A good approximation for $\\pi$ is $22 \\over 7$.
An even better approximation for $\\phi$ is ${1 + \\sqrt{5}} \\over 2$.
"""

requirejs.config
    baseUrl: 'js'

    paths:
        highlight: 'highlight/build/highlight.pack'

    shim:
        dropbox:
            exports: 'Dropbox'

requirejs ['jquery', 'marked', 'highlight', 'dropbox'], ($, marked, hl, Dropbox) ->
    # Setup Ace editor
    editor = ace.edit 'editor'
    editor.setTheme 'ace/theme/monokai'
    editor.getSession().setMode 'ace/mode/markdown'

    # Get a reference to the viewer element
    viewer = $ '#viewer'

    client = new Dropbox.Client
        key: 'bU8mb6wQpnA=|yAAb6C7Ke3/ROsEP06RqVJrxDez/09agnys6gI10Ag=='
        sandbox: yes

    client.authDriver new Dropbox.Drivers.Redirect()

    client.authenticate (error, client) ->
        if error
            console.log error
            return

        client.getUserInfo (error, info) ->
            console.log info.name

    # Set options for Markdown rendering
    marked.setOptions
        # Enable SmartyPants for nice quotes and dashes
        smartypants: on
        # Enable the GFM line break behaviour
        breaks: on
        # Add the callback for syntax highlighting
        highlight: (code, lang) ->
            hl.highlightAuto(code).value

    # Callback for when the document changes
    update = (delta) ->
        # Re-render Markdown and update viewer
        viewer.html marked editor.getValue()
        # Re-render equations
        MathJax.Hub.Queue ['Typeset', MathJax.Hub, 'viewer']

    editor.on 'change', update

    $(document).ready ->
        editor.setValue sample
        update()
