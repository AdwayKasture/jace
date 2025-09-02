defmodule Jace.Buffer do
  alias Jace.Bridge

  use GenServer

  def start_link(buffer) do
    GenServer.start_link(__MODULE__,buffer,name: __MODULE__)
  end

  @impl GenServer
  def init(buffer) do
    {:ok,buffer}
  end

  @impl GenServer 
  def handle_call({:draw_text,text,{x,y},fg,bg,attrs}, _from, buffer) do
    Bridge.draw_text(buffer,text,x,y,fg,bg,attrs)
    {:reply,:ok,buffer}
  end

  
end
