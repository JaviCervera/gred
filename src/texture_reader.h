#pragma once
#include <string>
#include <vector>

class TextureReader {
public:
    static std::vector<std::string> read(const std::string& path);
};
