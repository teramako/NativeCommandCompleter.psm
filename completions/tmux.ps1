<#
 # tmux completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    tmux_support256color             = Force tmux to assume the terminal supports 256 colours
    tmux_control                     = Start in control mode
    tmux_command                     = Execute shell-command using the default shell.
    tmux_noDaemon                    = Do not start the tmux server as a daemon.
    tmux_configFile                  = Specify  an alternative configuration file.
    tmux_socketName                  = Specify socket name
    tmux_loginShell                  = Behave as a login shell.
    tmux_noServer                    = Do not start the server
    tmux_socketPath                  = Specify a full alternative path to the server socket.
    tmux_terminalFeatures            = Set terminal features for the client.
    tmux_utf8                        = Write UTF-8 output to the terminal
    tmux_version                     = Report the tmux version.
    tmux_verbose                     = Request verbose logging.

    targetSession                    = Specify target session
    targetClient                     = Specify target client
    targetWindow                     = Specify target window
    targetPane                       = Specify target pane
    format                           = The format of each line
    filter                           = Filter
    startingDirectory                = Set working directory
    _setEnvironment                   = Set environment
    height                           = Set height
    width                            = Set width
    title                            = Set title
    position_x                       = X axis position
    position_y                       = Y axis position
    promptType                       = Prompt type
    keyTable                         = Key table

    attachSession                    = attach to existing session
    attachSession_detach             = detach any other clients
    attachSession_sendSIGHUP         = Send SIGHUP to the parent process
    attachSession_flags              = Set client flags
    attachSession_readonly           = alias for -f read-only,ignore-size
    attachSession_ignoreUpdateEnv    = update-environment option will not be applied.
    detachClient                     = detach current client
    detachClient_all                 = Kill all
    detachClient_sendSIGHUP          = Send SIGHUP to the parent process
    detachClient_replaceClient       = run shell-command to replace the client
    hasSession                       = report error and exit with 1 if the session does not exist
    killServer                       = kill tmux server, clients, and sessions
    killSession                      = destroy session, close its windows, and detach all its clients
    listClients                      = list all attached clients
    listCommands                     = list syntax for all tmux commands
    listSessions                     = list all sessions
    lockClient                       = lock client
    lockSession                      = lock session
    newSession                       = create a new session with name session-name
    newSession_attach                = Attach if already exists
    newSession_detach                = new session with detached
    newSession_detach_with_A         = with -A, behaves like -d to attach-session
    newSession_sendSIGHUP_with_A     = with -A, behaves like -x to attach-session
    newSession_ignoreUpdateEnv       = update-environment option will not be applied
    newSession_printInfo             = prints information
    newSession_flags                 = Set client flags
    newSession_windowName            = Set window name
    newSession_sessionName           = Set session name
    newSession_groupName             = Set group name
    newSession_width                 = Set window width
    newSession_height                = Set window height
    refreshClient                    = refresh client
    renameSession                    = rename session
    serverAccess                     = Change the access or read/write permission of user.
    showMessages                     = Show server messages or information.
    showMessages_jobs                = show debugging information about jobs
    showMessages_terminals           = show debugging information about terminals
    sourceFile                       = execute commands from path
    sourceFile_format                = expand <path> as a format
    sourceFile_quiet                 = no error even if <path> doesn't exist
    sourceFile_noExecuteCommands     = no execute commands
    sourceFile_verbose               = show the parsed commands and line numbers
    startServer                      = start tmux server if not running; do not create a session
    suspendClient                    = send SIGTSTP signal to client (tty stop)
    switchClient                     = Switch the current session for client target-client to target-session
    switchClient_ignoreUpdateEnv     = update-environment option will not be applied
    switchClient_moveToLast          = the client is moved to the last
    switchClient_moveToNext          = the client is moved to the next
    switchClient_moveToPrevious      = the client is moved to the previous
    switchClient_toggleReadOnly      = toggles the client read-only and ignore-size flags
    switchClient_keepZoom            = keeps the window zoomed if it was zoomed

    breakPane                        = break pane off into a new window
    breakPane_after                  = move the window to the next index after
    breakPane_before                 = move the window to the next index before
    breakPane_dontBeCurrent          = the new window does not become the current window
    breakPane_print                  = prints information about the new window
    breakPane_name                   = Set window name
    breakPane_srcPane                = Source pane to be moved
    breakPane_dstWindow              = Destination window
    capturePane                      = capture contents of a pane into a buffer
    capturePane_altScreen            = capture alternate screen
    capturePane_quiet                = Quiet even if alternate screen doesn't exist
    capturePane_print                = output to stdout
    capturePane_escapeSequence       = include color escapes
    capturePane_printOctal           = escape non-printable chars
    capturePane_ignoreTailing        = Ignore trailing positions that do not contain a character
    capturePane_preserveTailingSpace = Preserves trailing spaces
    capturePane_join                 = -P and joins any wrapped lines
    capturePane_buffer               = Specify buffer name
    capturePane_end                  = ending line number
    capturePane_start                = starting line number
    chooseClient                     = interactively choose client
    chooseTree                       = interactively choose session/window/pane
    customizeMode                    = interactively customize settings
    displayPanes                     = display a visible indicator for each pane
    displayPanes_dontBlock           = not blocked from running until the indicator is closed
    displayPanes_dontClose           = Don't close the indicator
    displayPanes_duration            = duration milliseconds
    findWindow                       = interactively choose window matching pattern
    joinPane                         = split destination pane and move source pane into one of the halves
    joinPane_srcPane                 = pane to move
    joinPane_dstPane                 = pane to be moved
    killPane                         = destroy a pane
    killPane_all                     = kills all
    killWindow                       = destroy a window
    killWindow_all                   = kills all
    lastPane                         = select the previously selected pane
    lastWindow                       = select the previously selected window
    linkWindow                       = link source window to destination window
    listPanes                        = list panes
    listPanes_all                    = show all
    listPanes_session                = list as session
    listWindows                      = list windows
    listWindows_all                  = show all
    moveWindow                       = move window
    newWindow                        = create a new window
    newWindow_name                   = Window name
    nextLayout                       = rearrange panes in a window according to the next layout
    nextWindow                       = move to the next window in the session
    pipePane                         = pipe output from pane to a shell command
    previousLayout                   = rearrange panes in a window according to the previous layout
    renameWindow                     = rename a window
    resizePane                       = resize a pane
    resizePane_mouse                 = begin mouse resize
    resizePane_trim                  = trim below cursor
    resizeWindow                     = resize a window
    respawnPane                      = reactivate a pane where a command exited
    respawnWindow                    = reactivate a window where a command exited
    rotateWindow                     = rotate panes within a window
    selectLayout                     = rearrange panes according to a given layout
    selectPane                       = activate specific pane
    selectWindow                     = activate specific window
    splitWindow                      = create a new pane by splitting target-pane
    swapPane                         = swap two panes
    swapPane_src                     = source pane
    swapPane_dst                     = dest pane
    swapWindow                       = swap two windows
    swapWindow_src                   = source window
    swapWindow_dst                   = dest window
    unlinkWindow                     = unlink target-window

    bindKey                          = bind key to command
    bindKey_nonPrefix                = make the binding work without using a prefix key
    bindKey_repeat                   = key may repeat
    listKeys                         = list all key bindings
    listKeys_onlyFirstKey            = lists only the first matching key.
    listKeys_prefix                  = print prefix-string before each key
    sendKeys                         = send key or event
    sendPrefix                       = send the prefix key
    unbindKey                        = unbind the command bound to key
    unbindKey_all                    = remove all key bindings
    unbindKey_nonPrefix              = command bound to key without a prefix (if any) removed

    option_paneOption                = Pane option
    option_windowOption              = Window option
    option_serverOption              = Server option
    option_globalOption              = Global option
    setOption                        = Set or unset option
    setOption_expandFormat           = Expand format
    setOption_unsetOption            = Unset option
    setOption_unsetOption2           = Unset option, also in child panes
    setOption_preventOverride        = Prevent override
    setOption_quiet                  = Suppress ambiguous option errors
    setOption_append                 = Append
    showOptions                      = Show set options
    showOptions_inheritedOptions     = Include inherited options
    showOptions_hooks                = Include hooks
    showOptions_quiet                = No error if unset
    showOptions_value                = Only show value

    environment_global               = global environment
    setEnvironment                   = Set or unset an environment variable
    setEnvironment_expandFormat      = expand as format
    setEnvironment_hide              = marks as hidden
    setEnvironment_remove            = remove from environment before starting a new process
    setEnvironment_unset             = unset variable
    showEnvironment                  = Show environemnt variables
    showEnvironment_shell            = show as Bourne shell format

    clearPromptHistory               = Clear status prompt history
    commandPrompt                    = Open the command prompt in a client
    commandPrompt_input              = Comma-separated list of initial text for each prompt
    commandPrompt_prompt             = Comma-separated list of prompts
    commandPrompt_type               = Prompt type
    confirmBefore                    = Ask for confirmation before executing command
    confirmBefore_char               = change the confirmation key (default: 'y')
    confirmBefore_prompt             = Prompt text
    displayMenu                      = Display a menu
    displayMenu_border               = drawing menu borders
    displayMenu_title                = Set title
    displayMessage                   = Display a message
    displayMessage_print             = print to stdout
    displayMessage_delay             = override display-time, 0 means waits for a key press
    displayPopup                     = Display a popup
    displayPopup_exit                = closes the popup automatically
    showPromptHistory                = Display status prompt history

    chooseBuffer                     = interactively choose buffer
    clearHistory                     = forget history for a pane
    clearHistory_hyperlinks          = removes all hyperlinks
    deleteBuffer                     = delete buffer
    listBuffers                      = list buffers
    loadBuffer                       = load buffer from path, use - for stdin
    loadBuffer_clipboard             = also sent to the clipboard
    pasteBuffer                      = paste buffer to pane
    pasteBuffer_delete               = delete the paste buffer
    saveBuffer                       = save buffer to path
    saveBuffer_append                = appends to rather than overwriting the file.
    setBuffer                        = set buffer to value
    showBuffer                       = print buffer to stdout

    clockMode                        = Display a large clock
    ifShell                          = Execute the first command if shell-command returns success or the second command otherwise.
    _runBackground                   = run in the background
    runShell                         = Execute shell-command
    runShell_delay                   = waits for delay seconds before execute
    runShell_redirectError           = redirect stderr to stdout
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$sessionCompleter = {
    tmux list-sessions -F "#S:#I `t#S #W#{?window_active,*, }" | Where-Object { $_ -like "$wordToComplete*" }
}
$clientCompleter = {
    tmux list-clients -F "#{client_tty} `t#{client_session}" | Where-Object { $_ -like "$wordToComplete*" }
}
$windowCompleter = {
    tmux list-windows -F "#I`t#W #{?window_active, *,}#{?window_marked_flag, M,}#{?window_zoomed_flag, Z,}" 2>/dev/null | Where-Object { $_ -like "$wordToComplete*" }
}
$paneCompleter = {
    $detail = '#{=/15/...:pane_title}#{?pane_marked, <marked>,}#{?window_active, <active #{?pane_active,pane,win.}>,}'
    @(
        tmux list-panes -F "#P`t#D $detail" 2>/dev/null
        tmux list-panes -s -F "#I.#P`t#D $detail" 2>/dev/null
        tmux list-panes -s -F "#D`t#I.#P $detail" 2>/dev/null
    ) | Where-Object { $_ -like "$wordToComplete*" }
}
$bufferCompleter = {
    tmux list-buffers -F "#{buffer_name}`t#{buffer_sample}" 2>/dev/null | Where-Object { $_ -like "$wordToComplete*" }
}
$optionCompleter = {
    param([int] $postion, [int] $argIndex)
    if ($argIndex -eq 0)
    {
        @(
            "backspace", "buffer-limit", "command-alias", "default-terminal", "copy-command", "escape-time", "editor", "exit-empty", "exit-unattached",
            "extended-keys", "focus-events", "history-file", "message-limit", "prompt-history-limit", "set-clipboard", "terminal-features", "terminal-overrides",
            "user-keys", "activity-action", "assume-paste-time", "base-index", "bell-action", "default-command", "default-shell", "default-size",
            "destroy-unattached", "detach-on-destroy", "display-panes-active-colour", "display-panes-colour", "display-panes-time", "display-time",
            "history-limit", "key-table", "lock-after-time", "lock-command", "message-command-style", "message-style", "mouse", "prefix", "renumber-windows",
            "repeat-time", "set-titles", "set-titles-string", "silence-action", "status", "status-format", "status-interval", "status-justify", "status-keys",
            "status-left", "status-left-length", "status-left-style", "status-position", "status-right", "status-right-length", "status-right-style", "status-style",
            "update-environment", "visual-activity", "visual-bell", "visual-silence", "word-separators", "aggressive-resize", "automatic-rename",
            "automatic-rename-format", "clock-mode-colour", "clock-mode-style", "fill-character", "main-pane-height", "main-pane-width", "copy-mode-match-style",
            "copy-mode-mark-style", "copy-mode-current-match-style", "mode-keys", "mode-style", "monitor-activity", "monitor-bell", "monitor-silence", "other-pane-height",
            "other-pane-width", "pane-active-border-style", "pane-base-index", "pane-border-format", "pane-border-indicators", "pane-border-lines", "pane-border-status",
            "pane-border-style", "popup-style", "popup-border-style", "popup-border-lines", "window-status-activity-style", "window-status-bell-style",
            "window-status-current-format", "window-status-current-style", "window-status-format", "window-status-last-style", "window-status-separator",
            "window-status-style", "window-size", "wrap-search", "allow-passthrough", "allow-rename", "alternate-screen", "cursor-colour", "pane-colours", "cursor-style",
            "remain-on-exit", "remain-on-exit-format", "scroll-on-clear", "synchronize-panes", "window-active-style", "window-style"
        ) | Where-Object { $_ -like "$wordToComplete*" }
    }
}
$promptTypes = "command", "search", "target", "window-target"
$terminalFeatures = @(
    "256`tSupports 256 colours",
    "clipboard`tAllows setting the system clipboard.",
    "ccolour`tAllows setting the cursor colour.",
    "cstyle`tAllows setting the cursor style.",
    "extkeys`tSupports extended keys.",
    "focus`tSupports focus reporting.",
    "hyperlinks`tSupports OSC 8 hyperlinks.",
    "ignorefkeys`tIgnore function keys from terminfo(5)",
    "margins`tSupports DECSLRM margins.",
    "mouse`tSupports xterm(1) mouse sequences.",
    "osc7`tSupports the OSC 7 working directory extension.",
    "overline`tSupports the overline SGR attribute.",
    "rectfill`tSupports the DECFRA rectangle fill escape sequence.",
    "RGB`tSupports RGB colour with the SGR escape sequences.",
    "sixel`tSupports SIXEL graphics.",
    "strikethrough`tSupports the strikethrough SGR escape sequence.",
    "sync`tSupports synchronized updates.",
    "title`tSupports xterm(1) title setting.",
    "usstyle`tAllows underscore style and colour to be set."
)

