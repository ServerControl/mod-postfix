#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Module::Postfix;

use strict;
use warnings;

our $VERSION = '0.96';

use ServerControl::Module;
use ServerControl::Commons::Process;

use base qw(ServerControl::Module);

__PACKAGE__->Implements( qw(ServerControl::Module::PidFile) );

__PACKAGE__->Parameter(
   help  => { isa => 'bool', call => sub { __PACKAGE__->help; } },
);

sub help {
   my ($class) = @_;

   print __PACKAGE__ . " " . $ServerControl::Module::Postfix::VERSION . "\n";

   printf "  %-30s%s\n", "--name=", "Instance Name";
   printf "  %-30s%s\n", "--path=", "The path where the instance should be created";
   print "\n";
   printf "  %-30s%s\n", "--user=", "Postfix User";
   printf "  %-30s%s\n", "--group=", "Postfix Group";
   print "\n";
   printf "  %-30s%s\n", "--create", "Create the instance";
   printf "  %-30s%s\n", "--start", "Start the instance";
   printf "  %-30s%s\n", "--stop", "Stop the instance";

}

sub start {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);

   my $args        = ServerControl::Args->get;
   my $conf_dir    = ServerControl::FsLayout->get_directory("Configuration", "conf");
   my $exec_file   = ServerControl::FsLayout->get_file("Exec", "postfix");
   my $post_alias  = ServerControl::FsLayout->get_file("Exec", "postalias");
   my $post_map    = ServerControl::FsLayout->get_file("Exec", "postmap");

   if (-e "$path/$conf_dir/aliases") {
      spawn("$path/$post_alias -c $path/$conf_dir $path/$conf_dir/aliases");
   }

   if (-e "$path/$conf_dir/transport") {
      spawn("$path/$post_map -c $path/$conf_dir $path/$conf_dir/transport");
   }

   spawn("$path/$exec_file -c $path/$conf_dir start");
}


1;
