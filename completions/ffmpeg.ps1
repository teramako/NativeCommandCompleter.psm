<#
 # ffmpeg completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    ffmpeg                          = video converter
    input_file                      = Input file
    output_file                     = Output file
    overwrite                       = Overwrite output files without asking
    no_overwrite                    = Do not overwrite output files
    codec                           = Set codec (copy to copy stream)
    codec_audio                     = Set audio codec
    codec_video                     = Set video codec
    codec_subtitle                  = Set subtitle codec
    codec_data                      = Set data codec
    filter                          = Set stream filtergraph
    filter_audio                    = Set audio filtergraph
    filter_video                    = Set video filtergraph
    filter_complex                  = Create a complex filtergraph
    bitrate                         = Set bitrate
    bitrate_audio                   = Set audio bitrate
    bitrate_video                   = Set video bitrate
    frames                          = Set number of frames to output
    frames_audio                    = Set number of audio frames to output
    frames_video                    = Set number of video frames to output
    quality                         = Set quality (codec-specific)
    quality_audio                   = Set audio quality
    quality_video                   = Set video quality
    format                          = Force format
    input_format                    = Force input format
    sample_format                   = Set sample format
    sample_rate                     = Set sample rate
    channels                        = Set number of audio channels
    channel_layout                  = Set channel layout
    video_size                      = Set frame size
    pixel_format                    = Set pixel format
    frame_rate                      = Set frame rate
    aspect_ratio                    = Set aspect ratio
    video_sync                      = Video sync method
    audio_sync                      = Audio sync method
    start_time                      = Set start time offset
    duration                        = Limit the duration of data read from input
    timestamp                       = Set the recording timestamp
    metadata                        = Set metadata
    disposition                     = Set disposition
    program                         = Add program with specified streams
    target                          = Specify target file type
    shortest                        = Finish encoding when the shortest input stream ends
    accurate_seek                   = Enable accurate seeking
    seek_timestamp                  = Enable seeking by timestamp
    thread_queue_size               = Set the maximum number of queued packets
    stream_loop                     = Set number of times input stream shall be looped
    loop_output                     = Number of times to loop output
    map                             = Set input stream mapping
    map_chapters                    = Set chapters mapping
    map_metadata                    = Set metadata information of outfile from infile
    threads                         = Set number of threads
    preset                          = Set preset
    stats                           = Print progress report during encoding
    progress                        = Write program-readable progress information
    stdin                           = Enable stdin interaction
    debug                           = Print specific debug info
    benchmark                       = Add timings for benchmarking
    benchmark_all                   = Add timings for each task
    timelimit                       = Set max runtime in seconds
    dump                            = Dump each input packet
    hex                             = Dump packets as hex
    re                              = Read input at native frame rate
    stream_group                    = Add stream group
    dcodec                          = Alias for -codec:d
    acodec                          = Alias for -codec:a
    vcodec                          = Alias for -codec:v
    scodec                          = Alias for -codec:s
    dn                              = Disable data stream
    an                              = Disable audio stream
    vn                              = Disable video stream
    sn                              = Disable subtitle stream
    pass                            = Select the pass number (1 or 2)
    passlogfile                     = Select two pass log file name prefix
    vstats                          = Dump video coding statistics to file
    vstats_file                     = Dump video coding statistics to file
    vstats_version                  = Version of vstats format
    hide_banner                     = Do not show program banner
    loglevel                        = Set logging level
    report                          = Generate a report
    max_alloc                       = Set maximum size of single allocated block
    cpuflags                        = Force specific CPU flags
    cpucount                        = Force specific CPU count
    help                            = Show help
    version                         = Show version
    formats                         = Show available formats
    devices                         = Show available devices
    codecs                          = Show available codecs
    decoders                        = Show available decoders
    encoders                        = Show available encoders
    bsfs                            = Show available bit stream filters
    protocols                       = Show available protocols
    filters                         = Show available filters
    pix_fmts                        = Show available pixel formats
    layouts                         = Show standard channel layouts
    sample_fmts                     = Show available audio sample formats
    dispositions                    = Show available stream dispositions
    colors                          = Show available color names
    sources                         = List sources of input device
    sinks                           = List sinks of output device
    hwaccels                        = Show available HW acceleration methods
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