$formatParam = New-ParamCompleter -ShortName F -Description $msg.format -Type Required -VariableName 'format'
$filterParam = New-ParamCompleter -ShortName f -Description $msg.filter -Type Required
$startingDirectoryParam_c = New-ParamCompleter -ShortName c -Description $msg.startingDirectory -Type Directory -VariableName 'start-directory'
$startingDirectoryParam_d = New-ParamCompleter -ShortName d -Description $msg.startingDirectory -Type Directory -VariableName 'start-directory'
$setEnvironmentParam = New-ParamCompleter -ShortName e -Description $msg._setEnvironment -Type Required -VariableName 'VARIABLE=name'
$targetClientParam = New-ParamCompleter -ShortName t -Description $msg.targetClient -VariableName 'target-client' -ArgumentCompleter $clientCompleter
$targetClientParam_c = New-ParamCompleter -ShortName c -Description $msg.targetClient -VariableName 'target-client' -ArgumentCompleter $clientCompleter
$targetSessionParam = New-ParamCompleter -ShortName t -Description $msg.targetSession -VariableName 'target-session' -ArgumentCompleter $sessionCompleter
$targetWindowParam = New-ParamCompleter -ShortName t -Description $msg.targetWindow -VariableName 'target-window' -ArgumentCompleter $windowCompleter
$targetPaneParam = New-ParamCompleter -ShortName t -Description $msg.targetPane -VariableName 'target-pane' -ArgumentCompleter $paneCompleter
$bufferNameParam = New-ParamCompleter -ShortName b -Description $msg.bufferName -VariableName 'buffer-name' -ArgumentCompleter $bufferCompleter
$promptTypeParam = New-ParamCompleter -ShortName T -Description $msg.promptType -VariableName 'prompt-type' -Arguments $promptTypes
$keyTableParam = New-ParamCompleter -ShortName T -Description $msg.keyTable -Type Required -VariableName 'key-table'

