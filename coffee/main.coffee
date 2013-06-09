requirejs.config
    baseUrl: 'res'

    paths:
        highlight: 'highlight/build/highlight.pack'

    shim:
        dropbox:
            exports: 'Dropbox'

require ['jquery', 'marked', 'highlight', 'dropbox'],
($, marked, hl, Dropbox) ->
    # Setup Ace Editor
    editor = ace.edit 'editor'
    editor.setTheme 'ace/theme/monokai'
    editor.getSession().setMode 'ace/mode/markdown'

    # Object to store cached DOM elements
    dom = {}

    # Display a message to the user.
    alert = (text) ->
        dom.message
            .text(text)
            .css(left: (dom.window.width() - dom.message.width()) / 2)
            .fadeIn('fast').delay(2000).fadeOut('slow')

    auth = ->
        if client.isAuthenticated()
            alert 'Already connected to Dropbox.'
            return

        client.authDriver new Dropbox.Drivers.Redirect rememberUser: yes

        client.authenticate (error, authed_client) ->
            if error
                alert "Error: could not connect to Dropbox."
                console.log error
                return

            authed_client.getUserInfo (error, info) ->
                console.log info.name

    client = client = new Dropbox.Client
        key: 'bU8mb6wQpnA=|yAAb6C7Ke3/ROsEP06RqVJrxDez/09agnys6gI10Ag=='
        sandbox: yes

    # If a token from a previous session is saved in localStorage, the client
    # can be silently and automatically authenticated.
    for key of localStorage
        if key.indexOf('dropbox-auth') isnt -1
            auth()
            break

    # Save the current document to Dropbox.
    save = ->
        if not client?
            alert 'Please connect to Dropbox to save documents.'
            return

        filename = dom.filename.val()

        if not filename
            alert 'Please name this document before saving.'
            return

        filename += '.md'

        client.writeFile filename, editor.getValue(), (error, stat) ->
            if error
                alert 'Error: could not save file.'
                console.log error
                return

            alert "File saved as #{filename}."


    # Set options for Markdown rendering
    marked.setOptions
        # Enable SmartyPants for nice quotes and dashes
        smartypants: on
        # Enable the GFM line break behaviour
        breaks: on
        # Ignore inline HTML -- it's not needed for writing prose and <script>
        # tags break things
        sanitize: yes
        # Enable smarter list behaviour
        smartLists: yes
        # Add the callback for syntax highlighting
        highlight: (code, lang) ->
            hl.highlightAuto(code).value

    # Format ordered lists to use numbers for the top level, letters for the
    # second and Roman numerals for the third.
    formatLists = ->
        # Get all the ordered lists in the viewer
        dom.viewer.find('ol').each ->
            t = $ this
            # Find out how many levels of parent lists there are above this one
            level = t.parents().filter('ol, ul').length
            # Assign their type based on this
            type = switch level % 3
                when 0 then '1'
                when 1 then 'a'
                when 2 then 'i'

            t.attr(type: type)

    # Callback for when the document changes
    update = (delta) ->
        # Re-render Markdown and update viewer
        dom.viewer.html marked editor.getValue()
        # Format ordered lists
        formatLists()
        # Re-render equations
        MathJax.Hub.Queue ['Typeset', MathJax.Hub, 'viewer']

    editor.on 'change', update

    $(document).ready ->
        # Cache references to some DOM elements
        for s in ['viewer', 'dropbox', 'save', 'message', 'filename']
            dom[s] = $ '#' + s
        dom.window = $ window

        # Load the sample document and insert it into the editor
        $.get 'sample.md', (text) -> editor.setValue text

        # Bind event handlers
        dom.dropbox.on 'click', auth
        dom.save.on 'click', save

        # Generate the initial document preview
        update()
