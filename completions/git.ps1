<#
 # git completion
 #>
Import-Module NativeCommandCompleter.psm -ErrorAction SilentlyContinue

$msg = data { ConvertFrom-StringData @'
    git                     = the stupid content tracker
    # Main porcelain commands
    add                     = Add file contents to the index
    add_all                 = Add changes from all tracked and untracked files
    add_dryRun              = Don't actually add the files, just show if they exist and/or would be added
    add_verbose             = Be verbose
    add_force               = Allow adding otherwise ignored files.
    add_patch               = Interactively choose hunks of patch
    am                      = Apply a series of patches from a mailbox
    archive                 = Create an archive of files from a named tree
    bisect                  = Use binary search to find the commit that introduced a bug
    branch                  = List, create, or delete branches
    bundle                  = Move objects and refs by archive
    checkout                = Switch branches or restore working tree files
    cherryPick              = Apply the changes introduced by some existing commits
    citool                  = Graphical alternative to git-commit
    clean                   = Remove untracked files from the working tree
    clone                   = Clone a repository into a new directory
    commit                  = Record changes to the repository
    describe                = Give an object a human readable name based on an available ref
    diff                    = Show changes between commits, commit and working tree, etc
    fetch                   = Download objects and refs from another repository
    formatPatch             = Prepare patches for e-mail submission
    gc                      = Cleanup unnecessary files and optimize the local repository
    gitk                    = The Git repository browser
    grep                    = Print lines matching a pattern
    gui                     = A portable graphical interface to Git
    init                    = Create an empty Git repository or reinitialize an existing one
    log                     = Show commit logs
    log_graph               = Display an ASCII graph of the branch and merge history beside the log output
    log_patch               = Show full diff of each commit
    log_maxCount            = Limit the number of commits to output
    log_stat                = Show statistics for files modified in each commit
    log_since               = Show commits more recent than <date>.
    log_until               = Show commits older than <date>.
    log_author              = Limit the commits output to ones with author/committer
    maintenance             = Run tasks to optimize Git repository data
    merge                   = Join two or more development histories together
    mv                      = Move or rename a file, a directory, or a symlink
    notes                   = Add or inspect object notes
    pull                    = Fetch from and integrate with another repository or a local branch
    push                    = Update remote refs along with associated objects
    rangeDiff               = Compare two commit ranges
    rebase                  = Reapply commits on top of another base tip
    reset                   = Reset current HEAD to the specified state
    restore                 = Restore working tree files
    revert                  = Revert some existing commits
    rm                      = Remove files from the working tree and from the index
    shortlog                = Summarize git log output
    show                    = Show various types of objects
    sparseCheckout          = Reduce your working tree to a subset of tracked files
    stash                   = Stash the changes in a dirty working directory away
    status                  = Show the working tree status
    submodule               = Initialize, update or inspect submodules
    switch                  = Switch branches
    tag                     = Create, list, delete or verify a tag object signed with GPG
    worktree                = Manage multiple working trees
    
    # Ancillary Commands / Manipulators
    config                  = Get and set repository or global options
    fastExport              = Git data exporter
    fastImport              = Backend for fast Git data importers
    filterBranch            = Rewrite branches
    mergetool               = Run merge conflict resolution tools to resolve merge conflicts
    packRefs                = Pack heads and tags for efficient repository access
    prune                   = Prune all unreachable objects from the object database
    reflog                  = Manage reflog information
    remote                  = Manage set of tracked repositories
    repack                  = Pack unpacked objects in a repository
    replace                 = Create, list, delete refs to replace objects
    
    # Ancillary Commands / Interrogators
    annotate                = Annotate file lines with commit information
    blame                   = Show what revision and author last modified each line of a file
    bugreport               = Collect information for user to file a bug report
    countObjects            = Count unpacked number of objects and their disk consumption
    diagnose                = Generate a zip archive of diagnostic information
    difftool                = Show changes using common diff tools
    fsck                    = Verifies the connectivity and validity of the objects in the database
    help                    = Display help information about Git
    instaweb                = Instantly browse your working repository in gitweb
    mergeTree               = Perform merge without touching index or working tree
    rerere                  = Reuse recorded resolution of conflicted merges
    showBranch              = Show branches and their commits
    verifyCommit            = Check the GPG signature of commits
    verifyTag               = Check the GPG signature of tags
    version                 = Display version information about Git
    whatchanged             = Show logs with difference each commit introduces
    
    # Interacting with Others
    archimport              = Import a GNU Arch repository into Git
    cvsexportcommit         = Export a single commit to a CVS checkout
    cvsimport               = Salvage your data out of another SCM people love to hate
    cvsserver               = A CVS server emulator for Git
    imapSend                = Send a collection of patches from stdin to an IMAP folder
    p4                      = Import from and submit to Perforce repositories
    quiltimport             = Applies a quilt patchset onto the current branch
    requestPull             = Generates a summary of pending changes
    sendEmail               = Send a collection of patches as emails
    svn                     = Bidirectional operation between a Subversion repository and Git
    
    # Low-level Commands / Manipulators
    apply                   = Apply a patch to files and/or to the index
    checkoutIndex           = Copy files from the index to the working tree
    commitGraph             = Write and verify Git commit-graph files
    commitTree              = Create a new commit object
    hashObject              = Compute object ID and optionally creates a blob from a file
    indexPack               = Build pack index file for an existing packed archive
    mergeFile               = Run a three-way file merge
    mergeIndex              = Run a merge for files needing merging
    mktag                   = Creates a tag object with extra validation
    mktree                  = Build a tree-object from ls-tree formatted text
    multiPackIndex          = Write and verify multi-pack-indexes
    packObjects             = Create a packed archive of objects
    prunePacked             = Remove extra objects that are already in pack files
    readTree                = Reads tree information into the index
    symbolicRef             = Read, modify and delete symbolic refs
    unpackObjects           = Unpack objects from a packed archive
    updateIndex             = Register file contents in the working tree to the index
    updateRef               = Update the object name stored in a ref safely
    writeTree               = Create a tree object from the current index
    
    # Low-level Commands / Interrogators
    catFile                 = Provide content or type and size information for repository objects
    cherry                  = Find commits yet to be applied to upstream
    diffFiles               = Compares files in the working tree and the index
    diffIndex               = Compare a tree to the working tree or index
    diffTree                = Compares the content and mode of blobs found via two tree objects
    forEachRef              = Output information on each ref
    forEachRepo             = Run a Git command on a list of repositories
    getTarCommitId          = Extract commit ID from an archive created using git-archive
    lsFiles                 = Show information about files in the index and the working tree
    lsRemote                = List references in a remote repository
    lsTree                  = List the contents of a tree object
    mergeBase               = Find as good common ancestors as possible for a merge
    nameRev                 = Find symbolic names for given revs
    packRedundant           = Find redundant pack files
    revList                 = Lists commit objects in reverse chronological order
    revParse                = Pick out and massage parameters
    showIndex               = Show packed archive index
    showRef                 = List references in a local repository
    unpackFile              = Creates a temporary file with a blob's contents
    var                     = Show a Git logical variable
    verifyPack              = Validate packed Git archive files
    
    # Low-level Commands / Syncing Repositories
    daemon                  = A really simple server for Git repositories
    fetchPack               = Receive missing objects from another repository
    httpBackend             = Server side implementation of Git over HTTP
    sendPack                = Push objects over Git protocol to another repository
    updateServerInfo        = Update auxiliary info file to help dumb servers
    
    # Low-level Commands / Internal Helpers
    checkAttr               = Display gitattributes information
    checkIgnore             = Debug gitignore / exclude files
    checkMailmap            = Show canonical names and email addresses of contacts
    checkRefFormat          = Ensures that a reference name is well formed
    column                  = Display data in columns
    credential              = Retrieve and store user credentials
    credentialCache         = Helper to temporarily store passwords in memory
    credentialStore         = Helper to store credentials on disk
    fmtMergeMsg             = Produce a merge commit message
    hook                    = Run git hooks
    interpretTrailers       = Add or parse structured information in commit messages
    mailinfo                = Extracts patch and authorship from a single e-mail message
    mailsplit               = Simple UNIX mbox splitter program
    mergeOneFile            = The standard helper program to use with git-merge-index
    patchId                 = Compute unique ID for a patch
    shI18n                  = Git's i18n setup code for shell scripts
    shSetup                 = Common Git shell script setup code
    stripspace              = Remove unnecessary whitespace
    
    # Common options
    _version                 = Prints the Git suite version
    _help                    = Prints the synopsis and a list of the most commonly used commands
    _changeCurrentDir        = Change current working directory
    _configParam             = Pass a configuration parameter to the command.
    _configEnv               = Like '-c <name>=<value>', but for environment variable
    _execPath                = Path to wherever your core Git programs are installed
    _htmlPath                = Print the path where Git's HTML documentation is installed and exit
    _manPath                 = Print the manpath for the man pages for this version of Git and exit
    _infoPath                = Print the path where the Info files documenting this version of Git are installed and exit
    _paginate                = Pipe all output into less
    _noPager                 = Do not pipe Git output into a pager
    _gitDir                  = Set the path to the repository
    _workTree                = Set the path to the working tree
    _namespace               = Set the Git namespace
    _bare                    = Treat the repository as a bare repository
    _noReplaceObjects        = Do not use replacement refs to replace Git objects
    _literalPathspecs        = Treat pathspecs literally
    _globPathspecs           = Add glob magic to all pathspec
    _noglobPathspecs         = Add literal magic to all pathspec
    _icasePathspecs          = Add case-insensitive magic to all pathspec
    _noOptionalLocks         = Do not perform optional operations that require locks
    _listCmds                = List all available commands
'@ }
Import-LocalizedData -BindingVariable localizedMessages -ErrorAction SilentlyContinue;
foreach ($key in $localizedMessages.Keys) { $msg[$key] = $localizedMessages[$key] }

$branchCompleter = {
    git for-each-ref --format="%(refname:strip=2)`tLocal Branch" --sort=refname refs/heads/ |
        Where-Object { $_ -like "$wordToComplete*" } 
}

$allBranchCompleter = {
    git for-each-ref --format="%(refname:strip=2)`t%(refname:rstrip=-2)" --sort=refname refs/heads/ refs/remotes/ |
        ForEach-Object {
            $fields=$_.Split("`t");
            $desc = switch($fields[1]) { 'refs/heads' { 'Loacal Branch' } 'refs/remotes' { 'Remote Branch' } };
            "{0}`t{1}" -f $fields[0], $desc
        } | Where-Object { $_ -like "$wordToComplete*" } 
}

$remoteCompleter = {
    git remote 2>/dev/null | Where-Object { $_ -like "$wordToComplete*" }
}

$tagCompleter = {
    git tag -l "$wordToComplete*" 2>/dev/null
}

$refCompleter = {
    @(
        git branch --format='%(refname:short)' 2>/dev/null
        git tag -l 2>/dev/null
    ) | Where-Object { $_ -like "$wordToComplete*" }
}

Register-NativeCompleter -Name git -Description $msg.git -Parameters @(
    New-ParamCompleter -ShortName v -LongName version -Description $msg._version
    New-ParamCompleter -ShortName h -LongName help -Description $msg._help
    New-ParamCompleter -ShortName C -Description $msg._changeCurrentDir -Type Directory -VariableName 'path'
    New-ParamCompleter -ShortName c -Description $msg._configParam -Type Required -VariableName 'name=value'
    New-ParamCompleter -LongName config-env -Description $msg._configEnv -Type Required -VariableName 'name=envvar'
    New-ParamCompleter -LongName exec-path -Description $msg._execPath -Type FlagOrValue
    New-ParamCompleter -LongName html-path -Description $msg._htmlPath
    New-ParamCompleter -LongName man-path -Description $msg._manPath
    New-ParamCompleter -LongName info-path -Description $msg._infoPath
    New-ParamCompleter -ShortName p -LongName paginate -Description $msg._paginate
    New-ParamCompleter -ShortName P -LongName no-pager -Description $msg._noPager
    New-ParamCompleter -LongName git-dir -Description $msg._gitDir -Type Directory
    New-ParamCompleter -LongName work-tree -Description $msg._workTree -Type Directory
    New-ParamCompleter -LongName namespace -Description $msg._namespace -Type Required
    New-ParamCompleter -LongName bare -Description $msg._bare
    New-ParamCompleter -LongName no-replace-objects -Description $msg._noReplaceObjects
    New-ParamCompleter -LongName literal-pathspecs -Description $msg._literalPathspecs
    New-ParamCompleter -LongName glob-pathspecs -Description $msg._globPathspecs
    New-ParamCompleter -LongName noglob-pathspecs -Description $msg._noglobPathspecs
    New-ParamCompleter -LongName icase-pathspecs -Description $msg._icasePathspecs
    New-ParamCompleter -LongName no-optional-locks -Description $msg._noOptionalLocks
    New-ParamCompleter -LongName list-cmds -Description $msg._listCmds -Type Required
) -SubCommands @(
    # Main porcelain commands
    New-CommandCompleter -Name add -Description $msg.add -Parameters @(
        New-ParamCompleter -ShortName n -LongName dry-run -Description $msg.add_dryRun
        New-ParamCompleter -ShortName v -LongName verbose -Description $msg.add_verbose
        New-ParamCompleter -ShortName f -LongName force -Description $msg.add_force
        New-ParamCompleter -ShortName p -LongName patch -Description $msg.add_patch
        New-ParamCompleter -ShortName A -LongName all -Description $msg.add_all
    )
    New-CommandCompleter -Name am -Description $msg.am
    New-CommandCompleter -Name archive -Description $msg.archive
    New-CommandCompleter -Name bisect -Description $msg.bisect
    New-CommandCompleter -Name branch -Description $msg.branch -ArgumentCompleter $branchCompleter
    New-CommandCompleter -Name bundle -Description $msg.bundle
    New-CommandCompleter -Name checkout -Description $msg.checkout -ArgumentCompleter $allBranchCompleter
    New-CommandCompleter -Name cherry-pick -Description $msg.cherryPick -ArgumentCompleter $refCompleter
    New-CommandCompleter -Name citool -Description $msg.citool
    New-CommandCompleter -Name clean -Description $msg.clean
    New-CommandCompleter -Name clone -Description $msg.clone
    New-CommandCompleter -Name commit -Description $msg.commit
    New-CommandCompleter -Name describe -Description $msg.describe
    New-CommandCompleter -Name diff -Description $msg.diff
    New-CommandCompleter -Name fetch -Description $msg.fetch -ArgumentCompleter $remoteCompleter
    New-CommandCompleter -Name format-patch -Description $msg.formatPatch
    New-CommandCompleter -Name gc -Description $msg.gc
    New-CommandCompleter -Name gitk -Description $msg.gitk
    New-CommandCompleter -Name grep -Description $msg.grep
    New-CommandCompleter -Name gui -Description $msg.gui
    New-CommandCompleter -Name init -Description $msg.init
    New-CommandCompleter -Name log -Description $msg.log -Parameters @(
        New-ParamCompleter -ShortName g -LongName graph -Description $msg.log_graph
        New-ParamCompleter -ShortName p -LongName patch -Description $msg.log_patch
        New-ParamCompleter -ShortName n -LongName max-count -Description $msg.log_maxCount -Type Required -VariableName 'NUM'
        New-ParamCompleter -LongName stat -Description $msg.log_stat
        New-ParamCompleter -LongName since, after -Description $msg.log_since -Type Required -VariableName 'date'
        New-ParamCompleter -LongName 'until', before -Description $msg.log_until -Type Required -VariableName 'date'
        New-ParamCompleter -LongName author, committer -Description $msg.log_author -Type Required -VariableName 'pattern'
    )
    New-CommandCompleter -Name maintenance -Description $msg.maintenance
    New-CommandCompleter -Name merge -Description $msg.merge -ArgumentCompleter $branchCompleter
    New-CommandCompleter -Name mv -Description $msg.mv
    New-CommandCompleter -Name notes -Description $msg.notes
    New-CommandCompleter -Name pull -Description $msg.pull -ArgumentCompleter $remoteCompleter
    New-CommandCompleter -Name push -Description $msg.push -ArgumentCompleter $remoteCompleter
    New-CommandCompleter -Name range-diff -Description $msg.rangeDiff
    New-CommandCompleter -Name rebase -Description $msg.rebase -ArgumentCompleter $branchCompleter
    New-CommandCompleter -Name reset -Description $msg.reset -ArgumentCompleter $refCompleter
    New-CommandCompleter -Name restore -Description $msg.restore
    New-CommandCompleter -Name revert -Description $msg.revert -ArgumentCompleter $refCompleter
    New-CommandCompleter -Name rm -Description $msg.rm
    New-CommandCompleter -Name shortlog -Description $msg.shortlog
    New-CommandCompleter -Name show -Description $msg.show -ArgumentCompleter $refCompleter
    New-CommandCompleter -Name sparse-checkout -Description $msg.sparseCheckout
    New-CommandCompleter -Name stash -Description $msg.stash
    New-CommandCompleter -Name status -Description $msg.status
    New-CommandCompleter -Name submodule -Description $msg.submodule
    New-CommandCompleter -Name switch -Description $msg.switch -ArgumentCompleter $branchCompleter
    New-CommandCompleter -Name tag -Description $msg.tag -ArgumentCompleter $tagCompleter
    New-CommandCompleter -Name worktree -Description $msg.worktree
    
    # Ancillary Commands / Manipulators
    New-CommandCompleter -Name config -Description $msg.config
    New-CommandCompleter -Name fast-export -Description $msg.fastExport
    New-CommandCompleter -Name fast-import -Description $msg.fastImport
    New-CommandCompleter -Name filter-branch -Description $msg.filterBranch
    New-CommandCompleter -Name mergetool -Description $msg.mergetool
    New-CommandCompleter -Name pack-refs -Description $msg.packRefs
    New-CommandCompleter -Name prune -Description $msg.prune
    New-CommandCompleter -Name reflog -Description $msg.reflog
    New-CommandCompleter -Name remote -Description $msg.remote -ArgumentCompleter $remoteCompleter
    New-CommandCompleter -Name repack -Description $msg.repack
    New-CommandCompleter -Name replace -Description $msg.replace
    
    # Ancillary Commands / Interrogators
    New-CommandCompleter -Name annotate -Description $msg.annotate
    New-CommandCompleter -Name blame -Description $msg.blame
    New-CommandCompleter -Name bugreport -Description $msg.bugreport
    New-CommandCompleter -Name count-objects -Description $msg.countObjects
    New-CommandCompleter -Name diagnose -Description $msg.diagnose
    New-CommandCompleter -Name difftool -Description $msg.difftool
    New-CommandCompleter -Name fsck -Description $msg.fsck
    New-CommandCompleter -Name help -Description $msg.help
    New-CommandCompleter -Name instaweb -Description $msg.instaweb
    New-CommandCompleter -Name merge-tree -Description $msg.mergeTree
    New-CommandCompleter -Name rerere -Description $msg.rerere
    New-CommandCompleter -Name show-branch -Description $msg.showBranch
    New-CommandCompleter -Name verify-commit -Description $msg.verifyCommit
    New-CommandCompleter -Name verify-tag -Description $msg.verifyTag
    New-CommandCompleter -Name version -Description $msg.version
    New-CommandCompleter -Name whatchanged -Description $msg.whatchanged
    
    # Interacting with Others
    New-CommandCompleter -Name archimport -Description $msg.archimport
    New-CommandCompleter -Name cvsexportcommit -Description $msg.cvsexportcommit
    New-CommandCompleter -Name cvsimport -Description $msg.cvsimport
    New-CommandCompleter -Name cvsserver -Description $msg.cvsserver
    New-CommandCompleter -Name imap-send -Description $msg.imapSend
    New-CommandCompleter -Name p4 -Description $msg.p4
    New-CommandCompleter -Name quiltimport -Description $msg.quiltimport
    New-CommandCompleter -Name request-pull -Description $msg.requestPull
    New-CommandCompleter -Name send-email -Description $msg.sendEmail
    New-CommandCompleter -Name svn -Description $msg.svn
    
    # Low-level Commands / Manipulators
    New-CommandCompleter -Name apply -Description $msg.apply
    New-CommandCompleter -Name checkout-index -Description $msg.checkoutIndex
    New-CommandCompleter -Name commit-graph -Description $msg.commitGraph
    New-CommandCompleter -Name commit-tree -Description $msg.commitTree
    New-CommandCompleter -Name hash-object -Description $msg.hashObject
    New-CommandCompleter -Name index-pack -Description $msg.indexPack
    New-CommandCompleter -Name merge-file -Description $msg.mergeFile
    New-CommandCompleter -Name merge-index -Description $msg.mergeIndex
    New-CommandCompleter -Name mktag -Description $msg.mktag
    New-CommandCompleter -Name mktree -Description $msg.mktree
    New-CommandCompleter -Name multi-pack-index -Description $msg.multiPackIndex
    New-CommandCompleter -Name pack-objects -Description $msg.packObjects
    New-CommandCompleter -Name prune-packed -Description $msg.prunePacked
    New-CommandCompleter -Name read-tree -Description $msg.readTree
    New-CommandCompleter -Name symbolic-ref -Description $msg.symbolicRef
    New-CommandCompleter -Name unpack-objects -Description $msg.unpackObjects
    New-CommandCompleter -Name update-index -Description $msg.updateIndex
    New-CommandCompleter -Name update-ref -Description $msg.updateRef
    New-CommandCompleter -Name write-tree -Description $msg.writeTree
    
    # Low-level Commands / Interrogators
    New-CommandCompleter -Name cat-file -Description $msg.catFile
    New-CommandCompleter -Name cherry -Description $msg.cherry
    New-CommandCompleter -Name diff-files -Description $msg.diffFiles
    New-CommandCompleter -Name diff-index -Description $msg.diffIndex
    New-CommandCompleter -Name diff-tree -Description $msg.diffTree
    New-CommandCompleter -Name for-each-ref -Description $msg.forEachRef
    New-CommandCompleter -Name for-each-repo -Description $msg.forEachRepo
    New-CommandCompleter -Name get-tar-commit-id -Description $msg.getTarCommitId
    New-CommandCompleter -Name ls-files -Description $msg.lsFiles
    New-CommandCompleter -Name ls-remote -Description $msg.lsRemote
    New-CommandCompleter -Name ls-tree -Description $msg.lsTree
    New-CommandCompleter -Name merge-base -Description $msg.mergeBase
    New-CommandCompleter -Name name-rev -Description $msg.nameRev
    New-CommandCompleter -Name pack-redundant -Description $msg.packRedundant
    New-CommandCompleter -Name rev-list -Description $msg.revList
    New-CommandCompleter -Name rev-parse -Description $msg.revParse
    New-CommandCompleter -Name show-index -Description $msg.showIndex
    New-CommandCompleter -Name show-ref -Description $msg.showRef
    New-CommandCompleter -Name unpack-file -Description $msg.unpackFile
    New-CommandCompleter -Name var -Description $msg.var
    New-CommandCompleter -Name verify-pack -Description $msg.verifyPack
    
    # Low-level Commands / Syncing Repositories
    New-CommandCompleter -Name daemon -Description $msg.daemon
    New-CommandCompleter -Name fetch-pack -Description $msg.fetchPack
    New-CommandCompleter -Name http-backend -Description $msg.httpBackend
    New-CommandCompleter -Name send-pack -Description $msg.sendPack
    New-CommandCompleter -Name update-server-info -Description $msg.updateServerInfo
    
    # Low-level Commands / Internal Helpers
    New-CommandCompleter -Name check-attr -Description $msg.checkAttr
    New-CommandCompleter -Name check-ignore -Description $msg.checkIgnore
    New-CommandCompleter -Name check-mailmap -Description $msg.checkMailmap
    New-CommandCompleter -Name check-ref-format -Description $msg.checkRefFormat
    New-CommandCompleter -Name column -Description $msg.column
    New-CommandCompleter -Name credential -Description $msg.credential
    New-CommandCompleter -Name credential-cache -Description $msg.credentialCache
    New-CommandCompleter -Name credential-store -Description $msg.credentialStore
    New-CommandCompleter -Name fmt-merge-msg -Description $msg.fmtMergeMsg
    New-CommandCompleter -Name hook -Description $msg.hook
    New-CommandCompleter -Name interpret-trailers -Description $msg.interpretTrailers
    New-CommandCompleter -Name mailinfo -Description $msg.mailinfo
    New-CommandCompleter -Name mailsplit -Description $msg.mailsplit
    New-CommandCompleter -Name merge-one-file -Description $msg.mergeOneFile
    New-CommandCompleter -Name patch-id -Description $msg.patchId
    New-CommandCompleter -Name sh-i18n -Description $msg.shI18n
    New-CommandCompleter -Name sh-setup -Description $msg.shSetup
    New-CommandCompleter -Name stripspace -Description $msg.stripspace
)