Register-NativeCompleter -Name tmux -Parameters @(
    New-ParamCompleter -ShortName '2' -Description $msg.tmux_support256color
    New-ParamCompleter -ShortName C -Description $msg.tmux_control
    New-ParamCompleter -ShortName c -Description $msg.tmux_command -Type Required -VariableName 'shell-command'
    New-ParamCompleter -ShortName D -Description $msg.tmux_noDaemon
    New-ParamCompleter -ShortName f -Description $msg.tmux_configFile -Type File -VariableName 'file'
    New-ParamCompleter -ShortName L -Description $msg.tmux_socketName -Type Required -VariableName 'socket-name'
    New-ParamCompleter -ShortName l -Description $msg.tmux_loginShell
    New-ParamCompleter -ShortName N -Description $msg.tmux_noServer
    New-ParamCompleter -ShortName S -Description $msg.tmux_socketPath -Type Directory -VariableName 'socket-path'
    New-ParamCompleter -ShortName T -Description $msg.tmux_terminalFeatures -Type List -Arguments $terminalFeatures
    New-ParamCompleter -ShortName u -Description $msg.tmux_utf8
    New-ParamCompleter -ShortName V -Description $msg.tmux_version
    New-ParamCompleter -ShortName v -Description $msg.tmux_verbose
) -SubCommands @(
    #
    # CLIENTS AND SESSIONS
    #

    # attach-session
    New-CommandCompleter -Name attach-session -Aliases attach -Description $msg.attachSession -Parameters @(
        New-ParamCompleter -ShortName d -Description $msg.attachSession_detach
        New-ParamCompleter -ShortName x -Description $msg.attachSession_sendSIGHUP
        New-ParamCompleter -ShortName f -Description $msg.attachSession_flags -Type List -Arguments @(
            "active-pane"
            "ignore-size"
            "no-output"
            "pause-after="
            "read-only"
            "wait-exit"
        )
        New-ParamCompleter -ShortName r -Description $msg.attachSession_readonly
        New-ParamCompleter -ShortName E -Description $msg.attachSession_ignoreUpdateEnv
        $startingDirectoryParam_c
        $targetSessionParam
    ) -NoFileCompletions
    # detach-client
    New-CommandCompleter -Name detach-client -Aliases detach -Description $msg.detachClient -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.detachClient_all
        New-ParamCompleter -ShortName P -Description $msg.detachClient_sendSIGHUP
        New-ParamCompleter -ShortName E -Description $msg.detachClient_replaceClient -Type Required
        New-ParamCompleter -ShortName s -Description $msg.targetSession -ArgumentCompleter $sessionCompleter
        $targetClientParam
    ) -NoFileCompletions
    # has-session
    New-CommandCompleter -Name has-session -Aliases has -Description $msg.hasSession -Parameters @(
        $targetSessionParam
    ) -NoFileCompletions
    # kill-server
    New-CommandCompleter -Name kill-server -Description $msg.killServer -NoFileCompletions
    # kill-session
    New-CommandCompleter -Name kill-session -Description $msg.killSession -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.killSession_all
        New-ParamCompleter -ShortName C -Description $msg.killSession_clearAlerts
        $targetSessionParam
    ) -NoFileCompletions
    # list-clients
    New-CommandCompleter -Name list-clients -Aliases lsc -Description $msg.listClients -Parameters @(
        $formatParam
        $filterParam
        $targetSessionParam
    ) -NoFileCompletions
    # list-commands
    New-CommandCompleter -Name list-commands -Aliases lscm -Description $msg.listCommands -Parameters @(
        $formatParam
    ) -NoFileCompletions
    # list-sessions
    New-CommandCompleter -Name list-sessions -Aliases ls -Description $msg.listSessions -Parameters @(
        $formatParam
        $filterParam
    ) -NoFileCompletions
    # lock-client
    New-CommandCompleter -Name lock-client -Aliases lockc -Description $msg.lockClient -Parameters @(
        $targetClientParam
    ) -NoFileCompletions
    # lock-session
    New-CommandCompleter -Name lock-session -Aliases locks -Description $msg.lockSession -Parameters @(
        $targetSessionParam
    ) -NoFileCompletions
    # new-session
    New-CommandCompleter -Name new-session -Aliases new -Description $msg.newSession -Parameters @(
        New-ParamCompleter -ShortName A -Description $msg.newSession_attach
        New-ParamCompleter -ShortName d -Description $msg.newSession_detach
        New-ParamCompleter -ShortName D -Description $msg.newSession_detach_with_A
        New-ParamCompleter -ShortName X -Description $msg.newSession_sendSIGHUP_with_A
        New-ParamCompleter -ShortName E -Description $msg.newSession_ignoreUpdateEnv
        New-ParamCompleter -ShortName P -Description $msg.newSession_printInfo
        $startingDirectoryParam_c
        $setEnvironmentParam
        New-ParamCompleter -ShortName f -Description $msg.newSession_flags -Type List
        New-ParamCompleter -ShortName F -Description $msg.format
        New-ParamCompleter -ShortName n -Description $msg.newSession_windowName -Type Required
        New-ParamCompleter -ShortName s -Description $msg.newSession_sessionName -Type Required
        New-ParamCompleter -ShortName t -Description $msg.newSession_groupName -Type Required
        New-ParamCompleter -ShortName x -Description $msg.newSession_width -Type Required
        New-ParamCompleter -ShortName h -Description $msg.newSession_height -Type Required
    ) -NoFileCompletions
    # refresh-client
    New-CommandCompleter -name refresh-client -Aliases refresh -Description $msg.refreshClient -Parameters @(
        # TBD
    ) -NoFileCompletions
    # rename-session
    New-CommandCompleter -Name rename-session -Aliases rename -Description $msg.renameSession -Parameters @(
        $targetSessionParam
    ) -NoFileCompletions
    # server-access
    New-CommandCompleter -Name server-access -Description $msg.serverAccess -Parameters @(
        # TBD
    )
    # show-messages
    New-CommandCompleter -Name show-messages -Aliases showmsgs -Description $msg.showMessages -Parameters @(
        New-ParamCompleter -ShortName J -Description $msg.showMessages_jobs
        New-ParamCompleter -ShortName T -Description $msg.showMessages_terminals
        $targetClientParam
    )
    # source-file
    New-CommandCompleter -Name source-file -Aliases source -Description $msg.sourceFile -Parameters @(
        New-ParamCompleter -ShortName F -Description $msg.sourceFile_format
        New-ParamCompleter -ShortName n -Description $msg.sourceFile_noExecuteCommands
        New-ParamCompleter -ShortName q -Description $msg.sourceFile_quiet
        New-ParamCompleter -ShortName v -Description $msg.sourceFile_verbose
        New-ParamCompleter -ShortName t -Description $msg.targetPane -ArgumentCompleter {}
    )
    # start-server
    New-CommandCompleter -Name start-server -Aliases start -Description $msg.startServer -NoFileCompletions
    # suspend-client
    New-CommandCompleter -Name suspend-client -Aliases suspendc -Description $msg.suspendClient -Parameters $targetClientParam -NoFileCompletions
    # switch-client
    New-CommandCompleter -Name switch-client -Aliases switchc -Description $msg.switchClient -Parameters @(
        New-ParamCompleter -ShortName E -Description $msg.switchClient_ignoreUpdateEnv
        New-ParamCompleter -ShortName l -Description $msg.switchClient_moveToLast
        New-ParamCompleter -ShortName n -Description $msg.switchClient_moveToNext
        New-ParamCompleter -ShortName p -Description $msg.switchClient_moveToPrevious
        New-ParamCompleter -ShortName r -Description $msg.switchClient_toggleReadOnly
        New-ParamCompleter -ShortName Z -Description $msg.switchClient_keepZoom
        New-ParamCompleter -ShortName c -Description $msg.targetClient -VariableName 'target-client' -ArgumentCompleter $clientCompleter
        $targetSessionParam
    ) -NoFileCompletions

    #
    # WINDOWS AND PANES
    #

    # break-pane
    New-CommandCompleter -Name break-pane -Aliases breakp -Description $msg.breakPane -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.breakPane_after
        New-ParamCompleter -ShortName b -Description $msg.breakPane_before
        New-ParamCompleter -ShortName d -Description $msg.breakPane_doneBeCurrent
        New-ParamCompleter -ShortName P -Description $msg.breakPane_print
        $formatParam
        New-ParamCompleter -ShortName n -Description $msg.breakPane_name -Type Required -VariableName 'window-name'
        New-ParamCompleter -ShortName s -Description $msg.breakPane_srcPane -VariableName 'src-pane' -ArgumentCompleter $paneCompleter
        New-ParamCompleter -ShortName t -Description $msg.breakPane_dstWindow -VariableName 'dst-window' -ArgumentCompleter $windowCompleter
    ) -NoFileCompletions
    # capture-pane
    New-CommandCompleter -Name capture-pane -Aliases capturep -Description $msg.capturePane -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.capturePane_altScreen
        New-ParamCompleter -ShortName p -Description $msg.capturePane_print
        New-ParamCompleter -ShortName q -Description $msg.capturePane_quiet
        New-ParamCompleter -ShortName e -Description $msg.capturePane_escapeSequence
        New-ParamCompleter -ShortName C -Description $msg.capturePane_printOctal
        New-ParamCompleter -ShortName T -Description $msg.capturePane_ignoreTailing
        New-ParamCompleter -ShortName N -Description $msg.capturePane_preserveTailingSpace
        New-ParamCompleter -ShortName J -Description $msg.capturePane_join
        New-ParamCompleter -ShortName P
        New-ParamCompleter -ShortName b -Description $msg.capturePane_buffer -VariableName 'buffer-name' -Type Required
        New-ParamCompleter -ShortName E -Description $msg.capturePane_end -VariableName 'end-line' -Type Required
        New-ParamCompleter -ShortName S -Description $msg.capturePane_start -VariableName 'start-line' -Type Required
        $targetPaneParam
    ) -NoFileCompletions
    # choose-client
    New-CommandCompleter -Name choose-client -Description $msg.chooseClient -Parameters @(
        # TBD
        $formatParam
        $filterParam
        $targetPaneParam
    ) -NoFileCompletions
    # choose-tree
    New-CommandCompleter -Name choose-tree -Description $msg.chooseTree -Parameters @(
        # TBD
        $formatParam
        $filterParam
        $targetPaneParam
    ) -NoFileCompletions
    # customize-mode
    New-CommandCompleter -Name customize-mode -Description $msg.customizeMode -Parameters @(
        # TBD
        $formatParam
        $filterParam
        $targetPaneParam
    ) -NoFileCompletions
    # display-panes
    New-CommandCompleter -Name display-panes -Aliases displayp -Description $msg.displayPanes -Parameters @(
        # TBD
        New-ParamCompleter -ShortName b -Description $msg.displayPanes_dontBlock
        New-ParamCompleter -ShortName N -Description $msg.displayPanes_dontClose
        New-ParamCompleter -ShortName d -Description $msg.displayPanes_duration -Type Required -VariableName duration
        $targetClientParam
    ) -NoFileCompletions
    # find-window
    New-CommandCompleter -Name find-window -Aliases findw -Description $msg.findWindow -Parameters @(
        # TBD
        $targetPaneParam
    ) -NoFileCompletions
    # join-pane
    New-CommandCompleter -Name join-pane -Aliases joinp -Description $msg.joinPane -Parameters @(
        # TBD
        New-ParamCompleter -ShortName s -Description $msg.joinPane_srcPane -VariableName 'src-pane' -ArgumentCompleter $paneCompleter
        New-ParamCompleter -ShortName t -Description $msg.joinPane_dstPane -VariableName 'dst-pane' -ArgumentCompleter $paneCompleter
    ) -NoFileCompletions
    # kill-pane
    New-CommandCompleter -Name kill-pane -Aliases killp -Description $msg.killPane -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.killPane_all
        $targetPaneParam
    ) -NoFileCompletions
    # kill-window
    New-CommandCompleter -Name kill-window -Aliases killw -Description $msg.killWindow -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.killWindow_all
        $targetWindowParam
    ) -NoFileCompletions
    # last-pane
    New-CommandCompleter -Name last-pane -Aliases lastp -Description $msg.lastPane -Parameters @(
        # TBD
        $targetWindowParam
    ) -NoFileCompletions
    # last-window
    New-CommandCompleter -Name last-window -Aliases last -Description $msg.lastWindow -Parameters @(
        # TBD
        $targetWindowParam
    ) -NoFileCompletions
    # link-window
    New-CommandCompleter -Name link-window -Aliases linkw -Description $msg.linkWindow -Parameters @(
        # TBD
        New-ParamCompleter -ShortName s -Description $msg.linkWindow_srcWindow -VariableName 'src-window' -ArgumentCompleter $windowCompleter
        New-ParamCompleter -ShortName t -Description $msg.linkWindow_dstWindow -VariableName 'dst-window' -ArgumentCompleter $windowCompleter
    ) -NoFileCompletions
    # list-panes
    New-CommandCompleter -Name list-panes -Aliases lsp -Description $msg.listPanes -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.listPanes_all
        New-ParamCompleter -ShortName s -Description $msg.listPanes_session
        $formatParam
        $filterParam
        New-ParamCompleter -ShortName t -Description $msg.listPanes_target -VariableName 'target' -ArgumentCompleter {
            if ($this.BoundParameters.ContainsKey('s'))
            {
                tmux list-sessions -F "#S:#I `t#S #W#{?window_active,*, }" | Where-Object { $_ -like "$wordToComplete*" }
            }
            else
            {
                tmux list-windows -F "#I`t#W #{?window_active, *,}#{?window_marked_flag, M,}#{?window_zoomed_flag, Z,}" 2>/dev/null | Where-Object { $_ -like "$wordToComplete*" }
            }
        }
    )
    # list-windows
    New-CommandCompleter -Name list-windows -Aliases lsw -Description $msg.listWindows -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.listWindows_all
        $formatParam
        $filterParam
        $targetSessionParam
    )
    # move-pane
    # (same as join-pane)
    New-CommandCompleter -Name move-pane -Aliases movep -Description $msg.joinPane -Parameters @(
        # TBD
        New-ParamCompleter -ShortName s -Description $msg.joinPane_srcPane -VariableName 'src-pane' -ArgumentCompleter $paneCompleter
        New-ParamCompleter -ShortName t -Description $msg.joinPane_dstPane -VariableName 'dst-pane' -ArgumentCompleter $paneCompleter
    ) -NoFileCompletions
    # move-window
    New-CommandCompleter -Name move-window -Aliases movew -Description $msg.moveWindow -Parameters @(
        # TBD
        New-ParamCompleter -ShortName s -Description $msg.linkWindow_srcWindow -VariableName 'src-window' -ArgumentCompleter $windowCompleter
        New-ParamCompleter -ShortName t -Description $msg.linkWindow_dstWindow -VariableName 'dst-window' -ArgumentCompleter $windowCompleter
    ) -NoFileCompletions
    # new-window
    New-CommandCompleter -Name new-window -Aliases neww -Description $msg.newWindow -Parameters @(
        # TBD
        $startingDirectoryParam_c
        $setEnvironmentParam
        New-ParamCompleter -ShortName n -Description $msg.newWindow_name -Type Required -VariableName 'name'
        $targetWindowParam
    ) -NoFileCompletions
    # next-layout
    New-CommandCompleter -Name next-layout -Aliases nextl -Description $msg.nextLayout -Parameters $targetWindowParam -NoFileCompletions
    # next-window
    New-CommandCompleter -Name next-window -Aliases next -Description $msg.nextWindow -Parameters @(
        $targetSessionParam
    ) -NoFileCompletions
    # pipe-pane
    New-CommandCompleter -Name pipe-pane -Aliases pipep -Description $msg.pipePane -Parameters @(
        # TBD
        $targetPaneParam
    ) -NoFileCompletions
    # previous-layout
    New-CommandCompleter -Name previous-layout -Aliases prevl -Description $msg.previousLayout -Parameters $targetWindowParam -NoFileCompletions
    # rename-window
    New-CommandCompleter -Name rename-window -Aliases renamew -Description $msg.renameWindow -Parameters $targetWindowParam -NoFileCompletions
    # resize-pane
    New-CommandCompleter -Name resize-pane -Aliases resizep -Description $msg.resizePane -Parameters @(
        # TBD
        New-ParamCompleter -ShortName M -Description $msg.resizePane_mouse
        New-ParamCompleter -ShortName T -Description $msg.resizePane_trim
        New-ParamCompleter -ShortName x -Description $msg.width -Type Required -VariableName 'width'
        New-ParamCompleter -ShortName y -Description $msg.height -Type Required -VariableName 'height'
        $targetPaneParam
    ) -NoFileCompletions
    # resize-window
    New-CommandCompleter -Name resize-window -Aliases resizew -Description $msg.resizeWindow -Parameters @(
        # TBD
        New-ParamCompleter -ShortName x -Description $msg.width -Type Required -VariableName 'width'
        New-ParamCompleter -ShortName y -Description $msg.height -Type Required -VariableName 'height'
        $targetWindowParam
    ) -NoFileCompletions
    # respawn-pane
    New-CommandCompleter -Name respawn-pane -Aliases respawnp -Description $msg.respawnPane -Parameters @(
        # TBD
        $targetPaneParam
    ) -NoFileCompletions
    # respawn-window
    New-CommandCompleter -Name respawn-window -Aliases respawnw -Description $msg.respawnWindow -Parameters @(
        # TBD
        $targetWindowParam
    ) -NoFileCompletions
    # rotate-window
    New-CommandCompleter -Name rotate-window -Aliases rotatew -Description $msg.rotateWindow -Parameters @(
        # TBD
        $targetWindowParam
    ) -NoFileCompletions
    # select-layout
    New-CommandCompleter -Name select-layout -Aliases selectl -Description $msg.selectLayout -Parameters @(
        # TBD
        $targetPaneParam
    ) -NoFileCompletions -ArgumentCompleter {
        "even-horizontal","even-vertical","main-horizontal","main-horizontal-mirrored","main-vertical","main-vertical-mirrored","tiled" |
            Where-Object { $_ -like "$wordToComplete*" }
    }
    # select-pane
    New-CommandCompleter -Name select-pane -Aliases selectp -Description $msg.selectPane -Parameters @(
        # TBD
        $targetPaneParam
    ) -NoFileCompletions
    # select-window
    New-CommandCompleter -Name select-window -Aliases selectw -Description $msg.selectWindow -Parameters @(
        # TBD
        $targetWindowParam
    ) -NoFileCompletions
    # split-window
    New-CommandCompleter -Name split-window -Aliases splitw -Description $msg.splitWindow -Parameters @(
        # TBD
        $startingDirectoryParam_c
        $targetPaneParam
    ) -NoFileCompletions
    # swap-pane
    New-CommandCompleter -Name swap-pane -Aliases swapp -Description $msg.swapPane -Parameters @(
        # TBD
        New-ParamCompleter -ShortName s -Description $msg.swapPane_src -VariableName 'src-pane' -ArgumentCompleter $paneCompleter
        New-ParamCompleter -ShortName t -Description $msg.swapPane_dst -VariableName 'dst-pane' -ArgumentCompleter $paneCompleter
    ) -NoFileCompletions
    # swap-window
    New-CommandCompleter -Name swap-window -Aliases swapw -Description $msg.swapWindow -Parameters @(
        # TBD
        New-ParamCompleter -ShortName s -Description $msg.swapWindow_src -VariableName 'src-pane' -ArgumentCompleter $paneCompleter
        New-ParamCompleter -ShortName t -Description $msg.swapWindow_dst -VariableName 'dst-pane' -ArgumentCompleter $paneCompleter
    ) -NoFileCompletions
    # unlink-window
    New-CommandCompleter -Name unlink-window -Aliases unlinkw -Description $msg.unlinkWindow -Parameters @(
        $targetWindowParam
    ) -NoFileCompletions

    #
    # KEY BINDINGS
    #

    # bind-key
    New-CommandCompleter -Name bind-key -Aliases bind -Description $msg.bindKey -Parameters @(
        New-ParamCompleter -ShortName n -Description $msg.bindKey_nonPrefix
        New-ParamCompleter -ShortName r -Description $msg.bindKey_repeat
        $keyTableParam
    ) -NoFileCompletions
    # list-keys
    New-CommandCompleter -Name list-keys -Aliases lsk -Description $msg.listKeys -Parameters @(
        New-ParamCompleter -ShortName '1' -Description $msg.listKeys_onlyFirstKey
        New-ParamCompleter -ShortName P -Description $msg.listKeys_prefix -Type Required -VariableName 'prefix-string'
        $keyTableParam
    ) -NoFileCompletions
    # send-keys
    New-CommandCompleter -Name send-keys -Aliases send -Description $msg.sendKeys -Parameters @(
        New-ParamCompleter -ShortName c -Description $msg.sendKeys_client -VariableName 'target-client' -ArgumentCompleter $clientCompleter
        New-ParamCompleter -ShortName N -Description $mst.sendKeys_repeat -Type Required -VariableName 'repeat-count'
        $targetPaneParam
    ) -NoFileCompletions
    # send-prefix
    New-CommandCompleter -Name send-prefix -Description $msg.sendPrefix -Parameters @(
        $targetPaneParam
    ) -NoFileCompletions
    # unbind-key
    New-CommandCompleter -Name unbind-key -Aliases unbind -Description $msg.unbindKey -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.unbindKey_all
        New-ParamCompleter -ShortName n -Description $msg.unbindKey_nonPrefix
        $keyTableParam
    )

    #
    # OPTIONS
    #

    # set-option
    New-CommandCompleter -Name set-option -Aliases set -Description $msg.setOption -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.setOption_append
        New-ParamCompleter -ShortName F -Description $msg.setOption_expandFormat
        New-ParamCompleter -ShortName g -Description $msg.option_globalOption
        New-ParamCompleter -ShortName o -Description $msg.setOption_preventOverride
        New-ParamCompleter -ShortName q -Description $msg.setOption_quiet
        New-ParamCompleter -ShortName p -Description $msg.option_paneOption
        New-ParamCompleter -ShortName s -Description $msg.option_serverOption
        New-ParamCompleter -ShortName u -Description $msg.setOption_unsetOption
        New-ParamCompleter -ShortName U -Description $msg.setOption_unsetOption2
        New-ParamCompleter -ShortName w -Description $mst.option_windowOption
        $targetPaneParam
    ) -NoFileCompletions -ArgumentCompleter $optionCompleter
    # show-options
    New-CommandCompleter -Name show-options -Aliases show -Description $msg.showOptions -Parameters @(
        New-ParamCompleter -ShortName A -Description $msg.showOptions_inheritedOptions
        New-ParamCompleter -ShortName g -Description $msg.option_globalOption
        New-ParamCompleter -ShortName H -Description $msg.showOptions_hooks
        New-ParamCompleter -ShortName p -Description $msg.option_paneOption
        New-ParamCompleter -ShortName q -Description $msg.showOptions_quiet
        New-ParamCompleter -ShortName s -Description $msg.option_serverOption
        New-ParamCompleter -ShortName v -Description $msg.showOptions_value
        New-ParamCompleter -ShortName w -Description $msg.option_windowOption
        $targetPaneParam
    ) -NoFileCompletions -ArgumentCompleter $optionCompleter

    #
    # GLOBAL AND SESSION ENVIRONMENT
    #

    # set-environment
    New-CommandCompleter -Name set-environment -Aliases setenv -Description $msg.setEnvironment -Parameters @(
        New-ParamCompleter -ShortName F -Description $msg.setEnvironment_expandFormat
        New-ParamCompleter -ShortName h -Description $msg.setEnvironment_hide
        New-ParamCompleter -ShortName g -Description $msg.environment_global
        New-ParamCompleter -ShortName r -Description $msg.setEnvironment_remove
        New-ParamCompleter -ShortName u -Description $msg.setEnvironment_unset
        $targetPaneParam
    ) -NoFileCompletions
    # show-environment
    New-CommandCompleter -Name show-environment -Aliases showenv -Description $msg.showEnvironment -Parameters @(
        New-ParamCompleter -ShortName g -Description $msg.environment_global
        New-ParamCompleter -ShortName s -Description $msg.showEnvironment_shell
        $targetPaneParam
    ) -NoFileCompletions

    #
    # STATUS LINE
    #

    # clear-prompt-history
    New-CommandCompleter -Name clear-prompt-history -Aliases clearphist -Description $msg.clearPromptHistory -Parameters @(
        $promptTypeParam
    ) -NoFileCompletions

    # command-prompt
    New-CommandCompleter -Name command-prompt -Description $msg.commandPrompt -Parameters @(
        New-ParamCompleter -ShortName I -Description $msg.commandPrompt_input -Type List -VariableName "inputs"
        New-ParamCompleter -ShortName p -Description $msg.commandPrompt_prompt -Type List -VariableName "prompts"
        $targetClientParam
        $promptTypeParam
    ) -NoFileCompletions

    # confirm-before
    New-CommandCompleter -Name confirm-before -Aliases confirm -Description $msg.confirmBefore -Parameters @(
        New-ParamCompleter -ShortName c -Description $msg.confirmBefore_char -Type Required -VariableName 'confirm-key'
        New-ParamCompleter -ShortName p -Description $msg.confirmBefore_prompt -Type Required -VariableName 'prompt'
        $targetClientParam
    ) -NoFileCompletions

    # display-menu
    New-CommandCompleter -Name display-menu -Aliases menu -Description $msg.displayMenu -Parameters @(
        New-ParamCompleter -ShortName b -Description $msg.displayMenu_border -Type Required -VariableName 'border-lines'
        $targetClientParam_c
        $targetPaneParam
        New-ParamCompleter -ShortName T -Description $msg.title -Type Required -VariableName 'title'
        New-ParamCompleter -ShortName x -Description $msg.position_x -Type Required -VariableName 'position'
        New-ParamCompleter -ShortName y -Description $msg.position_y -Type Required -VariableName 'position'
    ) -NoFileCompletions

    # display-message
    New-CommandCompleter -Name display-message -Aliases display -Description $msg.displayMessage -Parameters @(
        New-ParamCompleter -ShortName p -Description $msg.displayMessage_print
        $targetClientParam_c
        New-ParamCompleter -ShortName d -Description $msg.displayMessage_delay -Type Required -VariableName 'delay'
        $targetPaneParam
    ) -NoFileCompletions

    # display-popup
    New-CommandCompleter -Name display-popup -Aliases popup -Description $msg.displayPopup -Parameters @(
        New-ParamCompleter -ShortName E -Description $msg.displayPopup_exit
        $targetClientParam_c
        $startingDirectoryParam_d
        $setEnvironmentParam
        New-ParamCompleter -ShortName h -Description $msg.height -Type Required -VariableName 'height'
        New-ParamCompleter -ShortName w -Description $msg.width -Type Required -VariableName 'width'
        New-ParamCompleter -ShortName T -Description $msg.title -Type Required -VariableName 'title'
        New-ParamCompleter -ShortName x -Description $msg.position_x -Type Required -VariableName 'position'
        New-ParamCompleter -ShortName y -Description $msg.position_y -Type Required -VariableName 'position'
        $targetPaneParam
    ) -NoFileCompletions

    # show-prompt-history
    New-CommandCompleter -Name show-prompt-history -Aliases showphist -Description $msg.showPromptHistory -Parameters @(
        $promptTypeParam
    ) -NoFileCompletions

    #
    # BUFFERS
    #

    # choose-buffer
    New-CommandCompleter -Name choose-buffer -Description $msg.chooseBuffer -Parameters @(
        # TBD
        $formatParam
        $filterParam
        $targetPaneParam
    ) -NoFileCompletions

    # clear-history
    New-CommandCompleter -Name clear-history -Aliases clearhist -Description $msg.clearHistory -Parameters @(
        New-ParamCompleter -ShortName H -Description $msg.clearHistory_hyperlinks
        $targetPaneParam
    ) -NoFileCompletions

    # delete-buffer
    New-CommandCompleter -Name delete-buffer -Aliases deleteb -Description $msg.deleteBuffer -Parameters @(
        $bufferNameParam
    ) -NoFileCompletions

    # list-buffers
    New-CommandCompleter -Name list-buffers -Aliases lsb -Description $msg.listBuffers -Parameters @(
        $formatParam
        $filterParam
    ) -NoFileCompletions

    # load-buffer
    New-CommandCompleter -Name load-buffer -Aliases loadb -Description $msg.loadBuffer -Parameters @(
        New-ParamCompleter -ShortName w -Description $msg.loadBuffer_clipboard
        $bufferNameParam
        $targetClientParam
    )

    # paste-buffer
    New-CommandCompleter -Name paste-buffer -Aliases pasteb -Description $msg.pasteBuffer -Parameters @(
        # TBD
        New-ParamCompleter -ShortName d -Description $msg.pasteBuffer_delete
        $bufferNameParam
        $targetPaneParam
    ) -NoFileCompletions

    # save-buffer
    New-CommandCompleter -Name save-buffer -Aliases saveb -Description $msg.saveBuffer -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.saveBuffer_append
        $bufferNameParam
    )

    # set-buffer
    New-CommandCompleter -Name set-buffer -Aliases setb -Description $msg.setBuffer -Parameters @(
        New-ParamCompleter -ShortName a -Description $msg.saveBuffer_append
        New-ParamCompleter -ShortName w -Description $msg.loadBuffer_clipboard
        $bufferNameParam
        $targetClientParam
        New-ParamCompleter -ShortName n -Description $msg.setBuffer_name -Type Required -VariableName 'new-buffer-name'
    ) -NoFileCompletions

    # show-buffer
    New-CommandCompleter -Name show-buffer -Aliases showb -Description $msg.showBuffer -Parameters @(
        $bufferNameParam
    ) -NoFileCompletions

    #
    # MISCELLANEOUS
    #

    # clock-mode
    New-CommandCompleter -Name clock-mode -Description $msg.clockMode -Parameters @(
        $targetPaneParam
    ) -NoFileCompletions

    # if-shell
    New-CommandCompleter -Name if-shell -Aliases 'if' -Description $msg.ifShell -Parameters @(
        # TBD
        New-ParamCompleter -ShortName b -Description $msg._runBackground
        $targetPaneParam
    )

    # lock-server
    New-CommandCompleter -Name lock-server -Aliases lock -NoFileCompletions

    # run-shell
    New-CommandCompleter -Name run-shell -Aliases run -Description $msg.runShell -Parameters @(
        # TBD
        New-ParamCompleter -ShortName b -Description $msg._runBackground
        New-ParamCompleter -ShortName E -Description $msg.runShell_redirectError
        $startingDirectoryParam_c
        New-ParamCompleter -ShortName d -Description $msg.runShell_delay -Type Required -VariableName 'delay'
        $targetPaneParam
    ) -DelegateArgumentIndex 0

    # wait-for
    New-CommandCompleter -Name wait-for -Aliases wait -Parameters @(
        New-ParamCompleter -ShortName L
        New-ParamCompleter -ShortName S
        New-ParamCompleter -ShortName U
    )
) -NoFileCompletions
