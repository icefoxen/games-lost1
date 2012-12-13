open Drawing
open Vector2d

let verts = [
   (0.0, 0.0);
   (-0.02, 0.02);
   (0.04, 0.0);
   (-0.02, -0.02)
]

let drawPlayer = withPrim `quads (fun () -> vertices verts)

class player = 
object (self)
   val loc = (0.,0.)
   val vel = (0.,0.)
   val accel = 0.01
   val drag = 0.9
   (* This is on a mathematical axis, so increasing theta rotates
    * counterclockwise, and theta = 0 is facing along the x axis.  *)
   val theta = 0.
   val rotVel = 0.0
   val rotAccel = 0.05
   val rotDrag = 0.8
   val alive = true
   val weapon = new Weapon.peashooter 

   method loc = loc
   method calc = {< 
      loc = loc ^+ vel; 
      vel = vel ^* drag;
      theta = theta +. rotVel;
      rotVel = rotVel *. rotDrag;
      weapon = weapon#calc;
   >}

   method lerpLoc (old:player) (dt:int) =
       Globals.lerp old#loc self#loc dt 

   method draw (old:player) (dt:int) =
      (* timeslice = 50 ms *)
      let hereAndNow = self#lerpLoc old dt in
      [(Globals.playerLayer, withMatrix (translated hereAndNow (rotated theta (colored (0.0,1.0,0.0)
      drawPlayer))))]

   method private rotate direction =
      {< rotVel = rotVel +. (rotAccel *. direction) >}
      
   method rotateLeft = self#rotate (1.0)
   method rotateRight = self#rotate (-1.0)

   method thrust =
      let ax = accel *. (cos theta)
      and ay = accel *. (sin theta) in
      {< vel = vel ^+ (ax,ay) >}

   method fire =
      let wep, shots = weapon#fire loc theta in
      ({< weapon = wep >}, shots)
end

