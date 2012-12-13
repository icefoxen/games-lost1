open Vector2d

(* Created objects, removed objects, (current, last) obects *)
(*type 'a objlist = 'a list * 'a list * ('a * 'a) list*)

type 'a objlist = ('a * 'a option) list

type gamestate = {
   (* Game meta-data *)
   frames : int;
   lastCalc : int;
   continue : bool;

   (* Game resources *)
   input : gamestate Input.inputContext;
   res : Resources.resourcePool;

   (* Graphical stuff *)
   zoom : float;
   loc : vector2D;

   (* Game objects *)
   rocks : Objs.rock objlist;
   level : Level.level;

   player : Player.player;
   oldPlayer : Player.player;

   shots : Weapon.shot objlist;
}

let initInput res =
   let ic = Input.createContext () in
   let ic = Input.bindQuit ic (fun g -> {g with continue = false}) in
   let ic = Input.bindMany Input.bindButtonPress ic
      [(Sdlkey.KEY_q, (fun _ g -> {g with continue = false}));
      (Sdlkey.KEY_ESCAPE, (fun _ g -> {g with continue = false}))]
   in
   let ic = Input.bindMany Input.bindButtonHold ic
      [(Sdlkey.KEY_LEFT, (fun g -> {g with player = g.player#rotateLeft}));
      (Sdlkey.KEY_RIGHT, (fun g -> {g with player = g.player#rotateRight}));
      (Sdlkey.KEY_UP, (fun g -> {g with player = g.player#thrust}));
      (Sdlkey.KEY_c, (fun g -> let p, shots = g.player#fire in
      {g with player = p; (* shots = shots @ g.shots *)}));
      ]
   in
   ic

let initGamestate ic res = { 
   frames = 0;
   lastCalc = 0;
   continue = true;

   input = ic; 
   res = res; 

   loc = (0.,0.); 
   zoom = 1.;

   rocks = Objs.bunchOf 100 Objs.randomRock;
   level = {Level.background = Level.basicLevelDraw};

   player = new Player.player;
   oldPlayer = new Player.player;

   shots = [];
}


let getScreenBounds g loc =
    let x, y = loc in 
   (* 4:3 aspect ratio *)
   let x1 = x +. (1.25 *. g.zoom)
   and x2 = x -. (1.25 *. g.zoom)
   and y1 = y +. g.zoom
   and y2 = y -. g.zoom in
   (x2,x1,y1,y2)

let setView g loc =
   let x1, x2, y1, y2 = getScreenBounds g loc in
   Drawing.setView x1 x2 y1 y2



let doDrawing now g =
   let dt = now - g.lastCalc in
   (* ...oops.  What do we do when a feature gets added or removed?! *)
   let rockScene = 
      List.concat (List.map
      (fun (cur,prev) -> cur#draw (prev:>Objs.gameobj) dt) g.rocks)
   and playerScene = g.player#draw g.oldPlayer dt
   and shotScene = 
      List.concat (List.map
      (fun (cur,prev) -> cur#draw (prev:>Objs.gameobj) dt) g.shots)
   and levelScene = g.level.Level.background () 
   in

   let finalScene = Drawing.mergeScene rockScene levelScene in
   let finalScene = Drawing.mergeScene playerScene finalScene in
   let finalScene = Drawing.mergeScene shotScene finalScene in
   setView g (g.player#lerpLoc g.oldPlayer dt);
   Drawing.drawScene finalScene;
(*     Printf.printf "View set: %s\n" (Vector2d.string_of_vector2d (g.player#lerpLoc g.oldPlayer dt)); *)
   Gl.flush ();
;;


let doCalc now g =
   if (now - g.lastCalc) >= Globals.calcInterval then
      let ic, g = Input.doInput g.input g in
      let newRocks = List.map (fun f -> f#calc) g.rocks in
      let newShots = List.map (fun f -> f#calc) g.shots in
      let newPlayer = g.player#calc in
      (* This GC call is harmonious and auspicious.  It makes the game
       * run slightly faster.
       * I still wish I could have the option of turning the thing off entirely,
       * though.
       *)
      Gc.minor ();
      {g with 
      rocks = newRocks;
      player = newPlayer;
      shots = newShots;

      input = ic; 
      lastCalc = now; 
   }
   else
      g




(* Sometimes, doDrawing can do things before doCalc has a chance to set
 * everything up, and List.map2 blows up on, for instance, oldRocks
 *)
let rec doMainLoop g =
   let now = Sdltimer.get_ticks () in
   if g.continue then begin
      let g = {g with frames = g.frames + 1} in
      let g = doCalc now g in
      doDrawing now g;
      doMainLoop g;
   end
   else begin
      let frames = float_of_int g.frames
      and now = (float_of_int now) /. 1000. in
      Printf.printf "FPS: %f\n" (frames /. now);
   end


let main () =
   let res = Resources.createResourcePool () in

   let mainConf = Resources.getConfig res "cfg/main.cfg" in
   let x = Cfg.getInt mainConf "screen.x"
   and y = Cfg.getInt mainConf "screen.y" in
   Util.init x y;
   
   let ic = initInput res in 
   let g = initGamestate ic res in

   Gc.set { (Gc.get ()) with Gc.minor_heap_size = 0x100000};
(*   List.iter foo (Sdlgl.get_attr ()); *)

   doMainLoop g; 

   Util.quit ()

let _ = main ()
