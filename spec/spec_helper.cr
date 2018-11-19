require "spec"
require "../src/simple_rpc"

record Bla, x : String, y : Hash(String, Int32) { include MessagePack::Serializable }

class SpecProto
  include SimpleRpc::Proto

  def bla(x : String, y : Float64) : Float64
    x.to_f * y
  end

  def complex(a : Int32) : Bla
    h = Hash(String, Int32).new
    a.times do |i|
      h["_#{i}_"] = i
    end

    Bla.new(a.to_s, h)
  end

  def sleepi(v : Float64) : Nil
    sleep(v)
    nil
  end

  def no_args : Int32
    0
  end

  def with_default_value(x : Int32 = 1) : Int32
    x + 1
  end
end

class SpecProto2
  include SimpleRpc::Proto

  def bla(x : Float64, y : String) : Float64
    x * y.to_f
  end

  def zip : Nil
  end
end

spawn do
  SpecProto::Server.new("127.0.0.1", 8888).run
end

sleep 0.1
CLIENT     = SpecProto::Client.new("127.0.0.1", 8888)
CLIENT_BAD = SpecProto::Client.new("127.0.0.1", 8889)
CLIENT2    = SpecProto2::Client.new("127.0.0.1", 8888)
