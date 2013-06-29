define ['jquery', 'underscore', 'backbone', 'client'], ($, _, Backbone, client) ->
    {client} = client

    File = Backbone.Model.extend
        defaults:
            name: ''

    FileList = Backbone.Collection.extend
        model: File

    Modal = Backbone.View.extend
        id: 'modal'
        events:
            'click .close': 'close'

        template: _.template(JST.modal)

        initialize: ->
            # @listenTo @model, 'change', @render
            # client.readdir '/', (error, entries) =>
            #     if error
            #         console.log error
            #         return

            #     @entries = entries

        close: ->
            @$el.fadeOut('fast')

        render: ->
            @$el.html @template entries: @model.toJSON()
            this

    {Modal, File, FileList}

