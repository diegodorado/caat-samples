options = 
  setAsButton: ( image, indexes, callback) ->
    iNormal = indexes[0]
    iHover = indexes[1]
    iPressed = indexes[2]
    iDisabled = indexes[3]
    CAAT.Button.superclass.setAsButton.call this, image, iNormal, iHover, iPressed, iDisabled, callback


CAAT.Foundation.Actor.extend options, null, "CAAT.Button"

