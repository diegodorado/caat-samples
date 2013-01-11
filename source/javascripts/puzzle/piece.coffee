options =
  
  cornerRadius: 2
  swapping: false
  
  paint: (director, time) ->
    return if @empty and App.playing
    CAAT.Piece.superclass.paint.call this, director, time

    if App.playing
      ctx = director.ctx
      # Set faux rounded corners
      ctx.strokeStyle = "#eee"
      ctx.lineJoin = "round"
      ctx.lineWidth = @cornerRadius
      # Change origin and dimensions to match true size (a stroke makes the shape a bit larger)
      ctx.strokeRect((@cornerRadius/2), (@cornerRadius/2), @width-@cornerRadius, @height-@cornerRadius)
    
  randomMove: ->
    movables = @emptyPiece().neighbors()
    movables.sort -> 0.5 - Math.random()
    movables[0].swap(false)

    
  neighbors: ->
    p for p in @parent.childrenList when Math.abs(p.row - @row) + Math.abs(p.column - @column) is 1
    
  emptyPiece: ->
    (p for p in @parent.childrenList when p.empty)[0]
    
  hasWon: ->
    for p in @parent.childrenList
      return false unless p.position is p.index 
    return true
    
  canMove: ->
    for p in @neighbors()
      return true if p.empty
    return false
    
  swap: (transition=true) ->
    #swap pieces (without transition)
    return if @swapping
    ep = @emptyPiece()
    {x, y, row, column, position} = ep
    ep.x = @x
    ep.y = @y
    ep.row = @row
    ep.column = @column
    ep.position = @position

    @row = row
    @column = column
    @position = position

    if transition
      @swapping = true
      @moveTo x, y, 300, 0, null, =>
        @swapping = false
    else
      #swap without transition
      @x = x
      @y = y
  
  mouseEnter: (mouseEvent) ->
    CAAT.setCursor 'pointer'
    
  mouseExit: (mouseEvent) ->
    CAAT.setCursor 'default'
    
  mouseUp: (event) ->

    return unless App.playing
    if @canMove()
      @swap() 
      if @hasWon()
        App.playing = false


  #return @ to keep it chainable
  setIndex: (@index, n) -> 
    #columns and rows are the same
    @position = @index
    @row = (@index / n) >> 0
    @column = (@index % n)
    if @index is n*n-1
      @empty = true
    @

  shout: ->
    console.log @index, @position, @row, @column, @empty, @canMove(), (p.index for p in  @neighbors() )


#extend with these options
CAAT.Foundation.Actor.extend options, null, "CAAT.Piece"

