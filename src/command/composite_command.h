#pragma once

#include <vector>
#include "i_command.h"

class CompositeCommand : public ICommand
{
public:
  std::shared_ptr<ICommand> execute() override
  {
    std::shared_ptr<CompositeCommand> undo_cmd = std::make_shared<CompositeCommand>();
    for (const auto &cmd : commands)
    {
      undo_cmd->add_command(cmd->execute());
    }
    return (undo_cmd->commands.empty()) ? nullptr : undo_cmd;
  }

  void add_command(std::shared_ptr<ICommand> cmd)
  {
    if (cmd)
      commands.push_back(cmd);
  }

private:
  std::vector<std::shared_ptr<ICommand>> commands;
};
