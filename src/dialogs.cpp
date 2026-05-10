#include "dialogs.h"
#include "../lib/tinyfiledialogs/tinyfiledialogs.h"
#include <vector>
#include <string>
#include <cstring>
#include <cstdlib>

namespace Dialogs {

bool confirm(const std::string& title, const std::string& text, bool serious) {
    return tinyfd_messageBox(title.c_str(), text.c_str(),
                             "yesno", serious ? "error" : "question", 1) == 1;
}

void notify(const std::string& title, const std::string& text, bool serious) {
    tinyfd_messageBox(title.c_str(), text.c_str(),
                      "ok", serious ? "error" : "info", 0);
}

int proceed(const std::string& title, const std::string& text, bool serious) {
    return tinyfd_messageBox(title.c_str(), text.c_str(),
                             "yesnocancel", serious ? "error" : "question", 0);
}

std::string request_file(const std::string& title, const std::string& filters,
                          bool save, const std::string& file) {
    std::vector<std::string> split_filters;
    if (!filters.empty()) {
        std::string token;
        for (char c : filters) {
            if (c == ',') {
                if (!token.empty()) { split_filters.push_back(token); token.clear(); }
            } else {
                token += c;
            }
        }
        if (!token.empty()) split_filters.push_back(token);
    }

    std::vector<const char*> pfilters;
    for (const auto& s : split_filters)
        pfilters.push_back(s.c_str());

    const char* fname = nullptr;
    if (!save) {
        fname = tinyfd_openFileDialog(title.c_str(),
                                      file.c_str(),
                                      (int)pfilters.size(),
                                      pfilters.empty() ? nullptr : pfilters.data(),
                                      filters.empty() ? nullptr : filters.c_str(),
                                      0);
    } else {
        fname = tinyfd_saveFileDialog(title.c_str(),
                                      file.c_str(),
                                      (int)pfilters.size(),
                                      pfilters.empty() ? nullptr : pfilters.data(),
                                      filters.empty() ? nullptr : filters.c_str());
    }
    return fname ? fname : "";
}

std::string request_dir(const std::string& title, const std::string& dir) {
    const char* result = tinyfd_selectFolderDialog(title.c_str(),
                                                    dir.empty() ? nullptr : dir.c_str());
    return result ? result : "";
}

std::string request_input(const std::string& title, const std::string& text,
                           const std::string& def, bool password) {
    const char* result = tinyfd_inputBox(title.c_str(), text.c_str(),
                                         password ? nullptr : def.c_str());
    return result ? result : "";
}

} // namespace Dialogs
