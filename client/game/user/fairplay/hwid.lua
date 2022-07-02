local sha2for51 = require("libs.sha2for51");
local utf8string = require("libs.utf8string");

return class {
    init = function(self)
        self.wmic_response = io.popen("wmic diskdrive where(index=0) get serialnumber /value");
        self.hwid_string = (self.wmic_response:read("*a"):match("SerialNumber=([^\r\n]*)") or ""):match("^(.-)%s*$");

        self.hwid_string = utf8string.upper(sha2for51.sha224(self.hwid_string));
    end;

    get = function(self)
        return self.hwid_string;
    end;
}