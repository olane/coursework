requirejs.config

    paths:
        highlight: 'res/highlight/build/highlight.pack'
        jquery: 'res/jquery'
        backbone: 'res/backbone'
        marked: 'res/marked'
        dropbox: 'res/dropbox'
        underscore: 'res/underscore'

        modal: 'js/modal'
        client: 'js/client'
        toolbar: 'js/toolbar'
        editor: 'js/editor'

    shim:
        dropbox:
            exports: 'Dropbox'

        jquery:
            exports: '$'

        underscore:
            exports: '_'

        backbone:
            exports: 'Backbone'
            deps: ['jquery', 'underscore']

deps = [
    'jquery', 'backbone', 'marked', 'highlight', 'dropbox',
    'modal', 'client', 'toolbar', 'editor'
]

require deps, ($, Backbone, marked, hl, Dropbox, modal, client, Toolbar, editor) ->
    {Modal, File, FileList} = modal
    {client, auth} = client
    {editor, update} = editor

    # Object to store cached DOM elements
    window.dom = {}

    (($) ->
        $.fn.centre = ->
            this.css(left: (dom.window.width() - this.width()) / 2)
            this
    )(jQuery)

    # Display a message to the user.
    window.alert = (text) ->
        dom.message
            .text(text).centre().fadeIn('fast').delay(2000).fadeOut('slow')

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

    $(document).ready ->
        list = new FileList [{name: 'test'}]

        modal = new Modal(model: list)
        modal.$el.appendTo('body')
        modal.render()

        toolbar = new Toolbar()
        toolbar.$el.appendTo('header > .right')
        toolbar.render()




        # Cache references to some DOM elements
        for s in [
            'viewer',
            'dropbox', 'open', 'save',
            'message', 'modal', 'save-message',
            'filename'
        ]
            dom[s.replace('-', '_')] = $ '#' + s
        dom.window = $ window
        dom.shade = $ '.shade'

        # Load the sample document and insert it into the editor
        $.get 'sample.md', (text) -> editor.setValue text

        # Generate the initial document preview
        update()
