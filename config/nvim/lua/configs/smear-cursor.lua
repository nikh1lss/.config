local options = {
  filetypes_disabled = { "TelescopePrompt" },
  -- Smear cursor when switching buffers or windows.
  smear_between_buffers = true,
  min_horizontal_distance_smear = 0,
  min_vertical_distance_smear = 0,

  -- Smear cursor when moving within line or to neighbor lines.
  smear_between_neighbor_lines = true,

  -- Draw the smear in buffer space instead of screen space when scrolling
  scroll_buffer_space = true,

  -- Smear cursor in insert mode.
  -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
  smear_insert_mode = true,

  -- Toggles for directions
  smear_horizontally = true,
  smear_vertically = true,
  smear_diagonally = true, -- Neither horizontal nor vertical

  -- Smear cursor when entering or leaving command line mode
  smear_to_cmd = true,

  -- Smears will blend better on all backgrounds.
  legacy_computing_symbols_support = true,
  legacy_computing_symbols_support_vertical_bars = true,
  use_diagonal_blocks = true,

  -- Smear cursor in terminal mode.
  -- If the smear goes to the wrong location when enabled, try increasing `delay_after_key`.
  -- smear_terminal_mode = true,

  -- Sets animation framerate
  time_interval = 5, -- milliseconds

  -- Smear config

  -- How fast the smear's head moves towards the target.
  -- 0: no movement, 1: instantaneous
  stiffness = 0.6,

  -- How fast the smear's tail moves towards the target.
  -- 0: no movement, 1: instantaneous (default 0.5)
  trailing_stiffness = 0.3,

  -- Initial velocity factor in the direction opposite to the target
  anticipation = 0.2,

  -- Velocity reduction over time. O: no reduction, 1: full reduction (default 0.85)
  damping = 0.7,

  -- Controls if middle points are closer to the head or the tail.
  -- < 1: closer to the tail, > 1: closer to the head (default 3)
  trailing_exponent = 1.5,

  -- Stop animating when the smear's tail is within this distance (in characters) from the target.
  -- default 0.1
  distance_stop_animating = 0.05,

  -- Set of parameters for insert mode
  stiffness_insert_mode = 0.5,
  trailing_stiffness_insert_mode = 0.5,
  damping_insert_mode = 0.9,
  trailing_exponent_insert_mode = 1,

  distance_stop_animating_vertical_bar = 0.875,
  -- Can be decreased (e.g. to 0.1) if using legacy computing symbols

  -- When to switch between rasterization methods
  max_slope_horizontal = (1 / 3) / 1.5,
  min_slope_vertical = 2 * 1.5,
  max_angle_difference_diagonal = math.pi / 16, -- radians
  max_offset_diagonal = 0.2, -- cell widths
  min_shade_no_diagonal = 0.2, -- 0: less diagonal blocks, 1: more diagonal blocks
  min_shade_no_diagonal_vertical_bar = 0.5,

  color_levels = 256, -- minimum 1, don't set manually if using cterm_cursor_colors
  gamma = 2.2, -- For color blending
  gradient_exponent = 1.0, -- For longitudinal gradient. 0: no gradient, 1: linear, ...
  max_shade_no_matrix = 0.6, -- 0: more overhangs, 1: more matrices (default 0.75)
  matrix_pixel_threshold = 0.5, -- 0: all pixels, 1: no pixel (default 0.7)
  matrix_pixel_threshold_vertical_bar = 0.25, -- 0: all pixels, 1: no pixel
  matrix_pixel_min_factor = 0.5, -- 0: all pixels, 1: no pixel
  volume_reduction_exponent = 0.5, -- 0: no reduction, 1: full reduction (default 0.3)
  minimum_volume_factor = 0.5, -- 0: no limit, 1: no reduction (default 0.7)
  max_length = 25, -- ximum smear length
  max_length_insert_mode = 1,

  -- Particles configuration -----------------------------------------------------

  particles_enabled = false, -- When true, better to also set `never_draw_over_target` to true
  particle_max_num = 200,
  particle_spread = 1, -- 0: no spread, 1: spread over entire cursor
  particles_per_second = 200,
  particles_per_length = 2.0, -- per character width
  particle_max_lifetime = 1000, -- milliseconds
  particle_lifetime_distribution_exponent = 5,
  particle_max_initial_velocity = 10, -- characters width per second
  particle_velocity_from_cursor = 0.2, -- 0: none, 1: full
  particle_random_velocity = 100, -- characters width per second
  particle_damping = 0.2,
  particle_gravity = 20, -- characters width per second squared
  min_distance_emit_particles = 1.5, -- character widths
  particle_switch_octant_braille = 1, -- fraction of lifetime, used if `legacy_computing_symbols_support` is true
  particles_over_text = false,

  --Colours

  cursor_color = nil,
  normal_bg = nil,
}

return options
