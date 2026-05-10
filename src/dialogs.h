#pragma once
#include <string>

namespace Dialogs {
    bool        confirm(const std::string& title, const std::string& text, bool serious = false);
    void        notify(const std::string& title, const std::string& text, bool serious = false);
    int         proceed(const std::string& title, const std::string& text, bool serious = false);
    std::string request_file(const std::string& title, const std::string& filters,
                             bool save, const std::string& file = "");
    std::string request_dir(const std::string& title, const std::string& dir = "");
    std::string request_input(const std::string& title, const std::string& text,
                              const std::string& def = "", bool password = false);
}
