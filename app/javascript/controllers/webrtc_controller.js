import { Controller } from "@hotwired/stimulus"
import Connection from "./webrtc_connection"
import createWebrtcChannel from '../channels/webrtc_channel'

export default class extends Controller {
  static targets = [ "main", "remote", "mute" ]

  constructor(props) {
    super(props)
    this.connection = new Connection
    this.connection.remoteStreamTarget = this.remoteTarget
    this.channel = createWebrtcChannel("my-room", this.connection)
  }

  getUserMedia() {
    navigator.mediaDevices.getUserMedia({
      audio: true,
      video: true
    }).then((stream) => {
      this.connection.localStream = stream
      this.mainTarget.srcObject = stream
      this.channel.send({type: "TOKEN"})
    })
  }

  joinRoom() {
    this.connection.loadStream()
    this.connection.createOffer()
  }

  toggleMute() {
    const audioTrack = this.connection.localStream.getAudioTracks()[0];
  if (audioTrack) {
    audioTrack.enabled = !audioTrack.enabled; // Toggle mute/unmute
    console.log(audioTrack.enabled ? "Unmuted" : "Muted");
    this.muteTarget.innerText = audioTrack.enabled ? "Mute" : "Unmute";
  }
  }
}
