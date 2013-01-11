#= require_self
#= require './piece'
#= require './button'

#it is a utility function
#so, i dont expose it
swap_button= (b1, b2) ->
  {x,y} = b1
  b2.x= x
  b2.y = y
  b2.setVisible true
  b1.setVisible false

App = 
  init: ->


    # create a director object
    @director = new CAAT.Foundation.Director().initialize(320, 460, "canvas")

    # add a scene object to the director.
    @menu_scene = @director.createScene()
    @main_scene = @director.createScene()

    @puzzle_size = 260
    @pieces_container = null
    @menu_container = null


    new CAAT.Module.Preloader.Preloader()
      .addElement("buttons", "/images/buttons.png")
      .addElement("background", "/images/background.jpg")
      .load (i)=>@primary_images_loaded(i)


  easy_pressed: (button) ->
    @reset_pieces @pieces_container, "angelina", 3
    @director.switchToNextScene 2000, false, true

  hard_pressed: (button) ->
    @reset_pieces @pieces_container, "fifty", 5
    @director.switchToNextScene 2000, false, true

  scores_pressed: (button) ->
    alert 'not implemented yet'


  start_button_pressed: (button) ->
    #randomize it!
    swap_button button, @resign_button
    #@resign_button.invalidateLayout()
    for i in [0..100]
      @pieces_container.childrenList[0].randomMove() #horrible
    @playing = true

  resign_pressed: (button) ->
    @director.switchToPrevScene 2000, false, true

  play_again_pressed: (button) ->
    alert 'not implemented yet'
        
  menu_pressed: (button) ->
    @director.switchToPrevScene 2000, false, true



  build_main_container: ->
    #shorthand
    lm = CAAT.Foundation.UI.Layout.LayoutManager

    layout = new CAAT.Foundation.UI.Layout.BoxLayout()
      .setVGap(3)
      .setAxis(lm.AXIS.Y)
      .setAllPadding(0)
      .setHorizontalAlignment(lm.ALIGNMENT.CENTER)
      .setVerticalAlignment(lm.ALIGNMENT.CENTER)
      
    c = new CAAT.Foundation.ActorContainer()
      .setSize(@director.width, @director.height)
      .setLayout(layout)

    c

  reset_pieces: (container,image, n)->
    @resign_button.setVisible false
    @start_button.setVisible true
    @start_button.invalidateLayout()
    @playing = false

    layout = new CAAT.Foundation.UI.Layout.GridLayout(n, n)
      .setHGap(0)
      .setVGap(0)

    container.emptyChildren()
      .setLayout(layout)
    
    nsi = new CAAT.Foundation.SpriteImage()
      .initialize(image, n, n)

    for i in [0..(n*n-1)]
      number = new CAAT.Piece()
        .setIndex(i, n)
        .setBackgroundImage(nsi.getRef(), true)
        .setSpriteIndex(i)

      container.addChild number


    
  build_pieces_container: (size)->
      
    c = new CAAT.Foundation.ActorContainer()
      .setBounds(0, 0, size, size)
    c



  build_background: (image)->
    si= new CAAT.SpriteImage()
      .initialize(@director.getImage(image), 1, 1 )
    bg = new CAAT.Actor()
      .setBackgroundImage(si.getRef(), true )
    bg



      

  secondary_images_loaded: (images) ->
    for i in images
      @director.addImage i.id, i.image, true

  
  primary_images_loaded: (images) ->
    @director.setImagesCache images

    @menu_scene.addChild @build_background('background')
    @menu_container = @build_main_container(@director.width, @director.height)
    @menu_scene.addChild @menu_container

    @main_scene.addChild @build_background('background')
    @main_container = @build_main_container(@director.width, @director.height)
    @main_scene.addChild @main_container

    @pieces_container = @build_pieces_container(@puzzle_size)
    @main_container.addChild @pieces_container



    si = new CAAT.Foundation.SpriteImage().initialize(@director.getImage("buttons"), 7, 3 )

      
    @menu_container.addChild new CAAT.Button().setAsButton si.getRef(), [0..2], (b)=>@easy_pressed(b)
    @menu_container.addChild new CAAT.Button().setAsButton si.getRef(), [3..5], (b)=>@hard_pressed(b)
    @menu_container.addChild new CAAT.Button().setAsButton si.getRef(), [18..20], (b)=>@scores_pressed(b)
    
    
    @start_button =  new CAAT.Button().setAsButton si.getRef(), [6..8], (b)=>@start_button_pressed(b)
    @resign_button =  new CAAT.Button().setAsButton si.getRef(), [9..11], (b)=>@resign_pressed(b)
    @play_again_button =  new CAAT.Button().setAsButton si.getRef(), [12..14], (b)=>@play_again_pressed(b)
    @main_container.addChild @start_button
    @main_container.addChild @resign_button.setVisible false
    @main_container.addChild @play_again_button.setVisible false
    @main_container.addChild new CAAT.Button().setAsButton si.getRef(), [15..17], (b)=>@menu_pressed(b)



    CAAT.loop 60


    #defer puzzle images loading
    new CAAT.Module.Preloader.Preloader()
      .addElement("fifty", "/images/fifty.jpg")
      .addElement("angelina", "/images/angelina.jpg")
      .load (i)=>@secondary_images_loaded(i)
      

#exports
root = exports ? this
root.App = App
