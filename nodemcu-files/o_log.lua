o_log = {
    make_string = function(...)
        local printResult = ""
        for i, v in ipairs(arg) do
            printResult = printResult .. tostring(v) .. "\t"
        end
        if not printResult then return nil end
        return printResult .. "\n"
    end,

    print_log = function(...) print(o_log.save_log(...)) end,

    save_log = function(...)
        local str = o_log.make_string(...)
        if str then
            o_log.save_log_str(str)
            return str
        else
            return ""
        end
    end,

    save_log_str = function(str)
        fd = file.open("log_file.txt", "a")
        fd:writeline(str)
        fd:close();
        fd = nil
    end
}
