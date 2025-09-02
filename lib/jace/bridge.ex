defmodule Jace.Bridge do
  
   @lib  {:priv, "libopentui.so"}
   @header  {:priv, "include"}
  
   use Zig,otp_app: :jace,
    c: [link_lib: @lib,include_dirs: @header],
    resources: [:RendererResource,
                :OptimizedBufferResource,
                :TextBufferResource],
    nifs: [...]

  ~Z"""
    const c = @cImport({@cInclude("opentui.h");});
    const beam = @import("beam");
    const enif = @import("enif");
    const root = @import("root");


    const CAllocError = error{rendererEntry,bufferEntry};

    pub const RendererResource = beam.Resource(*c.CliRenderer,root,.{});
    pub const OptimizedBufferResource = beam.Resource(*c.OptimizedBuffer,root,.{});
    pub const TextBufferResource = beam.Resource(*c.TextBuffer,root,.{});
    
    pub fn new_renderer(width :u32,height :u32) !RendererResource {
      const renderer: ?*c.CliRenderer =  c.createRenderer(width,height);
      return if (renderer) |non_null_a| 
        RendererResource.create(non_null_a,.{})
      else
        error.renderer;
    }

    pub fn get_next_buffer(renderer: RendererResource) !OptimizedBufferResource {
      const buffer: ?*c.OptimizedBuffer = c.getNextBuffer(renderer.unpack());
      return if (buffer) |non_null_a|
        OptimizedBufferResource.create(non_null_a,.{})
      else
        error.bufferEntry;
  
    }

    pub fn buffer_clear(buffer: OptimizedBufferResource,bg: []const f32) void {
      c.bufferClear(buffer.unpack(),bg.ptr);
    }

    pub fn draw_text(buffer: OptimizedBufferResource,text: []const u8,x: u32,y: u32,fg: []const f32,bg: []const f32,attrs: u8) void{
      c.bufferDrawText(buffer.unpack(),text.ptr,text.len,x,y,fg.ptr,bg.ptr,attrs);
    }

    pub fn destroy_renderer(renderer: RendererResource,alternate_screen: bool,split_height: u32) void{
      c.destroyRenderer(renderer.unpack(),alternate_screen,split_height);
    }

  """
  
  def lib_path(),do: elem(@lib,1) 
  def include_dir_path(),do: elem(@header,1) 

  
end
