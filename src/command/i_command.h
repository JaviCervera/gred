#pragma once
#include <memory>

class ICommand {
public:
    virtual ~ICommand() = default;
    virtual std::shared_ptr<ICommand> execute() = 0;
};
