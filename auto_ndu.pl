use strict;
use warnings;
use Readonly;

Readonly::Scalar my $NAVISECCLI => "naviseccli";
Readonly::Scalar my $SCOPE      => 0;
Readonly::Scalar my $LOG_FILE   => "auto_ndu.log";
Readonly::Scalar my $CONF_FILE  => "conf.conf";

my $LOGFH   = undef;

sub log_msg {
    my $msg     = shift;
    my $level   = shift;
    
    if (! defined $level) {
        $level = "INFO";
    }

    # TODO : Add timestamp
    print $LOGFH "$level : $msg\n";
    
    return;
}

sub read_conf {
    my $conf    = shift;
    
    my $conffh = undef;
    open $conffh, "<$conf" || die "Can't read the $conf.";
    
    my %result_hash;
    while (my $oneline = <$conffh>) {
        if ($oneline =~ /host=(.*)/) {
            $result_hash{'host'} = $1;
        }
        elsif ($oneline =~ /user=(.*)/) {
            $result_hash{'user'} = $1;
        }
        elsif ($oneline =~ /password=(.*)/) {
            $result_hash{'password'} = $1;
        }
        elsif ($oneline =~ /package=(.*)/) {
            $result_hash{'package'} = $1;
        }
        
    }
    
    close $conffh;
    
    return %result_hash;
}

# If getcode == 1, return the code.
# else, return the return the output.
sub run_cmd {
    my $cmd     = shift;
    my $getcode = shift || 0;
    
    log_msg($cmd, "CMD");
    if ($getcode == 1) {
        my $rc = system $cmd;
        log_msg("$rc", "RETURN CODE");
        
        return scalar $rc;
    }
    else {
        my $rs = `$cmd`;
        chomp($rs);
        log_msg("$rs", "RETURN STRING");
        
        return scalar $rs;
    }
}

sub get_revision {
    my $host    = shift;
    my $user    = shift;
    my $password    = shift;
    
    my $cmd = "$NAVISECCLI -h $host -user $user -password $password
        -scope $SCOPE getagent -rev";
    my $rs = run_cmd($cmd);
    
    my $revision = undef;
    if ($rs =~ /Revision:\s+([\d\.]+)/) {
        $revision = $1;
    }
    else {
        log_msg("Can't get the revision.", "ERROR");
        die "Can't get the revision";
    }
    
    log_msg("The revision is $revision.");
    
    return $revision;
}

sub stop_statlog {
    my $host    = shift;
    my $user    = shift;
    my $password    = shift;
    
    my $cmd = "$NAVISECCLI -h $host -user $user -password $password
        -scope $SCOPE setstats";
    my $rs = run_cmd($cmd);
    
    if ($rs =~ /Statistics logging is ENABLED/) {
        $cmd = "$NAVISECCLI -h $host -user $user -password $password
            -scope $SCOPE setstats -off";
        if (run_cmd($cmd, 1) != 0) {
            log_msg("Can't disable the statistics logging.", "ERROR");
            die "Can't disable the statistics logging.";
        }
        
    }
    
    log_msg("Stop the statistics logging.");
    
    return;
}

sub start_ndu {
    my $host    = shift;
    my $user    = shift;
    my $password    = shift;
    my $package = shift;
    
    my $cmd = "$NAVISECCLI -h $host -user $user -password $password
        -scope $SCOPE ndu -install $package -force";
    my $rs = run_cmd($cmd);
    
    if ($rs =~ /Warnings/) {
        log_msg("Conditions exist that may need correction." . 
            "Installation proceeds.");
        print "Conditions exist that may need correction." . 
            "Installation proceeds.\n"
    }
    elsif ($rs =~ /Failure/) {
        log_msg("Conditions exist that require correction " .
            "before installation can proceed. Installation terminates.");
        die "Conditions exist that require correction " .
            "before installation can proceed. Installation terminates.";
    }
    
    log_msg("Validation check is successful. Installation proceeds.");
    
    return;
}

sub check_health {
    my $host    = shift;
    my $user    = shift;
    my $password    = shift;
    
    my $cmd = "$NAVISECCLI -h $host -user $user -password $password
        -scope $SCOPE faults -list";
    my $rs = run_cmd($cmd);

    if ($rs !~ /The array is operating normally./) {
        log_msg("There is faults on the rig. Need to fix them before ndu.",
            "ERROR");
        log_msg($rs, "ERROR");
        die "There is faults on the rig. Need to fix them before ndu.";
    }
    
    log_msg("There is no faults on the rig.");
    
    return;
}

sub pre_ndu {
    my $host    = shift;
    my $user    = shift;
    my $password    = shift;
    
    log_msg("Pre check for ndu.");
    print "Pre check for ndu.\n";
    
    # Get the privious revision.
    my $old_rev = get_revision($host, $user, $password);
    
    # Check whether there is faults.
    check_health($host, $user, $password);
    
    log_msg("Pass pre check.");
    print "Pass pre check.\n";
    
    return;
}

sub run_ndu {
    my $host    = shift;
    my $user    = shift;
    my $password    = shift;
    my $package = shift;
    
    log_msg("Begin to ndu.");
    print "Begin to ndu.\n";
    
    if (! -f $package) {
        log_msg("Can't find the ndu source package.");
        die("Can't find the ndu source package.")
    }
    
    # Stop the stat log
    stop_statlog($host, $user, $password);
    
    # Run the ndu
    start_ndu($host, $user, $password, $package);
    
    log_msg("Successfully run ndu.");
    print "Successfully run ndu.\n";
    
    return;
}

sub post_ndu {
    my $host    = shift;
    my $user    = shift;
    my $password    = shift;
    
    log_msg("Post ndu.");
    print "Post ndu.\n";
    
    log_msg("Post ndu.");
    print "Post ndu.\n";
    
    return;
}


sub main {
    # Create the log file.
    open $LOGFH, ">>$LOG_FILE";
    log_msg("++++++++++", "BEGIN");
    
    my %conf_hash = read_conf($CONF_FILE);
    
    my $host    = $conf_hash{'host'};
    my $user    = $conf_hash{'user'};
    my $password    = $conf_hash{'password'};
    my $package = $conf_hash{'package'};
    
    log_msg("host:$host");
    log_msg("user:$user");
    log_msg("password:$password");
    log_msg("package:$package");

    pre_ndu($host, $user, $password);
    
    run_ndu($host, $user, $password, $package);
    
    post_ndu($host, $user, $password);
    
    close $LOGFH;
    
    return;
}

main();