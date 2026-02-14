local options = {
  cursor_color = "#FFFFFF",
  particles_enabled = false,
  stiffness = 0.45, --default 0.45
  trailing_stiffness = 1,
  stiffness_insert_mode = 0.9,
  trailing_exponent = 5,
  damping = 1,
  gradient_exponent = 0,
  gamma = 10, -- default is 1
  never_draw_over_target = true, -- if you want to actually see under the cursor
  hide_target_hack = true, -- same
  particle_spread = 1,
  particles_per_second = 5000,
  particles_per_length = 50,
  particle_max_lifetime = 800,
  particle_max_initial_velocity = 20,
  particle_velocity_from_cursor = 0.5,
  particle_damping = 0.15,
  particle_gravity = -50,
  min_distance_emit_particles = 0,
  matrix_pixel_threshold = 0.5,

  -- Smears will blend better on all backgrounds.
  legacy_computing_symbols_support = true,
  legacy_computing_symbols_support_vertical_bars = true,
  use_diagonal_blocks = true,

  -- Sets animation framerate
  time_interval = 1000 / 180, -- milliseconds (1000 / fps)
  smear_insert_mode = false,
}

return options
