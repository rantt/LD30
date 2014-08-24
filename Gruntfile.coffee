module.exports = (grunt) ->

  @initConfig
    PKG: @file.readJSON 'package.json'
    APP_NAME: '<%= PKG.name %>'
    SRC_DIR: 'src'
    DST_DIR: 'dist'
    DST_FILE:  '<%= DST_DIR %>/main'
    INDEX_FILE: 'index.html.db5'

    # For the moment grab latest phaser build
    # from GH, later on phaser might have Bower support
    'curl-dir':
      '<%= SRC_DIR %>/js/lib/': [
        'https://raw.github.com/photonstorm/phaser/master/build/phaser.min.js',
      ]


    clean:
      options:
        force: true
      dist: ['<%= DST_DIR %>']

    copy:
      atlas:
        files: [
          expand: true
          flatten: false
          cwd: '<%= SRC_DIR %>/assets/atlas/'
          src: ['**']
          dest: '<%= DST_DIR %>/assets/atlas/'
        ]
      font:
        files: [
          expand: true
          flatten: false
          cwd: '<%= SRC_DIR %>/assets/fonts/'
          src: ['**']
          dest: '<%= DST_DIR %>/assets/fonts/'
        ]
      audio:
        files: [
          expand: true
          flatten: false
          cwd: '<%= SRC_DIR %>/assets/audio/'
          src: ['**']
          dest: '<%= DST_DIR %>/assets/audio/'
        ]
      index:
        files: [
          src: ['<%= SRC_DIR %>/<%= INDEX_FILE %>]']
          expand: false
          flatten: true
          dest: '<%= DST_DIR %>/<%= INDEX_FILE %>'

        ]

    jshint:
      app:
        options:
          force: true
          jshintrc: '.jshintrc'
          ignores: ['<%= SRC_DIR %>/js/lib/**/*.js']
        src: ['<%= SRC_DIR %>/js/lib/phaser.min.js','<%= SRC_DIR %>/js/load.js','<%= SRC_DIR %>/js/menu.js','<%= SRC_DIR %>/js/play.js','<%= SRC_DIR %>/js/game.js']


    uglify:
      dist:
        files:
          '<%= DST_FILE %>.min.js': ['<%= SRC_DIR %>/js/lib/phaser.min.js','<%= SRC_DIR %>/js/load.js','<%= SRC_DIR %>/js/menu.js','<%= SRC_DIR %>/js/play.js','<%= SRC_DIR %>/js/game.js']

      options:
        banner: '/*! <%= PKG.name %> v<%= PKG.version %> */\n'

    jsonmin:
      stripAll:
        options:
          stripWhitespace: true
          stripComments: true

        files:
          '<%= DST_DIR %>/assets/worlds/hall.json':  '<%= SRC_DIR %>/assets/worlds/hall.json'
          '<%= DST_DIR %>/assets/worlds/blue.json':  '<%= SRC_DIR %>/assets/worlds/blue.json'
          '<%= DST_DIR %>/assets/worlds/green.json':  '<%= SRC_DIR %>/assets/worlds/green.json'
          '<%= DST_DIR %>/assets/worlds/yellow.json':  '<%= SRC_DIR %>/assets/worlds/yellow.json'
          '<%= DST_DIR %>/assets/worlds/red.json':  '<%= SRC_DIR %>/assets/worlds/red.json'
          '<%= DST_DIR %>/assets/worlds/end.json':  '<%= SRC_DIR %>/assets/worlds/end.json'


    imagemin:
      png:
        options:
          optimizationLevel: 7
    
        files: [
          
          # Set to true to enable the following options…
          expand: true
          
          # cwd is 'current working directory'
          cwd: "<%= SRC_DIR %>/assets/images/"
          src: ["**/*.png"]
          
          # Could also match cwd line above. i.e. project-directory/img/
          dest: "<%= DST_DIR %>/assets/images/"
          ext: ".png"
        ]


    cssmin:
      dist:
        files:
          '<%= DST_FILE %>.min.css': ['<%= SRC_DIR %>/css/**/*.css']

    # htmlmin:
    #   options:
    #     removeComments: true
    #     removeCommentsFromCDATA: true
    #     removeCDATASectionsFromCDATA: true
    #     collapseWhitespace: true
    #     collapseBooleanAttributes: true
    #     removeAttributeQuotes: true
    #     removeRedundantAttributes: true
    #     useShortDoctype: true
    #
    #   index:
    #     files:
    #       '<%= DST_DIR %>/index.html': '<%= DST_DIR %>/<%= INDEX_FILE %>'

    processhtml:
      index:
        files:
          '<%= DST_DIR %>/index.html': '<%= SRC_DIR %>/<%=INDEX_FILE %>'

    connect:
      dev:
        options:
          port: 9000
          base: '<%= SRC_DIR %>'

    watch:
      js:
        files: ['<%= SRC_DIR %>/js/**/*.js']
        tasks: ['jshint']
        options:
          livereload: true

      ts:
        files: ['<%= SRC_DIR %>/js/**/*.ts']
        tasks: ['typescript']

      all:
        files: [
          '<%= SRC_DIR %>/assets/**/*'
          '<%= SRC_DIR %>/css/**/*.css'
          '<%= SRC_DIR %>/index.html'
        ]
        options:
           livereload: true

  @loadNpmTasks 'grunt-contrib-copy'
  @loadNpmTasks 'grunt-contrib-clean'
  @loadNpmTasks 'grunt-contrib-connect'
  @loadNpmTasks 'grunt-contrib-jshint'
  @loadNpmTasks 'grunt-contrib-uglify'
  @loadNpmTasks 'grunt-jsonmin'
  @loadNpmTasks 'grunt-contrib-imagemin'
  @loadNpmTasks 'grunt-contrib-cssmin'
  @loadNpmTasks 'grunt-contrib-htmlmin'
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-curl'
  @loadNpmTasks 'grunt-processhtml'


  # 'htmlmin' and 'jsonmin' are also available options
  @registerTask 'dist', ['clean', 'jshint', 'uglify','jsonmin'
                         'imagemin', 'cssmin', 'copy', 'processhtml']
  @registerTask 'server',  ['jshint', 'connect', 'watch']
  @registerTask 'update', ['curl-dir']
  @registerTask 'default', ['server']
