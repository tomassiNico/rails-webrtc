class WebrtcChannel < ApplicationCable::Channel
  def subscribed
    stream_from room_name
  end

  def receive(data)
    case data["type"]
    when "OFFER", "ANSWER", "CANDIDATE"
      ActionCable.server.broadcast(room_name, data)
    when "TOKEN"
      # servers = TwilioClient.instance.tokens.create.ice_servers

      ActionCable.server.broadcast(room_name, { type: "TOKEN", servers: [ # TODO: this servers should be changed in prod
        { urls: "stun:stun.l.google.com:19302" },
        { urls: "stun:stun.l.google.com:5349" },
        { urls: "stun:stun1.l.google.com:3478" },
        { urls: "stun:stun1.l.google.com:5349" },
        { urls: "stun:stun2.l.google.com:19302" },
        { urls: "stun:stun2.l.google.com:5349" },
        { urls: "stun:stun3.l.google.com:3478" },
        { urls: "stun:stun3.l.google.com:5349" },
        { urls: "stun:stun4.l.google.com:19302" },
        { urls: "stun:stun4.l.google.com:5349" }
      ] })
    else
      puts "Unknown signal type: #{data['type']}"
    end
  end

  def room_name
    "webrtc_channel_#{params[:name]}"
  end
end
