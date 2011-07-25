use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'ServerControl-Postfix',
   VERSION_FROM => 'lib/ServerControl/Module/Postfix.pm',
   PREREQ_PM => {'ServerControl' => '0.93'},
   LICENSE => 'bsd'
);

