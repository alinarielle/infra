match $env.degrees {
  0 => { sway output eDP-1 transform 270; $env.degrees = 270 },
  270 => { sway output eDP-1 transform 180; $env.degrees = 180 },
  180 => { sway output eDP-1 transform 90; $env.degrees = 90 },
  90 => { sway output eDP-1 transform 0; $env.degrees =  0},
  _ => "weh",
}
