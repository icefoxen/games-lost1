open Vector2d
open Drawing;;

let drawShot vec theta =
   let v = createDirMag theta 1. in
   let v1 = vec ^- (v ^* 0.03)
   and v2 = vec ^- (v ^* 0.06)
   and v3 = vec ^- (v ^* 0.09) in
   let shot = [
      withMatrix (colored (0.8, 0.0, 0.0)
        (affined ~t: vec ~r: theta ~s: 0.020 triangle));
      withMatrix (colored (0.6, 0.0, 0.0)
        (affined ~t: v1 ~r: theta ~s: 0.018 triangle));
      withMatrix (colored (0.4, 0.0, 0.0)
        (affined ~t: v2 ~r: theta ~s: 0.016 triangle));
      withMatrix (colored (0.2, 0.0, 0.0)
        (affined ~t: v3 ~r: theta ~s: 0.014 triangle));
   ]
   in
   addListToScene emptyScene Globals.weaponLayer shot

class shot loc theta =
   let vel = 0.2 in
   let vx = vel *. (cos theta)
   and vy = vel *. (sin theta) in
object (self : # Objs.gameobj)
   val loc = loc
   val vel = (vx,vy)

   method loc = loc
   method lerpLoc old dt =
      match old with
         None -> self#loc
       | Some( a ) -> Globals.lerp a#loc self#loc dt 

   method calc = {< loc = loc ^+ vel >}

   method draw old dt =
      let hereAndNow = self#lerpLoc old dt in
      drawShot hereAndNow theta

end
 

class peashooter =
object (self)
   val timeout = 0
   method fire loc theta = 
      let facing = createDirMag theta 0.1 in
      let loc = loc ^+ facing in
      if timeout <= 0 then ({<timeout = 5>}, [new shot loc theta])
      else (self, [])
   method calc = {<timeout = max (timeout - 1) 0>}
end
