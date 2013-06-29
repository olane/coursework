define(['backbone', 'modal'], (Backbone, modal) ->
    {Modal} = modal

    SettingsPanel = Backbone.View.extend

        template: _.template(JST.settings)

    SettingsView = Modal.extend()


    SettingsView
)
