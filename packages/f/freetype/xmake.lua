package("freetype")
    set_homepage("https://freetype.org")
    set_description("FreeType is a freely available software library to render fonts.")

    set_license("FTL")
    set_urls("https://github.com/zeromake/nvm-windows/releases/download/1.1.8/freetype.zip")
    add_versions("2.12.1", "1d30bee8afaac08664d28a949d3d48b0fb82c9c115ab309fd2e300919a4a19bd")
    add_configs("harfbuzz", {description = "Support harfbuzz", default = false, type = "boolean"})

    add_includedirs("include")
    on_load(function (package)
        if package:config("harfbuzz") then
            package:add("deps", "harfbuzz")
        end
    end)
    
    on_install("windows", "mingw", "macosx", "linux", function (package)
        os.cp(path.join(os.scriptdir(), "port", "*"), "./")
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
option("use-harfbuzz")
    set_default(false)
    set_showmenu(true)
option_end()

if has_config("use-harfbuzz") then 
    add_requires("harfbuzz")
end

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("freetype")
    set_kind("$(kind)")
    if has_config("use-harfbuzz") then 
        add_packages("harfbuzz")
        add_defines("FT_CONFIG_OPTION_USE_HARFBUZZ")
    end
    add_headerfiles("*.h")
    for _, f in ipairs({
        "ft.c"
    }) do
        add_files(f)
    end
]])
        local configs = {}
        local v = "n"
        if package:config("harfbuzz") then
            v = "y"
        end
        table.insert(configs, "--use-harfbuzz="..v)
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ft_font_create", {includes = "ft.h"}))
    end)
