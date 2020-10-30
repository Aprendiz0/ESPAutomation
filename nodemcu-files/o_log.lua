o_log = {
    print_log = function(...)
        local printResult = ""
        for i, v in ipairs(arg) do
            printResult = printResult .. tostring(v) .. "\t"
        end
        printResult = printResult .. "\n"
        print(printResult)
        
    end
}
