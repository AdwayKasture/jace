defmodule Mix.Tasks.Opentui do
  use Mix.Task

  @shortdoc "Manages the OpenTUI tool"
  
  @switches [build: :boolean]

  #@opentui_url "https://github.com/sst/opentui/releases/latest/download/install.sh"

  @moduledoc """
  A Mix task for managing the OpenTUI tool.

  This task will be responsible to managing opentui deps, downloads

  ## Examples

      mix opentui --build
  """
  
    def run(args) do
      {opts,_,_} = OptionParser.parse(args,switches: @switches)
      cond do
        opts[:build] -> build_from_deps()
      end
    end

    defp build_from_deps() do
      opentui_dep = Path.join(Mix.Project.deps_path(),"opentui")
      zig_path = Path.join([opentui_dep,"packages","core","src","zig"])
      header_path = Path.join([opentui_dep,"packages","go","opentui.h"])
      pc_in = Path.join([opentui_dep,"opentui.pc.in"])
      priv = "priv"
    
      # Ensure the build directory exists
      File.mkdir_p!(priv)
      File.mkdir_p!(Path.join(priv,"include"))

      File.cp_r!(zig_path, Path.join(priv,"zig"))
      {output, 0} = System.cmd("zig", ["build"], [cd: Path.join(priv,"zig")])
      Mix.shell().info(output)
      File.cp!(header_path, Path.join([priv,"include", "opentui.h"]))
      File.cp!(pc_in, Path.join([priv, "opentui.pc.in"]))

      Mix.shell().info("Build artifacts copied to #{priv}")

    end

  
end
