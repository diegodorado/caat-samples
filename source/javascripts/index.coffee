
#turn debug bar on
CAAT.DEBUG = 1

#director = new CAAT.Foundation.Director().initialize(100, 100, document.getElementById("canvas"))
director = new CAAT.Foundation.Director().initialize(800, 500, "canvas")

# add a scene object to the director.
scene = director.createScene()
empty_position = null

CAAT.Foundation.Actor.extend
  paint: (director, time) ->
    CAAT.Dude.superclass.paint.call this, director, time
    ctx = director.ctx
    ctx.strokeStyle = "#aaa"
    ctx.strokeRect 0, 0, @width, @height
, null, "CAAT.Dude"


new CAAT.Module.Preloader.Preloader()
  .addElement("dude", "/images/dude.png")
  .load (images) ->
    console.log images,director.id
    director.setImagesCache images

    reset = (spriteImage, time) ->
      spriteImage.playAnimation "stand"

    si = new CAAT.Foundation.SpriteImage()
      .initialize(director.getImage("dude"), 21, 7)
      .addAnimation("stand", [123..144], 100)
      .addAnimation("fall", [0..7], 100, reset)
      .addAnimation("wall_ud", [74..81], 100)
      .addAnimation("wall_lr", [82..89], 100)
      .addAnimation("tidy", [42..50], 100, reset)
      .addAnimation("die", [68..73], 100, reset)
      .addAnimation("jump", [95..90], 100, reset)
      .addAnimation("run_b", [96..122], 30)
      .addAnimation("run_f", [122..96], 30)
      .addAnimation("sad", [26..33], 100)

    actor = new CAAT.Dude()
      .setBackgroundImage(si)
      .setLocation(200, 50)
    actor.playAnimation "fall"
    scene.addChild actor


    actor.mouseUp = (event) ->
      actor = event.source
      pt = event.point
      actor.moveTo pt.x, pt.y, 1000, 500, null, (behavior, time, actor)->
        actor.playAnimation "sad"
      actor.playAnimation "fall"

    CAAT.loop 60

