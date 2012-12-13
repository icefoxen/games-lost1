(* There are three general types of objects: Features, Weapons and Ships.
 * Features collide with weapons and ships.
 * Weapons collide with weapons and ships.
 * Ships collide with weapons and features.
 * Effects collide with nothing.
 *)
open Vector2d
open Drawing

class type gameobj =
object
   method loc : vector2D
   method lerpLoc : gameobj option -> int -> vector2D
   method draw : gameobj option -> int -> Drawing.scene
end


(* Features.
 * Features are ambient things lying around fairly passively, that you can
 * run into and so on.
 *)


let drawRock vec =
   withMatrix (translated vec (colored (0.3,0.3,0.3) (scaled 0.05
      (circle 6))))

   (*
class type rock =
object (s : rock gameobj)
   method loc : vector2D
   method lerpLoc : 
   method calc : rock
   method 
   *)

class rock loc vel size =
object (self : #gameobj)
   val loc = loc
   val vel = vel
   val size : int = size
   val damage = 1
   method loc : vector2D = loc
   method lerpLoc old (dt:int) : vector2D =
      match old with
         None -> self#loc
       | Some( a ) -> Globals.lerp a#loc self#loc dt 

   method calc = {< loc = loc ^+ vel >}

   method draw old (dt:int) =
      let hereAndNow = self#lerpLoc old dt in
      [(Globals.rockLayer, drawRock hereAndNow)]


   (*
   method collideShot (shot:shot) : rock list = 
      if Collide.collideCircle loc (0.05) shot#loc (0.01) then
         []
      else
         [(self:>rock)]
*)
   (*
   method collideShip other = [(self:>feature)]
*)
end

(*
class cloud loc radius =
object (self)
   val loc = loc
   val rad = radius
   method calc = self
   (*
   method collideWeapon other = []
   method collideShip other = []
*)
   method draw old now =
      [(-100, withMatrix (translated loc (scaled 0.02 triangle)))]
end

class debris loc vel =
object (self)
   val loc = loc
   val vel = vel
   method calc = {< loc = loc ^+ vel >}
   (*
   method collideWeapon other = []
   method collideShip other = []
*)
   method draw old now =
      [(-100, withMatrix (translated loc (scaled 0.02 triangle)))]
end
*)


let randomVec x y =
   let xr = (Random.float (x *. 2.)) -. x
   and yr = (Random.float (y *. 2.)) -. y in
   (xr, yr)
;;

let randomRock () =
   new rock (randomVec 5.0 5.0) (randomVec 0.01 0.01) 5
;;

let bunchOf n item =
   let rec loop n accm =
      if n = 0 then accm
      else loop (n - 1) (((item ()), None) :: accm)
   in
   loop n []
;;
