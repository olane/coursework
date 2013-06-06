module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        uglify:
            options:
                banner: '/*! <%= pkg.name %> <%= grunt.template.today("dd-mm-yyyy") %> */\n'
        coffee:
            compile:
                files:
                    'js/main.js': 'coffee/main.coffee'
        sass:
            dist:
                files:
                    'css/style.css': 'sass/style.sass'


    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-concat'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-sass'

    grunt.registerTask 'default', ['sass', 'coffee']
