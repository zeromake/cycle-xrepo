package("harfbuzz")
    set_homepage("https://harfbuzz.github.io/")
    set_description("HarfBuzz is a text shaping library.")

    set_license("MIT")
    set_urls("https://github.com/zeromake/nvm-windows/releases/download/1.1.8/harfbuzz.zip")
    add_versions("5.3.1", "a5da5fcf25ad7fde60a1e5988982f799ab5f19881ad4a449eeb4ff45ea753bca")
    add_configs("freetype", {description = "Support freetype", default = false, type = "boolean"})

    add_includedirs("include")
    on_load(function (package)
        if package:config("freetype") then
            package:add("deps", "freetype")
        end
    end)

    on_install("windows", "mingw", "macosx", "linux", function (package)
        os.cp(path.join(os.scriptdir(), "port", "*"), "./")
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
option("use-freetype")
    set_default(false)
    set_showmenu(true)
option_end()

if has_config("use-freetype") then 
    add_requires("freetype")
end

if is_plat("windows") then
    add_cxflags("/utf-8")
end

target("harfbuzz")
    set_kind("$(kind)")
    if has_config("use-freetype") then 
        add_packages("freetype")
        add_defines("HAVE_FREETYPE")
    end
    add_headerfiles("*.h")
    for _, f in ipairs({
        "hb.c"
    }) do
        add_files(f)
    end
]])
        local configs = {}
        local v = "n"
        if package:config("freetype") then
            v = "y"
        end
        table.insert(configs, "--use-freetype="..v)
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("hb_font_create", {includes = "hb.h"}))
    end)
