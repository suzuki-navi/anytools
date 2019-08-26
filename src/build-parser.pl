use strict;
use warnings;
use utf8;

my $action = "";

while (@ARGV) {
    my $a = shift(@ARGV);
    if ($a eq "--option") {
        $action = "option";
    } elsif ($a eq "--command") {
        $action = "command";
    } elsif ($a eq "--load") {
        $action = "load";
    }
}

my @pkgnames = ();
my %commands = ();

while (my $line = <STDIN>) {
    $line =~ s/\n\z//g;
    if ($line =~ /\A\s*([-a-z0-9]+)\s*:([-_a-z0-9, ]+)\z/) {
        my $pkgname = $1;
        my $cmds = $2;
        my @cmds = ();
        foreach my $c (split(/,/, $cmds)) {
            if ($c =~ /\A\s*([^\s]+)\s*\z/) {
                push(@cmds, $1);
            }
        }
        push(@pkgnames, $pkgname);
        $commands{$pkgname} = \@cmds;
    }
}

if ($action eq "option") {
    foreach my $pkgname (@pkgnames) {
        print "        --${pkgname}=* )\n";
        print "            ${pkgname}_version=\"\${1#*=}\"\n";
        print "            ;;\n";
        print "        --${pkgname} )\n";
        print "            ${pkgname}_version=\"last\"\n";
        print "            ;;\n";
    }
}
if ($action eq "command") {
    foreach my $pkgname (@pkgnames) {
        foreach my $command (@{$commands{$pkgname}}) {
            print "    \"${command}\" )\n";
            print "        ${pkgname}_version=\${${pkgname}_version:-last}\n";
            print "        ;;\n";
        }
    }
}
if ($action eq "load") {
    foreach my $pkgname (@pkgnames) {
        print "if [ -n \"\${${pkgname}_version:-}\" ]; then\n";
        print "    . \$MULANG_SOURCE_DIR/install-${pkgname}.sh\n";
        print "    install_${pkgname} \$${pkgname}_version install\n";
        print "    . <(install_${pkgname} \$${pkgname}_version env)\n";
        print "fi\n";
    }
}