Register-NativeCompleter -Name ffmpeg -Description $msg.ffmpeg -Style Unix -Parameters @(
    # Main options
    New-ParamCompleter -OldStyleName f -Description $msg.format -Type Required -VariableName 'fmt'
    New-ParamCompleter -OldStyleName i -Description $msg.input_file -Type File -VariableName 'input'
    New-ParamCompleter -OldStyleName y -Description $msg.overwrite
    New-ParamCompleter -OldStyleName n -Description $msg.no_overwrite
    
    # Codec options
    New-ParamCompleter -OldStyleName c -Description $msg.codec -Type Required -VariableName 'codec'
    New-ParamCompleter -OldStyleName codec -Description $msg.codec -Type Required -VariableName 'codec'
    New-ParamCompleter -OldStyleName acodec -Description $msg.acodec -Type Required -VariableName 'codec'
    New-ParamCompleter -OldStyleName vcodec -Description $msg.vcodec -Type Required -VariableName 'codec'
    New-ParamCompleter -OldStyleName scodec -Description $msg.scodec -Type Required -VariableName 'codec'
    New-ParamCompleter -OldStyleName dcodec -Description $msg.dcodec -Type Required -VariableName 'codec'
    
    # Bitrate options
    New-ParamCompleter -OldStyleName b -Description $msg.bitrate -Type Required -VariableName 'bitrate'
    New-ParamCompleter -OldStyleName ab -Description $msg.bitrate_audio -Type Required -VariableName 'bitrate'
    New-ParamCompleter -OldStyleName vb -Description $msg.bitrate_video -Type Required -VariableName 'bitrate'
    
    # Filter options
    New-ParamCompleter -OldStyleName filter -Description $msg.filter -Type Required -VariableName 'filtergraph'
    New-ParamCompleter -OldStyleName af -Description $msg.filter_audio -Type Required -VariableName 'filtergraph'
    New-ParamCompleter -OldStyleName vf -Description $msg.filter_video -Type Required -VariableName 'filtergraph'
    New-ParamCompleter -OldStyleName filter_complex -Description $msg.filter_complex -Type Required -VariableName 'filtergraph'
    
    # Frame options
    New-ParamCompleter -OldStyleName frames -Description $msg.frames -Type Required -VariableName 'number'
    New-ParamCompleter -OldStyleName r -Description $msg.frame_rate -Type Required -VariableName 'rate'
    New-ParamCompleter -OldStyleName s -Description $msg.video_size -Type Required -VariableName 'size'
    New-ParamCompleter -OldStyleName aspect -Description $msg.aspect_ratio -Type Required -VariableName 'aspect'
    New-ParamCompleter -OldStyleName pix_fmt -Description $msg.pixel_format -Type Required -VariableName 'format'
    
    # Audio options
    New-ParamCompleter -OldStyleName ar -Description $msg.sample_rate -Type Required -VariableName 'rate'
    New-ParamCompleter -OldStyleName ac -Description $msg.channels -Type Required -VariableName 'channels'
    New-ParamCompleter -OldStyleName sample_fmt -Description $msg.sample_format -Type Required -VariableName 'format'
    New-ParamCompleter -OldStyleName channel_layout -Description $msg.channel_layout -Type Required -VariableName 'layout'
    
    # Quality options
    New-ParamCompleter -OldStyleName q -Description $msg.quality -Type Required -VariableName 'quality'
    New-ParamCompleter -OldStyleName qscale -Description $msg.quality -Type Required -VariableName 'quality'
    
    # Time options
    New-ParamCompleter -OldStyleName ss -Description $msg.start_time -Type Required -VariableName 'position'
    New-ParamCompleter -OldStyleName t -Description $msg.duration -Type Required -VariableName 'duration'
    New-ParamCompleter -OldStyleName to -Description $msg.duration -Type Required -VariableName 'position'
    New-ParamCompleter -OldStyleName timestamp -Description $msg.timestamp -Type Required -VariableName 'date'
    
    # Metadata options
    New-ParamCompleter -OldStyleName metadata -Description $msg.metadata -Type Required -VariableName 'key=value'
    New-ParamCompleter -OldStyleName disposition -Description $msg.disposition -Type Required -VariableName 'value'
    New-ParamCompleter -OldStyleName program -Description $msg.program -Type Required -VariableName 'title=program'
    
    # Stream selection
    New-ParamCompleter -OldStyleName map -Description $msg.map -Type Required -VariableName 'stream'
    New-ParamCompleter -OldStyleName map_chapters -Description $msg.map_chapters -Type Required -VariableName 'input'
    New-ParamCompleter -OldStyleName map_metadata -Description $msg.map_metadata -Type Required -VariableName 'spec'
    
    # Stream disable
    New-ParamCompleter -OldStyleName an -Description $msg.an
    New-ParamCompleter -OldStyleName vn -Description $msg.vn
    New-ParamCompleter -OldStyleName sn -Description $msg.sn
    New-ParamCompleter -OldStyleName dn -Description $msg.dn
    
    # Advanced options
    New-ParamCompleter -OldStyleName threads -Description $msg.threads -Type Required -VariableName 'count'
    New-ParamCompleter -OldStyleName preset -Description $msg.preset -Type Required -VariableName 'preset'
    New-ParamCompleter -OldStyleName target -Description $msg.target -Type Required -VariableName 'type'
    New-ParamCompleter -OldStyleName pass -Description $msg.pass -Type Required -VariableName 'n'
    New-ParamCompleter -OldStyleName passlogfile -Description $msg.passlogfile -Type File -VariableName 'prefix'
    New-ParamCompleter -OldStyleName shortest -Description $msg.shortest
    New-ParamCompleter -OldStyleName accurate_seek -Description $msg.accurate_seek
    New-ParamCompleter -OldStyleName seek_timestamp -Description $msg.seek_timestamp
    New-ParamCompleter -OldStyleName thread_queue_size -Description $msg.thread_queue_size -Type Required -VariableName 'size'
    New-ParamCompleter -OldStyleName stream_loop -Description $msg.stream_loop -Type Required -VariableName 'count'
    New-ParamCompleter -OldStyleName loop -Description $msg.loop_output -Type Required -VariableName 'count'
    
    # Sync options
    New-ParamCompleter -OldStyleName vsync -Description $msg.video_sync -Type Required -VariableName 'method'
    New-ParamCompleter -OldStyleName async -Description $msg.audio_sync -Type Required -VariableName 'samples'
    
    # Format options
    New-ParamCompleter -OldStyleName fmt -Description $msg.input_format -Type Required -VariableName 'format'
    
    # Statistics and logging
    New-ParamCompleter -OldStyleName stats -Description $msg.stats
    New-ParamCompleter -OldStyleName progress -Description $msg.progress -Type Required -VariableName 'url'
    New-ParamCompleter -OldStyleName stdin -Description $msg.stdin
    New-ParamCompleter -OldStyleName debug -Description $msg.debug -Type Required -VariableName 'flags'
    New-ParamCompleter -OldStyleName loglevel -Description $msg.loglevel -Type Required -VariableName 'level'
    New-ParamCompleter -OldStyleName report -Description $msg.report
    New-ParamCompleter -OldStyleName vstats -Description $msg.vstats
    New-ParamCompleter -OldStyleName vstats_file -Description $msg.vstats_file -Type File -VariableName 'file'
    New-ParamCompleter -OldStyleName vstats_version -Description $msg.vstats_version -Type Required -VariableName 'version'
    
    # Benchmark options
    New-ParamCompleter -OldStyleName benchmark -Description $msg.benchmark
    New-ParamCompleter -OldStyleName benchmark_all -Description $msg.benchmark_all
    New-ParamCompleter -OldStyleName timelimit -Description $msg.timelimit -Type Required -VariableName 'duration'
    
    # Debug options
    New-ParamCompleter -OldStyleName dump -Description $msg.dump
    New-ParamCompleter -OldStyleName hex -Description $msg.hex
    
    # Other options
    New-ParamCompleter -OldStyleName re -Description $msg.re
    New-ParamCompleter -OldStyleName stream_group -Description $msg.stream_group -Type Required -VariableName 'spec'
    New-ParamCompleter -OldStyleName max_alloc -Description $msg.max_alloc -Type Required -VariableName 'bytes'
    New-ParamCompleter -OldStyleName cpuflags -Description $msg.cpuflags -Type Required -VariableName 'flags'
    New-ParamCompleter -OldStyleName cpucount -Description $msg.cpucount -Type Required -VariableName 'count'
    
    # Display options
    New-ParamCompleter -OldStyleName hide_banner -Description $msg.hide_banner
    New-ParamCompleter -OldStyleName h -Description $msg.help -Type FlagOrValue -VariableName 'topic'
    New-ParamCompleter -OldStyleName version -Description $msg.version
    New-ParamCompleter -OldStyleName formats -Description $msg.formats
    New-ParamCompleter -OldStyleName devices -Description $msg.devices
    New-ParamCompleter -OldStyleName codecs -Description $msg.codecs
    New-ParamCompleter -OldStyleName decoders -Description $msg.decoders
    New-ParamCompleter -OldStyleName encoders -Description $msg.encoders
    New-ParamCompleter -OldStyleName bsfs -Description $msg.bsfs
    New-ParamCompleter -OldStyleName protocols -Description $msg.protocols
    New-ParamCompleter -OldStyleName filters -Description $msg.filters
    New-ParamCompleter -OldStyleName pix_fmts -Description $msg.pix_fmts
    New-ParamCompleter -OldStyleName layouts -Description $msg.layouts
    New-ParamCompleter -OldStyleName sample_fmts -Description $msg.sample_fmts
    New-ParamCompleter -OldStyleName dispositions -Description $msg.dispositions
    New-ParamCompleter -OldStyleName colors -Description $msg.colors
    New-ParamCompleter -OldStyleName sources -Description $msg.sources -Type Required -VariableName 'device'
    New-ParamCompleter -OldStyleName sinks -Description $msg.sinks -Type Required -VariableName 'device'
    New-ParamCompleter -OldStyleName hwaccels -Description $msg.hwaccels
)
