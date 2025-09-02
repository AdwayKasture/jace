if {:unix, :linux} == :os.type() do
  defmodule Jace.BridgeTest do
    use ExUnit.Case,async: true
    alias Jace.Bridge

    is_lib_placed =
      :jace
      |> :code.priv_dir()
      |> Path.join(Bridge.lib_path())
      |> File.exists?()

    is_header_placed =
      :jace
      |> :code.priv_dir()
      |> Path.join(Bridge.include_dir_path())
      |> Path.join("opentui.h")
      |> File.exists?()


    
    assert true == is_lib_placed 
    assert true == is_header_placed 

    test "opentui" do
      assert is_reference(Bridge.new_renderer(32,32))
      
    end
  end
else
  IO.inspect({"test aborted",:os.type()})  
end
