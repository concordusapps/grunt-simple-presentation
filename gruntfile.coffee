'use strict'

module.exports = (grunt) ->

  # Options
  # =======

  # Port offset
  # -----------
  # Increment this for additional gruntfiles that you want
  # to run simultaneously.
  portOffset = 0

  # Host
  # ----
  # You could set this to your IP address to expose it over a local internet.
  hostname = 'localhost'

  # Configuration
  # =============
  grunt.initConfig

    # Clean
    # -----
    # Configure 'grunt-contrib-clean' to remove all built and temporary
    # files.
    clean:
      all: [
        'temp'
      ]

    # Copy
    # ----
    # Ensure files go where they need to. Used for static files.
    copy:
      static:
        files: [
          expand: true
          filter: 'isFile'
          cwd: 'src'
          dest: 'temp'
          src: [
            '**/*'
          ]
        ]

    # Webserver
    # ---------
    connect:
      options:
        port: 5000 + portOffset
        hostname: hostname
        middleware: (connect, options) -> [
          require('connect-livereload')()
          connect.static options.base
        ]

      build:
        options:
          keepalive: true
          base: 'build'

      temp:
        options:
          base: 'temp'

    # Watch
    # -----
    watch:
      static:
        files: ['src/**/*']
        tasks: ['copy:static']

      livereload:
        options: {livereload: true}
        files: ['temp/**/*']

  # Dependencies
  # ============
  # Loads all grunt tasks from the installed NPM modules.
  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  # Tasks
  # =====

  # Default
  # -------
  # By default, the invocation 'grunt' should build and expose the
  # presentation at a default host/port.
  grunt.registerTask 'default', [
    'clean'
    'server'
  ]

  # Server
  # ------
  grunt.registerTask 'server', [
    'copy:static'
    'connect:temp'
    'watch'
  ]
