defmodule Jace do
  alias Jace.Bridge
  use GenServer
  import Bitwise

  def start_link([text] ) do
    GenServer.start_link(__MODULE__,[text],name: __MODULE__)
  end


  @impl GenServer
  def init([text]) do
    renderer_ref = Bridge.new_renderer(64,64)
    buff_ref = Bridge.get_next_buffer(renderer_ref)
    Bridge.draw_text(buff_ref,text,30,2,ello(),black(),attr())
    {:ok,renderer_ref}
  end

  @impl GenServer
  def terminate(_, ref) do
    Bridge.destroy_renderer(ref,false,0)
  end

  defp ello,do: [1.0,1.0,0.0,1.0]
  
  defp black,do: [0.0,0.0,0.0,1.0]

  defp attr,do: 1 <<< 0

end
