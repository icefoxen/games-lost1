
open Vector2d

(* interval = 50 milliseconds, physics goes at 20 FPS 
 * Can always be tweaked.  *)
let calcInterval = 50
let calcIntervalf = 50.0


(* Linear interpolation.  It's your buddy! *)
let lerp oldVec newVec dt =
   let difference = newVec ^- oldVec in
   oldVec ^+ (difference ^* ((float_of_int dt) /. calcIntervalf))


let weaponLayer = -99
and playerLayer = 0
and rockLayer = 60
and uiLayer = 100
