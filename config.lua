-- Variables
config_file_path = os.getenv("HOME").. "/.zwm"

-- Parse configuration

local function parse(source)
    local lines = {}
    local num = 0
    for line in source:gmatch("[^\r\n]+") do 
        lines[0] = line
    end

    config = lines

end

function load_config(file)
    local config_source = hs.execute("cat " .. config_file_path .. "/config")

    if config_source == "" then
        hs.alert.show("empty config")
    else 
        parse(config_source)
        hs.alert.show("loaded config")
    end

end

load_config(config_file_path)

local config_watcher = hs.pathwatcher.new(config_file_path, load_config):start()

