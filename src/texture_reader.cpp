#include "texture_reader.h"
#include <dirent.h>
#include <cstring>
#include <cctype>
#include <algorithm>

static std::string to_lower(std::string s) {
    std::transform(s.begin(), s.end(), s.begin(),
                   [](unsigned char c){ return (char)std::tolower(c); });
    return s;
}

std::vector<std::string> TextureReader::read(const std::string& path) {
    std::vector<std::string> result;
    DIR* dir = opendir(path.c_str());
    if (!dir) return result;
    struct dirent* entry;
    while ((entry = readdir(dir)) != nullptr) {
        std::string name = entry->d_name;
        if (name.empty() || name[0] == '.') continue;
        auto dot = name.rfind('.');
        if (dot == std::string::npos) continue;
        std::string ext = to_lower(name.substr(dot + 1));
        if (ext == "jpg" || ext == "png")
            result.push_back(name);
    }
    closedir(dir);
    std::sort(result.begin(), result.end());
    return result;
}
