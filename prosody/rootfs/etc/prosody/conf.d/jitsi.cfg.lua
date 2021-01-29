VirtualHost "auth.meet.jitsi"
ssl = {
        key = "/etc/prosody/certs/auth.meet.jitsi.key";
        certificate = "/etc/prosody/certs/auth.meet.jitsi.crt";
    }
    authentication = "internal_plain"

VirtualHost "recorder.meet.jitsi"
  modules_enabled = {
	  "ping";
  }
Component "internal-muc.meet.jitsi" "muc"
    storage = "memory"
    modules_enabled = {
        "ping";
    }
    muc_room_locking = false
    muc_room_default_public_jids = true
Component "muc.meet.jitsi" "muc"
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
    }
    muc_room_locking = false
    muc_room_default_public_jids = true


Component "speakerstats.meet.jitsi" "speakerstats_component"
    muc_component = "muc.meet.jitsi"

Component "conferenceduration.meet.jitsi" "conference_duration_component"
    muc_component = "muc.meet.jitsi"

Component "lobby.meet.jitsi" "muc"
    storage = "memory"
    restrict_room_creation = true
    muc_room_locking = false
    muc_room_default_public_jids = true

