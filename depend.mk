globals.cmo: ./spitting-camel/vector2d.cmi 
globals.cmx: ./spitting-camel/vector2d.cmx 
level.cmo: ./spitting-camel/drawing.cmi 
level.cmx: ./spitting-camel/drawing.cmx 
lost.cmo: weapon.cmo ./spitting-camel/vector2d.cmi ./spitting-camel/util.cmi \
    /usr/lib/ocaml/site-lib/sdl/sdltimer.cmi \
    /usr/lib/ocaml/site-lib/sdl/sdlkey.cmi ./spitting-camel/resources.cmi \
    player.cmo objs.cmo level.cmo ./spitting-camel/input.cmi globals.cmo \
    /usr/lib/ocaml/lablGL/gl.cmi ./spitting-camel/drawing.cmi \
    ./spitting-camel/cfg.cmi 
lost.cmx: weapon.cmx ./spitting-camel/vector2d.cmx ./spitting-camel/util.cmx \
    /usr/lib/ocaml/site-lib/sdl/sdltimer.cmi \
    /usr/lib/ocaml/site-lib/sdl/sdlkey.cmi ./spitting-camel/resources.cmx \
    player.cmx objs.cmx level.cmx ./spitting-camel/input.cmx globals.cmx \
    /usr/lib/ocaml/lablGL/gl.cmx ./spitting-camel/drawing.cmx \
    ./spitting-camel/cfg.cmx 
objs.cmo: ./spitting-camel/vector2d.cmi globals.cmo \
    ./spitting-camel/drawing.cmi 
objs.cmx: ./spitting-camel/vector2d.cmx globals.cmx \
    ./spitting-camel/drawing.cmx 
player.cmo: weapon.cmo ./spitting-camel/vector2d.cmi globals.cmo \
    ./spitting-camel/drawing.cmi 
player.cmx: weapon.cmx ./spitting-camel/vector2d.cmx globals.cmx \
    ./spitting-camel/drawing.cmx 
weapon.cmo: ./spitting-camel/vector2d.cmi objs.cmo globals.cmo \
    ./spitting-camel/drawing.cmi 
weapon.cmx: ./spitting-camel/vector2d.cmx objs.cmx globals.cmx \
    ./spitting-camel/drawing.cmx 
