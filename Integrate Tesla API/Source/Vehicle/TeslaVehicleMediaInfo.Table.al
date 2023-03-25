table 60207 "Tesla Vehicle Media Info"
{
    Caption = 'Tesla Vehicle Media Info';
    DataClassification = SystemMetadata;
    TableType = Temporary;
    Access = Internal;

    fields
    {
        field(1; ID; Text[20])
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
        }
        field(2; a2dp_source_name; Text[100])
        {
            Caption = 'A2DP Source Name';
            DataClassification = SystemMetadata;
        }
        field(3; audio_volume; Decimal)
        {
            Caption = 'Audio Volume';
            DataClassification = SystemMetadata;
        }
        field(4; audio_volume_increment; Decimal)
        {
            Caption = 'Audio Volume Increment';
            DataClassification = SystemMetadata;
        }
        field(5; audio_volume_max; Decimal)
        {
            Caption = 'Audio Volume Max';
            DataClassification = SystemMetadata;
        }
        field(6; media_playback_status; Text[20])
        {
            Caption = 'Media Playback Status';
            DataClassification = SystemMetadata;
        }
        field(7; now_playing_album; Text[100])
        {
            Caption = 'Now Playing Album';
            DataClassification = SystemMetadata;
        }
        field(8; now_playing_artist; Text[100])
        {
            Caption = 'Now Playing Artist';
            DataClassification = SystemMetadata;
        }
        field(9; now_playing_duration; Integer)
        {
            Caption = 'Now Playing Duration';
            DataClassification = SystemMetadata;
        }
        field(10; now_playing_elapsed; Integer)
        {
            Caption = 'Now Playing Elapsed';
            DataClassification = SystemMetadata;
        }
        field(11; now_playing_source; Integer)
        {
            Caption = 'Now Playing Source';
            DataClassification = SystemMetadata;
        }
        field(12; now_playing_station; Text[100])
        {
            Caption = 'Now Playing Station';
            DataClassification = SystemMetadata;
        }
        field(13; now_playing_title; Text[100])
        {
            Caption = 'Now Playing Title';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}
