local current_folder = (...):gsub('%.init$', '')
require (current_folder .. "GameObject")
require (current_folder .. "Brick")
require (current_folder .. "Paddle")
