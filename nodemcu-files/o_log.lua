o_log = {
    make_string = function(...)
        local printResult = ""
        for i, v in ipairs(arg) do
            printResult = printResult .. tostring(v) .. "\t"
        end
        return printResult .. "\n"
    end,

    print_log = function(...)
        print(o_log.save_log_str(...))
    end,

    save_log = function(...)
        local str = o_log.make_string(...)
        o_log.save_log_str(str)
        return str
    end,

    save_log_str = function(str)
        fd = file.open("log_file.txt", "a")
        fd:writeline(str)
        fd:close();
        fd = nil
    end
}
