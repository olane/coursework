requirejs.config
    baseUrl: 'res'

    paths:
        highlight: 'highlight/build/highlight.pack'

    shim:
        dropbox:
            exports: 'Dropbox'

require ['jquery', 'marked', 'highlight', 'dropbox'],
($, marked, hl, Dropbox) ->
    # Setup Ace editor
    editor = ace.edit 'editor'
    editor.setTheme 'ace/theme/monokai'
    editor.getSession().setMode 'ace/mode/markdown'

    # Get some DOM
    dom = {}

    alert = (text) ->
        dom.message
            .text(text)
            .css(left: (dom.window.width() - dom.message.width()) / 2)
            .fadeIn('fast').delay(2000).fadeOut('slow')

    client = null

    auth = ->
        client = new Dropbox.Client
            key: 'bU8mb6wQpnA=|yAAb6C7Ke3/ROsEP06RqVJrxDez/09agnys6gI10Ag=='
            sandbox: yes

        client.authDriver new Dropbox.Drivers.Redirect rememberUser: yes

        client.authenticate (error, authed_client) ->
            if error
                console.log error
                return

            authed_client.getUserInfo (error, info) ->
                console.log info.name

    save = ->
        if not client?
            alert 'Please connect to Dropbox to save documents.'
            return

        filename = dom.filename.val()

        if not filename
            alert 'Please name this document before saving.'
            return

        client.writeFile "#{filename}.md", editor.getValue(), (error, stat) ->
            if error
                console.log error
                return

            console.log 'File saved'


    # Set options for Markdown rendering
    marked.setOptions
        # Enable SmartyPants for nice quotes and dashes
        smartypants: on
        # Enable the GFM line break behaviour
        breaks: on
        # Ignore inline HTML -- it's not needed for writing prose and <script>
        # tags break things
        sanitize: yes
        # Add the callback for syntax highlighting
        highlight: (code, lang) ->
            hl.highlightAuto(code).value

    # Callback for when the document changes
    update = (delta) ->
        # Re-render Markdown and update viewer
        dom.viewer.html marked editor.getValue()
        # Re-render equations
        MathJax.Hub.Queue ['Typeset', MathJax.Hub, 'viewer']

    editor.on 'change', update

    $(document).ready ->
        for s in ['viewer', 'dropbox', 'save', 'message', 'filename']
            dom[s] = $ '#' + s
        dom.window = $ window

        $.get 'sample.md', (text)->
            editor.setValue text

        dom.dropbox.on 'click', auth
        dom.save.on 'click', save

        update()
