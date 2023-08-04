function love.conf(t)
    t.window.title = "Cosmic Conquest" -- Set the window title
    t.window.width = 600 -- Set the window width
    t.window.height = 800 -- Set the window height
    t.window.resizable = false -- Allow the window to be resized
    t.window.fullscreen = false -- Start the game in windowed mode
    t.modules.audio = true -- Enable audio module
    t.modules.keyboard = true -- Enable keyboard module
    t.modules.mouse = false -- Enable mouse module
    t.modules.sound = true -- Enable sound module
    t.modules.image = true -- Enable image module
    t.modules.graphics = true -- Enable graphics module
end
